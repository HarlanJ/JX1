import java.lang.Class;


//Used for moving the screen around the menu
int startTime;
final float moveTime = 800;
PVector screenPosition, screenTarget, screenStart;
boolean moving = false;

int initLevel = 0;
int initLevelCount = 2;
Button buttons[];

JSONObject settings;

void setup() {
  size(480, 320);
  //fullScreen();

  noSmooth();
  //noCursor();

  screenPosition = new PVector(0, 0);
  screenTarget = new PVector(0, 0);
  screenStart = new PVector(0, 0);

  buttons = new Button[19];

  thread("runSetup");

  textAlign(CENTER, CENTER);
  rectMode(CORNERS);
}

void draw() {
  if (initLevel == initLevelCount) {
    background(0);
    translate(screenPosition.x, screenPosition.y);

    drawButtons();
    drawLabels();

    if (moving) {
      float amt = pow((millis()-startTime)/moveTime, 2.1);
      screenPosition.set(lerp(screenStart.x, screenTarget.x, amt), lerp(screenStart.y, screenTarget.y, amt));
      if (amt >= 1) {
        screenPosition.set(screenTarget);
        moving = false;
      }
    }
  } else {
    background(0);
    text("Loading...", 0, 0, width, height);
  }
}

void mousePressed() {
  boolean lookingForButton = true;
  int button;
  for (button = 0; button < buttons.length && lookingForButton; button ++) {
    lookingForButton = !buttons[button].pressed();
  }
}