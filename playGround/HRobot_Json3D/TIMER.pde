class statusTimer33 extends java.util.TimerTask {
  public void run() {
    if (REALTIME) {
      send2robot();
      //justOne=false;
    }
  }
}
java.util.TimerTask statusTimer500 = new java.util.TimerTask() {

  public void run() {
    u.send("asdf"+logHeader(),"127.0.0.1",1212);
  }
};
