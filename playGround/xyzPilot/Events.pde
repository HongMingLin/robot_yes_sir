void keyPressed() {
  if (key=='o') {
    isOrtho=!isOrtho;
    println("isOrtho="+isOrtho);
    printCamera();
    printProjection();
  } else if (key=='c') {
    for (int i=0; i<Rs.length; i++)
      Rs[i].clearDiff();
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

void toOrtho(int[] viewport) {
    int w = viewport[2];
  int h = viewport[3];
  int x = viewport[0];
  int y = viewport[1];
  int y_inv =  height - y - h; // inverted y-axis
  if (isOrtho)
    ortho(-width/2, width/2, -height/2, height/2);
  else {
    //float fov = PI/3.0;
    //float cameraZ = (height/2.0) / tan(fov/2.0);
    //perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);
    perspective(60 * PI/180, w/(float)h, 1, 3000);
  }
 
}
