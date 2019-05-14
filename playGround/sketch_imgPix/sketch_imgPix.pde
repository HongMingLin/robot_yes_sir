  
import processing.video.*;
import java.lang.Math.*;
import peasy.*;

PeasyCam cam;
Movie myMovie;

class ascreen_info
{
  
  PVector R=new PVector();
  PVector G=new PVector();
  PVector B=new PVector();
  
  
  PVector XYZ=new PVector();
  PVector RYP=new PVector();
  
  PVector idx_on_video=new PVector();
  
  
  PVector pos_in_world=new PVector();
  ascreen_info(int idx_x,int idx_y,PVector pos_in_world)
  {
    idx_on_video.x = idx_x;
    idx_on_video.y = idx_y;
    this.pos_in_world.set(pos_in_world);
  }
  
  void setIdx(int idx_x,int idx_y)
  {
    idx_on_video.x = idx_x;
    idx_on_video.y = idx_y;
  }
  
  final PVector getR()
  {
    return R;
  }
  
  
  final PVector getG()
  {
    return G;
  }
  
  
  final PVector getB()
  {
    return B;
  }
  
  
  final PVector getIdx()
  {
    return idx_on_video;
  }
  
  final PVector getXYZ()
  {
    return XYZ;
  }
  
  final PVector getRYP()
  {
    return RYP;
  }
  
  final PVector getOrigin()
  {
    return pos_in_world;
  }
  
  
  int setRGBInfo(PVector R,PVector G,PVector B)
  {
    this.R.set(R);
    this.G.set(G);
    this.B.set(B);
    CorrdTrans(this.R,this.G,this.B,XYZ,RYP);
    return 0;
  }
  
  
  void CorrdTrans( PVector R,PVector G,PVector B,PVector ret_XYZ,PVector ret_RYP)
  {
    ret_XYZ.x = (G.x+B.x)/2;
    ret_XYZ.y = (G.y+B.y)/2;
    
    
    ret_XYZ.z = (float)Math.hypot(G.x-B.x,G.y-B.y)-0.5;
    
    
    float roll = atan2(G.y-B.y,G.x-B.x);
    //The x y is for image coordnate, x axis is upside down, ie, positive angle is CW
    //println(roll*180/PI);
    ret_RYP.x = roll;
    
    float Ry = -R.y;
    float rX = R.x * cos(roll) - Ry * sin(roll);
    float rY = Ry * cos(roll) + R.x * sin(roll);
    
    float rotateMap=PI/4;
    ret_RYP.y = rY*rotateMap;
    ret_RYP.z = rX*rotateMap;
    
  }
}





// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}


ascreen_info []ascArr;

