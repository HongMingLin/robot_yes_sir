JSONArray R12JsonArray;
JSONObject R1Json;
void runCircle() {
  //nowSin=millis()*(TWO_PI/CRICLE_Time);
  PVector tempXYZ=new PVector();
  //tempXYZ.x=ROBOT_XYZ_Cxyz.x+(CRICLE_R*sin(nowSin));
  //tempXYZ.y=HRs[whichRobot].XYZ.y;
  //tempXYZ.z=ROBOT_XYZ_Cxyz.z+(CRICLE_R*cos(nowSin));
  
  HRs[whichRobot].setXYZ(tempXYZ);
  
}

void drawXYZ() {
  stroke(255, 0, 0);
  line(0, 0, 0, Center_XYZLineLen, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, Center_XYZLineLen, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, Center_XYZLineLen);
}
