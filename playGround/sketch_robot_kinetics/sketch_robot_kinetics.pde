import java.lang.Math.*;


    
double[][][] geometries = new double[][][]{
  {  
    {1.00, 0, 0},
    {0, 7.70,0},
    {2.32, 0, 0},
    {4.54, 0, 0},
    {0, -1.00, 0},
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
  
  
  //double[] angles = new double[]{90*PI/180,0,0,0,0,0};
  double[] angles = kin.inverse(targetPoses[1]);
  double[][] calcPose = kin.forward(angles);
  double[]calcPose5 = calcPose[5];
  double[] angles_inv  = kin.inverse(calcPose5);
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