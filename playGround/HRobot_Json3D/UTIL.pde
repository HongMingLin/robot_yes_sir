import java.util.*;

void RGBtoHSV( PVector rgb , PVector hsv )
{
 float r=rgb.x, g=rgb.y, b=rgb.z;
 float min, max, delta;
 min = Math.min(Math.min(r, g), b);
 max = Math.max(Math.max(r, g), b);
 hsv.z = max; // v
 delta = max - min;
 if( max != 0 )
   hsv.y = delta / max; // s
 else {
   // r = g = b = 0 // s = 0, v is undefined
   hsv.y = 0;
   hsv.x = -1;
   return;
 }
 if( r == max )
   hsv.x = ( g - b ) / delta; // between yellow & magenta
 else if( g == max )
   hsv.x = 2 + ( b - r ) / delta; // between cyan & yellow
 else
   hsv.x = 4 + ( r - g ) / delta; // between magenta & cyan
 hsv.x *= 60; // degrees
 if( hsv.x  < 0 )
   hsv.x  += 360;
}

float hueOffset(float hue,float center)
{
  hue-=center;
  hue%=360;
  if(hue<0)hue+=360;
  if(hue>180)hue-=360;
  return hue;
}

boolean isR(PVector hsv,float range)
{
  float offset_hue = hueOffset(hsv.x,0);
  
  return offset_hue<range && offset_hue>-range;
}
boolean isG(PVector hsv,float range)
{
  float offset_hue = hueOffset(hsv.x,120);
  
  return offset_hue<range && offset_hue>-range;
}
boolean isB(PVector hsv,float range)
{
  float offset_hue = hueOffset(hsv.x,240);
  
  return offset_hue<range && offset_hue>-range;
}

int FindRGBLocation_(PImage img,int x,int y,int w,int h,PVector ret_RPos,PVector ret_GPos,PVector ret_BPos)
{
  if(x<0 || y<0 || w<0 || h<0 || x+w>img.width|| y+h>img.height)
  {
    return -1;
  }
  ret_RPos.set(0,0,0);
  ret_GPos.set(0,0,0);
  ret_BPos.set(0,0,0);
  int offset_origin = x+y*img.width;
  for(int i=0;i<h;i++)
  {
    int offset = offset_origin+i*img.width;
    for(int j=0;j<w;j++)
    {
      color c = img.pixels[offset+j];
      int R =(c&0xFF0000)>>16;
      int G =(c&0xFF00)>>8;
      int B =(c&0xFF)>>0;
      
      if(R+G+B<100)continue; 
      int V_thres=200;
      float alpha = (float)R-V_thres/(255-V_thres);
      ret_RPos.x+=j*alpha;
      ret_RPos.y+=i*alpha;
      ret_RPos.z+=1*alpha;
      alpha = (float)G-V_thres/(255-V_thres);
      ret_GPos.x+=j*alpha;
      ret_GPos.y+=i*alpha;
      ret_GPos.z+=1*alpha;
      
      alpha = (float)B-V_thres/(255-V_thres);
      ret_BPos.x+=j*alpha;
      ret_BPos.y+=i*alpha;
      ret_BPos.z+=1*alpha;
    }
    
  }
  
  if(ret_RPos.z>0)
  {
    ret_RPos.x/=ret_RPos.z;
    ret_RPos.y/=ret_RPos.z;
  }
  if(ret_GPos.z>0)
  {
    ret_GPos.x/=ret_GPos.z;
    ret_GPos.y/=ret_GPos.z;
  }
  if(ret_BPos.z>0)
  {
    ret_BPos.x/=ret_BPos.z;
    ret_BPos.y/=ret_BPos.z;
  }
  return 0;
}



boolean triangleCollision(
  PVector v00, PVector v01, PVector v02,
  PVector v10, PVector v11, PVector v12)
  {
    float t;
    PVector vec=new PVector();
    vec.set(v01);
    vec.sub(v00);
    t=rayIntersectsTriangle(v00, vec, v10,v11,v12);
    if(t==t && t<1 && t>0)return true;
    
    
    vec.set(v02);
    vec.sub(v01);
    t=rayIntersectsTriangle(v01, vec, v10,v11,v12);
    if(t==t && t<1 && t>0)return true;
    
    
    vec.set(v00);
    vec.sub(v02);
    t=rayIntersectsTriangle(v02, vec, v10,v11,v12);
    if(t==t && t<1 && t>0)return true;
    
    return false;
  }
  


float rayIntersectsTriangle(PVector p, PVector d, 
  PVector v0, PVector v1, PVector v2) {
    
       //println("----\n"+p+" "+d+" "+v0+" "+v1+" "+v2);
  float t =java.lang.Float.NaN;
  PVector e1=v1.copy();
  e1.sub(v0);
  PVector e2=v2.copy();
  e2.sub(v0);
  PVector h=d.cross(e2);

  float a = e1.dot(h);

  if (a > -0.00001 && a < 0.00001)
    return(t);

  float f, u, v;
  f = 1/a;
  PVector s=new PVector();
  PVector.sub(p, v0, s);
  u = f * (s.dot(h));

  if (u < 0.0 || u > 1.0)
    return(t);

  PVector q=s.cross(e1);

  v = f * (d.dot(q));

  if (v < 0.0 || u + v > 1.0)
    return(t);

  // at this stage we can compute t to find out where
  // the intersection point is on the line
  return f * (e2.dot(q));
}



