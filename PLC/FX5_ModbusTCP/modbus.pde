
byte MODBUSSERIAL=0;
byte ID=1;
byte VAL=(byte)0xff;
int whichMPx=2;
int SEQ_MAX=0xffff;
int SEQ=0;
byte[] set1Mval(int offset) {
  byte funCode=0x5;
  byte bb []={00, 00, 00, 00, 00, 06, 0, funCode, 8, 9, (byte)0xff, 0};

  bb[8]=(byte)(((offset+SW_M_START_ADDR) >>8) &0xff);
  bb[9]=(byte)((offset+SW_M_START_ADDR)&0xff );

  return bb;
}
byte[] setMval(byte[] datas) {
  int NUM=18;
  byte funCode=0xF;
  byte SEQH=(byte)((SEQ>>8)&0xff);
  byte SEQL=(byte)((SEQ)&0xff);
  byte bb []={SEQH, SEQL, 00, 00, 00, 06, 1, funCode, 8, 9, (byte)(0xff), (byte)0xff, 0x0};

  int ADDR=SW_M_START_ADDR;

  bb[8]=(byte)(ADDR>>8&0xff);
  bb[9]=(byte)(ADDR&0xff);

  bb[10]=(byte)(NUM>>8&0xff);
  bb[11]=(byte)(NUM&0xff);

  bb[12]=(byte)((datas.length)&0xff);

  bb=Arr_Arr(bb, datas);
  return bb;
}

byte[] forceAllOpen() {
  byte funCode=0x5;
  byte bb []={00, 00, 00, 00, 00, 06, 0, funCode, 8, 9, 0, 1};

  bb[8]=(byte)( ((100+SW_M_START_ADDR) >>8) &0xff);
  bb[9]=(byte)((100+ SW_M_START_ADDR)&0xff );
  bb[10]=(byte)(0xff);
  bb[11]=(byte)(0);
  return bb;
}
byte[] forceAllClose() {
  byte funCode=0x5;
  byte bb []={00, 00, 00, 00, 00, 06, 0, funCode, 8, 9, 0, 1};  
  bb[8]=(byte)( ((SW_M_START_ADDR) >>8) &0xff);
  bb[9]=(byte)(( SW_M_START_ADDR)&0xff );
  bb[10]=(byte)(0xff);
  bb[11]=(byte)(0);
  return bb;
}
byte[] MP_READ0103(int NUM) {
  byte funCode=0x1;
  byte SEQH=(byte)((SEQ>>8)&0xff);
  byte SEQL=(byte)((SEQ)&0xff);
  byte bb []={SEQH, SEQL, 00, 00, 00, 06, 1, funCode, 8, 9, 0, 1};

  bb[8]=(byte)((SW_Y_START_ADDR>>8)&0xff);
  bb[9]=(byte)(SW_Y_START_ADDR&0xff);
  bb[10]=(byte)((NUM>>8)&0xff);
  bb[11]=(byte)(NUM&0xff);
  return bb;
}
byte[] MP_SW(int ADDR, boolean sw) {
  byte funCode = 0x5;
  byte bb[] = {00, 00, 00, 00, 00, 06, 1, funCode, 8, 9, (byte) (0xff), (byte) 0x0};
  ADDR = ADDR + SW_M_START_ADDR + (sw ? 0 : 30);
  System.out.println("ADDR=" + ADDR);
  bb[8] = (byte) (ADDR >> 8 & 0xff);
  bb[9] = (byte) (ADDR & 0xff);
  return bb;
}

byte[] MP_many_SW(int NUM, boolean sw) {
  byte funCode=0xF;
  byte bb []={00, 00, 00, 00, 00, 06, 0, funCode, 8, 9, (byte)(0xff), (byte)0xff};
  int ADDR=NUM+SW_M_START_ADDR+(sw?0:30);
  print("ADDR="+ADDR);
  bb[8]=(byte)(ADDR>>8&0xff);
  bb[9]=(byte)(ADDR&0xff);

  bb[10]=(byte)(NUM>>8&0xff);
  bb[11]=(byte)(NUM&0xff);

  bb[12]=(byte)((NUM*2)&0xff);
  byte[] data=new byte[NUM];
  java.util.Arrays.fill(data, sw?(byte)0xff:0x0);
  bb=Arr_Arr(bb, data);
  return bb;
}
//boolean auto=false;
//int which=0;
//boolean addFlag=true;
