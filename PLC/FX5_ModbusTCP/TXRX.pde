String rxFX5="";
byte[] byteBuffer = new byte[32];
void tx(byte[] bb, String ip, int port) {
  if (udp!=null)
    udp.send(bb, ip, port);
  if (tcp!=null){
    
    tcp.write(bb);
  }
  SEQ++;
  if (SEQ>=0xffff)
    SEQ=0;
}
void clientEvent(Client someClient) {
  //print("[TCPRX]");
  int byteCount = tcp.readBytes(byteBuffer); 
  printBBb(true, "RXTCP", byteBuffer);

  if (isYack(byteBuffer))
    updateY_IO(byteBuffer);
}
//hot code for this PLC
/*
      0111          0010             0111                  0111
 3f4_3f3_3f2_3f1 2f4_2f3_2f2_2f1      4f4_4f3_4f2_4f1      null_4fS_3fS_2fS
 
 0000   0111
 4fL_3fL_2fL
 
 Y=01110010 01110111 00000101
 0.Y_2F_RP1=X 1.Y_2F_RP2=O 2.Y_2F_RP3=X 3.Y_2F_RP4=X 
 4.Y_3F_RP1=O 5.Y_3F_RP2=O 6.Y_3F_RP3=O 7.Y_3F_RP4=X 
 8.Y_4F_RP1=O 9.Y_4F_RP2=O 10.Y_4F_RP3=O 11.Y_4F_RP4=X 
 
 12.Y_2F_Stop=O 13.Y_3F_Stop=O 14.Y_4F_Stop=O 
 15.Y_Noon=X 
 16.Y_2F_LED=O 17.Y_3F_LED=X 18.Y_4F_LED=O     
 */
byte FX5C_ANS[]=new byte[3];
int[] btnMapbit={7, 6, 5, 4, 3, 2, 1, 0, 15, 14, 13, 12, 11, 10, 9, 8, 23, 22, 21};
void updateY_IO(byte[] bb) {

  FX5C_ANS[0]=bb[9];
  FX5C_ANS[1]=bb[10];
  FX5C_ANS[2]=bb[11];
  byte[] ans =FX5C_ANS;

  Ystr="Y="+binary(ans[0]) +" "+ binary(ans[1])+" "+binary(ans[2]);
  println(Ystr);
  for (int i=0; i<Y00_22.size(); i++) {
    Y00_22.get(i).on_off=getBitBoolean(ans, btnMapbit[i]);
  }

  //Y00_22.get(1).on_off=getBitBoolean(ans, 6);
  //Y00_22.get(2).on_off=getBitBoolean(ans, 5);
  //Y00_22.get(3).on_off=getBitBoolean(ans, 4);

  //Y00_22.get(4).on_off=getBitBoolean(ans, 3);
  //Y00_22.get(5).on_off=getBitBoolean(ans, 2);
  //Y00_22.get(6).on_off=getBitBoolean(ans, 1);
  //Y00_22.get(7).on_off=getBitBoolean(ans, 0);

  //Y00_22.get(8).on_off=getBitBoolean(ans, 15);
  //Y00_22.get(9).on_off=getBitBoolean(ans, 14);
  //Y00_22.get(10).on_off=getBitBoolean(ans, 13);
  //Y00_22.get(11).on_off=getBitBoolean(ans, 12);

  //Y00_22.get(12).on_off=getBitBoolean(ans, 11);
  //Y00_22.get(13).on_off=getBitBoolean(ans, 10);
  //Y00_22.get(14).on_off=getBitBoolean(ans, 9);
  //Y00_22.get(15).on_off=getBitBoolean(ans, 8);

  //Y00_22.get(16).on_off=getBitBoolean(ans, 23);
  //Y00_22.get(17).on_off=getBitBoolean(ans, 22);
  //Y00_22.get(18).on_off=getBitBoolean(ans, 21);

  hashmapYWalker(Y00_22);
}
boolean isYack(byte[] bb) {//[0](00) [1](03) [2](00) [3](00) [4](00) [5Len](06) [6](01) [7](01) [8](03) [9](FB) [10](7F) [11](07) 
  byte[] ackYHeader={0, 0, 0, 0, 0, 6, 1, 1, 3};
  boolean correct=true;
  for (int i=2; i<ackYHeader.length; i++) {
    if (ackYHeader[i]!=bb[i])
      correct=false;
  }
  return correct;
}
void receive(byte[] what, String fIP, int fPort) {
  printBBb(false, "RX", what);
  //if (what.length==12||what.length==13) {
  //  String rxs = binary((what[what.length-4] & 0xff) | (what[what.length-3] & 0xff) << 8 | (what[what.length-2] & 0xff) << 16 | (what[what.length-1] & 0xff) << 24);
  //  printBBb(true, fIP+":"+fPort+"=RX_bit", rxs.getBytes());
  //  if (fIP.equals(NML.UDP_MP1.ipDest)) {
  //    rxsMP1=rxs;
  //  } else if (fIP.equals(NML.UDP_MP2.ipDest)) {
  //    rxsMP2=rxs;
  //  } else if (fIP.equals(NML.UDP_MP3.ipDest)) {
  //    rxsMP3=rxs;
  //  }
  //}
}
