String append0x0(String msg) {
  if (msg.length()%4==0)
    msg+="\0\0\0\0";
  else
    for (int i=0;i<(msg.length()%4);i++)
      msg+="\0";
  return msg;
}
String encoderOSC(String msg) {
  String[] osc=msg.split(" ");
  String returnStr="";

  if (osc.length==1) {
    returnStr=append0x0(osc[0]);
  }
  else if (osc.length==3 && osc[1].equals(",i")) {
    returnStr+=append0x0(osc[0]);
    returnStr+=append0x0(osc[1]);
    int oscINT=int(osc[2]);    
    char[] c = new char[4];
    for (int i = 3; i >=0; i--) {
      c[i] = (char)(oscINT >>> (i * 8));
      returnStr+=c[i];
    }
  }
  else if (osc.length==3 && osc[1].equals(",s")) {
    returnStr+=append0x0(osc[0]);
    returnStr+=append0x0(osc[1]);
    returnStr+=append0x0(osc[2]);
  }
//  printStrinHEX(returnStr,"encoderOSC");
  return returnStr;
}
public static  byte[] my_int_to_bb_le(int myInteger) {
  return java.nio.ByteBuffer.allocate(4).order(java.nio.ByteOrder.LITTLE_ENDIAN).putInt(myInteger).array();
}

public static int my_bb_to_int_le(byte [] byteBarray) {
  return java.nio.ByteBuffer.wrap(byteBarray).order(java.nio.ByteOrder.LITTLE_ENDIAN).getInt();
}

public static  byte[] my_int_to_bb_be(int myInteger) {
  return java.nio.ByteBuffer.allocate(4).order(java.nio.ByteOrder.BIG_ENDIAN).putInt(myInteger).array();
}

public static int my_bb_to_int_be(byte [] byteBarray) {
  return java.nio.ByteBuffer.wrap(byteBarray).order(java.nio.ByteOrder.BIG_ENDIAN).getInt();
}
