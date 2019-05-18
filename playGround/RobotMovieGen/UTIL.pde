void drawBlock(){
  stroke(200);
  for(int i=0;i<3;i++){
    float wx=(mSize.x/robotArray.x)+(i*(mSize.x/robotArray.x));
    line(wx ,0,wx,mSize.y);
  }
  for(int i=0;i<2;i++){
    float wy=(mSize.y/robotArray.y)+(i*(mSize.y/robotArray.y));
    line(0,wy,mSize.x,wy);
  }
}
