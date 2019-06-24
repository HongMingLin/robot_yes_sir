void beginHUD() {

  cam.beginHUD();
  textAlign(LEFT);
  //image(img, 0, 0);
  //cp5setup();
  fill(255);


  //text(Qsb.toString(),WINDOW_W-textWidth(Qsb.toString())+(WINDOW_W/2*(1+sin(millis()*TWO_PI/2000))),20);
  int OFFSET_Y=20;
  int START_Y=25;

  //text("C_Distance:" +cam.getDistance()+" FPS:"+ nfc(frameRate, 2), 10, START_Y+=OFFSET_Y);
  text("C_Distance:" +nfc((float)cam.getDistance(), 2)+" FPS:"+ nfc(frameRate, 2)+"M_S="+M_S, 10, START_Y+=OFFSET_Y);

  float[] xyz = cam.getRotations();
  text("rX="+nf(xyz[0], 1, 3)+" rY="+nf(xyz[1], 1, 3)+" rZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);
  xyz=cam.getPosition();
  text("cX="+nf(xyz[0], 1, 3)+" cY="+nf(xyz[1], 1, 3)+" cZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);
  text("MinD"+MinD+", MaxD="+MaxD+", CamD"+CamD, 10, START_Y+=OFFSET_Y);
  xyz=cam.getLookAt();
  text("lookX="+nf(xyz[0], 1, 3)+" lookY="+nf(xyz[1], 1, 3)+" lookZ="+nf(xyz[2], 1, 3), 10, START_Y+=OFFSET_Y);

  START_Y=550;
  //text("{q w e r} = 4F ", 315, 40);
  //text("{a s d f} = 3F ", 315, 50);
  //text("{z x c v} = 2F ", 315, 60);
  //text("[P] ALL_Mode(ES,STOP,PAUSE,PLAY)="+AM, 5, START_Y);

  //textSize(20);
  //text("[M] 1Robot RunMode@"+whichRobot+"="+HRs[whichRobot].RM, 5, START_Y+=25);
  //textSize(12);
  //text("SafeXYZ=±"
  //  +HRs[whichRobot].SAFEx0y0z0.x+" - "+HRs[whichRobot].SAFEx1y1z1.x
  //  +HRs[whichRobot].SAFEx0y0z0.y+" - "+HRs[whichRobot].SAFEx1y1z1.y
  //  +HRs[whichRobot].SAFEx0y0z0.z+" - "+HRs[whichRobot].SAFEx1y1z1.z
  //  , 5, START_Y+=20);
  //HRs[whichRobot].transXYZformat();
  //text("XYZ="+HRs[whichRobot].sX+", "+HRs[whichRobot].sY+", "+HRs[whichRobot].sZ, 5, START_Y+=20);
  //text("ABC="+HRs[whichRobot].ABC.x+", "+HRs[whichRobot].ABC.y+", "+HRs[whichRobot].ABC.z, 5, START_Y+=20);
  fill(255, 255, 0);
  //DEBUG(jsonHUD);
  //text("TX_JSON="+outJ , 5, START_Y+=20);
  //text(("+jsonHUD.get("360A1")+"));



  int tY=365;
  for (int i=0; i<12; i++) {

    JSONObject JJJ=TXJSONObj.getJSONArray(JSONKEYWORD.Robots).getJSONObject(i);

    String s1 = String.format("%+06.1f %+06.1f %+06.1f %+06.1f %+06.1f %+06.1f "
      , JJJ.getFloat("A1"), JJJ.getFloat("A2"), JJJ.getFloat("A3"), 
      JJJ.getFloat("A4"), JJJ.getFloat("A5"), JJJ.getFloat("A6"))+" RK=";
    fill(255, 255, 0, 128);
    text(s1, 5, tY+=10);
    fill((HRs[i].RK_fatalError?255:0), (HRs[i].RK_fatalError?0:255), 0);
    text((HRs[i].RK_fatalError?"NG":"OK"), 5 + 1 + textWidth(s1), tY );
    s1+=(HRs[i].RK_fatalError?"NG":"OK");
    fill(255, 255, 0, 128);
    text(" CD=", 5 + 1 + textWidth(s1), tY );
    s1+=" CD=";
    fill((HRs[i].RK_ColliError.get()?255:0), (HRs[i].RK_ColliError.get()?0:255), 0);
    text((HRs[i].RK_ColliError.get()?"Y":"N"), 5 + 1 + textWidth(s1), tY );
    s1+=(HRs[i].RK_ColliError.get()?"Y":"N");

    stroke(200);
    strokeWeight(1);
    fill(200);
    text(", ALL=", 5 + 1 + textWidth(s1), tY );
    s1+=", ALL=";
    fill((HRs[i].ALL_PATH_OK?0:255), (HRs[i].ALL_PATH_OK?255:0), 0);
    rect(5 + 1 + textWidth(s1), tY-8, 5, 8);
    //text((HRs[i].ALL_PATH_OK?"Y":"N"), 5 + 1 + textWidth(s1), tY );

    fill(255, 255, 0, 128);


    try {
      if (RXJSONObj!=null) {
        JSONObject tempJ=RXJSONObj.getJSONArray(JSONKEYWORD.Robots).getJSONObject(i);
        String s  ="";
        s+="Servo="+(HRs[i].ServoOn?"O":"X");
        s+=" |RState="+tempJ.getString("RbtState");
        s+=" |HRSS="+tempJ.getString("HrssMode");
        s+=" |ECode="+tempJ.getString("ECode");
        s+=" |Motion="+tempJ.getString("MotStatus");
        s+=" |Safety="+tempJ.getString("SafetyCheck");
        s+=" |Level="+tempJ.getString("Level");
        
        

        HRs[i].ackXYZABCstr=s;
        SLL.getItem(i).put("text", s);
        SLL.update();

        s="";
        s+=(1+i)+". XYZ="+HRs[i].ackXYZ.x+","+HRs[i].ackXYZ.y+","+HRs[i].ackXYZ.z+
          " ABC="+
          HRs[i].ackABC.x+","+HRs[i].ackABC.y+","+HRs[i].ackABC.z;
        s+=" A1-6=";
        for (int r=1; r<=6; r++)
          s+=tempJ.getFloat("A"+r);
        //s+=" T1-6=";
        //for (int r=1; r<=6; r++)
        //  s+=tempJ.getFloat("T"+r);

        //text("RB>"+s, 5, tY+135+15 );
        text("RB>"+s, 5, tY+135 );
      } else
        text("RB>Notyet", 5, tY+135 );
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  //fill(255,255,0);
  text("TX_JSON="+TXJSONStr, 5, appH-30);
  text("RX_JSON="+RXJSONStr, 5, appH-45);

  fill(255);

  stroke(255);
  strokeWeight(1);
  line(0, appH-20, appW, appH-20);
  text("REALTIME(R)  TX/RX     | TX_mS="+TX_mS+"  | HOME= ", 6, appH-5);
  //text("ALL_PATH_OK", 6, appH-25);
  fill(REALTIME?0:255, REALTIME?255:0, 0);
  ellipse(88, appH-10, 8, 8);

  fill(TXLED?0:255, TXLED?255:0, 0);
  ellipse(145, appH-10, 8, 8);
  fill(RXLED?0:255, RXLED?255:0, 0);
  ellipse(155, appH-10, 8, 8);

  for (int i=0; i<12; i++) {
    if (HRs[i].atHome)
      fill(0, 255, 0);
    else
      fill(255, FlashStatus?255:0, 0);
    rect(305+(i*10)+(i%3==0?5:0), appH-13, 8, 8);
  }


  BB.update();
  drawMovie();
  cp5.draw();
  showRobotStatusHUD();
  text(mouseX+","+mouseY, mouseX, mouseY);
  cam.endHUD();
}
void showRobotStatusHUD() {
  PVector[] video12XY={
    new PVector(1, 1, 1), 
    new PVector(1, 1, 0), 
    new PVector(1, 0, 0), 
    new PVector(1, 0, 1), 

    new PVector(0, 1, 1), 
    new PVector(0, 1, 0), 
    new PVector(0, 0, 0), 
    new PVector(0, 0, 1), 
  };


  //RXJSONObj.getJsonArray();
  fill(HRs[0].Aligned?color(0, 255, 0):color(255, 0, 0));


  int startX=3;
  int startY=200;

  for (int xx=0; xx<12; xx++) {
    text(HRs[xx].RM+" SOn="+(HRs[xx].ServoOn?"O":"X"), startX+(xx%4*80),startY+(xx/4*80) );
  }

  //text(HRs[1].RM+"", 85, 205);
  //text(HRs[2].RM+"", 160, 205);
  //text(HRs[3].RM+"", 230, 205);
  //text(HRs[4].RM+"", 10, 280);
  //text(HRs[5].RM+"", 85, 280);
  //text(HRs[6].RM+"", 160, 280);
  //text(HRs[7].RM+"", 230, 280);
  //text(HRs[8].RM+"", 10, 350);
  //text(HRs[9].RM+"", 85, 350);
  //text(HRs[10].RM+"", 160, 350);
  //text(HRs[11].RM+"", 230, 350);
}
