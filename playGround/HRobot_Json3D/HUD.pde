void beginHUD() {
 
  cam.beginHUD();
  //image(img, 0, 0);
  //cp5setup();
  fill(255);

  text(mouseX+","+mouseY, mouseX, mouseY);
  //text(Qsb.toString(),WINDOW_W-textWidth(Qsb.toString())+(WINDOW_W/2*(1+sin(millis()*TWO_PI/2000))),20);
  int OFFSET_Y=20;
  int START_Y=40;

  text("C_Distance:" +cam.getDistance()+" FPS:"+ nfc(frameRate, 2), 10, START_Y+=OFFSET_Y);
  float[] xyz = cam.getRotations();
  text("rX="+nf(xyz[0], 1, 3)+" rY="+nf(xyz[1], 1, 3)+" rZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);
  xyz=cam.getPosition();
  text("cX="+nf(xyz[0], 1, 3)+" cY="+nf(xyz[1], 1, 3)+" cZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);
  text("MinD"+MinD+", MaxD="+MaxD+", CamD"+CamD, 10, START_Y+=OFFSET_Y);
  xyz=cam.getLookAt();
  text("lookX="+nf(xyz[0], 1, 3)+" lookY="+nf(xyz[1], 1, 3)+" lookZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);

  text("M="+mode, 5, 20);
  text("SafeXYZ=±"+HRs[whichRobot].limit_xyz_d2.x+", ±"+HRs[whichRobot].limit_xyz_d2.y+", ±"+HRs[whichRobot].limit_xyz_d2.z, 5, appH-20);
  HRs[whichRobot].updateXYZformat();
  text("XYZ="+HRs[whichRobot].sX+", "+HRs[whichRobot].sY+", "+HRs[whichRobot].sZ, 5, appH-40);
  text("ABC="+HRs[whichRobot].ABC.x+", "+HRs[whichRobot].ABC.y+", "+HRs[whichRobot].ABC.z, 5, appH-60);
  START_Y=520;
  fill(0, 222, 0);




  //println("BALL_IS_MATCH_MOTOR="+BALL_IS_MATCH_MOTOR);
   if (runCircle) {
   
    fill(255, 0, 0);
    stroke(255);
    ellipse(HRs[whichRobot].XYZ.x, HRs[whichRobot].XYZ.z, 5, 5);
  } 

  cam.endHUD();
}
