

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
  
  
  PVector pos_in_world=new PVector();
  ascreen_info(int idx_x,int idx_y,PVector pos_in_world)
  {
    idx_on_video.x = idx_x;
    idx_on_video.y = idx_y;
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
    
    float rotateMap=PI/4;
    ret_RYP.y = rY*rotateMap;
    ret_RYP.z = rX*rotateMap;
    
  }
}