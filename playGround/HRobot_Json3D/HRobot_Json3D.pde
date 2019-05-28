import peasy.PeasyCam;
import java.text.SimpleDateFormat;
import java.util.Date;
ALLMODE AM=ALLMODE.PLAY;
PeasyCam cam;
final int M_SCALE=1;
final int Center_XYZLineLen=100*M_SCALE;
float Window_W=240.0;
//float Window_D=104.0;
float Window_D=30.0;
float Window_H=274.0;
boolean TXLED=false;
boolean RXLED=false;
PImage photo;

PVector robotArray=new PVector(4, 3);
PVector ROOM_W_D_H=new PVector(425, 425, 321);
PVector GLOBAL_ROTATE=new PVector(HALF_PI, 0, 0);
PVector GLOBAL_OFFSET=new PVector(-(Window_W+(Window_W/2)), 0, Window_H/2);

PVector ROOM=new PVector(ROOM_W_D_H.x*M_SCALE, ROOM_W_D_H.y*M_SCALE, ROOM_W_D_H.z*M_SCALE);
String R_IP="10.10.10.88";
int R_PORT=6666;
int R_PORT2=9999;

JSONObject json;
int MinD=0;
int MaxD=(int)ROOM.x*100*M_SCALE;
float CamD=(int)ROOM.x*2*M_SCALE;


PVector windowSize=new PVector(Window_W, Window_D, Window_H);

float CRICLE_R=1;
float globalCRICLE_Time=5000.0;
float globalNowSin=0;
int appH=700;
int appW=900;
UDP u,u2;
boolean REALTIME=false;
String outJ="",inJstr="NotYet";
HRobot[] HRs; 
WHICHROBOT WR=WHICHROBOT.R4F1;
int whichRobot=WR.ID();
LEDPanel[] LEDPs;
float Bpercent=0.5;
int TX_mS=33;
java.util.Timer TX_TIMER =new java.util.Timer("TXTIMER");
statusTimer33 t33=new statusTimer33();
void setup() {
  size(900, 700, P3D);
  try {
    photo = loadImage("HRobot_small.png");
  }
  catch(Exception e) {
    println(e);
  }
  cam = new PeasyCam(this, CamD);
  cam.setMinimumDistance(MinD);
  cam.setMaximumDistance(MaxD);
  cam.setWheelHandler(null);
  //cam.setRotations(-1.218, 0,0);
  //cam.setRotations(0,0, 0.258);
  //cam.setRotations(0, 0.939, 0);
  //cam.lookAt(-124.9, 20.8, 62.6, 837, 2000);
  u = new UDP( this, 1313 );
  u.log( false );
  u.listen( true );
  u2 = new UDP( this, 1212 );
  u2.log( false );
  u2.listen( true );
  HRs=new HRobot[(int)(robotArray.x*robotArray.y)];
  for (int i=0; i<HRs.length; i++) {
    HRs[i]=new HRobot(i);
  }
  LEDPs=new LEDPanel[(int)(robotArray.x*robotArray.y)];
  for (int i=0; i<LEDPs.length; i++)
    LEDPs[i]=new LEDPanel(HRs[i], new PVector(windowSize.x*(i%robotArray.x), windowSize.z*((int)(i/robotArray.x)), windowSize.y*((int)(i/robotArray.x))), new PVector(10, 10));

  setupJson();
  cam.setRotations(-1.32, -0.326, 0.123);
  cam.lookAt(-231, -196, 304, 2000);
  cam.setDistance(1250, 3000);

  TX_TIMER.scheduleAtFixedRate(t33, 0, TX_mS);
    new java.util.Timer().scheduleAtFixedRate(statusTimer500, 0, 500);

}

void draw() {
  background(10);
  fill(0, 255, 0, 50);
  rectMode(CENTER);
  rect(0, 0, 1000, 1000);//green plane
  pushMatrix();
  translate(0, 0, Window_H*3+100);

  rotateX(-HALF_PI);
  if(REALTIME)
  rotateY(QUARTER_PI/5*sin(millis()*TWO_PI/3000.0) );
  imageMode(CENTER);
  image(photo, 0, 0);
  
  //translate(0,0,-130);
  translate(0,80,  0);

  box(10,50,10);
  popMatrix();

  drawXYZ();

  beginHUD();
  //drawToolBox();
  for (int i=0; i<HRs.length; i++)
    HRs[i].UPDATE();
}
void  drawToolBox() {
  noFill();
  stroke(255);
  sphereDetail(2);
  pushMatrix();
  rotateX(GLOBAL_ROTATE.x);
  rect(0, 0, windowSize.x, windowSize.z);
  noFill();
  stroke(255, 255, 0);
  box(Window_W, Window_H, Window_D);//window
  stroke(255);


  popMatrix();
}
