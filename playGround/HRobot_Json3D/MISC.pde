JSONArray R12JsonArray;
JSONObject R1Json;
//void setupJson() {
//  json = new JSONObject();
  
//  R12JsonArray= new JSONArray();
//  for (int i = 0; i < HRs.length; i++) {
//  R1Json= new JSONObject();
//  R1Json.setString("Robot", (i+1)+"");
//  R1Json.setString("Command", "ptp_pose");
//  R1Json.setString("X", "0");
//  R1Json.setString("Y", "0");
//  R1Json.setString("Z", "0");
//  R1Json.setString("A", "0");
//  R1Json.setString("B", "0");
//  R1Json.setString("C", "0");
//    R12JsonArray.setJSONObject(i, R1Json);
//  }
//  json.setString("TIMESTAMP", millis()+"");
//  json.setJSONArray("GroupCommand", R12JsonArray);
//}


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
