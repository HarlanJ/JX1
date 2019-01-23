//----------HELPER FUNCTIONS FOR initializeButtons()----------
final int DFLT_BTN_COLOR = 0xFF323264; //0xFF2b9ae5;
final int DFLT_TXT_COLOR = 0xFFBBBBBB; //0xFF000000;

//The margins parameter is a string representation of a nibble for where the edges of the window are:
//If the top and left sides of the button were against window edges, it would be 0b1001. The order (msb->lsb) is clockwise, starting at the top.
PGraphics generateButtonBase(PVector size, String marginString, String label, PFont font) {
  return generateButtonBase(size, marginString, label, DFLT_BTN_COLOR, DFLT_TXT_COLOR, font);
}

PGraphics generateButtonBase(PVector size, String marginString, String label, int fillColor, int textColor, PFont font){
  return generateButtonBase(size, marginString, label, fillColor, textColor, font, fillColor);
}

PGraphics generateButtonBase(PVector oSize, String marginString, String label, int fillColor, int textColor, PFont font, int borderColor) {
  PVector size = oSize.copy();
  size.mult(uiTextureScaling);
  int margins = unbinary(marginString);
  int tMargin, rMargin, bMargin, lMargin;
  tMargin = rMargin = bMargin = lMargin = 7;
  lMargin += 7* (margins&0x1);
  tMargin += 7*((margins&0x8)>>3);
  rMargin += 7*((margins&0x4)>>2) + lMargin;
  bMargin += 7*((margins&0x2)>>1) + tMargin;

  int textSize = 1;
  PGraphics t = createGraphics((int)size.x, (int)size.y);

  t.smooth(3);
  t.beginDraw();
  t.stroke(borderColor);
  t.fill(fillColor);
  t.rectMode(CORNER);
  t.rect(lMargin, tMargin, size.x-rMargin, size.y-bMargin, 15 * uiTextureScaling);

  t.fill(textColor);
  t.textAlign(CENTER, CENTER);
  t.textFont(font);
  t.textSize(textSize);

  while (t.textWidth(label) < size.x * .75 && textSize <= 64*uiTextureScaling) {
    t.textSize(textSize);
    textSize ++;
  }
  textSize--;

  int lines = 1;
  for (int i = 0; i < label.length(); i ++) {
    if (label.charAt(i) == '\n') {
      lines ++;
    }
  }
  float textHeight = (t.textAscent() + t.textDescent()) * lines;

  while (textHeight > size.y * .75 && textSize > 0) {
    t.textSize(textSize);
    textSize --;
    textHeight = (t.textAscent() + t.textAscent()) * lines;
  }

  t.text(label, lMargin, tMargin, size.x-rMargin, size.y-bMargin);
  t.endDraw();

  return t;
}
//------------------------------------------------------------

void drawButtons() {
  pushStyle();
  imageMode(CORNER);
  for (Button b : buttons) {
    b.draw();
  }
  popStyle();
}

void moveScreen(float x, float y) {
  moving = true;
  screenStart.set(screenPosition);
  startTime = millis();
  screenTarget.set(x, y);
}

void moveScreenRelative(float x, float y){
  moveScreen(screenPosition.x + x, screenPosition.y + y);
}

void drawLabels() {
  fill(255);
  textSize(35);
  text("Shutdown\nPrinter?", 0, height, width, height / 3 + height);
  text(moveTime + "\nms", 2 * width + (width /2), (height/1.5) / 2);
  switch(settingColor){
    case BG_COLOR:
      textSize(25);
      text("Setting\nBackground", width * 2 + width / 4, height * 2 + height * .75, width * 2 + width / 2, height * 3);
      textSize(35);
    break;
    case BUTTON_COLOR:
      text("Setting\nButton", width * 2 + width / 4, height * 2 + height * .75, width * 2 + width / 2, height * 3);
    break;
    case TEXT_COLOR:
      text("Setting\nText", width * 2 + width / 4, height * 2 + height * .75, width * 2 + width / 2, height * 3);
    break;
  }

  if(settings.getInt(colors[TEXT_COLOR]) == 0xFFFFFF00 && settings.getInt(colors[BUTTON_COLOR]) == 0xFFDC143C && millis() % (int)random(5, 11) != 0){
    if(eEggTime == -1){
      eEggTime = millis() + 3500;
    }
    if(eEggTime > millis()){
      text("Seems like communist\npropaganda to me but ok", -screenPosition.x, -screenPosition.y, width - screenPosition.x, height - screenPosition.y);
    }
  }
}

