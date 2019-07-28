//Button( POSITION, SIZE, IMAGE, CALLBACK)
//generateButtonBase( SIZE, MARGINS, LABEL)
void initializeButtons() {
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
  PVector size = new PVector(width / 2, height / 1.5);

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

  pos.set(0, height / 1.5);
  size.set(width, height / 3.0);
  buttons[2] = new Button(pos, size, generateButtonBase(size, "0111", "Shutdown", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(0, -height);
    }
  }
  );

  pos.set(0, height / 3.0 + height);
  size.set(width / 2, height / 1.5);
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

  pos.set(width * .5, height / 3.0 + height);
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
  size.set(width / 2.0, height / 3.0);
  buttons[6] = new Button(pos, size, generateButtonBase(size, "1000", "Menu Font", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(-2 * width, height);
    }
  }
  );


  pos.set(2 * width, -height + (height / 1.5));
  size.set(width / 4.0, height / 3.0);
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

  pos.set(2 * width, -height + (height / 3.0));
  buttons[9] = new Button(pos, size, generateButtonBase(size, "0001", "Gugi", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Gugi.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0), -height);
  buttons[10] = new Button(pos, size, generateButtonBase(size, "1000", "Orbitron", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Orbitron.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0), -height + (height / 3));
  buttons[11] = new Button(pos, size, generateButtonBase(size, "0000", "Press Start\n2P", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Press Start 2P.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 4.0), -height + (height / 1.5));
  buttons[12] = new Button(pos, size, generateButtonBase(size, "0010", "Audiowide", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Audiowide.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0), -height );
  buttons[13] = new Button(pos, size, generateButtonBase(size, "1000", "Quantico", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Quantico.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0), -height + (height / 3.0));
  buttons[14] = new Button(pos, size, generateButtonBase(size, "0000", "Gloria\nHallelujah", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Gloria Hallelujah.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width / 2.0), -height + (height / 1.5));
  buttons[15] = new Button(pos, size, generateButtonBase(size, "0010", "Mina", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Mina.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75), -height);
  buttons[16] = new Button(pos, size, generateButtonBase(size, "1100", "Russo\nOne", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Russo One.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75), -height + (height / 3.0));
  buttons[17] = new Button(pos, size, generateButtonBase(size, "0100", "Source\nCode Pro", fillColor, textColor, font), new Runnable() {
    public void run() {
      settings.setString("font", "Source Code Pro.ttf");
      saveJSONObject(settings, "settings.json");
      initLevel --;
      thread("initializeButtons");
    }
  }
  );

  pos.set(2 * width + (width * .75), -height + (height / 1.5));
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
  size.set(width/3, height / 1.5);
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

  pos.set(2 * width + (width / 1.5), 0);
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

  pos.set(2 * width, height / 1.5);
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

  pos.set(-width, height / 1.5);
  buttons[25] = new Button(pos, size, generateButtonBase(size, "0111", "Back", fillColor, textColor, font), new Runnable() {
    public void run() {
      moveScreen(0, 0);
    }
  }
  );

  pos.set(width * 1.5, height / 1.5);
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
                            byte(-speed), byte(-speed >> 8),
                            0, 0
                            });
    }
  });

  pos.set(width * 2 + width/3, height);
  buttons[28] = new Button(pos, size, generateButtonBase(size, "1000", "Y+", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            0, 0,
                            byte(speed), byte(speed >> 8),
                            0, 0,
                            0, 0
                            });
    }
  });

  pos.set(width * 2 + width / 1.5, height);
  buttons[29] = new Button(pos, size, generateButtonBase(size, "1100", "Z+", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            0, 0,
                            0, 0,
                            byte(speed), byte(speed >> 8),
                            0, 0
                            });
    }
  });

  pos.set(width * 2, height + height / 3);
  buttons[30] = new Button(pos, size, generateButtonBase(size, "0001", "X-", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            byte(-speed), byte(-speed >> 8),
                            0, 0,
                            0, 0,
                            0, 0
                            });
    }
  });

  pos.set(width * 2 + width / 1.5, height + height / 3);
  buttons[31] = new Button(pos, size, generateButtonBase(size, "0100", "X+", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            byte(speed), byte(speed >> 8),
                            0, 0,
                            0, 0,
                            0, 0
                            });
    }
  });

  pos.set(width * 2 + width / 3, height + height / 1.5);
  buttons[32] = new Button(pos, size, generateButtonBase(size, "0010", "Y-", fillColor, textColor, font), new Runnable(){
    public void run(){
      nano.write(new byte[]{0,
                            0, 0,
                            byte(-speed), byte(-speed >> 8),
                            0, 0,
                            0, 0
                            });
    }
  });

  pos.set(width * 2, height + height / 1.5);
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

  pos.set(width + width / 2, height * 2 + height / 1.5);
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
  pos.set(width * 2 + width *.75, height * 2);
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

  pos.set(width * 2, height * 2 + height *.75);
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
  pos.set(width * 2 + width * .75, height * 2 + height / 4);
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