void setup() {
  
  size(600, 600,P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(5000);
  cam.lookAt(0, 0, 0,1600,0);
  myMovie = new Movie(this, "UntitledSingle_LOW.m4v");
  
  myMovie.loop();
  ascArr=new ascreen_info[12];
  /*for(int i=0;i<ascArr.length;i++)
  {
    int x= i%4;
    int y= i/4;
    ascArr[i]=new ascreen_info(x,y,new PVector(x*30,y*30,0));
  }*/
  
  float w1=2400+200,w2=2400+1400,h=-2740-2760;
  
  ascArr[ 0]=new ascreen_info(0,0,new PVector(-w1-w2/2,h,0));
  ascArr[ 1]=new ascreen_info(1,0,new PVector(-w2/2,h,0));
  ascArr[ 2]=new ascreen_info(2,0,new PVector( w2/2,h,0));
  ascArr[ 3]=new ascreen_info(3,0,new PVector(+w1+w2/2,h,0));
  
  ascArr[ 4]=new ascreen_info(0,1,new PVector(-w1-w2/2,0,0));
  ascArr[ 5]=new ascreen_info(1,1,new PVector(-w2/2,0,0));
  ascArr[ 6]=new ascreen_info(2,1,new PVector( w2/2,0,0));
  ascArr[ 7]=new ascreen_info(3,1,new PVector(+w1+w2/2,0,0));
  
  ascArr[ 8]=new ascreen_info(0,2,new PVector(-w1-w2/2,-h,0));
  ascArr[ 9]=new ascreen_info(1,2,new PVector(-w2/2,-h,0));
  ascArr[10]=new ascreen_info(2,2,new PVector( w2/2,-h,0));
  ascArr[11]=new ascreen_info(3,2,new PVector(+w1+w2/2,-h,0));
  
  //ascArr[1]=new ascreen_info(1,1,new PVector(10,10,0));
  for(int i=0;i<ascArr.length;i++)
  {
    ascArr[i].setIdx(1,1);
  }
}

void drawFrame()
{
  float size=1000;
  //rect(-5, -5, 10, 10);
  noFill();
  stroke(255,0,0);
  rect(-2400/2, -2740/2, 2400, 2740);
}

void drawBoard()
{
  float size=1000;
  //rect(-5, -5, 10, 10);
  noStroke();
  fill(0,0,255);
  rect(-size/2, -size/2, size/2, size);
  fill(0,255,0);
  rect(0, -size/2, size/2, size);
  /*noStroke();
  scale(10,10,2);
  sphere(1);  */ 
}


void sectionFinding( PImage myImage,ascreen_info []asc_arr )
{
  
  myImage.loadPixels();
  PVector R=new PVector();
  PVector G=new PVector();
  PVector B=new PVector();
  int t1 = millis();
  int XSectNum=4;
  int YSectNum=3;
  int SectW=myImage.width/XSectNum;
  int SectH=myImage.height/YSectNum;
  
  textAlign(CENTER,CENTER);
  
  
  for(int i=0;i<asc_arr.length;i++)
  {
    int idx_x=(int)asc_arr[i].getIdx().x;
    int idx_y=(int)asc_arr[i].getIdx().y;
    
    //println(idx_y+","+idx_x);
    FindRGBLocation(myImage,SectW*idx_x,SectH*idx_y,SectW-1,SectH-1,R,G,B);
    
    R.x-=SectW/2.0f;
    R.y-=SectH/2.0f;
    
    R.x/=SectW/2.0f;//scale to same W
    R.y/=SectW/2.0f;
    
    
    
    G.x-=SectW/2.0f;
    G.y-=SectH/2.0f;
    
    G.x/=SectW/2.0f;//scale to same W
    G.y/=SectW/2.0f;
    
    
    B.x-=SectW/2.0f;
    B.y-=SectH/2.0f;
    
    B.x/=SectW/2.0f;//scale to same W
    B.y/=SectW/2.0f;
    
    
    asc_arr[i].setRGBInfo( R, G, B);
  }
  
  PVector XYZ=new PVector();
  PVector RYP=new PVector();
  for(int i=0;i<asc_arr.length;i++)
  {
    if(asc_arr[i].getR().z*asc_arr[i].getG().z*asc_arr[i].getB().z==0)continue;
    XYZ.set(asc_arr[i].getXYZ());
    RYP.set(asc_arr[i].getRYP());
    
    pushMatrix();
    
    final PVector origin = asc_arr[i].getOrigin();
    translate(origin.x,origin.y,origin.z);
    drawFrame();
    translate(1000*XYZ.x, 1000*XYZ.y, 4000*XYZ.z);
    rotateZ(RYP.x);
    rotateX(RYP.y);
    rotateY(RYP.z);
    
    drawBoard();
    
    popMatrix();
  }
  /*
      if(false)
      {
        cam.beginHUD();
        R.x+=1;
        R.y+=1;
        G.x+=1;
        G.y+=1;
        B.x+=1;
        B.y+=1;
        R.mult(300);
        G.mult(300);
        B.mult(300);
        if(R.z>10)
        {
          stroke(255,0,0);
          fill(255,0,0);
          ellipse(R.x, R.y, 20, 20);
          stroke(255,0,0);
          fill(255);
          text(R.z,R.x, R.y);
        }
        if(G.z>10)
        {
          stroke(0,255,0);
          fill(0,255,0);
          ellipse(G.x, G.y, 20, 20);
          fill(255);
          text(G.z,G.x, G.y);
        }
        if(B.z>10)
        {
          stroke(0,0,255);
          fill(0,0,255);
          ellipse(B.x, B.y, 20, 20);
          fill(255);
          text(B.z,B.x, B.y);
        }
        cam.endHUD();
      }
      println("-x:"+j +" y:"+i);
      println(R);
      println(G);
      println(B);
    }*/
  int timeDiff = millis()-t1;
  
  println("timeDiff:"+timeDiff);
}


void draw() {
  
  background(0);
  scale(0.1,0.1,0.1);
  strokeWeight(10); 
  //rotateX(PI);
  ambientLight(100, 100, 100);
  lightSpecular(100, 100, 100);shininess(15.0);
  directionalLight(150, 150,150, 1, 1, -1);
  {
    stroke(255,0,0,0.3);
    line(0, 0, 0, 10000, 0, 0);
    stroke(0,255,0,0.3);
    line(0, 0, 0, 0, 10000, 0);
    stroke(0,0,255,0.3);
    line(0, 0, 0, 0, 0, 10000);
  }
  sectionFinding(myMovie,ascArr);
}