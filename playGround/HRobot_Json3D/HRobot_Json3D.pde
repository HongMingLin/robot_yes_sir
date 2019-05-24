import peasy.PeasyCam;
ALLMODE AM=ALLMODE.PLAY;
PeasyCam cam;
final int M_SCALE=1;
final int Center_XYZLineLen=100*M_SCALE;
PVector robotArray=new PVector(4, 3);
PVector ROOM_W_D_H=new PVector(425, 425, 321);
PVector ROOM=new PVector(ROOM_W_D_H.x*M_SCALE, ROOM_W_D_H.y*M_SCALE, ROOM_W_D_H.z*M_SCALE);
String R_IP="10.10.10.88";
int R_PORT=6666;
JSONObject json;
int MinD=0;
int MaxD=(int)ROOM.x*100*M_SCALE;
float CamD=(int)ROOM.x*2*M_SCALE;

float Window_W=140.0;
float Window_D=104.0;
float Window_H=274.0;
PVector windowSize=new PVector(Window_W, Window_D, Window_H);

float CRICLE_R=1;
float globalCRICLE_Time=5000.0;
float globalNowSin=0;
int appH=700;
int appW=900;
UDP u;
boolean REALTIME=false;

HRobot[] HRs; 
int whichRobot=0;
LEDPanel[] LEDPs;
float Bpercent=0.5;
void setup() {
  size(900, 700, P3D);
  cam = new PeasyCam(this, CamD);
  cam.setMinimumDistance(MinD);
  cam.setMaximumDistance(MaxD);
  cam.setWheelHandler(null);
  //cam.setRotations(-1.218, 0,0);
  //cam.setRotations(0,0, 0.258);
  //cam.setRotations(0, 0.939, 0);
  //cam.lookAt(-124.9, 20.8, 62.6, 837, 2000);
  u = new UDP( this, 7777 );
  u.log( false );
  u.listen( true );
  HRs=new HRobot[(int)(robotArray.x*robotArray.y)];
  for (int i=0; i<HRs.length; i++)
    HRs[i]=new HRobot();
  LEDPs=new LEDPanel[(int)(robotArray.x*robotArray.y)];
  for (int i=0; i<LEDPs.length; i++)
    LEDPs[i]=new LEDPanel(new PVector(windowSize.x*(i%robotArray.x), windowSize.z*((int)(i/robotArray.x)), windowSize.y*((int)(i/robotArray.x))), new PVector(10, 10));

  setupJson();

  new java.util.Timer().scheduleAtFixedRate(statusTimer33, 0, 33);
}
void draw() {
  background(10);
  drawXYZ();
  drawWindow();
  beginHUD();
  drawToolBox();
  for (int i=0; i<HRs.length; i++)
    HRs[i].UPDATE();
  
  //for (int i=0; i<LEDPs.length; i++) {
  //  LEDPs[i].update();
  //}
}
void  drawToolBox() {

  noFill();
  stroke(255);
  sphereDetail(2);
  pushMatrix();
  translate(HRs[whichRobot].XYZ.x, HRs[whichRobot].XYZ.y, HRs[whichRobot].XYZ.z);

  sphere(10);
  box(100, 10, 100);
  popMatrix();
}
