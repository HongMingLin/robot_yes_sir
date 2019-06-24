
CallbackListener btnAction = new CallbackListener() {
  @ Override void controlEvent(CallbackEvent evt) {
    final Controller<?> btn = evt.getController();
    String name = btn.getName();
    boolean value = (int) btn.getValue()==0?false:true;
    int ID = (int) btn.getId();
    //byte[] outBytes=setMval(setBit(FX5C_ANS,btnMapbit[ID],value));
    //println(ID, name, value, frameCount);
    byte[] outBytes=set1Mval(ID);
    
    tx(outBytes,PLC_IP1, PLC_PORT1);; 
  }
};
//void keyPressed() {  
//  switch(keyCode) {
//  }
//  switch(key) {
//  }
//}
//void keyReleased() {
//}
//void mouseWheel(MouseEvent event) {
//}
