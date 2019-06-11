
import processing.video.*;
import java.lang.Math.*;
import peasy.*;

Movie myMovie;
//JSONObject json=new JSONObject();
//JSONArray R12JsonArray=new JSONArray();
//JSONObject R1Json;
//UDP u;
//String outJ="";
//String R_IP="10.10.10.88";
//int R_PORT=6666;
//java.util.TimerTask statusTimer500 = new java.util.TimerTask() {
//  public void run() {
//    u.send(outJ+"\n", R_IP, R_PORT);
//    //println("[TX]"+outJ);
//  }
//};

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}


ascreen_info []ascArr;

PVector[] identityBoxV;



/*

 
 
 
 
 
 
 ________________________________________________
 |//|
 |//|
 |//|
 |//|
 |//|
 |//|
 |//|
 |//|
 
 
 ^y
 >X
 @Z (toward you)
 the [o] is the hiwin origin, so we assume [v0] has no height
 
 R/J2{Z}---[v2]--R/J3{X}---[v3]---R/J4{Z}
 |                                |
 |                               [v4] 
 |                              R/J5 {Y}
 |
 [v1]
 |
 |                        
 |                               
 [o]__R/J1{Z}  ^                   
 |    /        |                 
 |  [v0]       |                    
 |  /          |                  
 R/J0{Y}       |height "525mm"         
 |   |         |                         
 |___|         V                          
 |@@@|Support  ^                              ____
 |@@@|structure|                              |//|
 |@@@|         |                              |//|
 |@@@|         |                              |//|
 |@@@|         |                              |//|
 |@@@|         |                              |//|
 |@@@|         |                              |//|
 |@@@|<--------|----------------------------->|//|
 |@@@|         V                              |//|
 //////////////////////////////////////////////
 */




double[][][] geometries = new double[][][]{
  {
    //{150, 525, 0}, 
    //hiwin robot origin( the point along with J1 axis ...
    //subject to the closest points between J1 and J2 axis), ie, assume there is no height to J1
    {150, 0, 0}, 
    {0, 770, 0}, 
    {232, 150, 0}, 
    {454, 0, 0}, 
    {0, -110, 0}, 
  }
};

/*
16200 deg/s for motor
 
 speed reduction ratio
 J1 147
 J2 161
 J3 164.07
 J4 81
 J5 160
 J6 100
 */

double maxMotorAngularV=16200*PI/180*0.4;
double []jointAngularV=new double[]{
  maxMotorAngularV/147f, 
  maxMotorAngularV/161f, 
  maxMotorAngularV/164.07f, 
  maxMotorAngularV/81f, 
  maxMotorAngularV/160f, 
  maxMotorAngularV/100f
};

Vector<PVector> obj1v=new Vector<PVector>();
Vector<PVector> obj3v=new Vector<PVector>();
Vector<PVector> obj2v=new Vector<PVector>();
PMatrix invCameraMat;
PMatrix CameraMat;
Kinematics kinma;

void setupJson() {
  json = new JSONObject();
  jsonHUD = new JSONObject();
  R12JsonArray= new JSONArray();
  for (int i = 0; i < 12; i++) {
    R1Json= new JSONObject();
    R1Json.setString("Robot", (i+1)+"");
    R1Json.setString("Command", "STOP");
    R1Json.setString("A1", "0");
    R1Json.setString("A2", "0");
    R1Json.setString("A3", "0");
    R1Json.setString("A4", "0");
    R1Json.setString("A5", "0");
    R1Json.setString("A6", "0");

    R1Json.setString("X", "0");
    R1Json.setString("Y", "0");
    R1Json.setString("Z", "0");
    R1Json.setString("A", "0");
    R1Json.setString("B", "0");
    R1Json.setString("C", "0");

    R12JsonArray.setJSONObject(i, R1Json);
  }
  json.setString("TIMESTAMP", millis()+"");
  json.setJSONArray("GroupCommand", R12JsonArray);
  jsonHUD.setJSONArray("Robots", R12JsonArray);
}

