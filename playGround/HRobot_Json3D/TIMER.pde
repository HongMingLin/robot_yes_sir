class statusTimer33 extends java.util.TimerTask {
  public void run() {
    if (REALTIME) {
      send2robot12();
      //justOne=false;
    }
  }
}

java.util.TimerTask statusTimer500 = new java.util.TimerTask() {
  public void run() {

    try {
      u2.send("{\"CMD\":\"AllStatus\"}\n", "10.10.10.88", 9999);
    }
    catch(Exception e) {
      println(e);
    }
    


    if (RX_LOST_COUNT==3&&!RX_OFFLINE) {
      exec("/usr/bin/say", "Robot Boss Offline");
      RX_OFFLINE=true;
    }
    RX_LOST_COUNT++;
  }
};
java.util.TimerTask statusTimer999 = new java.util.TimerTask() {
  public void run() {
    try {
      wsSend(clearAllASCII(inJson.toString()));
    }
    catch(Exception e) {
      println(e);
    }
  }
};
