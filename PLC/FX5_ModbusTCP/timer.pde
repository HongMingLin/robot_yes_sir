java.util.TimerTask statusTimer500 = new java.util.TimerTask() {
    public void run() {
      //print(".");            
      tx(MP_READ0103(24),PLC_IP1, PLC_PORT1);
      
      //tx(MP_READ0103(32), NML.UDP_MP2.ipDest, NML.UDP_MP2.portDest);
      //tx(MP_READ0103(32), NML.UDP_MP3.ipDest, NML.UDP_MP3.portDest);
    }
  };
