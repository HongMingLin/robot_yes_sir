import java.lang.Math.*;

import peasy.*;

PeasyCam cam;
    
double[][][] geometries = new double[][][]{
  {    
    {100, 280, 0},
    {0, 770,0},
    {232, 0,   0},
    {454, 0,   0},
    {0, 110, 0},
  
  },
  {
    {1, 1, 1},
    {0, 8, 2},
    {0, 10, 0},
    {5, 0, 0},
    {0, -6, 0},
  },
};
    
double[][]targetPoses = new double[][] {
  {0, 8, 7, -2.89, 0, 0},
  {7.7, 1, -7.86, 1.5707963, 3.1415927, 1.5707964},
  {6, -6, -2, 0, 1, 3},
  {3, 8, 3, 4, 0, 3},
};

void drawRobot(double[][] pose,double[] originalPos)
{
  for(int j=0;j<pose.length-1;j++)
  {
    double[] p0 = pose[j];
    double[] p1 = pose[j+1];
    stroke(255);
    fill(128);
    drawRod(
    new PVector((float)p0[0],(float)p0[1],(float)p0[2]),
    new PVector((float)p1[0],(float)p1[1],(float)p1[2]),200,0);
  }
  pushMatrix();
  double []pose5=pose[5];
  translate((float)pose5[0], (float)pose5[1], (float)pose5[2]);
  //println(pose5[3]+":"+pose5[4]+":"+pose5[5]);
  //println(pose5);
  
  
  //rotateZ((float)pose5[4]);
  //rotateX((float)pose5[3]);
  //rotateY((float)pose5[5]);
  //rotateY((float)pose5[5]);
  
  //rotateY(-PI/2);
  
  
  //rotateY((float)pose5[3]);
  //rotateY((float)pose5[3]);
  //rotateX((float)pose5[4]);
  //rotateY((float)pose5[5]);
  
  
  drawFrame();
  
  drawAxis(300);
  popMatrix();

  
}


void drawAxis(float size)
{  
  {
    stroke(255,0,0);
    line(0, 0, 0, size, 0, 0);
    stroke(0,255,0);
    line(0, 0, 0, 0, size, 0);
    stroke(0,0,255);
    line(0, 0, 0, 0, 0, size);
  }
}

void drawFrame()
{
  float size=1000;
  //rect(-5, -5, 10, 10);
  //noFill();
  fill(255,0,0,100);
  stroke(255,0,0);
  float w=1000,h=1000;
  rect(-w/2, -h/2, w, h);
  

}
Kinematics kin;
void setup()
{
  Quaternion q=new Quaternion();
  q.rotateAxis(1,new PVector(1,0,0));
  //q.rotateAxis(1,new PVector(1,0,0));
  PVector ret_ZYX=new PVector();
  
  //q.getEuler(q, ret_ZYX, Quaternion_RotSeq.yxz);
  
  ret_ZYX.set(0,0,1);
  q.mult(ret_ZYX,ret_ZYX);
  
  
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(10);
  cam.setMaximumDistance(5000);
  cam.setWheelScale(0.1);
  cam.lookAt(0, 0, 0,600,0);
  
  //cam.rotateX(-180*PI/180);
  //cam.rotateY(45*PI/180);
  size(600, 600,P3D);
  kin=new Kinematics(geometries[0]);
  
  double[] pose = new double[]{0,0,0, 0,0,0};

  
  float xx=0;
  float yy=-165+1000;
  float zz=425+500;
  pose[0]=yy;
  pose[1]=zz;
  pose[2]=xx;
  
  pose[3]=0*(-154.137*PI/180);
  pose[4]=0*(-13.921*PI/180);
  pose[5]=0*(136.646*PI/180);
  
  double[] angles = kin.inverse(pose);
  double[][] calcPose = kin.forward(angles);
  double[]calcPose5 = calcPose[5];
  double[] angles_inv  = kin.inverse(calcPose5);
  
  
  println(pose);
  print("A:");
  for(int k=0;k<angles.length;k++)
  {
    print(angles[k]*180/PI+",");
  }
  print("\nP:");
  for(int k=0;k<calcPose5.length;k++)
  {
    if(k<3)
      print(calcPose5[k]+",");
    else
      print(calcPose5[k]*180/PI+",");
  }
  println();
  
  println("targetPose");
  println(targetPoses[0]);
  println("angles=inverse(targetPose)");
  println(angles);
  println("calcPose5=forward(angles)");
  println(calcPose5);
  println("angles=inverse(targetPose)");
  println(angles_inv);
  
}
int idx6=0;
float inc_X=0;
void draw()
{
  inc_X+=0.01;
  background(0);

  scale(0.1,-0.1,0.1);
  strokeWeight(10); 

  drawAxis(1000);
  double[] pose = new double[]{0,0,0, 0,0,0};
  pose[0]=786;
  pose[1]=940;
  pose[2]=0;
  pose[3]=(mouseY-width/2)/100f;
  pose[4]=0.1;
  pose[5]=-PI/2;
  
  
  double[] angles = kin.inverse(pose);
  println("angles");
  println(angles);
  //angles = new double[]{0,0,0,0,0,0};
  /*if(idx6>=0 &&idx6<6)
  {
    angles[idx6]=inc_X;
    //angles[idx6+1]=inc_X;
  }
  else
  {
    inc_X=0;
  }*/
  double[][] calcPose = kin.forward(angles);
  
  println("calcPose");
  println(calcPose[5]);
  
  /*print("A:");
  for(int k=3;k<angles.length;k++)
  {
    print(angles[k]*180/PI+",");
  }
  println();
  /*print("\nP:");
  for(int k=0;k<calcPose[5].length;k++)
  {
    if(k<3)
    {
      print(calcPose[5][k]+",");
    }
    else
    {
      print(calcPose[5][k]*180/PI+",");
    }
  }
  println();
  */
  
  drawRobot(calcPose,pose);
}


void keyPressed()
{
  switch(key)
  {
    case 'k':
      idx6=(idx6+1)%7;
    break;
    case 's':
      idx6=6;
    break;
  }
}