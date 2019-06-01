JSONObject inJson;// = parseJSONObject(data);
String pattern  = "MM/dd HH:mm:ss.SSS";

byte logSeq=0;
void receive(byte[] bb, String ip, int port) {
  inJstr=new String(bb); 
  println("RX="+inJstr);
  switch(port) {
  case 9999:  
    try {
      inJson = parseJSONObject(inJstr);
      if (json == null) {
        println("[X]ParseJsonFail");
      } else {
println("[O]ParseJsonOK");
        System.out.println(logHeader()+inJson );
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
//R1Json
void send2robot() {

  for (int i = 0; i < HRs.length; i++) {
    R1Json.setString("Robot", "1");
    R1Json.setString("X", String.valueOf(cm2mm( HRs[0].XYZ.x)));
    R1Json.setString("Y", String.valueOf(cm2mm( HRs[0].XYZ.y)));
    R1Json.setString("Z", String.valueOf(cm2mm( HRs[0].XYZ.z)));

    //float a=lerp(-70, 58, (mouseX/(float)Window_X));
    //float b=lerp(-89, 88, Bpercent);
    //float c=lerp(-180, 180, (mouseY/(float)Window_Y));
    //ROBOT_ABC.lerp(a, b, c, 0.1);
    R1Json.setString("A", String.valueOf(HRs[0].ABC.x) );
    R1Json.setString("B", String.valueOf(HRs[0].ABC.y) );
    R1Json.setString("C", String.valueOf(HRs[0].ABC.z) );
  }


  outJ=R1Json.toString().replaceAll("[/ /g]", "");
  outJ=outJ.replaceAll("[^\\x20-\\x7e]", "");
  println(logHeader()+outJ);
  //u.send(printBB("TX",outJ),R_IP,R_PORT);
  TXLED=!TXLED;
  sendX(outJ);
  //u.send(outJ, R_IP, R_PORT);
  //list.addItem(logHeader()+outJ,logSeq++);
  //if(list.getItems().size()>100)
  //  list.clear();
  //list.addItem("log "+i, i);
  //list.getItem("log "+i).put("color", new CColor().setBackground(0xffff0000).setBackground(0xffff88aa));
  //if(getItems)
}
void send2robot12() {

  for (int i = 0; i < HRs.length; i++) {
    JSONObject tJ=R12JsonArray.getJSONObject(i);
    tJ.setString("X", String.valueOf(cm2mm( HRs[i].XYZ.x)));
    tJ.setString("Y", String.valueOf(cm2mm( HRs[i].XYZ.y)));
    tJ.setString("Z", String.valueOf(cm2mm( HRs[i].XYZ.z)));

    //float a=lerp(-70, 58, (mouseX/(float)Window_X));
    //float b=lerp(-89, 88, Bpercent);
    //float c=lerp(-180, 180, (mouseY/(float)Window_Y));
    //ROBOT_ABC.lerp(a, b, c, 0.1);
    tJ.setString("A", String.valueOf(HRs[i].ABC.x) );
    tJ.setString("B", String.valueOf(HRs[i].ABC.y) );
    tJ.setString("C", String.valueOf(HRs[i].ABC.z) );
  }


  outJ=json.toString().replaceAll("[/ /g]", "");
  outJ=outJ.replaceAll("[^\\x20-\\x7e]", "");
  println(logHeader()+outJ);
  //u.send(printBB("TX",outJ),R_IP,R_PORT);
  TXLED=!TXLED;
  sendX(outJ);
  //u.send(outJ, R_IP, R_PORT);
}
void sendX(String s) {
  //u.send(s, R_IP, R_PORT);
}
String logHeader() {
  return "["+new SimpleDateFormat(pattern).format( new Date() )+"]";
}
