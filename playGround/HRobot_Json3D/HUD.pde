void beginHUD() {

  cam.beginHUD();
  textAlign(LEFT);
  //image(img, 0, 0);
  //cp5setup();
  fill(255);

  
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
  
  START_Y=550;
  text("{q w e r} = 4F ", 5, START_Y-65);
  text("{a s d f} = 3F ", 5, START_Y-45);
  text("{z x c v} = 2F ", 5, START_Y-25);
  text("[P] ALL_Mode(ES,STOP,PAUSE,PLAY)="+AM, 5, START_Y);
  textSize(20);
  text("[M] 1Robot RunMode@"+whichRobot+"="+HRs[whichRobot].RM, 5, START_Y+=25);
  textSize(12);
  text("SafeXYZ=±"
    +HRs[whichRobot].SAFEx0y0z0.x+" - "+HRs[whichRobot].SAFEx1y1z1.x
    +HRs[whichRobot].SAFEx0y0z0.y+" - "+HRs[whichRobot].SAFEx1y1z1.y
    +HRs[whichRobot].SAFEx0y0z0.z+" - "+HRs[whichRobot].SAFEx1y1z1.z
    , 5, START_Y+=20);
  HRs[whichRobot].transXYZformat();
  text("XYZ="+HRs[whichRobot].sX+", "+HRs[whichRobot].sY+", "+HRs[whichRobot].sZ, 5, START_Y+=20);
  text("ABC="+HRs[whichRobot].ABC.x+", "+HRs[whichRobot].ABC.y+", "+HRs[whichRobot].ABC.z, 5, START_Y+=20);
  fill(255,255,0);
  text("TX_JSON="+outJ , 5, START_Y+=20);
  text("RX_JSON="+inJstr , 5, START_Y+=16);
  
  fill(255);

  stroke(255);
  strokeWeight(1);
  line(0,appH-20,appW,appH-20);
  text("REALTIME(R)     TX/RX        | TX_mS="+TX_mS, 6, appH-5);
  fill(REALTIME?0:255, REALTIME?255:0, 0);
  ellipse(88, appH-10, 8, 8);
  
  fill(TXLED?0:255, TXLED?255:0, 0);
  ellipse(145, appH-10, 8, 8);
  fill(RXLED?0:255, RXLED?255:0, 0);
  ellipse(155, appH-10, 8, 8);
  drawMovie();
  cp5.draw();
  showRobotStatusHUD();
  text(mouseX+","+mouseY, mouseX, mouseY);
  cam.endHUD();
}
void showRobotStatusHUD(){
  PVector[] video12XY={
    new PVector(1,1,1),
    new PVector(1,1,0),
    new PVector(1,0,0),
    new PVector(1,0,1),
    
    new PVector(0,1,1),
    new PVector(0,1,0),
    new PVector(0,0,0),
    new PVector(0,0,1),
  };
  
  //HRs[0].Aligned
  text(HRs[0].RM+"",10,225);
  text(HRs[4].RM+"",10,290);
  text(HRs[8].RM+"",10,360);
  
  text(HRs[1].RM+"",85,225);
  text(HRs[5].RM+"",85,290);
  text(HRs[9].RM+"",85,360);
  
  text(HRs[2].RM+"",160,225);
  text(HRs[6].RM+"",160,290);
  text(HRs[10].RM+"",160,360);
  
  text(HRs[3].RM+"",230,225);
  text(HRs[7].RM+"",230,290);
  text(HRs[11].RM+"",230,360);
}
