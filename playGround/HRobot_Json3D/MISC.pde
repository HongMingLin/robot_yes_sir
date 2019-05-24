
void setupJson() {
  json = new JSONObject();
  json.setString("Robot", "3");
  json.setString("Command", "ptp_pose");
  json.setString("X", "0");
  json.setString("Y", "0");
  json.setString("Z", "0");
  json.setString("A", "0");
  json.setString("B", "0");
  json.setString("C", "0");
}


void runCircle() {
  //nowSin=millis()*(TWO_PI/CRICLE_Time);
  PVector tempXYZ=new PVector();
  //tempXYZ.x=ROBOT_XYZ_Cxyz.x+(CRICLE_R*sin(nowSin));
  //tempXYZ.y=HRs[whichRobot].XYZ.y;
  //tempXYZ.z=ROBOT_XYZ_Cxyz.z+(CRICLE_R*cos(nowSin));
  
  HRs[whichRobot].setXYZ(tempXYZ);
  
}
void drawWindow() {
  noFill();
  stroke(255, 255, 0);
  box(Window_W, Window_D, Window_H);
}
void drawXYZ() {
  stroke(255, 0, 0);
  line(0, 0, 0, Center_XYZLineLen, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, Center_XYZLineLen, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, Center_XYZLineLen);
}