void setup2() {
  //setupJson();
  //u = new UDP( this, 1313 );
  //u.log( false );
  //u.listen( true );

  //new java.util.Timer().scheduleAtFixedRate(statusTimer500, 0, 100);



  identityBoxV=boxVertices(1, 1, 1);
  kinma=new Kinematics(geometries[0]);

  //size(600, 600,P3D);
  //cam = new PeasyCam(this, 100);
  //cam.setMinimumDistance(10);
  //cam.setMaximumDistance(5000);
  cam.setWheelScale(0.1);
  //cam.lookAt(0, 0, 0,1600,0);
  myMovie = new Movie(this, "0.mp4");
  //hint(DISABLE_DEPTH_TEST); 

  myMovie.loop();
  ascArr=new ascreen_info[12];
  /*for(int i=0;i<ascArr.length;i++)
   {
   int x= i%4;
   int y= i/4;
   ascArr[i]=new ascreen_info(x,y,new PVector(x*30,y*30,0));
   }*/

  float w1=2400+200, w2=2400+1400, h=-2740-2760;

  ascArr[ 0]=new ascreen_info(0, 0, new PVector(-w1-w2/2, h, 0));
  ascArr[ 1]=new ascreen_info(1, 0, new PVector(-w2/2, h, 0));
  ascArr[ 2]=new ascreen_info(2, 0, new PVector( w2/2, h, 0));
  ascArr[ 3]=new ascreen_info(3, 0, new PVector(+w1+w2/2, h, 0));

  ascArr[ 4]=new ascreen_info(0, 1, new PVector(-w1-w2/2, 0, 0));
  ascArr[ 5]=new ascreen_info(1, 1, new PVector(-w2/2, 0, 0));
  ascArr[ 6]=new ascreen_info(2, 1, new PVector( w2/2, 0, 0));
  ascArr[ 7]=new ascreen_info(3, 1, new PVector(+w1+w2/2, 0, 0));

  ascArr[ 8]=new ascreen_info(0, 2, new PVector(-w1-w2/2, -h, 0));
  ascArr[ 9]=new ascreen_info(1, 2, new PVector(-w2/2, -h, 0));
  ascArr[10]=new ascreen_info(2, 2, new PVector( w2/2, -h, 0));
  ascArr[11]=new ascreen_info(3, 2, new PVector(+w1+w2/2, -h, 0));

  //ascArr[1]=new ascreen_info(1,1,new PVector(10,10,0));
}


float frameW=2400;
float frameH=2740;

//float frameW=2000;
//float frameH=2000;

PVector[] frameRodPts={
  new PVector(frameW/2, frameH/2, 0), new PVector(-frameW/2, frameH/2, 0), 
  new PVector(frameW/2, frameH/2, 0), new PVector(frameW/2, -frameH/2, 0), 
  new PVector(-frameW/2, -frameH/2, 0), new PVector(-frameW/2, frameH/2, 0), 
  new PVector(-frameW/2, -frameH/2, 0), new PVector(frameW/2, -frameH/2, 0), 
};

void drawFrame()
{
  float size=1000;
  //rect(-5, -5, 10, 10);
  //noFill();
  fill(255, 0, 0, 100);
  stroke(255, 0, 0);
  rect(-2400/2, -2740/2, 2400, 2740);
}

void draw3Axis(float size)
{

  stroke(255, 0, 0);
  line(0, 0, 0, size, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, size, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, size);
}

float board_WH=1000;
float board_thickness=100;

/*  flange2BoardCenter_distance
 <--------->
 \          |=|
 |\---------|=|board
 | \        |=|
 
 ^flange2Board_angle         
 
 
 */
float flange2Board_angle=-60*PI/180;
float flange2BoardCenter_distance=165.583;


void drawBoard_keepTranse()
{

  //rect(-5, -5, 10, 10);
  noStroke();
  rotateY(PI/2);
  rotateX(flange2Board_angle);
  translate(0, 0, flange2BoardCenter_distance);
  fill(0, 0, 255);
  rect(-board_WH/2, -board_WH/2, board_WH/2, board_WH);
  fill(0, 255, 0);
  rect(0, -board_WH/2, board_WH/2, board_WH);
  draw3Axis(400);
  rotateY(-PI/2);
  scale(board_thickness, board_WH, board_WH);
  /*noStroke();
   scale(10,10,2);
   sphere(1);  */
}

