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
int appW=800;
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

  int gap = 5;

  // tiling size
  int tilex = floor((width  - gap) / NX);
  int tiley = floor((height - gap) / NY);

  // viewport offset ... corrected gap due to floor()
  int offx = (width  - (tilex * NX - gap)) / 2;
  int offy = (height - (tiley * NY - gap)) / 2;

  // viewport dimension
  int cw = tilex - gap;
  int ch = tiley - gap;

  // create new viewport for each camera
  for (int y = 0; y < NY; y++) {
    for (int x = 0; x < NX; x++) {
      int id = y * NX + x;
      int cx = offx + x * tilex;
      int cy = offy + y * tiley;
      cameras[id] = new PeasyCam(this, 400);
      cameras[id].setDistance(50);
      cameras[id].setViewport(cx, cy, cw, ch);
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
void processingJ(JSONObject J) {
  JSONArray inJArr=J.getJSONArray(JSONKEYWORD.Robots);
  if (inJArr!=null&&inJArr.size()==12) {
    String LINEStr="";
    for (int i=0; i<12; i++) {
      int ID=inJArr.getJSONObject(i).getInt(JSONKEYWORD.ID)-1;
      PVector p=new PVector(inJArr.getJSONObject(i).getFloat("X"), 
        inJArr.getJSONObject(i).getFloat("Y"), 
        inJArr.getJSONObject(i).getFloat("Z"));
      Rs[ID].XYZ=p.normalize().mult(50);
      PVector p2=new PVector(inJArr.getJSONObject(i).getFloat("A"), 
        inJArr.getJSONObject(i).getFloat("B"), 
        inJArr.getJSONObject(i).getFloat("C"));
      Rs[ID].RYP=p2.normalize().mult(100);
    }
  } else {
    println("[X]J12Arr Error");
  }
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
  text("MAX_XYZ= "+nf(Rs[0].max_XYZ.x,2,2)+", "+nf(Rs[0].max_XYZ.y,2,2)+", "+nf(Rs[0].max_XYZ.z,2,2)+"", 10, 35);
   
  text("MIN_XYZ= "+nf(Rs[0].min_XYZ.x,2,2)+", "+nf(Rs[0].min_XYZ.y,2,2)+", "+nf(Rs[0].min_XYZ.z,2,2)+"", 10, 55);
  text("DIF_XYZ= "+nf(Rs[0].diff_XYZ.x,2,2)+", "+nf(Rs[0].diff_XYZ.y,2,2)+", "+nf(Rs[0].diff_XYZ.z,2,2)+"", 10, 75);
  cam.endHUD();
}
