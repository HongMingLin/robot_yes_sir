

public enum Quaternion_RotSeq{zyx, zyz, zxy, zxz, yxz, yxy, yzx, yzy, xyz, xyx, xzy,xzx};

  
public class Quaternion {
    
  public float x, y, z, w;
  public Quaternion() {
      clear();
  }
  
  public Quaternion(float _x, float _y, float _z, float _w) {
      x = _x;
      y = _y;
      z = _z;
      w = _w;
  }
  
  public void clear() {
      x = y = z = 0;
      w = 1;
  }
  public Quaternion(Quaternion ref) {
     set(ref);
  }
  
  public Quaternion(float angle, PVector axis) {
      setAngleAxis(angle, axis);
  }
  
  public Quaternion clone() {
      return new Quaternion(x, y, z, w);
  }
  
  public float diffMag(Quaternion q) {
    
      return (float)Math.hypot(Math.hypot(x-q.x,y-q.y),Math.hypot(z-q.z,w-q.w));
  }
  public Boolean equal(Quaternion q,float tor) {
    
      return diffMag(q)<tor;
  }
  
  public void set(float _x, float _y, float _z, float _w) {
      x = _x;
      y = _y;
      z = _z;
      w = _w;
  }
  public void set(Quaternion ref) {
      x = ref.x;
      y = ref.y;
      z = ref.z;
      w = ref.w;
  }
  
  public void setAngleAxis(float angle, PVector axis) {
      axis.normalize();
      float hcos = cos(angle / 2);
      float hsin = sin(angle / 2);
      w = hcos;
      x = axis.x * hsin;
      y = axis.y * hsin;
      z = axis.z * hsin;
  }
  
  
  public void rotateAxis(float angle, PVector axis) {
      
      Quaternion mulp = new Quaternion(angle,axis);
      
      mult(this,mulp);
  }
  
  
  public void conj(Quaternion q) {
      Quaternion ret = q;
      ret.x = -x;
      ret.y = -y;
      ret.z = -z;
      ret.w = w;
  }
  public Quaternion conj() {
      Quaternion ret = new Quaternion(this);
      conj(ret);
      return ret;
  }
  
  public void mult(Quaternion q,float r) {
      Quaternion ret = q;
      ret.x = x * r;
      ret.y = y * r;
      ret.z = z * r;
      ret.w = w * w;
  }
  public Quaternion mult(float r) {
      Quaternion ret = new Quaternion(this);
      mult(ret,r);
      return ret;
  }
  
  public void mult(Quaternion q_mult_in,Quaternion multiplier)
  {
      Quaternion ret = q_mult_in;
      float _x = multiplier.w*x + multiplier.x*w + multiplier.y*z - multiplier.z*y;
      float _y = multiplier.w*y - multiplier.x*z + multiplier.y*w + multiplier.z*x;
      float _z = multiplier.w*z + multiplier.x*y - multiplier.y*x + multiplier.z*w;
      float _w = multiplier.w*w - multiplier.x*x - multiplier.y*y - multiplier.z*z;
      
      set(_x,_y,_z,_w);
    
  }
  public Quaternion mult(Quaternion q) {
      Quaternion ret = new Quaternion(this);
      mult(ret,q);
      return ret;
  }
  
  
  public void mult(PVector v,PVector res) {
    float px = (1 - 2 * y * y - 2 * z * z) * v.x +
               (2 * x * y - 2 * z * w) * v.y +
               (2 * x * z + 2 * y * w) * v.z;
               
    float py = (2 * x * y + 2 * z * w) * v.x +
               (1 - 2 * x * x - 2 * z * z) * v.y +
               (2 * y * z - 2 * x * w) * v.z;
               
    float pz = (2 * x * z - 2 * y * w) * v.x +
               (2 * y * z + 2 * x * w) * v.y +
               (1 - 2 * x * x - 2 * y * y) * v.z;
  
    res.set(px, py, pz);
  }
  
  public void normalize(){
    float len = w*w + x*x + y*y + z*z;
    float factor = 1.0f / sqrt(len);
    x *= factor;
    y *= factor;
    z *= factor;
    w *= factor;
  }
  
  
  void twoaxisrot(double r11, double r12, double r21, double r31, double r32, PVector ret_vec){
    ret_vec.x = (float)Math.atan2( r11, r12 );
    ret_vec.y = (float)Math.acos ( r21 );
    ret_vec.z = (float)Math.atan2( r31, r32 );
  }
      
