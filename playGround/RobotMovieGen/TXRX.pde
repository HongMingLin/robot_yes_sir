void receive(byte[] bb, String ip, int port) {
  try{
  String rxStr=new String(bb); 
  //DEBUG("RX="+inJstr);
  switch(port) {
  case 33333:
    if (rxStr.startsWith("/cue/")) {
      processCUE(rxStr);
    }
    break;
  }
  }catch(Exception e){
    e.printStackTrace();
  }
}
