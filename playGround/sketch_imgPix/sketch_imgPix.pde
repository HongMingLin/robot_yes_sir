  
import processing.video.*;
import java.lang.Math.*;
import peasy.*;

PeasyCam cam;
Movie myMovie;



// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}


ascreen_info []ascArr;

PVector[] identityBoxV;
    
double[][][] geometries = new double[][][]{
  {
    {100, 280, 0},
    {0, 770,0},
    {232, 0, 0},
    {454, 0, 0},
    {0, -110, 0},
  }
};
    
Vector<PVector> obj1v=new Vector<PVector>();
Vector<PVector> obj2v=new Vector<PVector>();
PMatrix invCameraMat;
PMatrix CameraMat;
Kinematics kinma;
void setup() {
  identityBoxV=boxVertices(1,1,1);
  kinma=new Kinematics(geometries[0]);
 
  size(600, 600,P3D);
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(5000);
  cam.setWheelScale(0.1);
  cam.lookAt(0, 0, 0,1600,0);
  myMovie = new Movie(this, "XYZ.m4v"); 
  //hint(DISABLE_DEPTH_TEST); 
  
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

}


float frameW=2400;
float frameH=2740;

//float frameW=2000;
//float frameH=2000;

PVector[] frameRodPts={
  new PVector(frameW/2,frameH/2,0),new PVector(-frameW/2,frameH/2,0),
  new PVector(frameW/2,frameH/2,0),new PVector(frameW/2,-frameH/2,0),
  new PVector(-frameW/2,-frameH/2,0),new PVector(-frameW/2,frameH/2,0),
  new PVector(-frameW/2,-frameH/2,0),new PVector(frameW/2,-frameH/2,0),
};

void drawFrame()
{
  float size=1000;
  //rect(-5, -5, 10, 10);
  //noFill();
  fill(255,0,0,100);
  stroke(255,0,0);
  rect(-2400/2, -2740/2, 2400, 2740);
}

void draw3Axis(float size)
{
  
  stroke(255,0,0);
  line(0, 0, 0, size, 0, 0);
  stroke(0,255,0);
  line(0, 0, 0, 0, size, 0);
  stroke(0,0,255);
  line(0, 0, 0, 0, 0, size);
}
void drawBoard_keepTranse()
{
  float size=1000;
  //rect(-5, -5, 10, 10);
  noStroke();
  draw3Axis(400);
  rotateY(PI/2);
  fill(0,0,255);
  rect(-size/2, -size/2, size/2, size);
  fill(0,255,0);
  rect(0, -size/2, size/2, size);
  
  rotateY(-PI/2);
  scale(size,size,10);
  /*noStroke();
  scale(10,10,2);
  sphere(1);  */ 
  
}