double [] boardPose2FlangePose(double []pose)
{
  double []pfose=new double[6];
  PMatrix3D mat = new PMatrix3D();
  mat.reset();


  //mat.translate(0,-flange2BoardCenter_distance*5,0);
  //mat.rotateX(-flange2Board_angle);
  mat.translate((float)pose[0], (float)pose[1], (float)pose[2]);
  PVector RYP=new PVector((float)pose[3], (float)pose[4], (float)pose[5]);
  mat.rotateZ(RYP.z);
  mat.rotateY(RYP.y);
  mat.rotateX(RYP.x);

  mat.translate(-flange2BoardCenter_distance, 0, 0);
  mat.rotateZ(flange2Board_angle);
  //
  //mat.invert();
  PVector origin = new PVector(0, 0, 0);
  PVector tar = new PVector();
  mat.mult(origin, tar);

  pfose[0]=tar.x;
  pfose[1]=tar.y;
  pfose[2]=tar.z;

  Quaternion qn=new Quaternion();
  qn.set(mat);
  qn.getEuler(qn, RYP, Quaternion_RotSeq.zyx);
  pfose[3]=RYP.x;
  pfose[4]=RYP.y;
  pfose[5]=RYP.z;
  return pfose;
}

boolean CollisionDetection(Vector<PVector> obj1_v, Vector<PVector> obj2_v)
{
  for (int i=0; i<obj1_v.size(); i+=3)
  {
    PVector v00=obj1_v.get(i);
    PVector v01=obj1_v.get(i+1);
    PVector v02=obj1_v.get(i+2);

    for (int j=0; j<obj2_v.size(); j+=3)
    {
      PVector v10=obj2_v.get(j);
      PVector v11=obj2_v.get(j+1);
      PVector v12=obj2_v.get(j+2);

      boolean c =triangleCollision(v00, v01, v02, v10, v11, v12);
      if (c)return c;
    }
  }
  return false;
}
boolean CollisionDetection(Vector<PVector> obj1_v, Vector<PVector> obj2_v, Vector<PVector> obj3_v)
{
  return CollisionDetection(obj1_v, obj2_v)||
    CollisionDetection(obj1_v, obj3_v)||
    CollisionDetection(obj2_v, obj3_v);
}
double[] drawRobotWorld(double[] pose,Boolean isCollided)
{
  isCollided=false;
  obj1v.clear();
  obj2v.clear();
  obj3v.clear();
  double[] angles =kinma.inverse(pose);
  //angles =new double[]{0,0,0,0,HALF_PI,0};

  double[][] calcPose = kinma.forward(angles);
  double[] calcPose5 = calcPose[5];
  //for(int k=0;k<calcPose5.length;k++)
  //{
  //  print(round((float)(calcPose5[k]*1000))/1000f+" ");
  //}
  //println();
  pushMatrix();

  rotateX(PI/2);
  rotateY(PI/2);
  for (int j=0; j<calcPose.length-1; j++)
  {
    double[] p0 = calcPose[j];
    double[] p1 = calcPose[j+1];
    stroke(255);
    fill(128);


    pushMatrix();
    drawRod_keepTranse_HACK(
      new PVector((float)p0[0], (float)p0[1], (float)p0[2]), 
      new PVector((float)p1[0], (float)p1[1], (float)p1[2]), 200, 0);
    //
    PMatrix WxO = getMatrix();//CxWxO


    popMatrix();
    if (j==3)
    {

      scale(1, 1, 1);
      //tint(0,255,0);
      translate(-HIWIN_LOGO.width/2, -HIWIN_LOGO.height/2, 110);
      image(HIWIN_LOGO, 0, 0);
    }

    if (j!=4)//ignore the part J5~J6
    {
      WxO.preApply(invCameraMat);
      for (PVector v : identityBoxV)
      {
        PVector pt=new PVector();
        WxO.mult(v, pt);
        obj1v.add(pt);
      }
    }

    popMatrix();
  }

  //rotateX(PI/2);
  translate((float)calcPose5[0], (float)calcPose5[1], (float)calcPose5[2]);
  rotateZ((float)calcPose5[5]);
  rotateY((float)calcPose5[4]);
  rotateX((float)calcPose5[3]);
  //translate(50, 0, 0);

  //println(calcPose5[3]/PI/2+":"+calcPose5[4]/PI/2+":"+calcPose5[5]/PI/2);
  drawBoard_keepTranse();
  {
    PMatrix WxO = getMatrix();//CxWxO
    WxO.preApply(invCameraMat);
    for (PVector v : identityBoxV)
    {
      PVector pt=new PVector();
      WxO.mult(v, pt);
      obj3v.add(pt);
    }
  }

  popMatrix();

  pushMatrix();

  translate(0, 880, 739-200);
  rotateX(PI/2);


  fill(200, 200, 200);
  stroke(255, 0, 0);
  for (int i=0; i<frameRodPts.length; i+=2)
  {
    pushMatrix();
    drawRod_keepTranse(
      frameRodPts[i], frameRodPts[i+1], 200, 0);
    PMatrix WxO = getMatrix();//CxWxO
    WxO.preApply(invCameraMat);
    for (PVector v : identityBoxV)
    {
      PVector pt=new PVector();
      WxO.mult(v, pt);
      obj2v.add(pt);
    }
    popMatrix();
  }

  boolean drawModelPoints=false;
  if (drawModelPoints)
  {  
    pushMatrix();
    resetMatrix();
    applyMatrix(CameraMat);

    fill(255, 0, 0, 100);
    stroke(255, 0, 0);
    for (PVector v : obj2v)
    {
      pushMatrix();
      translate(v.x, v.y, v.z);
      box(1);
      popMatrix();
    }

    fill(255, 255, 0, 100);
    stroke(255, 0, 0);
    for (PVector v : obj3v)
    {
      pushMatrix();
      translate(v.x, v.y, v.z);
      box(1);
      popMatrix();
    }

    fill(0, 255, 0, 100);
    stroke(0, 255, 0);
    for (PVector v : obj1v)
    {
      pushMatrix();
      translate(v.x, v.y, v.z);
      box(1);
      popMatrix();
    }

    popMatrix();
  }

  boolean collision = CollisionDetection(obj1v, obj2v, obj3v);

  fill(255, 0, 0, 100);
  stroke(255, 0, 0);
  if (collision)
  {
    box(1000, 1000, 1000);
    isCollided=true;
  }

  popMatrix();
  return angles;
}


