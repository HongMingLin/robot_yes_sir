

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
  
void drawRod(PVector p1,PVector p2,float thickness,float xrotate)
{

  pushMatrix();
  PVector pv1 = new PVector(p2.x,p2.y,p2.z);
  pv1.sub(p1);
  
  Cart2Polar3D(pv1,pv1);
  
  
   
  translate((p1.x+p2.x)/2, (p1.y+p2.y)/2, (p1.z+p2.z)/2);
  rotateZ(pv1.y);
  rotateY(pv1.z-PI/2);
  rotateX(xrotate);
  box(pv1.x,thickness,thickness); 
  //sphere(thickness);
  //drawCylinder( 3, thickness, thickness, pv1.x);
  popMatrix();
}