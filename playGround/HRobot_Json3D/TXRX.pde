JSONObject inJson;// = parseJSONObject(data);
String pattern  = "MM/dd HH:mm:ss.SSS";
boolean RXLED2=false;
int RX_LOST_COUNT=0;
boolean RX_OFFLINE=true;
byte logSeq=0;
void receive(byte[] bb, String ip, int port) {
  inJstr=new String(bb); 
  //println("RX="+inJstr);
  switch(port) {
  case 9999:
    if (RX_OFFLINE) {
      exec("/usr/bin/say", "HI WIN Robot Boss Online");
      RX_OFFLINE=false;
    }
    RXLED=!RXLED;
    RX_OFFLINE=false;
    RX_LOST_COUNT=0;
    try {
      inJson = parseJSONObject(inJstr);
      if (json == null) {
        //println("[X]ParseJsonFail");
      } else {
        println("[O]ParseJsonOK");
        System.out.println(logHeader()+inJson );
        JSONArray inJArr=inJson.getJSONArray(JSONKEYWORD.Robots);
        if (inJArr.size()==12) {
          for (int i=0; i<12; i++) {
            HRs[i].MotStatus=inJArr.getJSONObject(i).getString("MotStatus");
          }
        } else {
          println("[inJ]Len!=12");
        }
      }
    }
    catch(Exception e) {
      println("[X]ParseJsonError");
    }
    break;
  case 6666:

    break;
  }
}
void send2robot12() {
  TXLED=!TXLED;
  if (second()%5==0)
    println(logHeader()+"[TX]= "+outJ);
  json.setString(JSONKEYWORD.TIMESTAMP, millis()+"");
  outJ=clearAllASCII(json.toString());
  sendX(outJ+"\n");
}
void sendX(String s) {
  u.send(s, R_IP, R_PORT);
}
void wsSend(String s) {
  String ss="asdf";
  if (wsc!=null) {
    wsc.sendMessage(s);
  } else {
    println("ws ==null");
    initWS();
    println("init ws..OK");
  }
}
String logHeader() {
  return "["+new SimpleDateFormat(pattern).format( new Date() )+"]";
}
void initWS() {
  try {
    println("ws1");
    wsc= new WebsocketClient(this, "ws://hrobot.decade.tw:8888/flora");
    println("ws2");
  }
  catch(Exception e) {
    println("ws3");
  }
}
