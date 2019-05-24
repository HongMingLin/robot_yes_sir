PVector ROBOT_XYZ_Cxyz=new PVector(0, 0, 0);
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(runCircle){
    CRICLE_Time+=e*10;
    println("CRICLE_Time="+CRICLE_Time);
  }else{
  PVector tempXYZ=new PVector(HRs[0].XYZ.x,HRs[0].XYZ.y,HRs[0].XYZ.z);
  tempXYZ.y+=e*0.1;
  HRs[0].setXYZ(tempXYZ);
  
  }
  
}
void keyPressed() {
  if (key == 'r' || key == 'R') {
    REALTIME=!REALTIME;
    println(REALTIME);
  } else if (key == 'c' || key == 'C') {
    HRs[whichRobot].setCC_XYZ_NOW();
    
    runCircle=!runCircle;
  } else if (key == 'm' || key == 'M') {
    mode=mode.next();
  }
  motorWalk();
}
void motorWalk() {
  PVector walkXYZ=new PVector(0,0,0);
  if (key == CODED) {
    if (keyCode == SHIFT) {
      
    }else if (keyCode == UP) {
       HRs[whichRobot].addXYZ(new PVector(0,0,10));
    } else if (keyCode == DOWN) {
      HRs[whichRobot].addXYZ(new PVector(0,0,-10));
    } else if (keyCode == LEFT) {
       HRs[whichRobot].addXYZ(new PVector(-10,0,0));
    } else if (keyCode == RIGHT) {
      HRs[whichRobot].addXYZ(new PVector(10,0,0));
    } 
    
  }
}