int FindRGBLocation(PImage img,int x,int y,int w,int h,PVector ret_RPos,PVector ret_GPos,PVector ret_BPos)
{
  if(x<0 || y<0 || w<0 || h<0 || x+w>img.width|| y+h>img.height)
  {
    return -1;
  }
  ret_RPos.set(0,0,0);
  ret_GPos.set(0,0,0);
  ret_BPos.set(0,0,0);
  PVector RGB_HSV_Vec=new PVector();
  int offset_origin = x+y*img.width;
  for(int i=0;i<h;i++)
  {
    int offset = offset_origin+i*img.width;
    for(int j=0;j<w;j++)
    {
      color c = img.pixels[offset+j];
      RGB_HSV_Vec.set((c&0xFF0000)>>16,(c&0xFF00)>>8,c&0xFF);
      
      //if(RGB_HSV_Vec.x+RGB_HSV_Vec.y+RGB_HSV_Vec.z<100)continue; 
      RGBtoHSV( RGB_HSV_Vec ,RGB_HSV_Vec );
      //if(RGB_HSV_Vec.y<0.1)continue;
      int V_thres=200;
      if(RGB_HSV_Vec.z<V_thres)continue;
      float range=30;
      float alpha = (RGB_HSV_Vec.z-V_thres)/(255-V_thres);
      if(isR(RGB_HSV_Vec,range))
      {
        ret_RPos.x+=j*alpha;
        ret_RPos.y+=i*alpha;
        ret_RPos.z+=1*alpha;
      }
      else if(isG(RGB_HSV_Vec,range))
      {
        ret_GPos.x+=j*alpha;
        ret_GPos.y+=i*alpha;
        ret_GPos.z+=1*alpha;
      }
      else if(isB(RGB_HSV_Vec,range))
      {
        ret_BPos.x+=j*alpha;
        ret_BPos.y+=i*alpha;
        ret_BPos.z+=1*alpha;
      }
    }
    
  }
  
  if(ret_RPos.z>0)
  {
    ret_RPos.x/=ret_RPos.z;
    ret_RPos.y/=ret_RPos.z;
  }
  if(ret_GPos.z>0)
  {
    ret_GPos.x/=ret_GPos.z;
    ret_GPos.y/=ret_GPos.z;
  }
  if(ret_BPos.z>0)
  {
    ret_BPos.x/=ret_BPos.z;
    ret_BPos.y/=ret_BPos.z;
  }
  return 0;
}


class ascreen_info
{
  
  PVector R=new PVector();
  PVector G=new PVector();
  PVector B=new PVector();
  
  
  PVector XYZ=new PVector();
  PVector RYP=new PVector();
  
  PVector idx_on_video=new PVector();
  
  double []AX;
  
  PVector pos_in_world=new PVector();
  ascreen_info(int idx_x,int idx_y,PVector pos_in_world)
  {
    idx_on_video.x = idx_x;
    idx_on_video.y = idx_y;
    AX=new double[6];
    this.pos_in_world.set(pos_in_world);
  }
  
  void setIdx(int idx_x,int idx_y)
  {
    idx_on_video.x = idx_x;
    idx_on_video.y = idx_y;
  }
  
  final PVector getR()
  {
    return R;
  }
  
  
  final PVector getG()
  {
    return G;
  }
  
  
  final PVector getB()
  {
    return B;
  }
  
  
  final PVector getIdx()
  {
    return idx_on_video;
  }
  
  final PVector getXYZ()
  {
    return XYZ;
  }
  
  final PVector getRYP()
  {
    return RYP;
  }
  
  final PVector getOrigin()
  {
    return pos_in_world;
  }
  
  final void setAngles(double []angles)
  {
    for(int i=0;i<angles.length;i++)
    {
      AX[i]=angles[i];
    }
  }
  
  final double[] getAngles()
  {
    return AX;
  }
  
  int setRGBInfo(PVector R,PVector G,PVector B)
  {
    this.R.set(R);
    this.G.set(G);
    this.B.set(B);
    CorrdTrans(this.R,this.G,this.B,XYZ,RYP);
    return 0;
  }
  
  
  void CorrdTrans( PVector R,PVector G,PVector B,PVector ret_XYZ,PVector ret_RYP)
  {
    ret_XYZ.x = (G.x+B.x)/2;
    ret_XYZ.y = (G.y+B.y)/2;
    
    
    ret_XYZ.z = (float)Math.hypot(G.x-B.x,G.y-B.y)-0.5;
    
    
    float roll = atan2(G.y-B.y,G.x-B.x);
    //The x y is for image coordnate, x axis is upside down, ie, positive angle is CW
    //println(roll*180/PI);
    ret_RYP.x = roll;
    
    float Ry = -R.y;
    float rX = R.x * cos(roll) - Ry * sin(roll);
    float rY = Ry * cos(roll) + R.x * sin(roll);
    rX = Ry;
    rY = R.x;
    float rotateMap=PI/6;
    ret_RYP.y = rY*rotateMap;
    ret_RYP.z = -rX*rotateMap;
    
  }
}



