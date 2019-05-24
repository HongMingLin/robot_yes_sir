//{'Command':'ptp_pose',


UDP u;
String R_IP="10.10.10.88";
int R_PORT=6666;
JSONObject json;//,jsonStop;
String jsonStopStr="";
int Window_X=240;
int Window_Y=274;
int Window_Z=500;
PVector xyz000=new PVector((int)X/2, (int)Y/2, (int)Z/2);
PVector windowSize=new PVector(240, 274);
boolean REALTIME=false;
boolean justOne=true;
java.util.TimerTask statusTimer33 = new java.util.TimerTask() {
  public void run() {
    if (REALTIME) {
      
      //json.setString("Robot", "1");
      //send2robot();
      //json.setString("Robot", "2");
      //send2robot();
      
      json.setString("Robot", "3");
      send2robot();
      //justOne=false;
    }
  }
};
void setup() {
  size(240, 274);
  frameRate(60);
  u = new UDP( this, 7777 );
  u.log( false );
  u.listen( true );
  
  //jsonStop= new JSONObject();
  //jsonStop.setString("Command", "Clear");
  //jsonStop.setString("Robot", "3");
  //jsonStopStr=jsonStop.toString().replaceAll(" ", "");
  //jsonStopStr=jsonStopStr.replaceAll("[^\\x20-\\x7e]", "");
  
  json = new JSONObject();
  json.setString("Command", "ptp_pose");
  json.setString("Robot", "3");
  json.setString("X", "0");
  json.setString("Y", "0");
  json.setString("Z", "0");
  json.setString("A", "0");
  json.setString("B", "0");
  json.setString("C", "0");  
  new java.util.Timer().scheduleAtFixedRate(statusTimer33, 0, 10);
  exec("/usr/bin/say", "HIWIN Robot online");
}
//PVector robotXYZ(PVector XYZ) {
//  XYZ.x-=(Window_X/2);
//  XYZ.z+=(Window_Y/2);
//  return XYZ;
//}
PVector ROBOT_XYZ=new PVector(0, 0, 0);
PVector ROBOT_ABC=new PVector(0, 0, 0);
void draw() {
  //rect(0,0,);
  background(0);
  stroke(255);
  line(Window_X>>1, 0, Window_X>>1, Window_Y);
  line(0, Window_Y>>1, Window_X, Window_Y>>1);
  text(mouseX+","+mouseY, mouseX, mouseY);
  if (runCircle) {
    runCircle();
    fill(255, 0, 0);
    stroke(255);
    ellipse(ROBOT_XYZ.x, ROBOT_XYZ.z, 5, 5);
  } 
  fill(255);
  text(ROBOT_XYZ.x+","+ROBOT_XYZ.y+","+ROBOT_XYZ.z, mouseX, mouseY-10);
  text("M="+mode, 5, 20);
  text("XYZ="+ROBOT_XYZ.x+","+ROBOT_XYZ.y+","+ROBOT_XYZ.z, 5, 40);
  text("ABC="+ROBOT_ABC.x+","+ROBOT_ABC.y+","+ROBOT_ABC.z, 5, 60);
}

StringBuffer sb=new StringBuffer("");
byte[] printBB(String h, String s) {

  byte bb[]=s.getBytes();

  sb.setLength(0);
  sb.append(h);
  sb.append(s+"=>");
  for (int i=0; i<bb.length; i++) {
    sb.append(" ["+i+"]"+hex(bb[i]));
  }

  println(sb.toString());
  return bb;
}
float limit_x=500;
float limit_y=200;
float limit_z=300;

float CRICLE_R=500;
float CRICLE_Time=TWO_PI/3000;
float nowSin=0;

void runCircle() {
  nowSin=millis()*CRICLE_Time;
  ROBOT_XYZ.x=(CRICLE_R*sin(nowSin));
  //ROBOT_XYZ.z=mouseY+(CRICLE_R*cos(nowSin));
}

void run100cm() {
  nowSin=millis()*TWO_PI/1000;
  ROBOT_XYZ.x=mouseX+(CRICLE_R*sin(nowSin));
  //ROBOT_XYZ.z=mouseY+(CRICLE_R*cos(nowSin));
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  //if (mode==mode.M_ABC){
    Bpercent+=e*0.1;
    if(Bpercent>1)Bpercent=1;
    else if(Bpercent<=0)Bpercent=0;
  //}else if (mode==mode.M_XYZ){
    //ROBOT_XYZ.y+=e;
  //}

  println(e);
}
