import peasy.PeasyCam;
import java.text.SimpleDateFormat;
import java.util.Date;
import controlP5.*;
import processing.video.*;
import java.lang.Math.*;
import codeanticode.syphon.*;

PGraphics canvas;
SyphonClient client;

ControlP5 cp5;
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
PImage HIWIN_LOGO;
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
UDP u, u2;
boolean REALTIME=false;
String outJ="", inJstr="NotYet";
HRobot[] HRs; 
WHICHROBOT WR=WHICHROBOT.R2F1;
int whichRobot=WR.ID();
LEDPanel[] LEDPs;
float Bpercent=0.5;
int TX_mS=33;
java.text.DecimalFormat df=new java.text.DecimalFormat("#.###");

java.util.Timer TX_TIMER =new java.util.Timer("TXTIMER");
statusTimer33 t33=new statusTimer33();
void fakeGraphics(PGraphics pg){
  pg.beginDraw();
  pg.background(0);
  
  pg.endDraw();
}

void setup() {
  size(1000, 800, P3D);
  try {
    photo = loadImage("HRobot_small.png");
    HIWIN_LOGO= loadImage("HIWIN_LOGO.png");
  }
  catch(Exception e) {
    println(e);
  }
    canvas= createGraphics(300, 300);
  fakeGraphics(canvas);
  client = new SyphonClient(this);

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  setup_cp5();
  cam = new PeasyCam(this, CamD);
  cam.setMinimumDistance(MinD);
  cam.setMaximumDistance(MaxD);
  //cam.setWheelHandler(null);
  //cam.setRotations(-1.218, 0,0);
  //cam.setRotations(0,0, 0.258);
  //cam.setRotations(0, 0.939, 0);
  //cam.lookAt(-124.9, 20.8, 62.6, 837, 2000);
  u = new UDP( this, 1313 );
  u.log( false );
  u.listen( true );
  u2 = new UDP( this, 9999 );
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
  cam.setRotations(-1.537, -0.273, 0.053);
  cam.lookAt(-591, 92, 798, 2000);
  cam.setDistance(1908, 6000);

  TX_TIMER.scheduleAtFixedRate(t33, 0, TX_mS);
  new java.util.Timer().scheduleAtFixedRate(statusTimer500, 0, 500);
  exec("/usr/bin/say", "HI WIN Robot online");


  setup2();
}

void draw() {
  background(10);
    if (client.newFrame()) {
    canvas = client.getGraphics(canvas);
    
    //image(canvas, 0, 0, width, height);    
  } 

  fill(0, 255, 0, 50);
  rectMode(CENTER);
  rect(0, 0, 1000, 1000);//green plane
  rectMode(CORNER);
  pushMatrix();
  translate(0, 0, Window_H*3+100);

  rotateX(-HALF_PI);
  if (REALTIME)
    rotateY(QUARTER_PI/5*sin(millis()*TWO_PI/3000.0) );
  imageMode(CENTER);
  image(photo, 0, 0);

  //translate(0,0,-130);
  translate(0, 80, 0);
  noStroke();
  box(10, 50, 10);
  popMatrix();

  drawXYZ();

  beginHUD();
  //drawToolBox();
  for (int i=0; i<HRs.length; i++)
    HRs[i].UPDATE();
  pushMatrix();
  translate(0,0,1000);
  rotateX(-HALF_PI);
  
  draw2();
  strokeWeight(1);
  //noStroke();
  popMatrix();
}
void  drawToolBox() {
  noFill();
  stroke(255);
  sphereDetail(2);
  pushMatrix();
  rotateX(GLOBAL_ROTATE.x);
  rectMode(CENTER);
  rect(0, 0, windowSize.x, windowSize.z);
  rectMode(CORNER);
  noFill();
  stroke(255, 255, 0);
  box(Window_W, Window_H, Window_D);//window
  stroke(255);
  popMatrix();
}
Knob myKnobA;
Knob myKnobB;
ListBox list;
void setup_cp5() {
  
  ButtonBar b = cp5.addButtonBar("bar")
    .setPosition(10, 0)
    .setSize(300, 20)
    .addItems(split("a b c d e f g h i j k ", " "))
    ;
  println(b.getItem("a"));
  //b.changeItem("a","text","REALTIME "+(REALTIME?"ON":"OFF"));
  //b.changeItem("b","text","ESTOP");
  //b.changeItem("c","text","third");
  b.onMove(new CallbackListener() {
    public void controlEvent(CallbackEvent ev) {
      ButtonBar bar = (ButtonBar)ev.getController();
      println("hello ", bar.hover());
    }
  }
  );
  myKnobA = cp5.addKnob("knob")
    .setRange(0, 255)
    .setValue(50)
    .setPosition(20, 400)
    .setRadius(20)
    .setDragDirection(Knob.VERTICAL)
    ;
    myKnobB = cp5.addKnob("knobValue")
    .setRange(0, 255)
    .setValue(220)
    .setPosition(80, 400)
    .setRadius(20)
    .setNumberOfTickMarks(10)
    .setTickMarkLength(4)
    .snapToTickMarks(true)
    .setColorForeground(color(255))
    .setColorBackground(color(0, 160, 100))
    .setColorActive(color(255, 255, 0))
    .setDragDirection(Knob.HORIZONTAL)
    ;
  list = cp5.addListBox("ROBOT LOG")
    .setPosition(500, 0)
    .setSize(500, 500)
    .setItemHeight(15)
    .setBarHeight(20)
    .setColorBackground(color(255, 128))
    .setColorActive(color(0))
    .setColorForeground(color(255, 100))
    .close()
    ;   
  list.getCaptionLabel().setColor(0xffff0000);
  for (int i=0; i<80; i++) {
    list.addItem("log "+i, i);
    list.getItem("log "+i).put("color", new CColor().setBackground(0xffff0000).setBackground(0xffff88aa));
  }
  
}
