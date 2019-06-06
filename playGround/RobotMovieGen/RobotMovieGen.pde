import com.hamoid.*;
import codeanticode.syphon.*;
import java.text.SimpleDateFormat;
boolean recording = false;
String videoFilename;
SimpleDateFormat SDF= new SimpleDateFormat("MMdd_HHmmss.S");
PGraphics canvas;
SyphonServer server;
VideoExport videoExport;
MODE ALLMODE=MODE.MOUSE_GB;
PVector SCALE_MOVIE=new PVector(0.5, 0.5);

PVector robotArray=new PVector(4, 3);
PVector windowSize=new PVector(260, 274);
PVector ledSize=new PVector(100, 100);
PVector ledSizeHalf=new PVector(ledSize.x/2, ledSize.y/2);
PVector windowHalfSize=new PVector(windowSize.x/2, windowSize.y/2);

PVector movieSize=new PVector(windowSize.x*robotArray.x*SCALE_MOVIE.x, windowSize.y*robotArray.y*SCALE_MOVIE.y);

GBbox[] gbBoxs;//=new gbBoxs[robotArray.x*robotArray.y];
RedDot[] redDots;
void settings() {
  size((int)movieSize.x, (int)movieSize.y, P2D);
}
void setup() {


  println("SCALE_WH.x"+SCALE_MOVIE.x+", SCALE_WH.y"+SCALE_MOVIE.y);
  println("mSize.x"+movieSize.x+", mSize.y"+movieSize.y);
  println("windowSize.x"+windowSize.x+", windowSize.y"+windowSize.y);
  println();  
  redDots=new RedDot[(int)(robotArray.x*robotArray.y)];
  for (int i=0; i<redDots.length; i++)
    redDots[i]=new RedDot(new PVector(windowSize.x*(i%robotArray.x), windowSize.y*((int)(i/robotArray.x))), new PVector(10, 10));

  gbBoxs=new GBbox[(int)(robotArray.x*robotArray.y)];
  for (int i=0; i<gbBoxs.length; i++)
    gbBoxs[i]=new GBbox(new PVector(windowSize.x*(i%robotArray.x), windowSize.y*((int)(i/robotArray.x))), SCALE_MOVIE);

  server = new SyphonServer(this, "RobotSyphon");
}

void draw() {
  background(0);
  drawBlock();
  pushMatrix();
  scale(SCALE_MOVIE.x, SCALE_MOVIE.y);
  effect();
  for (int i=0; i<gbBoxs.length; i++) {
    gbBoxs[i].update();
  }
  for (int i=0; i<redDots.length; i++) {
    redDots[i].update();
  }
  popMatrix();
  if (recording) {
    videoExport.saveFrame();
  }
  server.sendImage(get());
  fill(255);
  text(" FPS:"+ nfc(frameRate, 2)+" Mode="+ALLMODE, 10, 10);
  text(mouseX+","+mouseY, mouseX, mouseY);
}

void effect() {

  switch(ALLMODE) {
  case MOUSE_RED:
    for (int i=0; i<gbBoxs.length; i++) {
      redDots[i].setXY(
        (mouseX/movieSize.x), 
        (mouseY/movieSize.y));
    }
    break;
  case MOUSE_GB:
    for (int i=0; i<gbBoxs.length; i++) {
      gbBoxs[i].setXY(
        (mouseX/movieSize.x), 
        (mouseY/movieSize.y));
    }
    break;
  case CIRCLE_XY:
    for (int i=0; i<gbBoxs.length; i++) {
      gbBoxs[i].goXY(-10+windowSize.x/4.0*sin(millis()*TWO_PI/3000.0), 
        -10+windowSize.x/4.0*cos(millis()*TWO_PI/3000.0), 1000);
    }

    break;
  default:
    break;
  }
}
