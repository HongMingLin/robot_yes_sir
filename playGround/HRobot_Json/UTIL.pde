boolean runCircle=false;
public RunMODE mode=RunMODE.M_XYZ;
enum RunMODE {
  M_XYZ,M1000mm,M_ABC;
  private static RunMODE[] vals = values();
  public RunMODE next()
  {
    int now = this.ordinal()+1;
    return vals[(now) % vals.length];
  }
}
void keyPressed() {
  if (key == 'r' || key == 'R') {
    REALTIME=!REALTIME;
    exec("/usr/bin/say", "realtime "+(REALTIME?"On":"Off"));
    println(REALTIME);
  } else if (key == 'c' || key == 'C') {
    runCircle=!runCircle;
    exec("/usr/bin/say", "圈圈 "+(runCircle?"開":"Off"));
  } else if (key == 'm' || key == 'M') {
    mode=mode.next();
  }
}
//'X':'800','Y':'200','Z':'45',
//A +58 -70
//B +88 -89
//C +180 -180
float Bpercent=0.5;
void send2robot() {
  switch(mode) {
  case M1000mm:
      //float x=500*sin(millis()*(TWO_PI/5000.0));
      
    break;
  case M_XYZ:
    if (runCircle) {
      float y=lerp(-200, 200, Bpercent);
      ROBOT_XYZ.y=y;
      
      json.setString("X", String.valueOf(ROBOT_XYZ.x));
      json.setString("Y", String.valueOf(y));
      json.setString("Z", String.valueOf(ROBOT_XYZ.z));
    } else {
      float x=lerp(-800, 800, (mouseX/(float)Window_X));
      float y=lerp(-200, 200, Bpercent);
      float z=lerp(-145, 145, (mouseY/(float)Window_X));
      ROBOT_XYZ.lerp(x,y,z,0.1);
      //ROBOT_XYZ.x=x;
      //ROBOT_XYZ.y=y;
      //ROBOT_XYZ.z=z;
      json.setString("X", String.valueOf(ROBOT_XYZ.x));
      json.setString("Y", String.valueOf(ROBOT_XYZ.y));
      json.setString("Z", String.valueOf(ROBOT_XYZ.z));
      
    }

    break;
  case M_ABC:
    float a=lerp(-70, 58, (mouseX/(float)Window_X));
    float b=lerp(-89, 88, Bpercent);
    float c=lerp(-180, 180, (mouseY/(float)Window_Y));
    ROBOT_ABC.lerp(a,b,c,0.1);
   
    json.setString("A", String.valueOf(0) );
    json.setString("B", String.valueOf(ROBOT_ABC.y) );
    json.setString("C", String.valueOf(ROBOT_ABC.z) );
    break;
  }

  //println(json.toString());
  String outJ=json.toString().replaceAll(" ", "");
  outJ=outJ.replaceAll("[^\\x20-\\x7e]", "");
  
  
  //println(outJ);
  //u.send(printBB("TX",outJ),R_IP,R_PORT);
  //u.send(jsonStopStr, R_IP, R_PORT);
  
  u.send(outJ, R_IP, R_PORT);
}
