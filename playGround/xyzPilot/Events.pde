void keyPressed() {
  if (key=='c') {
    println("isOrtho="+isOrtho);
    if (isOrtho) {
      toPerspetive();
    } else {
      toOrtho();
    }
  }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  zoomRatio += e/20; 
  if (zoomRatio>1.2) {
    zoomRatio =1.2;
  }
  if (zoomRatio < 0.1) {
    zoomRatio = 0.1;
  }
}

void toPerspetive() {
  for(int i=0;i<cameras.length;i++)
  cameras[i].setDistance(map(zoomRatio, 0.1, 1.2, 50, 500));
  isOrtho = !isOrtho;
}

void toOrtho() {
  for(int i=0;i<cameras.length;i++)
  zoomRatio = map((float)cameras[i].getDistance(), 50, 500, 0.1, 1.2);
  isOrtho = !isOrtho;
}
