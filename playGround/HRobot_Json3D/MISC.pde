enum RunMODE {
  M_XYZ, M_ABC;
  private static RunMODE[] vals = values();
  public RunMODE next()
  {
    int now = this.ordinal()+1;
    return vals[(now) % vals.length];
  }
}
void setupJson() {
  json = new JSONObject();
  json.setString("Command", "ptp_pose");
  json.setString("X", "0");
  json.setString("Y", "0");
  json.setString("Z", "0");
  json.setString("A", "0");
  json.setString("B", "0");
  json.setString("C", "0");
}


void runCircle() {
  nowSin=millis()*(TWO_PI/CRICLE_Time);
  PVector tempXYZ=new PVector();
  tempXYZ.x=ROBOT_XYZ_Cxyz.x+(CRICLE_R*sin(nowSin));
  tempXYZ.y=HRs[whichRobot].XYZ.y;
  tempXYZ.z=ROBOT_XYZ_Cxyz.z+(CRICLE_R*cos(nowSin));
  
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


void send2robot() {
  switch(mode) {
  case M_XYZ:
    if (runCircle) {
      HRs[whichRobot].XYZ.y=lerp(-200, 200, Bpercent);
    } else {

      HRs[whichRobot].setX(lerp(-800, 800, (HRs[whichRobot].XYZ.x/(float)Window_W)));
      HRs[whichRobot].setY(lerp(-200, 200, Bpercent));
      HRs[whichRobot].setZ(lerp(-45, 45, (HRs[whichRobot].XYZ.y/(float)Window_W)));
    }
      json.setString("X", String.valueOf(HRs[whichRobot].XYZ.x));
      json.setString("Y", String.valueOf(HRs[whichRobot].XYZ.y));
      json.setString("Z", String.valueOf(HRs[whichRobot].XYZ.z));

    break;
  case M_ABC:
    float a=lerp(-70, 58, (mouseX/(float)Window_W));
    float b=lerp(-89, 88, Bpercent);
    float c=lerp(-180, 180, (mouseY/(float)Window_D));
    HRs[whichRobot].ABC.x=a;
    HRs[whichRobot].ABC.y=b;
    HRs[whichRobot].ABC.z=c;
    json.setString("A", String.valueOf(0) );
    json.setString("B", String.valueOf(b) );
    json.setString("C", String.valueOf(c) );
    break;
  }

  //println(json.toString());
  String outJ=json.toString().replaceAll(" ", "");
  outJ=outJ.replaceAll("[^\\x20-\\x7e]", "");
  println(outJ);
  //u.send(printBB("TX",outJ),R_IP,R_PORT);
  u.send(outJ, R_IP, R_PORT);
}
