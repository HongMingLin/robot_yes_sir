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
      exec("/usr/bin/say", "HI WIN Robot Balls Online");//Boss
      RX_OFFLINE=false;
    }
    RXLED=!RXLED;
    RX_OFFLINE=false;
    RX_LOST_COUNT=0;
    try {
      inJson = parseJSONObject(inJstr);
      if (json == null) {
        println("[X]ParseJsonFail>>>"+inJstr);
      } else {
        //println("[O]ParseJsonOK");

        JSONArray inJArr=inJson.getJSONArray(JSONKEYWORD.Robots);
        if (inJArr.size()==12) {
          String LINEStr="";
          for (int i=0; i<12; i++) {
            LINEStr+=" "+inJArr.getJSONObject(i).getInt("RID");
            LINEStr+=" "+inJArr.getJSONObject(i).getString("MotStatus");
            LINEStr+=" "+"OvrSpeed="+inJArr.getJSONObject(i).getInt("OvrSpeed");
            LINEStr+=" "+"CmdCount="+inJArr.getJSONObject(i).getInt("CmdCount");
            LINEStr+=" "+"ServoOn="+inJArr.getJSONObject(i).getBoolean("ServoOn");
            LINEStr+=" "+"SafetyCheckObj="+inJArr.getJSONObject(i).getJSONObject("SafetyCheckObj");
            
            //LINEStr+=" "+"SafetyCheck="+inJArr.getJSONObject(i).getString("SafetyCheck");
            LINEStr+=" "+"RbtState="+inJArr.getJSONObject(i).getString("RbtState");
            LINEStr+=" "+"Level="+inJArr.getJSONObject(i).getString("Level");
            LINEStr+=" "+"ECode="+inJArr.getJSONObject(i).getString("ECode");
            
            for (int j=0; j<6; j++) {
              LINEStr+=" T"+j+"="+json.getString("T"+j);
            }
            HRs[i].MotStatus=LINEStr;
          }
          println("[Line]"+LINEStr);
        } else {
          println("[inJ]Len!=12");
        }
        
      }
    }
    catch(Exception e) {
      println("[X]ParseJsonError>>>");//+inJstr);
      e.printStackTrace();
    }
    break;
  case 6666:
    println("[UDP666]"+inJstr);
    break;
  }
}
void LINE(JSONObject JO) {
  String LINEStr="";
  JSONArray inJArr=JO.getJSONArray(JSONKEYWORD.Robots);
  for (int i=0; i<12; i++) {
    JSONObject json=inJArr.getJSONObject(i);
    LINEStr+="ServoOn="+json.getString("ServoOn");
    LINEStr+="SafetyCheckMs="+json.getString("SafetyCheckMs");
    LINEStr+="RID="+json.getString("RID");
    LINEStr+="SafetyCheck="+json.getString("SafetyCheck");
    LINEStr+="RbtState="+json.getString("RbtState");
    LINEStr+="MotStatus="+json.getString("MotStatus");
    LINEStr+="Level="+json.getString("Level");
    LINEStr+="ECode="+json.getString("ECode");
    for (int j=0; j<6; j++) {
      LINEStr+="A"+j+json.getString("A"+j);
    }
  }
  println(logHeader()+LINEStr );
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
    //wsc= new WebsocketClient(this, "ws://hrobot.decade.tw:60000");
    println("ws2");
  }
  catch(Exception e) {
    println("ws3");
  }
}
