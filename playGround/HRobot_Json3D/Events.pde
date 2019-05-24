PVector ROBOT_XYZ_Cxyz=new PVector(0, 0, 0);
void mouseWheel(MouseEvent event) {
  //float e = event.getCount();
  HRs[whichRobot].handleMouseEvent(event);
}
void keyPressed() {
  motorWalk();
  switch(key) {
  case 'R':
    REALTIME=!REALTIME;
    exec("/usr/bin/say", "real time "+(REALTIME?"On":"Off"));
    println(REALTIME);
    break;
  case 'M':
    HRs[whichRobot].setCC_XYZ_NOW();
    HRs[whichRobot].RM=HRs[whichRobot].RM.next();
    break;
  default:
    for (int i=0; i<WHICHROBOT.values().length; i++) {
      WR=WR.next();
      //println(i+" temp="+WR.ID()+", "+WR.hotKey());
      if (key == WR.hotKey()) {
        whichRobot=WR.ID();
        println("whichRobot="+whichRobot);
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
