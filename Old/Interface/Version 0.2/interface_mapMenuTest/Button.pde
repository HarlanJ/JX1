import java.lang.Runnable;

class Button{
  PVector pos, size;
  PImage texture;
  
  private Runnable callback;
  
  Button(PVector p, PVector s, PImage t, Runnable CallBack){
    this.pos = p.copy();
    this.size = s.copy();
    this.texture = t;
    this.callback = CallBack;
  }
  
  boolean pressed(){
    float x = mouseX - screenPosition.x;
    float y = mouseY - screenPosition.y;
    if(x > pos.x && x < pos.x + size.x && y > pos.y && y < pos.y + size.y){
      callback.run();
      return true;
    }
    return false;
  }
  
  void draw(){
    if(moving || pos.x + 5 > -screenPosition.x && pos.x< (-screenPosition.x) + width && pos.y + 5 > -screenPosition.y && pos.y < (-screenPosition.y) + height){
      pushStyle();
      imageMode(CORNER);
      image(texture, pos.x, pos.y, size.x, size.y);
      popStyle();
    }
  }
}