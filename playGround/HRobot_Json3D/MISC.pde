final PVector HOMEXYZ=new PVector(0f, 25f, -65f);
final PVector HOMEABC=new PVector(0, 100, 0);
JSONObject TXJSONObj;
JSONObject RXJSONObj;
String TXJSONStr="";
String RXJSONStr="";
void isAtHome(int i,PVector XYZ,PVector ABC){
  float d1 = PVector.dist(XYZ, HOMEXYZ);
  float d2 = PVector.dist(ABC, HOMEABC);
  
  if(d1<10&&d2<10){
    HRs[i].atHome=true;
  }

}
void setupJson() {  
  TXJSONObj= new JSONObject();
 //RXJSONObj= new JSONObject();
 // RXJSONObj.setString("HB", "RG");
  
  //jsonHUD = new JSONObject();
  JSONArray R12JsonArray= new JSONArray();
  for (int i = 0; i < 12; i++) {
    JSONObject R1Json= new JSONObject();
    R1Json.setString(JSONKEYWORD.ID, (i+1)+"");
    R1Json.setString(JSONKEYWORD.CMD, JSONKEYWORD.STOP);
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
  TXJSONObj.setString(JSONKEYWORD.TIMESTAMP, "0");
  TXJSONObj.setJSONArray(JSONKEYWORD.Robots, R12JsonArray);
  //jsonHUD.setJSONArray("HUD_R_Info", R12JsonArray);
}

void runCircle() {
  //nowSin=millis()*(TWO_PI/CRICLE_Time);
  PVector tempXYZ=new PVector();
  //tempXYZ.x=ROBOT_XYZ_Cxyz.x+(CRICLE_R*sin(nowSin));
  //tempXYZ.y=HRs[whichRobot].XYZ.y;
  //tempXYZ.z=ROBOT_XYZ_Cxyz.z+(CRICLE_R*cos(nowSin));
  
  HRs[whichRobot].setXYZ(tempXYZ);
  
}
void DEBUG(String s){
  if(!GlobalDebug)return;
    println(s);
}
void drawXYZ() {
  stroke(255, 0, 0);
  line(0, 0, 0, Center_XYZLineLen, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, Center_XYZLineLen, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, Center_XYZLineLen);
}