void runSetup() {
  try {
    settings = loadJSONObject("settings.json");
  }
  catch (java.lang.NullPointerException e) {
    settings = new JSONObject();
    settings.setString("font", "Quantico.ttf");
    settings.setInt("moveTime", 450);
    settings.setFloat("uiTextureScaling", 1);
    settings.setBoolean("isOnTargetPi", false);
    settings.setInt("bgColor", 0xFF000000);
    settings.setInt("buttonColor", 0xFF6495ED);
    settings.setInt("textColor", 0xFF000000);

    saveJSONObject(settings, "settings.json");
  }

  boolean settingsOk = true;
  if (settings.isNull("uiTextureScaling")) {
    settings.setFloat("uiTextureScaling", 1);
    settingsOk = false;
  }
  if (settings.isNull("moveTime")) {
    settings.setInt("moveTime", 1);
    settingsOk = false;
  }
  if (settings.isNull("font")) {
    settings.setString("font", "Quantico.ttf");
    settingsOk = false;
  }
  if (settings.isNull("isOnTargetPi")) {
    settings.setBoolean("isOnTargetPi", false);
    settingsOk = false;
  }
  if(settings.isNull("bgColor")){
    settings.setInt("bgColor", 0xFF000000);
    settingsOk = false;
  }
  if(settings.isNull("buttonColor")){
    settings.setInt("buttonColor", 0xFF323264);
    settingsOk = false;
  }
  if(settings.isNull("textColor")){
    settings.setInt("textColor", 0xFFBBBBBB);
    settingsOk = false;
  }

  if (!settingsOk) {
    saveJSONObject(settings, "settings.json");
  }

  moveTime = settings.getInt("moveTime");
  uiTextureScaling = settings.getFloat("uiTextureScaling");
  //isOnTargetPi is set in settings()

  initializeButtons();
  initLevel ++;
}

final String[] fileButtonBorders = {"1100", "0100", "0100", "0010"};
Button[] loadPrintFiles(String dir){
  int fillColor = settings.getInt(colors[BUTTON_COLOR]);
  int textColor = settings.getInt(colors[TEXT_COLOR]);
  File root = new File(dir);
  File[] files = root.listFiles();
  ArrayList<Button> buttonList = new ArrayList<Button>(0);
  int i = 0;
  PVector pos = new PVector(width * -2 + width/ 4, 0);
  PVector size = new PVector(width / 4 * 3, height / 4);
  firstFileButton = buttons.length;
  filenames = new String[0];
  for(File f : files){
    println(firstFileButton + i + "  " + f.getName());
    if(f.getName().substring(f.getName().lastIndexOf(".")).toLowerCase().equals(".jcode")){
      filenames = (String[])append(filenames, f.getName());
      buttonList.add(new Button(pos, size, generateButtonBase(size, fileButtonBorders[i % 4], f.getName(), fillColor, textColor, font), new Runnable(){
        public void run(){
          moveScreen(width * 2, height);
        }
      }));

      if(i % 4 == 3){
        pos.y = height * ((i+1)/4);
      } else{
        pos.y += height / 4;
      }

      i++;
    } else if(f.getName().substring(f.getName().lastIndexOf(".")).toLowerCase().equals(".gcode")){
      filenames = (String[])append(filenames, f.getName());
      buttonList.add(new Button(pos, size, generateButtonBase(size, fileButtonBorders[i % 4], f.getName(), fillColor, textColor, font), new Runnable(){
        public void run(){
          moveScreen(width * 3, 0);
        }
      }));

      if(i % 4 == 3){
        pos.y = height * ((i+1)/4);
      } else{
        pos.y += height / 4;
      }

      i++;
    }
  }
  lastFileButton = firstFileButton + i;

  pos.set(width * -2, 0);
  size.set(width / 4, height / 2);
  buttonList.add(new Button(pos, size, generateButtonBase(size, "1001", "Back", fillColor, textColor, font), new Runnable(){
    public void run(){
      moveScreen(width, 0);
    }
  }));

  lastFileNav = lastFileButton;

  if(i > 4){
    pos.set(width * -2, height / 2);
    buttonList.add(new Button(pos, size, generateButtonBase(size, "0011", "\\/", fillColor, textColor, font), new Runnable(){
      public void run(){
        moveScreenRelative(0, -height);
      }
    }));
    lastFileNav++;
  }

  for(int j = i/4; j > 0; j --){
    pos.add(0, height / 2);
    buttonList.add(new Button(pos, size, generateButtonBase(size, "1001", "/\\", fillColor, textColor, font), new Runnable(){
      public void run(){
        moveScreenRelative(0, height);
      }
    }));
    lastFileNav++;

    if(j != 1){
      pos.add(0, height / 2);
      buttonList.add(new Button(pos, size, generateButtonBase(size, "0011", "\\/", fillColor, textColor, font), new Runnable(){
        public void run(){
          moveScreenRelative(0, -height);
        }
      }));
      lastFileNav++;
    }
  }

  if(buttonList.size() == 0){
    return new Button[]{};
  }
  Button[] buttonArray = new Button[buttonList.size()];
  return buttonList.toArray(buttonArray);
}