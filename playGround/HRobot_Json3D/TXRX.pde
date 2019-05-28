JSONObject inJson;// = parseJSONObject(data);
String pattern  = "MM/dd HH:mm:ss.SSS";


void receive(byte[] bb, String ip, int port) {
  inJstr=new String(bb); 
  switch(port) {
  case 9999:  
    try {
      inJson = parseJSONObject(inJstr);
      if (json == null) {
        println("[X]ParseJsonFail");
      } else {
        
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

void send2robot() {

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


  outJ=json.toString().replaceAll("[/ /g]","");
  outJ=outJ.replaceAll("[^\\x20-\\x7e]", "");
  println(logHeader()+outJ);
  //u.send(printBB("TX",outJ),R_IP,R_PORT);
  TXLED=!TXLED;
  u.send(outJ, R_IP, R_PORT);
  
}
String logHeader(){
return "["+new SimpleDateFormat(pattern).format( new Date() )+"]";
}