boolean CollisionDetection(Vector<PVector> obj1_v,Vector<PVector> obj2_v)
{
  for(int i=0;i<obj1_v.size();i+=3)
  {
    PVector v00=obj1_v.get(i);
    PVector v01=obj1_v.get(i+1);
    PVector v02=obj1_v.get(i+2);
    
    for(int j=0;j<obj2_v.size();j+=3)
    {
      PVector v10=obj2_v.get(j);
      PVector v11=obj2_v.get(j+1);
      PVector v12=obj2_v.get(j+2);
      
      boolean c =triangleCollision(v00,v01,v02,v10,v11,v12);
      if(c)return c;
    }
    
  }
  return false;
}
double[] drawRobotWorld(double[] pose)
{
  obj1v.clear();
  obj2v.clear();
  double[] angles =kinma.inverse(pose);
  //angles =new double[]{0,0,0,0,-PI,0};
  double[][] calcPose = kinma.forward(angles);
  double[] calcPose5 = calcPose[5];

  for(int k=0;k<calcPose5.length;k++)
  {
    print(round((float)(calcPose5[k]*1000))/1000f+" ");
  }
  println();
  pushMatrix();
  
  rotateX(PI/2);
  rotateY(PI/2);
  for(int j=0;j<calcPose.length-1;j++)
  {
    double[] p0 = calcPose[j];
    double[] p1 = calcPose[j+1];
    stroke(255);
    fill(128);
    
  
    pushMatrix();
    drawRod_keepTranse(
    new PVector((float)p0[0],(float)p0[1],(float)p0[2]),
    new PVector((float)p1[0],(float)p1[1],(float)p1[2]),200,0);
    
    PMatrix WxO = getMatrix();//CxWxO
    
    WxO.preApply(invCameraMat);
    for(PVector v:identityBoxV)
    {
      PVector pt=new PVector();
      WxO.mult(v,pt);
      obj1v.add(pt);
      
    }
    
    popMatrix();
  }
  
  //rotateX(PI/2);
  translate((float)calcPose5[0], (float)calcPose5[1], (float)calcPose5[2]);
  rotateZ((float)calcPose5[5]);
  rotateY((float)calcPose5[4]);
  rotateX((float)calcPose5[3]);
  translate(50,0,0);
  
  //println(calcPose5[3]/PI/2+":"+calcPose5[4]/PI/2+":"+calcPose5[5]/PI/2);
  drawBoard_keepTranse();
  {
    PMatrix WxO = getMatrix();//CxWxO
    WxO.preApply(invCameraMat);
    for(PVector v:identityBoxV)
    {
      PVector pt=new PVector();
      WxO.mult(v,pt);
      obj1v.add(pt);
    }
  }
  
  popMatrix();
  
  pushMatrix();
  translate(0,880,739-200);
  rotateX(PI/2);
  
  
  fill(200,200,200);
  stroke(255,0,0);
  for(int i=0;i<frameRodPts.length;i+=2)
  {
    pushMatrix();
    drawRod_keepTranse(
    frameRodPts[i],frameRodPts[i+1],200,0);
    PMatrix WxO = getMatrix();//CxWxO
    WxO.preApply(invCameraMat);
    for(PVector v:identityBoxV)
    {
      PVector pt=new PVector();
      WxO.mult(v,pt);
      obj2v.add(pt);
    }
    popMatrix();
  }
  
  boolean drawModelPoints=false;
  if(drawModelPoints)
  {  
    pushMatrix();
    resetMatrix();
    applyMatrix(CameraMat);
    
    fill(255,0,0,100);
    stroke(255,0,0);
    for(PVector v:obj2v)
    {
      pushMatrix();
      translate(v.x,v.y,v.z);
      box(1);
      popMatrix();
    }
    
    
    fill(0,255,0,100);
    stroke(0,255,0);
    for(PVector v:obj1v)
    {
      pushMatrix();
      translate(v.x,v.y,v.z);
      box(1);
      popMatrix();
    }
    
    popMatrix();
      
      
  }

  boolean collision = CollisionDetection(obj1v,obj2v);
  
  fill(255,0,0,100);
  stroke(255,0,0);
  if(collision)
    box(1000,1000,1000);
  
  popMatrix();
  return angles;
}


float inc_X=0;
void sectionFinding( PImage myImage,ascreen_info []asc_arr )
{
  inc_X+=0.1;
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
    
    R.y*=-1;
    G.y*=-1;
    B.y*=-1;
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
    translate(-origin.x,origin.z,-origin.y);
    
    //O[X]  V[Y] >[Z] processing world
    
    
    //>X ^y  @Z (toward you) Kinematics world
    PVector pXYZ=new PVector(1300*XYZ.x,1300*(XYZ.z+1),1300*XYZ.y);
    //pXYZ.x=20*sin(inc_X);
    //pXYZ.y=780;
    //pXYZ.z=940;
    //RYP.x=0;
    //RYP.y=0;
    //RYP.z=0;
    double[] pose=new double[]{
      pXYZ.x,pXYZ.y,pXYZ.z,RYP.x,RYP.y,RYP.z
    };
    //axisSwap(pose,0,1,2);
    
    axisSwap(pose,1,2,0,false,false,true);
    
    double[] angles=drawRobotWorld(pose);
    
    println("pose["+i+"].");
    for(int k=0;k<pose.length;k++)
    {
      print(round((float)(pose[k]*1000))/1000f+" ");
    }
    print("angles.  ");
    for(int k=0;k<angles.length;k++)
    {
      print(round((float)(angles[k]*180/PI*1000))/1000f+" ");
    }
    println();
    
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
  image(myMovie,0,0);
  CameraMat=getMatrix();
  invCameraMat = CameraMat.get();
  invCameraMat.invert();
  scale(0.1,-0.1,0.1);
  strokeWeight(10); 
  rotateZ(PI);
  rotateX(PI/2);
  ambientLight(100, 100, 100);
  lightSpecular(100, 100, 100);shininess(15.0);
  directionalLight(150, 150,150, 1, 1, -1);
  {
    stroke(255,0,0);
    line(0, 0, 0, 10000, 0, 0);
    stroke(0,255,0);
    line(0, 0, 0, 0, 10000, 0);
    stroke(0,0,255);
    line(0, 0, 0, 0, 0, 10000);
  }
  sectionFinding(myMovie,ascArr);
}