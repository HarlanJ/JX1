import processing.serial.*;
import java.lang.Class;
import java.io.File;

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

void settings(){
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

  //diagonal = int(sqrt(sq(width) + sq(height)));
  noSmooth();
}

void setup() {
  if(isOnTargetPi) exec("/usr/share/scripts/login");

  try{
    String portName = "";
    if(isOnTargetPi){
      portName  = "/dev/serial0";
    } else {
      portName = "COM3";
    }
    nano = new Serial(this, portName, 115200);
    println("Serial connected.");
  } catch (RuntimeException e){
    println("Serial failed to connect.");
  }

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

void handleSerial(){
  while(nano.available() > 0){
    print(nano.readString());
  }
}

void draw() {
  if (initLevel == initLevelCount) {
    handleSerial();
    background(settings.getInt("bgColor"));
    translate(screenPosition.x, screenPosition.y);

    drawButtons();
    drawLabels();

    if (moving) {
      float amt = pow((millis()-startTime)/(float)moveTime, 2.1);
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

void mousePressed() {
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
