
int[] M_mapping={0, 1, 2, 3, 6, 7, 8, 9, 12, 13, 14, 15, 4, 10, 16, 0, 5, 11, 17 };
CallbackListener btnAction = new CallbackListener() {
  @ Override void controlEvent(CallbackEvent evt) {
    final Controller<?> btn = evt.getController();
    String name = btn.getName();
    boolean value = (int) btn.getValue()==0?false:true; //now is true click then false
    int ID = (int) btn.getId();
    //byte[] outBytes=setMval(setBit(FX5C_ANS,btnMapbit[ID],value));
    //println(ID, name, value, frameCount);
    byte[] outBytes=set1Mval(M_mapping[ID], value);
    println("SW"+ID+" to "+value +" ="+btn.getValue());
    printBBb(true, "TX_set1M", outBytes);
    tx(outBytes, PLC_IP1, PLC_PORT1);
    ;
  }
};
CallbackListener btnALLAction = new CallbackListener() {
  @ Override void controlEvent(CallbackEvent evt) {
    final Controller<?> btn = evt.getController();
    String name = btn.getName();
    boolean value = (int) btn.getValue()==0?false:true; //now is true click then false
    for (int i=0; i<=17; i++) {
      byte[] outBytes=set1Mval(M_mapping[ID], value);
      //println("SW"+ID+" to "+value +" ="+btn.getValue());
      //printBBb(true, "TX_set1M", outBytes);
      tx(outBytes, PLC_IP1, PLC_PORT1);
    }
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
