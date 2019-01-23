import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import java.lang.Class; 
import java.io.File; 
import java.lang.Runnable; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class interface_mapMenuTest extends PApplet {





Serial nano;

//Used for moving the screen around the menu
int startTime;
int moveTime = 0;
PVector screenPosition, screenTarget, screenStart;
boolean moving = false;

int initLevel = 0;
int initLevelCount = 2;
Button buttons[];

PFont font;

JSONObject settings;
boolean isOnTargetPi=false;
float uiTextureScaling=1;
PImage loadingScreen;

int firstFileButton = -1;
int lastFileButton = -1;
int lastFileNav = -1;
String[] filenames;

final short BG_COLOR = 0, BUTTON_COLOR = 1, TEXT_COLOR = 2;
final String[] colors = {"bgColor", "buttonColor", "textColor"};
short settingColor = -1;

int eEggTime = -2;

int diagonal=0;

//String __LOG__ = "";

public void settings(){
  boolean success = true;
  try{
    isOnTargetPi = loadJSONObject("settings.json").getBoolean("isOnTargetPi");
  } catch (Exception e){
    success = false;
  }
  if(success && isOnTargetPi){
    fullScreen();
  } else {
    size(800, 480);
  }

  diagonal = PApplet.parseInt(sqrt(sq(width) + sq(height)));
  noSmooth();
}

public void setup() {
  if(isOnTargetPi) exec("/usr/share/scripts/login");

  nano = new Serial(this, "/dev/serial0", 115200);

  screenPosition = new PVector(0, 0);
  screenTarget = new PVector(0, 0);
  screenStart = new PVector(0, 0);

  buttons = new Button[48];

  if(isOnTargetPi){
    noCursor();
  }

  thread("runSetup");

  textAlign(CENTER, CENTER);
  rectMode(CORNERS);
}

public void draw() {
  if (initLevel == initLevelCount) {
    background(settings.getInt("bgColor"));
    translate(screenPosition.x, screenPosition.y);

    drawButtons();
    drawLabels();

    if (moving) {
      float amt = pow((millis()-startTime)/(float)moveTime, 2.1f);
      screenPosition.set(lerp(screenStart.x, screenTarget.x, amt), lerp(screenStart.y, screenTarget.y, amt));
      if (amt >= 1) {
        screenPosition.set(screenTarget);
        moving = false;
      }
    }
  } else {
    if(loadingScreen != null){
      background(loadingScreen);
    } else {
      background(settings.getInt("bgColor"));
      text("Loading...", 0, 0, width, height);
    }
  }

  /*
  while(nano.available() > 0){
    __LOG__ += char(nano.read());
  }
  text(__LOG__, width/2-screenPosition.x, height/2-screenPosition.y);
  */
}

public void mousePressed() {
  if(moving){
    return;
  }
  boolean lookingForButton = true;
  int button;
  for (button = 0; button < buttons.length && lookingForButton; button ++) {
    lookingForButton = !buttons[button].pressed();
  }
  if(!lookingForButton && button > firstFileButton && button <= lastFileButton){
    println(filenames[button - firstFileButton - 1]);
  }
}


class Button{
  PVector pos, size;
  PImage texture;

  Runnable callback;

  Button(PVector p, PVector s, PImage t, Runnable CallBack){
    this.pos = p.copy();
    this.size = s.copy();
    this.texture = t;
    this.callback = CallBack;
  }

  public boolean pressed(){
    float x = mouseX - screenPosition.x;
    float y = mouseY - screenPosition.y;
    if(x > pos.x && x < pos.x + size.x && y > pos.y && y < pos.y + size.y){
      callback.run();
      return true;
    }
    return false;
  }

  public void draw(){
    
    if(moving || pos.x + 5 > -screenPosition.x &&
                 pos.x < (-screenPosition.x) + width &&
                 pos.y + 5 > -screenPosition.y &&
                 pos.y < (-screenPosition.y) + height){

    //if(pos.dist(PVector.mult(screenPosition, -1)) <= diagonal){
      //pushStyle();
      //imageMode(CORNER);
      //moved to an outer function for performance
      image(texture, pos.x, pos.y, size.x, size.y);
      //popStyle();
    }
  }
}
//----------HELPER FUNCTIONS FOR initializeButtons()----------
final int DFLT_BTN_COLOR = 0xFF323264; //0xFF2b9ae5;
final int DFLT_TXT_COLOR = 0xFFBBBBBB; //0xFF000000;

//The margins parameter is a string representation of a nibble for where the edges of the window are:
//If the top and left sides of the button were against window edges, it would be 0b1001. The order (msb->lsb) is clockwise, starting at the top.
public PGraphics generateButtonBase(PVector size, String marginString, String label, PFont font) {
  return generateButtonBase(size, marginString, label, DFLT_BTN_COLOR, DFLT_TXT_COLOR, font);
}

public PGraphics generateButtonBase(PVector size, String marginString, String label, int fillColor, int textColor, PFont font){
  return generateButtonBase(size, marginString, label, fillColor, textColor, font, fillColor);
}

public PGraphics generateButtonBase(PVector oSize, String marginString, String label, int fillColor, int textColor, PFont font, int borderColor) {
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

  while (t.textWidth(label) < size.x * .75f && textSize <= 64*uiTextureScaling) {
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

  while (textHeight > size.y * .75f && textSize > 0) {
    t.textSize(textSize);
    textSize --;
    textHeight = (t.textAscent() + t.textAscent()) * lines;
  }

  t.text(label, lMargin, tMargin, size.x-rMargin, size.y-bMargin);
  t.endDraw();

  return t;
}
//------------------------------------------------------------

public void drawButtons() {
  pushStyle();
  imageMode(CORNER);
  for (Button b : buttons) {
    b.draw();
  }
  popStyle();
}

public void moveScreen(float x, float y) {
  moving = true;
  screenStart.set(screenPosition);
  startTime = millis();
  screenTarget.set(x, y);
}

public void moveScreenRelative(float x, float y){
  moveScreen(screenPosition.x + x, screenPosition.y + y);
}

public void drawLabels() {
  fill(255);
  textSize(35);
  text("Shutdown\nPrinter?", 0, height, width, height / 3 + height);
  text(moveTime + "\nms", 2 * width + (width /2), (height/1.5f) / 2);
  switch(settingColor){
    case BG_COLOR:
      textSize(25);
      text("Setting\nBackground", width * 2 + width / 4, height * 2 + height * .75f, width * 2 + width / 2, height * 3);
      textSize(35);
    break;
    case BUTTON_COLOR:
      text("Setting\nButton", width * 2 + width / 4, height * 2 + height * .75f, width * 2 + width / 2, height * 3);
    break;
    case TEXT_COLOR:
      text("Setting\nText", width * 2 + width / 4, height * 2 + height * .75f, width * 2 + width / 2, height * 3);
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

public void runSetup() {
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
public Button[] loadPrintFiles(String dir){
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
//Button( POSITION, SIZE, IMAGE, CALLBACK)
//generateButtonBase( SIZE, MARGINS, LABEL)
public void initializeButtons() {
  font = createFont("fonts/" + settings.getString("font"), 64);
  textFont(font);
  textSize(35);

  int fillColor = settings.getInt("buttonColor");
  int textColor = settings.getInt("textColor");

  PGraphics temp = createGraphics(width, height);
  temp.beginDraw();
  temp.background(0);
  temp.textFont(font);
  temp.textSize(35);
  temp.textAlign(CENTER, CENTER);
  temp.text("Loading...", 0, 0, width, height);
  temp.endDraw();
  loadingScreen = temp.copy();

  PVector pos = new PVector(0, 0);
  PVector size = new PVector(width / 2, height / 1.5f);

  buttons[0] = new Button(pos, size, generateButtonBase(size, "1001", "Print", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(width, 0);
    }
  }
  );

  pos.set(width / 2, 0);
  buttons[1] = new Button(pos, size, generateButtonBase(size, "1100", "Settings", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(-width, 0);
    }
  }
  );

  pos.set(0, height / 1.5f);
  size.set(width, height / 3.0f);
  buttons[2] = new Button(pos, size, generateButtonBase(size, "0111", "Shutdown", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(0, -height);
    }
  }
  );

  pos.set(0, height / 3.0f + height);
  size.set(width / 2, height / 1.5f);
  buttons[3] = new Button(pos, size, generateButtonBase(size, "0011", "Yes", fillColor, textColor, font), new Runnable() {
    public void run() {
      saveJSONObject(settings, "settings.json");
      if(isOnTargetPi){
        exec("/sbin/poweroff");
      }
      exit();
    }
  }
  );

  pos.set(width * .5f, height / 3.0f + height);
  buttons[4] = new Button(pos, size, generateButtonBase(size, "0110", "No", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(0, 0);
    }
  }
  );

  pos.set(width, 0);
  size.set(width / 2, height / 2);
  buttons[5] = new Button(pos, size, generateButtonBase(size, "1001", "Main Menu", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(0, 0);
    }
  }
  );

  pos.set(width + (width / 2), 0);
  size.set(width / 2.0f, height / 3.0f);
  buttons[6] = new Button(pos, size, generateButtonBase(size, "1000", "Menu Font", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(-2 * width, height);
    }
  }
  );


  pos.set(2 * width, -height + (height / 1.5f));
  size.set(width / 4.0f, height / 3.0f);
  buttons[7] = new Button(pos, size, generateButtonBase(size, "0011", "Back", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(-width, 0);
    }
  }
  );

  pos.set(2 * width, -height);
  buttons[8] = new Button(pos, size, generateButtonBase(size, "1001", "Cutefont", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Cutefont.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width, -height + (height / 3.0f));
  buttons[9] = new Button(pos, size, generateButtonBase(size, "0001", "Gugi", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Gugi.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0f), -height);
  buttons[10] = new Button(pos, size, generateButtonBase(size, "1000", "Orbitron", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Orbitron.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0f), -height + (height / 3));
  buttons[11] = new Button(pos, size, generateButtonBase(size, "0000", "Press Start\n2P", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Press Start 2P.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0f), -height + (height / 1.5f));
  buttons[12] = new Button(pos, size, generateButtonBase(size, "0010", "Audiowide", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Audiowide.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0f), -height );
  buttons[13] = new Button(pos, size, generateButtonBase(size, "1000", "Quantico", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Quantico.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0f), -height + (height / 3.0f));
  buttons[14] = new Button(pos, size, generateButtonBase(size, "0000", "Gloria\nHallelujah", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Gloria Hallelujah.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0f), -height + (height / 1.5f));
  buttons[15] = new Button(pos, size, generateButtonBase(size, "0010", "Mina", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Mina.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75f), -height);
  buttons[16] = new Button(pos, size, generateButtonBase(size, "1100", "Russo\nOne", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Russo One.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75f), -height + (height / 3.0f));
  buttons[17] = new Button(pos, size, generateButtonBase(size, "0100", "Source\nCode Pro", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Source Code Pro.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75f), -height + (height / 1.5f));
  buttons[18] = new Button(pos, size, generateButtonBase(size, "0110", "Vollkorn", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Vollkorn.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(width + (width/2), height / 3);
  size.set(width / 2, height / 3);
  buttons[19] = new Button(pos, size, generateButtonBase(size, "0100", "Move Time", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(-2 * width, 0);
    }
  }
  );

  pos.set(2 * width, 0);
  size.set(width/3, height / 1.5f);
  buttons[20] = new Button(pos, size, generateButtonBase(size, "1001", "-", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveTime -= 50;
      if (moveTime < 1) {
        moveTime = 1;
      }
      settings.setInt("moveTime", moveTime);
      saveJSONObject(settings, "settings.json");
    }
  }
  );

  pos.set(2 * width + (width / 1.5f), 0);
  buttons[21] = new Button(pos, size, generateButtonBase(size, "1001", "+", fillColor, textColor, font), new Runnable() {
    public void run() {
      if (moveTime == 1) {
        moveTime = 0;
      }
      moveTime += 50;
      settings.setInt("moveTime", moveTime);
      saveJSONObject(settings, "settings.json");
    }
  }
  );

  pos.set(2 * width, height / 1.5f);
  size.set(width, height / 3);
  buttons[22] = new Button(pos, size, generateButtonBase(size, "0111", "Back", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(-1 * width, 0);
    }
  }
  );

  pos.set(-width, 0);
  buttons[23] = new Button(pos, size, generateButtonBase(size, "1101", "Print from USB", fillColor, textColor, font), new Runnable() {
    public void run() {
      /*
      moveScreen(width*2, 0);
      println(buttons.length + " " + firstFileButton + " " + lastFileButton + " " + lastFileNav);
      if(firstFileButton != -1)
        buttons = (Button[])concat((Button[])subset(buttons, 0, firstFileButton), (Button[])subset(buttons, lastFileNav+1));
      firstFileButton = lastFileButton = lastFileNav = -1;
      buttons = (Button[])concat(buttons, loadPrintFiles("D:/browseTest2/"));
      */
    }
  }
  );

  pos.set(-width, height / 3);
  buttons[24] = new Button(pos, size, generateButtonBase(size, "0101", "Print from FTP folder", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(width*2, 0);
      if(firstFileButton != -1)
        buttons = (Button[])concat((Button[])subset(buttons, 0, firstFileButton), (Button[])subset(buttons, lastFileNav+1));
      firstFileButton = lastFileButton = lastFileNav = -1;
      buttons = (Button[])concat(buttons, loadPrintFiles("/home/pi/FTPprint"));
    }
  }
  );

  pos.set(-width, height / 1.5f);
  buttons[25] = new Button(pos, size, generateButtonBase(size, "0111", "Back", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(0, 0);
    }
  }
  );

  pos.set(width * 1.5f, height / 1.5f);
  size.set(width / 2, height / 3);
  buttons[26] = new Button(pos, size, generateButtonBase(size, "0110", "Jog", fillColor, textColor, font), new Runnable(){
    public void run(){
      moveScreen(width * -2, -height);
    }
  });

  final short speed = 25 * 10; //25steps/mm, 10mm = 1cm

  pos.set(width * 2, height);
  size.set(width / 3, height / 3);
  buttons[27] = new Button(pos, size, generateButtonBase(size, "1001", "Z-", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            0, 0,
                            0, 0,
                            PApplet.parseByte(-speed), PApplet.parseByte(-speed >> 8),
                            0, 0
                            });
    }
  });

  pos.set(width * 2 + width/3, height);
  buttons[28] = new Button(pos, size, generateButtonBase(size, "1000", "Y+", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            0, 0,
                            PApplet.parseByte(speed), PApplet.parseByte(speed >> 8),
                            0, 0,
                            0, 0
                            });
    }
  });

  pos.set(width * 2 + width / 1.5f, height);
  buttons[29] = new Button(pos, size, generateButtonBase(size, "1100", "Z+", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            0, 0,
                            0, 0,
                            PApplet.parseByte(speed), PApplet.parseByte(speed >> 8),
                            0, 0
                            });
    }
  });

  pos.set(width * 2, height + height / 3);
  buttons[30] = new Button(pos, size, generateButtonBase(size, "0001", "X-", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            PApplet.parseByte(-speed), PApplet.parseByte(-speed >> 8),
                            0, 0,
                            0, 0,
                            0, 0
                            });
    }
  });

  pos.set(width * 2 + width / 1.5f, height + height / 3);
  buttons[31] = new Button(pos, size, generateButtonBase(size, "0100", "X+", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            PApplet.parseByte(speed), PApplet.parseByte(speed >> 8),
                            0, 0,
                            0, 0,
                            0, 0
                            });
    }
  });

  pos.set(width * 2 + width / 3, height + height / 1.5f);
  buttons[32] = new Button(pos, size, generateButtonBase(size, "0010", "Y-", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            0, 0,
                            PApplet.parseByte(-speed), PApplet.parseByte(-speed >> 8),
                            0, 0,
                            0, 0
                            });
    }
  });

  pos.set(width * 2, height + height / 1.5f);
  buttons[33] = new Button(pos, size, generateButtonBase(size, "0011", "Back", fillColor, textColor, font), new Runnable(){
    public void run(){
      moveScreen(-width, 0);
    }
  });

  pos.set(width, height / 2);
  size.set(width / 2, height / 2);
  buttons[34] = new Button(pos, size, generateButtonBase(size, "0011", "\\/", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(-width, height * -2);
    }
  }
  );

  pos.set(width, height * 2);
  buttons[35] = new Button(pos, size, generateButtonBase(size, "1001", "/\\", fillColor, textColor, font), new Runnable(){
    public void run(){
      moveScreen(-width, 0);
    }
  });

  pos.set(width + width / 2, height * 2);
  size.set(width / 2, height / 3);
  buttons[36] = new Button(pos, size, generateButtonBase(size, "1100", "Background Color", fillColor, textColor, font), new Runnable(){
    public void run(){
      settingColor = BG_COLOR;
      moveScreen(width * -2, height * -2);
    }
  });

  pos.set(width + width / 2, height * 2 + height / 3);
  buttons[37] = new Button(pos, size, generateButtonBase(size, "0100", "Button Color", fillColor, textColor, font), new Runnable(){
    public void run(){
      settingColor = BUTTON_COLOR;
      moveScreen(width * -2, height * -2);
    }
  });

  pos.set(width + width / 2, height * 2 + height / 1.5f);
  buttons[38] = new Button(pos, size, generateButtonBase(size, "0110", "Text Color", fillColor, textColor, font), new Runnable(){
    public void run(){
      settingColor = TEXT_COLOR;
      moveScreen(width * -2, height * -2);
    }
  });

  //White
  pos.set(width * 2, height * 2);
  size.set(width / 4, height / 4);
  buttons[39] = new Button(pos, size, generateButtonBase(size, "1001", "", 0xFFFFFFFF, 0xFF000000, font, 0xFF000000), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFFFFFFFF);
      saveJSONObject(settings, "settings.json");

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  //Black
  pos.set(width * 2 + width / 4, height * 2);
  buttons[40] = new Button(pos, size, generateButtonBase(size, "1000", "", 0xFF000000, 0xFFFFFFFF, font, 0xFFFFFFFF), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFF000000);
      saveJSONObject(settings, "settings.json");

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  //Cornflower Blue
  pos.set(width * 2 + width / 2, height * 2);
  buttons[41] = new Button(pos, size, generateButtonBase(size, "1000", "", 0xFF6495ED, 0xFFFFFFFF, font, 0xFF000000), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFF6495ED);
      saveJSONObject(settings, "settings.json");

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  //Crimson
  pos.set(width * 2 + width *.75f, height * 2);
  buttons[42] = new Button(pos, size, generateButtonBase(size, "1100", "", 0xFFDC143C, 0xFFFFFFFF, font, 0xFF000000), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFFDC143C);
      saveJSONObject(settings, "settings.json");

      if(settingColor != BG_COLOR) eEggTime = -1;

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  //Dark Orange
  pos.set(width * 2, height * 2 + height / 4);
  buttons[43] = new Button(pos, size, generateButtonBase(size, "0001", "", 0xFFFF8C00, 0xFFFFFFFF, font, 0xFF000000), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFFFF8C00);
      saveJSONObject(settings, "settings.json");

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  pos.set(width * 2, height * 2 + height *.75f);
  buttons[44] = new Button(pos, size, generateButtonBase(size, "0011", "Back", fillColor, textColor, font), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);
    }
  });

  //Yellow
  pos.set(width * 2 + width / 4, height * 2 + height / 4);
  buttons[45] = new Button(pos, size, generateButtonBase(size, "0000", "", 0xFFFFFF00, 0xFF000000, font, 0xFF000000), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFFFFFF00);
      saveJSONObject(settings, "settings.json");
      if(settingColor != BG_COLOR) eEggTime = -1;

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  //SeaGreen
  pos.set(width * 2 + width / 2, height * 2 + height / 4);
  buttons[46] = new Button(pos, size, generateButtonBase(size, "0000", "", 0xFF2E8B57, 0xFFFFFFFF, font, 0xFFFFFFFF), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFF2E8B57);
      saveJSONObject(settings, "settings.json");

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  //Purple
  pos.set(width * 2 + width * .75f, height * 2 + height / 4);
  buttons[47] = new Button(pos, size, generateButtonBase(size, "0100", "", 0xFF800080, 0xFFFFFFFF, font, 0xFFFFFFFF), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFF800080);
      saveJSONObject(settings, "settings.json");

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  //Gray
  pos.set(width * 2, height * 2 + height / 2);
  buttons[47] = new Button(pos, size, generateButtonBase(size, "0001", "", 0xFF808080, 0xFFFFFFFF, font, 0xFFFFFFFF), new Runnable(){
    public void run(){
      moveScreen(-width, height * -2);

      settings.setInt(colors[settingColor], 0xFF808080);
      saveJSONObject(settings, "settings.json");

      if(settingColor!=BG_COLOR){
        initLevel --;
        thread("initializeButtons");
      }

      settingColor = -1;
    }
  });

  initLevel ++;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "interface_mapMenuTest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