void Cart2Polar3D(PVector in_cart,PVector out_polar)
{
  float x= in_cart.x;
  float y= in_cart.y;
  float z= in_cart.z;
  out_polar.x = sqrt(x * x + y * y + z * z);
  float mag_xy = sqrt(x * x + y * y);
  out_polar.y = (mag_xy<0.0001)?0:acos(x / mag_xy) * (y < 0 ? -1 : 1);//long
  out_polar.z = acos(z / out_polar.x);//lat

}
void drawRod_keepTranse_HACK(PVector p1,PVector p2,float thickness,float xrotate)
{

  PVector pv1 = new PVector(p2.x,p2.y,p2.z);
  pv1.sub(p1);
  
  Cart2Polar3D(pv1,pv1);
  
  
   
  translate((p1.x+p2.x)/2, (p1.y+p2.y)/2, (p1.z+p2.z)/2);
  rotateZ(pv1.y);
  rotateY(pv1.z-PI/2);
  rotateX(xrotate);
  box(pv1.x,thickness,thickness); 
  pushMatrix();
  scale(pv1.x,thickness,thickness);
  //sphere(thickness);
  //drawCylinder( 3, thickness, thickness, pv1.x);
}

void drawRod_keepTranse(PVector p1,PVector p2,float thickness,float xrotate)
{
  PVector pv1 = new PVector(p2.x,p2.y,p2.z);
  pv1.sub(p1);
  
  Cart2Polar3D(pv1,pv1);
  
  
   
  translate((p1.x+p2.x)/2, (p1.y+p2.y)/2, (p1.z+p2.z)/2);
  rotateZ(pv1.y);
  rotateY(pv1.z-PI/2);
  rotateX(xrotate);
  box(pv1.x,thickness,thickness); 
  scale(pv1.x,thickness,thickness);
  //sphere(thickness);
  //drawCylinder( 3, thickness, thickness, pv1.x);
}



PVector[] boxVertices(float w,float h, float d)
{
  PVector[] v={
    new PVector(1,1,1),
    new PVector(1,1,0),
    new PVector(1,0,0),
    new PVector(1,0,1),
    
    new PVector(0,1,1),
    new PVector(0,1,0),
    new PVector(0,0,0),
    new PVector(0,0,1),
  };
  
  for(PVector sv:v)
  {
    sv.sub(0.5,0.5,0.5);
    sv.x*=w;
    sv.y*=h;
    sv.z*=d;
  }
  
  PVector[] vs={
    v[0],v[1],v[2],
    v[2],v[3],v[0],
    
    v[0],v[4],v[7],
    v[7],v[3],v[0],
    
    v[4],v[5],v[6],
    v[6],v[4],v[7],
    
    
    v[1],v[5],v[6],
    v[6],v[2],v[1],
    
    v[0],v[1],v[5],
    v[5],v[4],v[0],
    
    v[3],v[7],v[6],
    v[6],v[2],v[3],
  };
  
  
  
  return vs;
}


float vec_idx(PVector vec,int idx)
{
  if(idx==0)return vec.x;
  if(idx==1)return vec.y;
  if(idx==2)return vec.z;
  return Float.NaN;
}
void axisSwap(PVector vec,int x_idx,int y_idx,int z_idx)
{
  float nx;
  float ny;
  float nz;
  
  if(x_idx<0)nx=-vec_idx(vec,-x_idx);
  else       nx=vec_idx(vec,x_idx);
  if(y_idx<0)ny=-vec_idx(vec,-y_idx);
  else       ny=vec_idx(vec,y_idx);
  if(z_idx<0)nz=-vec_idx(vec,-z_idx);
  else       nz=vec_idx(vec,z_idx);
  
  vec.x = nx;
  vec.y = ny;
  vec.z = nz;
  
}


void axisSwap(float[] vec,int x_idx,int y_idx,int z_idx)
{
  float nx;
  float ny;
  float nz;
  
  if(x_idx<0)nx=-vec[-x_idx];
  else       nx= vec[ x_idx];
  if(y_idx<0)ny=-vec[-y_idx];
  else       ny= vec[ y_idx];
  if(z_idx<0)nz=-vec[-z_idx];
  else       nz= vec[ z_idx];
  
  vec[0] = nx;
  vec[1] = ny;
  vec[2] = nz;
}

void axisSwap(double[] vec,int x_idx,int y_idx,int z_idx,boolean x_flip,boolean y_flip,boolean z_flip)
{
  double nx;
  double ny;
  double nz;
  
  if(x_flip) nx=-vec[x_idx];
  else       nx= vec[x_idx];
  if(y_flip) ny=-vec[y_idx];
  else       ny= vec[y_idx];
  if(z_flip) nz=-vec[z_idx];
  else       nz= vec[z_idx];
  
  vec[0] = nx;
  vec[1] = ny;
  vec[2] = nz;
}