  void threeaxisrot(double r11, double r12, double r21, double r31, double r32, PVector ret_vec){
    ret_vec.x = (float)Math.atan2( r31, r32 );
    ret_vec.y = (float)Math.asin ( r21 );
    ret_vec.z = (float)Math.atan2( r11, r12 );
  }
  
  
  
  void getEuler(final Quaternion q, PVector ret_vec, Quaternion_RotSeq rotSeq)
  {
      switch(rotSeq){
      case zyx:
        threeaxisrot( 2*(q.x*q.y + q.w*q.z),
                       q.w*q.w + q.x*q.x - q.y*q.y - q.z*q.z,
                      -2*(q.x*q.z - q.w*q.y),
                       2*(q.y*q.z + q.w*q.x),
                       q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z,
                       ret_vec);
        break;
      
      case zyz:
        twoaxisrot( 2*(q.y*q.z - q.w*q.x),
                     2*(q.x*q.z + q.w*q.y),
                     q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z,
                     2*(q.y*q.z + q.w*q.x),
                    -2*(q.x*q.z - q.w*q.y),
                    ret_vec);
        break;
                  
      case zxy:
        threeaxisrot( -2*(q.x*q.y - q.w*q.z),
                        q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z,
                        2*(q.y*q.z + q.w*q.x),
                       -2*(q.x*q.z - q.w*q.y),
                        q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z,
                        ret_vec);
        break;
  
      case zxz:
        twoaxisrot( 2*(q.x*q.z + q.w*q.y),
                    -2*(q.y*q.z - q.w*q.x),
                     q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z,
                     2*(q.x*q.z - q.w*q.y),
                     2*(q.y*q.z + q.w*q.x),
                     ret_vec);
        break;
  
      case yxz:
        threeaxisrot( 2*(q.x*q.z + q.w*q.y),
                       q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z,
                      -2*(q.y*q.z - q.w*q.x),
                       2*(q.x*q.y + q.w*q.z),
                       q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z,
                       ret_vec);
        break;
  
      case yxy:
        twoaxisrot( 2*(q.x*q.y - q.w*q.z),
                     2*(q.y*q.z + q.w*q.x),
                     q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z,
                     2*(q.x*q.y + q.w*q.z),
                    -2*(q.y*q.z - q.w*q.x),
                    ret_vec);
        break;
        
      case yzx:
        threeaxisrot( -2*(q.x*q.z - q.w*q.y),
                        q.w*q.w + q.x*q.x - q.y*q.y - q.z*q.z,
                        2*(q.x*q.y + q.w*q.z),
                       -2*(q.y*q.z - q.w*q.x),
                        q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z,
                        ret_vec);
        break;
  
      case yzy:
        twoaxisrot( 2*(q.y*q.z + q.w*q.x),
                    -2*(q.x*q.y - q.w*q.z),
                     q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z,
                     2*(q.y*q.z - q.w*q.x),
                     2*(q.x*q.y + q.w*q.z),
                     ret_vec);
        break;
  
      case xyz:
        threeaxisrot( -2*(q.y*q.z - q.w*q.x),
                      q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z,
                      2*(q.x*q.z + q.w*q.y),
                     -2*(q.x*q.y - q.w*q.z),
                      q.w*q.w + q.x*q.x - q.y*q.y - q.z*q.z,
                      ret_vec);
        break;
          
      case xyx:
        twoaxisrot( 2*(q.x*q.y + q.w*q.z),
                    -2*(q.x*q.z - q.w*q.y),
                     q.w*q.w + q.x*q.x - q.y*q.y - q.z*q.z,
                     2*(q.x*q.y - q.w*q.z),
                     2*(q.x*q.z + q.w*q.y),
                     ret_vec);
        break;
          
      case xzy:
        threeaxisrot( 2*(q.y*q.z + q.w*q.x),
                       q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z,
                      -2*(q.x*q.y - q.w*q.z),
                       2*(q.x*q.z + q.w*q.y),
                       q.w*q.w + q.x*q.x - q.y*q.y - q.z*q.z,
                       ret_vec);
        break;
          
      case xzx:
        twoaxisrot( 2*(q.x*q.z - q.w*q.y),
                     2*(q.x*q.y + q.w*q.z),
                     q.w*q.w + q.x*q.x - q.y*q.y - q.z*q.z,
                     2*(q.x*q.z + q.w*q.y),
                    -2*(q.x*q.y - q.w*q.z),
                    ret_vec);
        break;
      default:
        println("Unknown rotation sequence");
        break;
     }
  }

}
