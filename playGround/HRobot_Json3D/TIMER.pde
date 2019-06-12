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
    //println(outJ);
    //u.send("asdf"+logHeader(),"127.0.0.1",1212);
    //println("[TX]");
        u2.send("{\"CMD\":\"AllStatus\"}\n","10.10.10.88",9999);
        //u2.send("{\"CMD\":\"giveMeFive\"}\n","10.10.10.88",9999);
        

  }
};
