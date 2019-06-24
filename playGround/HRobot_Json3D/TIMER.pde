class statusTimer33 extends java.util.TimerTask {
  public void run() {
    TXJSONStr=clearAllASCII(TXJSONObj.toString());
    if (REALTIME) {
      send2robot12();
      //justOne=false;
    }
    if (logSaveTx) {
      output.println(TXJSONStr+"\n"); 
      
    }
  }
}

java.util.TimerTask statusTimer500 = new java.util.TimerTask() {
  public void run() {
    //println(BB.getItem(second()%12+""));
    for (int i=1; i<=12; i++)
      BB.changeItem(i+"", "selected", false);
    BB.changeItem(second()%12+1+"", "selected", true);

    try {
      //if (REALTIME) {
      u2.send("{\"CMD\":\"AllStatus\"}\n", "10.10.10.88", 9999);
      TXLED=!TXLED;
      //}
    }
    catch(Exception e) {
      DEBUG(e.toString());
    }



    if (RX_LOST_COUNT==3&&!RX_OFFLINE) {
      exec("/usr/bin/say", "Robot Balls Offline");//Boss
      RX_OFFLINE=true;
    }
    RX_LOST_COUNT++;
    FlashStatus=!FlashStatus;
  }
};
java.util.TimerTask statusTimer999 = new java.util.TimerTask() {
  public void run() {
    try {
      wsSend(clearAllASCII(RXJSONObj.toString()));
    }
    catch(Exception e) {
      DEBUG(e.toString());
    }
  }
};
