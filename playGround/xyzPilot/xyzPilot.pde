import peasy.PeasyCam;
UDP u;
final int M_SCALE=1;
final int Center_XYZLineLen=100*M_SCALE;
PVector ROOM_W_D_H=new PVector(425, 425, 321);
PVector ROOM=new PVector(ROOM_W_D_H.x*M_SCALE, ROOM_W_D_H.y*M_SCALE, ROOM_W_D_H.z*M_SCALE);
int MinD=0;
int MaxD=(int)ROOM.x*100*M_SCALE;
float CamD=(int)ROOM.x*2*M_SCALE;
int appH=600;
int appW=1000;
//PeasyCam cam;
Robot[] Rs=new Robot[12];
final int NX = 2;
final int NY = 2;
PeasyCam[] cameras = new PeasyCam[NX * NY];
boolean isOrtho=true; 
float zoomRatio = 1.0;
void settings() {
  size(appW, appH, P3D);
}
void setup() {
  setupJson();
  u = new UDP( this, 6666 );
  u.log( false );
  u.listen( true );
  setupCam();
  for (int i=0; i<Rs.length; i++) {
    Rs[i]=new Robot(this);
  }
}
void setupCam() {
  for (int i=0; i<cameras.length-1; i++) {
    cameras[i] = new PeasyCam(this, 400);
    cameras[i].setDistance(50);
    cameras[i].setViewport((width/3)*i, 0, width/3, height/2);
  }
  cameras[3] = new PeasyCam(this, 400);
  cameras[3].setViewport(0, height/2, width, height/2);
  setupCam2();
}
void setupCam2() {

  for (int id=0; id<cameras.length; id++) {

    if (id==0)
      cameras[id].setYawRotationMode();   
    else if (id==1)
      cameras[id].setPitchRotationMode(); 
    else if (id==2)
      cameras[id].setRollRotationMode();  
    else if (id==3)
      cameras[id].setSuppressRollRotationMode(); 
    else
      cameras[id].setFreeRotationMode();
  }
}
void draw() {
  setGLGraphicsViewport(0, 0, width, height);
  background(10);


  for (int i = 0; i < cameras.length; i++) {
    pushStyle();
    pushMatrix();
    displayScene(cameras[i], i);
    popMatrix();
    popStyle();
  }
  //paitPath3D();
}
void setGLGraphicsViewport(int x, int y, int w, int h) {
  PGraphics3D pg = (PGraphics3D) this.g;
  PJOGL pgl = (PJOGL) pg.beginPGL();  
  pg.endPGL();

  pgl.enable(PGL.SCISSOR_TEST);
  pgl.scissor (x, y, w, h);
  pgl.viewport(x, y, w, h);
}

void displayScene(PeasyCam cam, int ID) {

  int[] viewport = cam.getViewport();
  int w = viewport[2];
  int h = viewport[3];
  int x = viewport[0];
  int y = viewport[1];
  int y_inv =  height - y - h; // inverted y-axis
  setGLGraphicsViewport(x, y_inv, w, h);
  cam.feed();
  //cam.rotateY(radians(1));
  perspective(60 * PI/180, w/(float)h, 1, 3000);
  //background(24);  
  stroke(0);
  strokeWeight(1);

  // scene objects
  pushMatrix();
  Rs[0].updateDraw();
  //for (int i=0; i<Rs.length; i++) {
  //  Rs[i].updateDraw();
  //}
  //rotateX(PI/(ID+1));
  drawXYZ();


  popMatrix();

  //pushMatrix();
  //translate(100, 0, 0);
  //rotateX(PI/2);
  //float c = 255 * ID/(float) (cameras.length-1);
  //fill(255-c/2, 255, 255-c);
  //sphere(80);
  //popMatrix();

  // screen-aligned 2D HUD
  cam.beginHUD();

  rectMode(CORNER);
  fill(0);
  rect(0, 0, 60, 23);
  fill(255, 128, 128);
  text("cam "+ID, 10, 15);
  fill(255, 255, 0);
  
  int START_Y=100, OFFSET_Y=16;
  if(ID==3){
  text("MAX_XYZ= "+nf(Rs[0].max_XYZ.x, 2, 3)+", "+nf(Rs[0].max_XYZ.y, 2, 3)+", "+nf(Rs[0].max_XYZ.z, 2, 3)+"", 10, START_Y+=OFFSET_Y);
  text("MIN_XYZ= "+nf(Rs[0].min_XYZ.x, 2, 3)+", "+nf(Rs[0].min_XYZ.y, 2, 3)+", "+nf(Rs[0].min_XYZ.z, 2, 3)+"", 10, START_Y+=OFFSET_Y);
  text("DIF_XYZ= "+nf(Rs[0].diff_XYZ.x, 2, 3)+", "+nf(Rs[0].diff_XYZ.y, 2, 3)+", "+nf(Rs[0].diff_XYZ.z, 2, 3)+"", 10, START_Y+=OFFSET_Y);
  text("MAX_ABC= "+nf(Rs[0].max_RYP.x, 2, 3)+", "+nf(Rs[0].max_RYP.y, 2, 3)+", "+nf(Rs[0].max_RYP.z, 2, 3)+"", 10, START_Y+=OFFSET_Y);
  text("MIN_ABC= "+nf(Rs[0].min_RYP.x, 2, 3)+", "+nf(Rs[0].min_RYP.y, 2, 3)+", "+nf(Rs[0].min_RYP.z, 2, 3)+"", 10, START_Y+=OFFSET_Y);
  text("DIF_ABC= "+nf(Rs[0].diff_RYP.x, 2, 3)+", "+nf(Rs[0].diff_RYP.y, 2, 3)+", "+nf(Rs[0].diff_RYP.z, 2, 3)+"", 10, START_Y+=OFFSET_Y);
  }
  START_Y=20;
  OFFSET_Y=16;
  float[] xyz = cameras[ID].getRotations();
  fill(255);
  text("rX="+nf(xyz[0], 1, 3)+" rY="+nf(xyz[1], 1, 3)+" rZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);
  xyz=cameras[ID].getPosition();
  text("cX="+nf(xyz[0], 1, 3)+" cY="+nf(xyz[1], 1, 3)+" cZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);
  xyz=cameras[ID].getLookAt();
  text("lookX="+nf(xyz[0], 1, 3)+" lookY="+nf(xyz[1], 1, 3)+" lookZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);
  cam.endHUD();
}
