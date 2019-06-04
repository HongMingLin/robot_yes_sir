PVector ROBOT_XYZ_Cxyz=new PVector(0, 0, 0);
void mouseWheel(MouseEvent event) {
  //float e = event.getCount();
  HRs[whichRobot].handleMouseEvent(event);
}
void keyPressed() {
  motorWalk();
  switch(key) {
    case 'J':
    u2.send("{\"Command\":\"AllStatus\"}","10.10.10.157",9999);
    break;
  case ' ':
    REALTIME=false;
    for (int i=0; i<HRs.length; i++) {
      HRs[i].RM=HRs[i].RM.STOP;
    }
        exec("/usr/bin/say", "All Stop");

    break;
  case 'T':
    TXms=TXms.next();
    TX_mS=TXms.ms;

    t33.cancel();
    //TX_TIMER.cancel();
    //TX_TIMER.purge();
    t33=new statusTimer33();
    //TX_TIMER =new java.util.Timer();
    TX_TIMER.scheduleAtFixedRate(t33, 0, TX_mS);
    break;
  case 'R':
    REALTIME=!REALTIME;
    exec("/usr/bin/say", "real time "+(REALTIME?"On":"Off"));
    println(REALTIME);
    break;
  case 'A':
    HRs[0].RM=HRs[0].RM.next();
    for (int i=0; i<HRs.length; i++) {
      HRs[i].RM=HRs[0].RM;
      HRs[i].setCC_XYZ_NOW();
    }

    break;
  case 'H':
    
    JSONObject jTemp=json.getJSONArray("GroupCommand").getJSONObject(whichRobot);
    jTemp.setString("Command", "HOME");
    sendX(clearAllASCII(jTemp.toString())+"\n");
    
    break;

  case 'M':
    HRs[whichRobot].setCC_XYZ_NOW();
    HRs[whichRobot].RM=HRs[whichRobot].RM.next();
    exec("/usr/bin/say", "Robot "+whichRobot+" "+HRs[whichRobot].RM);

    break;
  default:
    for (int i=0; i<WHICHROBOT.values().length; i++) {
      WR=WR.next();
      //println(i+" temp="+WR.ID()+", "+WR.hotKey());
      if (key == WR.hotKey()) {
        whichRobot=WR.ID();
        println("whichRobot="+whichRobot);
        exec("/usr/bin/say", "Robot "+whichRobot+" ");
//exec("/usr/bin/say","-v","Victoria","Im Victoria");
//  exec("/usr/bin/say","-v","Zarvox"," and Robot.");
        break;
      }
    }
    break;
  }
}
void motorWalk() {
  PVector walkXYZ=new PVector(0, 0, 0);
  if (key == CODED) {
    if (keyCode == SHIFT) {
    } else if (keyCode == UP) {
      HRs[whichRobot].addXYZ(new PVector(0, 0, 10));
    } else if (keyCode == DOWN) {
      HRs[whichRobot].addXYZ(new PVector(0, 0, -10));
    } else if (keyCode == LEFT) {
      HRs[whichRobot].addXYZ(new PVector(-10, 0, 0));
    } else if (keyCode == RIGHT) {
      HRs[whichRobot].addXYZ(new PVector(10, 0, 0));
    }
  }
}
