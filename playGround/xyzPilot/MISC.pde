JSONObject rXJSONObj;
interface JSONKEYWORD
{
  public static final String TIMESTAMP = "TIMESTAMP";
  public static final String Robots = "Robots";
  public static final String RID = "RID";
  public static final String ID = "ID";
  public static final String CMD = "CMD";

  public static final String PASS = "PASS";
  public static final String STOP = "STOP";
  public static final String SEVO_ON = "SEVO_ON";
  public static final String SEVO_OFF = "SEVO_OFF";
  //public static final String ESTOP = "ESTOP";
  public static final String HOME = "HOME";
  public static final String ptp_pose = "ptp_pose";
  public static final String ptp_axis = "ptp_axis";
}
void SetCamVector(float x, float y, float z)
{
  //Rotation rot=new Rotation(new PVector(0, 0, 10), new PVector(x, y, z));
  //camera.setState(new CameraState(rot, new Vector3D(0, 0, 0), camera.getDistance()));
}
void setupJson() {  
  rXJSONObj= new JSONObject();
}
void drawXYZ() {
  strokeWeight(3);
  stroke(255, 0, 0);
  line(0, 0, 0, Center_XYZLineLen, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, Center_XYZLineLen, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, Center_XYZLineLen);
}
