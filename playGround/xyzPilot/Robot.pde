class Robot extends PApplet {

  ArrayList<PVector> currentLine_XYZ = new ArrayList<PVector>();
  ArrayList<PVector> currentLine_RYP = new ArrayList<PVector>();
  final int maxPoint=1000;
  private PVector max_XYZ=new PVector(0, 0, 0);
  private PVector min_XYZ=new PVector(0, 0, 0);
  private PVector diff_XYZ=new PVector(0, 0, 0);
  private PVector max_RYP=new PVector(0, 0, 0);
  private PVector min_RYP=new PVector(0, 0, 0);
  private PVector diff_RYP=new PVector(0, 0, 0);
  private PVector XYZ=new PVector(0, 0, 0);
  private PVector RYP=new PVector(0, 0, 0);

  PApplet PAPA;
  Robot(PApplet p) {
    PAPA=p;
    g=p.g;
  }
  void updateDraw() {
    paitPath3D();
  }
  void dotXYZ(PVector dXYZ, color c) {
    strokeWeight(1);
    stroke(c);
    pushMatrix();
    translate(dXYZ.x, 0, 0);

    line(dXYZ.x, -10, 0, dXYZ.x, 10, 0);
    line(dXYZ.x, 0, -10, dXYZ.x, 0, 10);
    popMatrix();
    pushMatrix();
    translate(0, dXYZ.y, 0);

    line(-10, dXYZ.y, 0, 10, dXYZ.y, 0);
    line(0, dXYZ.y, -10, 0, dXYZ.y, 10);
    popMatrix();
    pushMatrix();
    translate(0, 0, dXYZ.z);

    line(0, -10, dXYZ.z, 0, 10, dXYZ.z);
    line(-10, 0, dXYZ.z, 10, 0, dXYZ.z);
    popMatrix();
  }
  void paitPath3D() {
    noFill();

    currentLine_XYZ.add(new PVector(XYZ.x, XYZ.y, XYZ.z));
    if (currentLine_XYZ.size() > maxPoint)
      currentLine_XYZ.remove(0);
    paintLine(currentLine_XYZ, color(255, 255, 0), max_XYZ, min_XYZ, diff_XYZ);
    dotXYZ(XYZ, color(255, 255, 0));


    currentLine_RYP.add(new PVector(RYP.x, RYP.y, RYP.z));
    if (currentLine_RYP.size() > maxPoint)
      currentLine_RYP.remove(0);
    paintLine(currentLine_RYP, color( 255, 0, 255), max_RYP, min_RYP, diff_RYP);
    dotXYZ(RYP, color(255, 0, 255));
  }
  void paintLine(ArrayList<PVector> pv, color c, PVector max_p, PVector min_p, PVector diff_p) {

    beginShape();
    float theta = 0f;
    strokeWeight(1);
    for (PVector v : pv) {

      //stroke(255, (255 * (0.5f + 0.5f * sin(theta))), 0,(255 * (0.5f +0.5f * sin( theta++))));
      //stroke(colori, 255 * sin(theta), 0, 255 * sin(theta++));
      max_p.x=max(max_p.x, v.x);
      max_p.y=max(max_p.y, v.y);
      max_p.z=max(max_p.z, v.z);

      if (min_p.x==0)
        min_p.x=v.x;
      if (min_p.y==0)
        min_p.y=v.y;
      if (min_p.z==0)
        min_p.z=v.z;

      min_p.x=min(min_p.x, v.x);
      min_p.y=min(min_p.y, v.y);
      min_p.z=min(min_p.z, v.z);

      diff_p.x=abs(max_p.x-min_p.x);
      diff_p.y=abs(max_p.y-min_p.y);
      diff_p.z=abs(max_p.z-min_p.z);
      stroke(c);
      vertex(v.x, v.y, v.z);
    }
    endShape();
  }
}
