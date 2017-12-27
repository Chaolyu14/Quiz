class Button{
  float x,y;
  int bx,by;
  PFont font = createFont("SourceHanSansCN-Normal",64);
  int boxcolor = 255;
  int textcolor = 0;

  Button(float a,float b,int c,int d){
    x = a;
    y = b;
    bx = c;
    by = d;
  }


  void show(String text){
    textFont(font);
    textAlign(LEFT);
    fill(boxcolor);
    rect(x,y,bx,by);
    fill(textcolor);
    text(text,x+17,y+58);
  }

  
  void showAnswer(String t){
    textFont(font);
    textAlign(LEFT);
    fill(0,200,0);
    rect(x,y,bx,by);
    fill(textcolor);
    text(t,x+17,y+58);
  }

  boolean OverBox(){
    if(mouseX > x && mouseX < x+bx
      && mouseY > y && mouseY < y+by){
        boxcolor = 0;
        textcolor = 255;
        return true;
      }else{
        boxcolor = 255;
        textcolor = 0;
        return false;
      }
  }
  
  void mouseReleased(){
      boxcolor = 255;
      textcolor = 0;
  }

  void selected(){
        boxcolor = 0;
        textcolor = 255;
  }
  
  void unselected(){
        boxcolor = 255;
        textcolor = 0;
  }
}