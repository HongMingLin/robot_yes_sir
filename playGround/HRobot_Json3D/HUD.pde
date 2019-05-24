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

  text("M="+AM, 5, 20);
  text("SafeXYZ=±"
    +HRs[whichRobot].SAFEx0y0z0.x+" - "+HRs[whichRobot].SAFEx1y1z1.x
    +HRs[whichRobot].SAFEx0y0z0.y+" - "+HRs[whichRobot].SAFEx1y1z1.y
    +HRs[whichRobot].SAFEx0y0z0.z+" - "+HRs[whichRobot].SAFEx1y1z1.z
    , 5, appH-20);
  HRs[whichRobot].transXYZformat();
  text("XYZ="+HRs[whichRobot].sX+", "+HRs[whichRobot].sY+", "+HRs[whichRobot].sZ, 5, appH-40);
  text("ABC="+HRs[whichRobot].ABC.x+", "+HRs[whichRobot].ABC.y+", "+HRs[whichRobot].ABC.z, 5, appH-60);
  text("RM@"+whichRobot+"="+HRs[whichRobot].RM, 5, appH-80);
  
  START_Y=520;
  fill(0, 222, 0);

  //if (XMODE==RunMODE.XYZ_CIRCLE) {
  //  fill(255, 0, 0);
  //  stroke(255);
  //  ellipse(HRs[whichRobot].XYZ.x, HRs[whichRobot].XYZ.z, 5, 5);
  //} 
  fill(REALTIME?0:255, REALTIME?255:0, 0);
  ellipse(73, appH-10, 8, 8);

  text("REALTIME     HIMC RX/TX       | ALIGN_BALL     |   IsSystemOper     |WIFI", 6, appH-5);

  cam.endHUD();
}
