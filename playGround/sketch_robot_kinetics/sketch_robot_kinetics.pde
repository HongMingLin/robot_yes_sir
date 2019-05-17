import java.lang.Math.*;


    
double[][][] geometries = new double[][][]{
  {    
    {100, 280, 0},
    {0, 770,0},
    {232, 0, 0},
    {454, 0, 0},
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

void setup()
{
  
  Kinematics kin=new Kinematics(geometries[0]);
  
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
  
  exit();
}