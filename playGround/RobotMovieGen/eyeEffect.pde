class Eye {
  int x, y;
  float mx, my;
  int size;
  float dist;
  float angle = 0.0;
  
  Eye(int tx, int ty, int ts) {
    x = tx;
    y = ty;
    size = ts;
 }

  float update(int mx, int my) {
    
    this.mx=mx;
    this.my=my;
    dist=dist(x,y,mx,my);
    angle = atan2(my-y, mx-x);
    return angle;
  }
  
  void drawx() {
    fill(255);
    line(x,y,mx,my);
  }
}
