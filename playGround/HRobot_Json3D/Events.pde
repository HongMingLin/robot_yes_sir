PVector ROBOT_XYZ_Cxyz=new PVector(0, 0, 0);
void STOP_STOP_STOP_ALL() {
  for (int i=0; i<12; i++)
    STOP_STOP_STOP(i);
  //if(isMacOs) exec("/usr/bin/say", "Robot Stop");
}
void STOP_STOP_STOP(int i) {
  TXJSONObj.getJSONArray(JSONKEYWORD.Robots).getJSONObject(i).setString(JSONKEYWORD.CMD, JSONKEYWORD.STOP);
  HRs[i].ALL_PATH_OK=false;
  HRs[i].RM=HRs[i].RM.STOP;
}
void robotGo() {
  JSONObject jTemp=null;
  for (int i=0; i<12; i++) {
    HRs[i].RM=RunMODE.MOVIE;
    jTemp=TXJSONObj.getJSONArray(JSONKEYWORD.Robots).getJSONObject(i);
    jTemp.setString(JSONKEYWORD.CMD, JSONKEYWORD.ptp_axis);
  }

  if(isMacOs) exec("/usr/bin/say", "Robot Go");
}
void mouseWheel(MouseEvent event) {
  //float e = event.getCount();
  HRs[whichRobot].handleMouseEvent(event);
}

void cueQLAB(String cue) {
  //OscMessage myMessage = new OscMessage(cue);
  u3.send(encoderOSC(cue), "10.10.10.33", 53000);
  //oscP5.send(myMessage, myRemoteLocation);
}

boolean HACK_videoPlayToggle=false;

void keyPressed() {
  motorWalk();
  JSONObject jTemp=null;
  switch(key) {
  case '`':
    disableMovie=!disableMovie;
    break;
  case '1':

    break;

  case '6':
    loadMovie("6.mp4");
    break;
  case '7':
    loadMovie("7.mp4");
    break;
  case '8':
    loadMovie("8.mp4");
    break;
  case '9':
    loadMovie("9.mp4");
    break;
  case 'W':
    skip_calcAckApproved=!skip_calcAckApproved;
    break;
  case 'L':
    if (output==null) {
      output = createWriter("RGOD_TX_RBOSS.POI."+logHeader()+".txt"); 
      logSaveTx=true;
    } else {
      logSaveTx=false;
      output.flush(); 
      output.close();
      output=null;
    }
    break;
  case 'd':
    GlobalDebug=!GlobalDebug;
    break;
  case 'V':
    M_S=M_S.next();
    if (M_S!=MOVIE_or_SHAREIAMGE.Movie)
      if (myMovie!=null)
        myMovie.stop();
    break;
  case 'p':
    if (myMovie!=null)
      myMovie.pause();
    break;
  case 'P':
    if (myMovie!=null) {
      myMovie.play();
    }
    break;

  case 'J':
    u2.send("{\"Command\":\"AllStatus\"}", "10.10.10.157", 9999);
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
    //if(isMacOs) exec("/usr/bin/say", "real time "+(REALTIME?"On":"Off"));

    break;
  case 'A':
    HRs[0].RM=HRs[0].RM.next();
    for (int i=0; i<HRs.length; i++) {
      HRs[i].RM=HRs[0].RM;
      HRs[i].setCC_XYZ_NOW();
    }

    break;
  case 'I':
    jTemp=null;
    for (int i=0; i<12; i++) {
      //HRs[i].RM=RunMODE.MOVIE;
      jTemp=TXJSONObj.getJSONArray(JSONKEYWORD.Robots).getJSONObject(i);
      jTemp.setString(JSONKEYWORD.CMD, JSONKEYWORD.SEVO_ON);
    }
    if(isMacOs) exec("/usr/bin/say", "Robot Servo on");

    break;
  case 'O':
    jTemp=null;
    for (int i=0; i<12; i++) {
      //HRs[i].RM=RunMODE.MOVIE;
      jTemp=TXJSONObj.getJSONArray(JSONKEYWORD.Robots).getJSONObject(i);
      jTemp.setString(JSONKEYWORD.CMD, JSONKEYWORD.SEVO_OFF);
    }
    if(isMacOs) exec("/usr/bin/say", "Robot Servo off");

    break;
  case ' ':
    STOP_STOP_STOP_ALL();
    break;
  case 'G':
    robotGo();

    break;
  case 'H':
    R_home();

    break;

  default:
    for (int i=0; i<WHICHROBOT.values().length; i++) {
      WR=WR.next();
      //DEBUG(i+" temp="+WR.ID()+", "+WR.hotKey());
      if (key == WR.hotKey()) {
        whichRobot=WR.ID();
        DEBUG("whichRobot="+whichRobot);
        if(isMacOs) exec("/usr/bin/say", "Robot "+whichRobot+" ");
        //if(isMacOs) exec("/usr/bin/say","-v","Victoria","Im Victoria");
        //  if(isMacOs) exec("/usr/bin/say","-v","Zarvox"," and Robot.");
        break;
      }
    }
    break;
  }
}
void R_home() {
  JSONObject jTemp=null;
  for (int i=0; i<12; i++) {
    jTemp=TXJSONObj.getJSONArray(JSONKEYWORD.Robots).getJSONObject(i);
    jTemp.setString(JSONKEYWORD.CMD, JSONKEYWORD.HOME);
    HRs[i].RM=RunMODE.HOME;
    HRs[i].ALL_PATH_OK=true;

    HRs[i].atHome=false;
    for (int j=0; j<HRs[i].RK_fatalErrorWhich.length; j++)
      HRs[i].RK_fatalErrorWhich[j]=false;
  }
  //sendX(clearAllASCII(json.toString()+"\n") );
  if(isMacOs) exec("/usr/bin/say", "Robot 全部 回家");
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
