import controlP5.*;
import processing.net.*;

public static final String PLC_IP1 = "10.10.10.222";
public static final int PLC_PORT1 = 501;
String Ystr="";
String YNamestr="";
UDP udp;
ControlP5 cp5;
Toggle toggles[],togglesAll;
Client tcp;
void setup() {
  //initNet();
  thread("initNet");
  size(500, 250);
  frameRate(30);
  cp5 = new ControlP5(this);
  toggles=new Toggle[Y00_22.size()];
  boolean skipNull=false;
togglesAll=cp5.addToggle("ALL")
    .setPosition(260, 5)
      .setSize(200, 200)
      .setValue(true)
      .onPress(btnALLAction)
      //.setMode(ControlP5.SWITCH)
      ;
  for (int i=0; i<Y00_22.size(); i++) {
    Y00_22.get(i);
    String name=(Y00_22.get(i)).name;
    //if(name=="null"){
    //  skipNull=true;
    //  continue;
    //}
    
    
    toggles[i]=cp5.addToggle(i+name)

      .setPosition(5+(i%4*58), 5+(i/4*40))
      .setSize(50, 20)
      .setValue(false)
      .onPress(btnAction)
      //.setMode(ControlP5.SWITCH)
      ;
    toggles[i].setId(i);
    
  }
  toggles[15].setVisible(false);




  new java.util.Timer().scheduleAtFixedRate(statusTimer500, 1111, 500);
}
void initNet() {

  udp = new UDP(this);
  udp.listen(true);
  udp.log(false);
  try {
    tcp = new Client(this, PLC_IP1, PLC_PORT1);
  }
  catch(Exception e) {
    tcp=null;
    e.printStackTrace();
  }
}
void draw() {
  background(0);
  surface.setTitle("HIWIN | RobotGod PLCtools v20190620 rev.x FPS=" + (int) (frameRate));
  fill(255, 255, 0, 200);
  text(YNamestr, 3, height-15);
  text(Ystr, 3, height-30);
}
