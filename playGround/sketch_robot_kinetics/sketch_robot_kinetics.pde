import java.lang.Math.*;


    
float[][][] geometries = new float[][][]{
  {
    {1, 1, 0},
    {0, 10, 0},
    {5, 0, 0},
    {3, 0, 0},
    {0, -3, 0},
  },
  {
    {1, 1, 1},
    {0, 8, 2},
    {0, 10, 0},
    {5, 0, 0},
    {0, -6, 0},
  },
};
    
    
float[][]targetPoses = new float[][] {
  {1, 1, 2, 1, 2, 3},
  {3, 8, 2, 4, 1, 3},
  {6, -6, -2, 0, 1, 3},
  {3, 8, 3, 4, 0, 3},
};

void setup()
{
  
  Kinematics kinma=new Kinematics(geometries[0]);
  
  kinma.KinematicsTest(kinma,targetPoses[0]);
  
}
