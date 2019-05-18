import com.hamoid.*;
import codeanticode.syphon.*;

PGraphics canvas;
SyphonServer server;
VideoExport videoExport;
PVector wish_APP_WH;
PVector SCALE_WH=new PVector(1, 1);

PVector robotArray=new PVector(4, 3);
PVector windowSize=new PVector(240, 274);
PVector ledSize=new PVector(100, 100);

PVector mSize;//=new PVector(windowSize.x*robotArray.x,windowSize.y*robotArray.y);
GBbox[] gbBoxs;//=new gbBoxs[robotArray.x*robotArray.y];
void settings() {
  ledSize.x*=SCALE_WH.x;
  ledSize.y*=SCALE_WH.y;
  windowSize.x*=SCALE_WH.x;
  windowSize.y*=SCALE_WH.y;
  wish_APP_WH=new PVector((robotArray.x*windowSize.x),(robotArray.y*windowSize.y));
  mSize=new PVector(windowSize.x*robotArray.x,windowSize.y*robotArray.y);
  size((int)wish_APP_WH.x, (int)wish_APP_WH.y, P2D);
}
void setup() {
  
  println("wish_APP_WH.x"+wish_APP_WH.x+", wish_APP_WH.y"+wish_APP_WH.y);  
  println("SCALE_WH.x"+SCALE_WH.x+", SCALE_WH.y"+SCALE_WH.y);
  println("mSize.x"+mSize.x+", mSize.y"+mSize.y);
  println("windowSize.x"+windowSize.x+", windowSize.y"+windowSize.y);
  println();  
  gbBoxs=new GBbox[(int)(robotArray.x*robotArray.y)];
  for (int i=0; i<gbBoxs.length; i++)
    gbBoxs[i]=new GBbox(new PVector(windowSize.x*(i%robotArray.x), windowSize.y*((int)(i/robotArray.x))), SCALE_WH);
  
  server = new SyphonServer(this, "Robot Syphon");
}

void draw() {
  background(0);
  drawBlock();
  drawGBbox();
  if (recording) {
    videoExport.saveFrame();
  }
  server.sendImage(get());
}

void drawGBbox() {

  for (int i=0; i<gbBoxs.length; i++) {
    gbBoxs[i].update();
  }
}
boolean recording = false;
String videoFilename;
void keyPressed() {
  if (key == 'r' || key == 'R') {
    if (videoExport==null) {
      videoFilename=new java.util.Date()+".mp4";
      videoExport = new VideoExport(this, videoFilename);
      videoExport.startMovie();
      println("videoFilename="+videoFilename);
    }
    recording = !recording;
    println("Recording is " + (recording ? "RECing" : "PAUSE"));
  } else if (key == 'q') {
    videoExport.endMovie();
    videoExport=null;
  }
}
class GBbox {
  PVector boxSize;//=new PVector(100, 100);
  PVector boxPosOffset; 
  PVector boxPos=new PVector(0, 0);
  GBbox(PVector bPO, PVector scale) {
    boxPosOffset=bPO;
    boxSize=new PVector(100*scale.x, 100*scale.y);
    println("boxPosOffset.x"+boxPosOffset.x+", boxPosOffset.y"+boxPosOffset.y);
  }

  void update() {
    noStroke();
    
    
    pushMatrix();
    rectMode(CORNER);
    translate(boxPosOffset.x, boxPosOffset.y);
    //boxPos.x+=50*sin(millis()*TWO_PI/3000.0);
    fill(0, 255, 0);
    translate(-boxSize.x/2, -boxSize.y/2);
    rect(0,0, boxSize.x/2, boxSize.y);
    fill(0, 0, 255);
    translate(boxSize.x/2, 0);
    rect(0,0, boxSize.x/2, boxSize.y);
    popMatrix();
    
    //pushMatrix();
    //translate(windowSize.x/2, windowSize.y/2);
    //fill(255, 0,0);
    //ellipse(0,0, 10, 10);
    //popMatrix();
    
  }
  void set_boxPosOffset(float x, float y) {
    boxPosOffset.x=x;
    boxPosOffset.y=y;
  }
}
