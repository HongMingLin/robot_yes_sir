import processing.video.*;
import com.hamoid.*;
import codeanticode.syphon.*;
import java.text.SimpleDateFormat;
//boolean recording = false;
String videoFilename;
SimpleDateFormat SDF= new SimpleDateFormat("MMdd_HHmmss.S");
PGraphics canvas;
SyphonServer server;
VideoExport videoExport;
MODE ALLMODE=MODE.QLAB;
//PVector SCALE_MOVIE=new PVector(0.5, 0.5);
PVector movieSize=new PVector(640, 480);
Movie myMovie;
PVector robotArray=new PVector(4, 3);
PVector windowSize=new PVector(240, 274);
PVector ledSize=new PVector(100, 100);
PVector ledSizeHalf=new PVector(ledSize.x/2, ledSize.y/2);
PVector windowHalfSize=new PVector(windowSize.x/2, windowSize.y/2);
PVector SCALE_MOVIE=new PVector(movieSize.x/(windowSize.x*robotArray.x), movieSize.y/(windowSize.y*robotArray.y));

//PVector movieSize=new PVector(windowSize.x*robotArray.x*SCALE_MOVIE.x, windowSize.y*robotArray.y*SCALE_MOVIE.y);

GBbox[] gbBoxs;//=new gbBoxs[robotArray.x*robotArray.y];
RedDot[] redDots;
int circleTime=10000;
void movieEvent(Movie m) {
  m.read();
}
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
    gbBoxs[i]=new GBbox(i, new PVector(windowSize.x*(i%robotArray.x), windowSize.y*((int)(i/robotArray.x))), SCALE_MOVIE);
  try {
    ///Users/xlinx/Movies/robotTest/Test 11-1.mp4
    File mf = new File(System.getProperty("user.dir")+"/Movies/robotTest/Test 11-1.mp4");
    if (mf.exists())
    {
      myMovie = new Movie(this, mf.getAbsolutePath());
      myMovie.loop();
    }
    ///Users/xlinx/Movies/robotTest/Test 3-2.mp4
  }
  catch(Exception e) {
    myMovie=null;
    e.printStackTrace();
  }


  server = new SyphonServer(this, "RobotSyphon");
}
void notMovie() {
  pushMatrix();
  scale(SCALE_MOVIE.x, SCALE_MOVIE.y);
  effect();
  for (int i=0; i<gbBoxs.length; i++) {
    gbBoxs[i].drawx();
  }
  for (int i=0; i<redDots.length; i++) {
    redDots[i].drawx();
  }
  popMatrix();
}
void draw() {
  background(0);

  switch(ALLMODE) {

  case MOVIE:
    //image(myMovie, 0, 0, 300, myMovie.height/(myMovie.width/300.0));
    if (myMovie!=null)
      image(myMovie, 0, 0, movieSize.x, movieSize.y);
    break;
  default:
    notMovie();
    break;
  }
  drawBlock();
  //server.sendImage(get());
  server.sendScreen();  



  if (videoExport!=null) {
    videoExport.saveFrame();
  }

  //pushMatrix();

  //popMatrix();
  fill(255);
  textSize(12);
  text(" FPS:"+ nfc(frameRate, 2)+" Mode="+ALLMODE+" M-Wheel="+(SCALE_ROTATE?"scale ":"rotate ") + (gbBoxs[0].nowBoxSize), 10, 10);
  text(mouseX+","+mouseY, mouseX, mouseY);
}

void effect() {

  switch(ALLMODE) {

  case EYE:
    for (int i=0; i<gbBoxs.length; i++) {
      redDots[i].setXY((mouseX/movieSize.x), (mouseY/movieSize.y));
      println("["+i+"]="+redDots[i].eye.angle);
    }
    break;

  case SEQ_GB:

    for (int i=0; i<gbBoxs.length; i++) {
      gbBoxs[i].setXY(
        ((float)mouseX/movieSize.x)*((1+sin(TWO_PI/12*i))/2.0), 
        ((float)mouseY/movieSize.y)*((1+sin(TWO_PI/12*i))/2.0));
    }
    break;
  case MOUSE_RED:
    PVector mouseP=new PVector(mouseX, mouseY);
    for (int i=0; i<gbBoxs.length; i++) {
      //int dist=mouseP.dist(redDots[i].boxPosOffset);
      mouseP.sub(redDots[i].boxPosOffset);
      redDots[i].setXY(
        ((float)mouseX/movieSize.x), 
        ((float)mouseY/movieSize.y));
    }
    break;
  
  case MOUSE_GB:
    for (int i=0; i<gbBoxs.length; i++) {
      gbBoxs[i].setXY(
        ((float)mouseX/movieSize.x), 
        ((float)mouseY/movieSize.y));
    }
    break;
  case CIRCLE_RED:
    for (int i=0; i<redDots.length; i++) {
      redDots[i].setXY(
        (1+sin(millis()*TWO_PI/circleTime))/2, 
        (1+cos(millis()*TWO_PI/circleTime))/2);
      gbBoxs[i].setXY(
        ((float)mouseX/movieSize.x), 
        ((float)mouseY/movieSize.y));
    }
    break;
  case CIRCLE_XY:
    for (int i=0; i<gbBoxs.length; i++) {
      gbBoxs[i].setXY(
        (1+sin(millis()*TWO_PI/circleTime))/2, 
        (1+cos(millis()*TWO_PI/circleTime))/2);
    }

    break;
  default:
    break;
  }
}