float inc_X=0;
void sectionFinding( PImage myImage, ascreen_info []asc_arr )
{
  inc_X=millis();
  myImage.loadPixels();
  PVector R=new PVector();
  PVector G=new PVector();
  PVector B=new PVector();
  int t1 = millis();
  int XSectNum=4;
  int YSectNum=3;
  int SectW=myImage.width/XSectNum;
  int SectH=myImage.height/YSectNum;

  textAlign(CENTER, CENTER);


  for (int i=0; i<asc_arr.length; i++)
  {
    int idx_x=(int)asc_arr[i].getIdx().x;
    int idx_y=(int)asc_arr[i].getIdx().y;

    //println(idx_y+","+idx_x);
    FindRGBLocation(myImage, SectW*idx_x, SectH*idx_y, SectW-1, SectH-1, R, G, B);

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



  int timeDiff = millis()-t1;

  //println("timeDiff:"+timeDiff);
}

void J4StepDown(double []angles, int step)
{
  if (step==0)return;
  if (step<0)//angles[3]-P_angle3>HALF_PI )
  {
    angles[3]-=PI;
  } else if (step>0)
  {
    angles[3]+=PI;
  }


  for (int k=0; k<angles.length; k++)
  {
    angles[k]%=2*PI;
  }

  {
    angles[4]+=HALF_PI;
    angles[4]*=-1;
    angles[4]-=HALF_PI;
    if (angles[4]>HALF_PI )
    {
      angles[4]=2*PI-angles[4];
    } else if (angles[4]<-HALF_PI )
    {
      angles[4]=2*PI+angles[4];
    }

    angles[5]+=PI;

    if (angles[5]>PI )
    {
      angles[5]=angles[5]-2*PI;
    } else if (angles[5]<-PI )
    {
      angles[5]=angles[5]+2*PI;
    }
  }
}

int count=0;
double maxDiff=0;
void RK(ascreen_info []asc_arr) {
  count++;
  boolean fatalError=false;
  if (count<10)maxDiff=0;
  PVector XYZ=new PVector();
  PVector RYP=new PVector();
  for (int i=0; i<asc_arr.length; i++)
  {
    if (asc_arr[i].getR().z*asc_arr[i].getG().z*asc_arr[i].getB().z==0)continue;
    XYZ.set(asc_arr[i].getXYZ());
    RYP.set(asc_arr[i].getRYP());
    pushMatrix();

    final PVector origin = asc_arr[i].getOrigin();
    translate(-origin.x, origin.z, -origin.y);

    //O[X]  V[Y] >[Z] processing world


    //>X ^y  @Z (toward you) Kinematics world
    PVector pXYZ=new PVector(-700*XYZ.x, 700*(XYZ.z)+780+600, 700*XYZ.y+300);

    //float period=4;
    //pXYZ.x=+0*sin(inc_X*2*PI/1000/period);
    //pXYZ.y=780+300+100*sin(inc_X*2*PI/1000/period);
    //pXYZ.z=940+100*cos(inc_X*2*PI/1000/period);
    //RYP.x=10*sin(inc_X*2*PI/1000/period)*PI/180;
    //RYP.y=0;
    //RYP.z=0;
    //RYP.x/=2;//make rotation smaller for safety
    //RYP.y/=2;
    //RYP.z/=2;


    if (asc_arr[i].realWorld_XYZ.x==asc_arr[i].realWorld_XYZ.x)
    {

      pXYZ= PVector.lerp(asc_arr[i].realWorld_XYZ, pXYZ, 0.1);
      pXYZ = PositionAdv(asc_arr[i].realWorld_XYZ, pXYZ, 50);
    }
    double[] pose=new double[]{
      pXYZ.x, pXYZ.y, pXYZ.z, RYP.x, RYP.y, RYP.z
    };

    asc_arr[i].realWorld_XYZ.set(pXYZ);

    axisSwap(pose, 1, 2, 0, false, false, false);
    //525mm, base floor to hiwin robot origin()

    double[] flangePose =  boardPose2FlangePose(pose);

    //if (i==2 || i==3)println(pose[2]);  
    Boolean isCollided=false;
    double[] angles=drawRobotWorld(flangePose,isCollided);

    if(isCollided)
    {
      fatalError=true;
    }
    

    {
      boolean overAngle=false;
      double []P_angles = asc_arr[i].getAngles();

      double P_angle3 = P_angles[3];

      double pDIFF4 = (angles[3]-P_angles[3])*180/PI;
      if (angles[3]-P_angle3>HALF_PI )
      {
        J4StepDown(angles, -1);
      } else if (angles[3]-P_angle3<-HALF_PI )
      {
        J4StepDown(angles, 1);
      }

      if (angles[3]>PI)
      {
        J4StepDown(angles, -1);
        //J4StepDown(angles, -1);
        println("......Turn over-!!!");
        fatalError=true;
      } else if (angles[3]<-PI)
      {
        J4StepDown(angles, 1);
        //J4StepDown(angles, 1);
        println("......Turn over+!!!");
        fatalError=true;
      }


      double DIFF4 = (angles[3]-P_angles[3])*180/PI;
      
      
      double DIFF6 = (angles[5]-P_angles[5]);
      
      if(DIFF6>PI)
      {
        angles[5]-=TWO_PI;
      }
      else if(DIFF6<-PI)
      {
        angles[5]+=TWO_PI;
      }
      
      if (Math.abs(maxDiff)<Math.abs(DIFF4))
      {
        maxDiff = DIFF4;
      }


      //if (i==0)println("angles:"+angles[0]+","+angles[1]+","+angles[2]+","+angles[3]+","+angles[4]+","+angles[5]);
      //if (i==0)println("angles:"+angles[5]*180/PI+" P_angles:"+P_angles[5]*180/PI);
      //maxDiff*=0.999;
      //if (i==0)println("maxDiff:"+maxDiff+" DIFF4:"+DIFF4 +" pDIFF4:"+pDIFF4);
      //print("DIFF4:"+DIFF4+" >angles[3]="+angles[3]+"  "+P_angles[3] );
      //println("DIFF4:"+(angles[3]-P_angles[3]));
      for (int k=0; k<angles.length; k++)
      {
        float angV = (float)(angles[k]-P_angles[k])*frameRate;
        float ratio = abs(round((float)(angV/jointAngularV[k]*10000))/10000f);
        //print("["+k+"]"+ratio+" ");
        if (ratio>1){
          println("Motor[J"+(k+1)+"] speed overload= "+ratio*100);
          if(ratio*100>200)
          {
            println("*****SUPER OVERLOAD*****");
            
            fatalError=true;
          }
        }
        //print(jointAngularV[k]*180/PI+" ");
      }
      //println();
      asc_arr[i].setAngles(angles);
    }


    for (int k=0; k<angles.length; k++)
    {
      float angle = (float)angles[k];

      //HIWIN J5(index 4) has PI/2 offset
      if (k==4)
        angle-=HALF_PI;

      //HIWIN J6(index 5) rotates diffetent direction
      if (k==5)
        angle=-angle;

      float fff=round((float)((angle)*180/PI*1000))/1000f;
      //println(fff+" ");
      //if(i==0)
      {
        //print(fff+" ");
        json.getJSONArray("GroupCommand").getJSONObject(i).setString("A"+(k+1), df.format(fff)+"");
        float dgree=fff/TWO_PI*360.0;
        jsonHUD.setString("360A"+(k+1), nf(fff,2,1)+"º"+"^"+nf(dgree/360,2,2));
      }
    }

    for (int k=0; k<flangePose.length; k++)pose[k]=flangePose[k];
    axisSwap(pose, 2, 0, 1, false, false, false);
    JSONObject jTemp=json.getJSONArray("GroupCommand").getJSONObject(i);
    jTemp.setString("X", df.format(pose[0])+"");
    jTemp.setString("Y", df.format(pose[1])+"");
    jTemp.setString("Z", df.format(pose[2])+"");
    jTemp.setString("A", df.format(pose[3]/TWO_PI*360.0)+"");
    jTemp.setString("B", df.format(pose[4]/TWO_PI*360.0)+"");
    jTemp.setString("C", df.format(pose[5]/TWO_PI*360.0)+"");


    popMatrix();
  }

  json.setString("TIMESTAMP", millis()+"");
  outJ=clearAllASCII(json.toString());


  //println(outJ.length()+"=>"+outJ);
}
String clearAllASCII(String in) {
  return in.toString().replaceAll("[/ /g]", "").replaceAll("[^\\x20-\\x7e]", "");
}
void drawMovie() {
  pushMatrix();
  imageMode(CORNER);
  rectMode(CORNER);

  //translate(-myMovie.width/2,-myMovie.height/2, -1000);
  translate(0, 155, 0);

  //image(myMovie, 0, 0, 300, myMovie.height/(myMovie.width/300.0));
  switch(M_S) {
  case Movie:
    if (myMovie!=null)
      image(myMovie, 0, 0, 300, myMovie.height/(myMovie.width/300.0));
    break;
  case ShareImage:

    image(canvas.get(), 0, 0, 300, canvas.height/(canvas.width/300.0));
    break;
  }

  popMatrix();
}
void draw2() {
  imageMode(CORNER);
  //background(0);
  //pushMatrix();
  //translate(-myMovie.width/2,-myMovie.height/2, -1000);
  //image(myMovie,0,0);
  //popMatrix();

  CameraMat=getMatrix();
  invCameraMat = CameraMat.get();
  invCameraMat.invert();
  scale(0.1, -0.1, 0.1);
  strokeWeight(10); 
  rotateZ(PI);
  rotateX(PI/2);
  ambientLight(100, 100, 100);
  lightSpecular(100, 100, 100);
  shininess(15.0);
  directionalLight(150, 150, 150, 1, 1, -1);
  {
    stroke(255, 0, 0);
    line(0, 0, 0, 10000, 0, 0);
    stroke(0, 255, 0);
    line(0, 0, 0, 0, 10000, 0);
    stroke(0, 0, 255);
    line(0, 0, 0, 0, 0, 10000);
  }
  //sectionFinding(myMovie, ascArr);
    switch(M_S){
    case Movie:
    if(myMovie!=null)
      sectionFinding(myMovie, ascArr);
    break;
    case ShareImage:
      sectionFinding(canvas.get(), ascArr);
    break;
  }

  RK(ascArr);
}
