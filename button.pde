class button{
  int x,y,sizeX,sizeY;
  
  button(int xi, int yi, int sizeXi, int sizeYi){
    x=xi;
    y=yi;
    sizeX=sizeXi;
    sizeY=sizeYi;
  }
  
  void draw(){
    rect(x,y,sizeX,sizeY);
  }
  
  boolean click(int xi, int yi){
    return (xi>x && xi<x+sizeX && yi>y && yi<y+sizeY);
  }
}