//Button( POSITION, SIZE, IMAGE, CALLBACK)
//generateButtonBase( SIZE, MARGINS, LABEL)
void initializeButtons() {
  PFont font = createFont("fonts/" + settings.getString("font"), 64);
  textFont(font);
  textSize(35);

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
  PVector size = new PVector(width / 2, height / 1.5);

  buttons[0] = new Button(pos, size, generateButtonBase(size, "1001", "Print", font), new Runnable() {
    public void run() {
    }
  }
  );

  pos.set(width / 2, 0);
  buttons[1] = new Button(pos, size, generateButtonBase(size, "1100", "Settings", font), new Runnable() {
    public void run() {
      moveScreen(-width, 0);
    }
  }
  );

  pos.set(0, height / 1.5);
  size.set(width, height / 3.0);
  buttons[2] = new Button(pos, size, generateButtonBase(size, "0111", "Shutdown", font), new Runnable() {
    public void run() {
      moveScreen(0, -height);
    }
  }
  );

  pos.set(0, height / 3.0 + height);
  size.set(width / 2, height / 1.5);
  buttons[3] = new Button(pos, size, generateButtonBase(size, "0011", "Yes", font), new Runnable() {
    public void run() {
      saveJSONObject(settings, "settings.json");
      exit();
    }
  }
  );

  pos.set(width * .5, height / 3.0 + height);
  buttons[4] = new Button(pos, size, generateButtonBase(size, "0110", "No", font), new Runnable() {
    public void run() {
      moveScreen(0, 0);
    }
  }
  );

  pos.set(width, 0);
  size.set(width / 2, height / 2);
  buttons[5] = new Button(pos, size, generateButtonBase(size, "1001", "Main Menu", font), new Runnable() {
    public void run() {
      moveScreen(0, 0);
    }
  }
  );

  pos.set(width + (width / 2), 0);
  size.set(width / 2.0, height / 3.0);
  buttons[6] = new Button(pos, size, generateButtonBase(size, "1000", "Menu Font", font), new Runnable() {
    public void run() {
      moveScreen(-2 * width, height);
    }
  }
  );


  pos.set(2 * width, -height + (height / 1.5));
  size.set(width / 4.0, height / 3.0);
  buttons[7] = new Button(pos, size, generateButtonBase(size, "0011", "Back", font), new Runnable() {
    public void run() {
      moveScreen(-width, 0);
    }
  }
  );

  pos.set(2 * width, -height);
  buttons[8] = new Button(pos, size, generateButtonBase(size, "1001", "Cutefont", font), new Runnable() {
    public void run() {
      settings.setString("font", "Cutefont.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width, -height + (height / 3.0));
  buttons[9] = new Button(pos, size, generateButtonBase(size, "0001", "Gugi", font), new Runnable() {
    public void run() {
      settings.setString("font", "Gugi.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0), -height);
  buttons[10] = new Button(pos, size, generateButtonBase(size, "1000", "Orbitron", font), new Runnable() {
    public void run() {
      settings.setString("font", "Orbitron.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0), -height + (height / 3));
  buttons[11] = new Button(pos, size, generateButtonBase(size, "0000", "Press Start\n2P", font), new Runnable() {
    public void run() {
      settings.setString("font", "Press Start 2P.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0), -height + (height / 1.5));
  buttons[12] = new Button(pos, size, generateButtonBase(size, "0010", "Audiowide", font), new Runnable() {
    public void run() {
      settings.setString("font", "Audiowide.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0), -height );
  buttons[13] = new Button(pos, size, generateButtonBase(size, "1000", "Quantico", font), new Runnable() {
    public void run() {
      settings.setString("font", "Quantico.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0), -height + (height / 3.0));
  buttons[14] = new Button(pos, size, generateButtonBase(size, "0000", "Gloria\nHallelujah", font), new Runnable() {
    public void run() {
      settings.setString("font", "Gloria Hallelujah.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0), -height + (height / 1.5));
  buttons[15] = new Button(pos, size, generateButtonBase(size, "0010", "Mina", font), new Runnable() {
    public void run() {
      settings.setString("font", "Mina.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75), -height);
  buttons[16] = new Button(pos, size, generateButtonBase(size, "1100", "Russo\nOne", font), new Runnable() {
    public void run() {
      settings.setString("font", "Russo One.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75), -height + (height / 3.0));
  buttons[17] = new Button(pos, size, generateButtonBase(size, "0100", "Source\nCode Pro", font), new Runnable() {
    public void run() {
      settings.setString("font", "Source Code Pro.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75), -height + (height / 1.5));
  buttons[18] = new Button(pos, size, generateButtonBase(size, "0110", "Vollkorn", font), new Runnable() {
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
  buttons[19] = new Button(pos, size, generateButtonBase(size, "01000", "Move Time", font), new Runnable() {
    public void run() {
      moveScreen(-2 * width, 0);
    }
  }
  );

  pos.set(2 * width, 0);
  size.set(width/3, height / 1.5);
  buttons[20] = new Button(pos, size, generateButtonBase(size, "1001", "-", font), new Runnable() {
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

  pos.set(2 * width + (width / 1.5), 0);
  buttons[21] = new Button(pos, size, generateButtonBase(size, "1001", "+", font), new Runnable() {
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

  pos.set(2 * width, height / 1.5);
  size.set(width, height / 3);
  buttons[22] = new Button(pos, size, generateButtonBase(size, "0111", "Back", font), new Runnable() {
    public void run() {
      moveScreen(-1 * width, 0);
    }
  }
  );

  initLevel ++;
}

//----------HELPER FUNCTIONS FOR initializeButtons()----------
final int DFLT_BTN_COLOR = 0xFF323264;
final int DFLT_TXT_COLOR = 0xFFBBBBBB;

//The margins parameter is a string representation of a nibble for where the edges of the window are:         
//If the top and left sides of the button were against window edges, it would be 0b1001. The order (msb->lsb) is clockwise, starting at the top.
PGraphics generateButtonBase(PVector size, String marginString, String label, PFont font) {
  return generateButtonBase(size, marginString, label, DFLT_BTN_COLOR, DFLT_TXT_COLOR, font);
}

PGraphics generateButtonBase(PVector oSize, String marginString, String label, int fillColor, int textColor, PFont font) {
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
  t.noStroke();
  t.fill(fillColor);
  t.rectMode(CORNER);
  t.rect(lMargin, tMargin, size.x-rMargin, size.y-bMargin, 15);

  t.fill(textColor);
  t.textAlign(CENTER, CENTER);
  t.textFont(font);
  t.textSize(textSize);

  while (t.textWidth(label) < size.x * .75 && textSize <= 64) {
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
  for (Button b : buttons) {
    b.draw();
  }
}

void moveScreen(float x, float y) {
  moving = true;
  screenStart.set(screenPosition);
  startTime = millis();
  screenTarget.set(x, y);
}

void drawLabels() {
  fill(255);
  textSize(35);
  text("Shutdown\nPrinter?", 0, height, width, height / 3 + height);
  text(moveTime + "\nms", 2 * width + (width /2), (height/1.5) / 2);
}

void runSetup() {
  try {
    settings = loadJSONObject("settings.json");
  } 
  catch (java.lang.NullPointerException e) {
    settings = new JSONObject();
    settings.setString("font", "Quantico.ttf");
    settings.setInt("moveTime", 1);
    settings.setFloat("uiTextureScaling", 1);
    settings.setBoolean("isOnTargetPi", false);

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

  if (!settingsOk) {
    saveJSONObject(settings, "settings.json");
  }

  moveTime = settings.getInt("moveTime");
  uiTextureScaling = settings.getFloat("uiTextureScaling");
  //isOnTargetPi is set in settings()

  initializeButtons();
  initLevel ++;
}