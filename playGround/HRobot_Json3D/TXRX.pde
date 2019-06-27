
String pattern  = "MMdd_HHmmss.SSS";
boolean RXLED2=false;
int RX_LOST_COUNT=0;
boolean RX_OFFLINE=true;
byte logSeq=0;
String rxStr="";


StringBuffer inTXTSB=new StringBuffer("");
void parseFile(String fname) {
  BufferedReader reader = createReader(fname);
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {

      JSONObject txtIn1Json = parseJSONObject(line);
    }
    reader.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
} 
void receive(byte[] bb, String ip, int port) {
  rxStr=new String(bb); 
  //DEBUG("RX="+inJstr);
  switch(port) {
  case 44444:
    if (rxStr.startsWith("/cue/")) {
      processCUE(rxStr);
    }
    break;
  case 9999:
    if (RX_OFFLINE) {
      exec("/usr/bin/say", "HI WIN Robot Boss Online");//Boss
      RX_OFFLINE=false;
    }
    RXLED=!RXLED;
    RX_OFFLINE=false;
    RX_LOST_COUNT=0;
    try {
      JSONObject in1Json = parseJSONObject(rxStr);
      if (in1Json == null) {
        DEBUG("[X]ParseJsonFail>>>"+rxStr);
      } else {
        RXJSONObj=in1Json;
        RXJSONStr=clearAllASCII(RXJSONObj.toString());
        JSONArray inJArr=RXJSONObj.getJSONArray(JSONKEYWORD.Robots);
        if (inJArr.size()==12) {
          String LINEStr="";
          for (int i=0; i<12; i++) {
            int ID=inJArr.getJSONObject(i).getInt("RID")-1;
            HRs[ID].ackXYZ.x=inJArr.getJSONObject(i).getInt("X");
            HRs[ID].ackXYZ.y=inJArr.getJSONObject(i).getInt("Y");
            HRs[ID].ackXYZ.z=inJArr.getJSONObject(i).getInt("Z");
            HRs[ID].ackABC.x=inJArr.getJSONObject(i).getInt("A");
            HRs[ID].ackABC.y=inJArr.getJSONObject(i).getInt("B");
            HRs[ID].ackABC.z=inJArr.getJSONObject(i).getInt("C");
            HRs[ID].ServoOn=inJArr.getJSONObject(i).getBoolean("ServoOn");


            //HRs[ID].ackINFO[0]=inJArr.getJSONObject(i).getInt("CmdCount");
            //HRs[ID].ackINFO[1]=inJArr.getJSONObject(i).getString("SafetyCheck");
            //HRs[ID].ackINFO[2]=inJArr.getJSONObject(i).getString("ECode");

            LINEStr+=" RID="+ID;
            LINEStr+=" CmdCount="+HRs[ID].ackINFO[0];
            LINEStr+=" SafetyCheck="+HRs[ID].ackINFO[1];
            LINEStr+=" ECode="+HRs[ID].ackINFO[2];
            LINEStr+=" XYZ="+HRs[ID].ackXYZ.x+","+HRs[ID].ackXYZ.y+","+HRs[ID].ackXYZ.z;
            LINEStr+=" ABC="+HRs[ID].ackABC.x+","+HRs[ID].ackABC.y+","+HRs[ID].ackABC.z;
            for (int j=0; j<6; j++) {
              HRs[ID].ackJ1J6[j]=inJArr.getJSONObject(i).getFloat("A"+(j+1));
              //LINEStr+=" A"+(j+1)+"="+inJArr.getJSONObject(i).getFloat("T"+(j+1));
            }
            isAtHome(i, HRs[ID].ackJ1J6);
            for (int j=0; j<6; j++) {
              LINEStr+=" T"+j+"="+inJArr.getJSONObject(i).getFloat("T"+(j+1));
            }
          }
          DEBUG("[Line]"+LINEStr);
        } else {
          DEBUG("[inJ]Len!=12");
        }
        if (millis()%5==0) {
          String msg="[RB]"+RXJSONObj.toString();
          String cmd="curl -X POST -H 'Authorization: Bearer [1aqZBluKbLlpdzdye5Dit16h2HZN3qTZu5Q9BuYhZfj]' -F 'message="+msg+"' https://notify-api.line.me/api/notify";
        }
        DEBUG(RXJSONObj.toString());
      }
    }
    catch(Exception e) {
      DEBUG("[X]ParseJsonError>>>");//+inJstr);
      e.printStackTrace();
    }
    break;
  case 6666:
    DEBUG("[UDP666]"+rxStr);
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
  DEBUG(logHeader()+LINEStr );
}
void send2robot12() {
  TXLED=!TXLED;

  //TXJSONObj.setString(JSONKEYWORD.TIMESTAMP, millis()+"");

  sendX(TXJSONStr);
}
void sendX(String s) {
  TXJSONObj.setString(JSONKEYWORD.TIMESTAMP, millis()+"");
  u.send(s, R_IP, R_PORT);
}
void wsSend(String s) {
  String ss="asdf";
  if (wsc!=null) {
    wsc.sendMessage(s);
  } else {
    DEBUG("ws ==null");
    initWS();
    DEBUG("init ws..OK");
  }
}
String logHeader() {
  return "["+new SimpleDateFormat(pattern).format( new Date() )+"]";
}
void initWS() {
  try {
    DEBUG("ws1");
    //wsc= new WebsocketClient(this, "ws://hrobot.decade.tw:60000");
    DEBUG("ws2");
  }
  catch(Exception e) {
    DEBUG("ws3");
  }
}
