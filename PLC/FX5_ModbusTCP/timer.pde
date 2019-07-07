java.util.TimerTask statusTimer500 = new java.util.TimerTask() {
  public void run() {
    //print(".");            
    tx(MP_READ0103(24), PLC_IP1, PLC_PORT1);

    //tx(MP_READ0103(32), NML.UDP_MP2.ipDest, NML.UDP_MP2.portDest);
    //tx(MP_READ0103(32), NML.UDP_MP3.ipDest, NML.UDP_MP3.portDest);
  }
};
java.util.TimerTask statusTimer1000 = new java.util.TimerTask() {
  public void run() {
    if (hour()==9&&minute()==55&&second()==0) {
      toggleALLLED=false;
      thread("run3LEDstoggle");
      println("[DECADE]open LED x3 ");
    } else if (hour()==22&&minute()==5&&second()==0) {
      toggleALLLED=true;
      thread("run3LEDstoggle");
      println("[DECADE]close LED x3 ");
    }
  }
};
boolean toggleALLLED=false;

//Calendar date10am = Calendar.getInstance();
//date10am.set(Calendar.HOUR, 10);
//Calendar date10pm = Calendar.getInstance();
//date10pm.set(Calendar.HOUR, 22);

//Date date2pm = new java.util.Date();
//date2pm.setHour(14);
//date2pm.setMinutes(0);

//Timer timer = new Timer();
//timer.sc(myOwnTimerTask,date2pm, 86400000);

void run3LEDstoggle() {

  int[] btnID = {16, 17, 18};
  for (int i=0; i<btnID.length; i++) {
    byte[] outBytes=set1Mval(M_mapping[btnID[i]], toggleALLLED);
    println("SW"+btnID[i]+" to "+toggleALLLED);    
    outBytes[5]=(byte)(outBytes.length-6);//tcp header len =6
    printBBb(true, "TX_set1M", outBytes);
    tx(outBytes, PLC_IP1, PLC_PORT1);
    try {
      Thread.sleep(555);
    }
    catch(Exception e) {
    }
  }
  System.out.println("TT：" + new java.util.Date());
};
