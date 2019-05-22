
class InverseKinematic {
  
  public boolean debug=false;
  public double sq(double num){return num*num;};
  public double [][]geometry;
  public double [][]J_initial_absolute;
  public double []R_corrected;
  public double V1_length_x_z;
  public double V4_length_x_y_z;
  public int OK,OUT_OF_RANGE,OUT_OF_BOUNDS;

  InverseKinematic(double [][]geometry) {
    this.OK = 0;
    this.OUT_OF_RANGE = 1;
    this.OUT_OF_BOUNDS = 2;

    this.V1_length_x_z = (double)Math.sqrt((double)Math.pow(geometry[1][0], 2) + (double)Math.pow(geometry[1][2], 2));
    this.V4_length_x_y_z = (double)Math.sqrt((double)Math.pow(geometry[4][0], 2) + (double)Math.pow(geometry[4][2], 2) + (double)Math.pow(-geometry[4][1], 2));


    double [] tmpPos = new double[]{0, 0, 0};
    J_initial_absolute=new double[geometry.length][];
    
    for (int i = 0; i < geometry.length; i++) {
      J_initial_absolute[i]=new double[3];
      J_initial_absolute[i][0]=tmpPos[0];
      J_initial_absolute[i][1]=tmpPos[1];
      J_initial_absolute[i][2]=tmpPos[2];
      
      tmpPos[0] += geometry[i][0];
      tmpPos[1] += geometry[i][1];
      tmpPos[2] += geometry[i][2];
    }


    R_corrected=new double[6];

    this.R_corrected[1] += (double)Math.PI / 2;
    this.R_corrected[1] -= (double)Math.atan2(geometry[1][0], geometry[1][2]); // correct offset bone;

    this.R_corrected[2] += (double)Math.PI / 2;
    this.R_corrected[2] += (double)Math.atan2((geometry[2][2] + geometry[3][2]), (geometry[2][0] + geometry[3][0])); // correct offset bone V2,V3;
    this.R_corrected[2] += (double)Math.atan2(geometry[1][0], geometry[1][2]); // correct bone offset of V1;

    this.R_corrected[4] += (double)Math.PI;

    this.geometry = geometry;
  };

  void  inverse(double[] pose, double[] angles)
  {
    calculateAngles( pose[0], pose[1], pose[2], pose[3], pose[4], pose[5], angles);
  }
  double[] inverse(double[] pose)
  {
    double[] angles=new double[6];
    inverse( pose, angles);
    return angles;
  }
  void  inverse(double x,double y,double z,double a,double b,double c, double[] angles)
  {
    calculateAngles( x, y, z, a, b, c, angles);
  }
  void  calculateAngles(double x,double y,double z,double a,double b,double c, double[] angles)
  {
    calculateAngles( x, y, z, a, b, c, angles,new boolean[]{false, false, false});
  }
  void calculateAngles(double x,double y,double z,double a,double b,double c, double[] angles, boolean[] config) {
    double cc = (double)Math.cos(c);
    double sc = (double)Math.sin(c);
    double cb = (double)Math.cos(b);
    double sb = (double)Math.sin(b);
    double ca = (double)Math.cos(a);
    double sa = (double)Math.sin(a);

    double[] targetVectorZ = new double[]{
      sb, -sa * cb,
      ca * cb,
    };

    double[] R = new double[]{
      this.R_corrected[0],
      this.R_corrected[1],
      this.R_corrected[2],
      this.R_corrected[3],
      this.R_corrected[4],
      this.R_corrected[5],
    };

    double[][] J  = new double[][]{
      new double[]{0, 0, 0},
      new double[]{0, 0, 0},
      new double[]{0, 0, 0},
      new double[]{0, 0, 0},
      new double[]{0, 0, 0},
      new double[]{0, 0, 0}
    };



    // ---- J5 ----

    J[5][0] = x;
    J[5][1] = y;
    J[5][2] = z;


    // ---- J4 ----
    // vector;

    J[4][0] = x - this.V4_length_x_y_z * targetVectorZ[0];
    J[4][1] = y - this.V4_length_x_y_z * targetVectorZ[1];
    J[4][2] = z - this.V4_length_x_y_z * targetVectorZ[2];


    // ---- R0 ----
    // # J4;

    double alphaR0 = (double)Math.asin(this.J_initial_absolute[4][1] / this.length2(J[4][1], J[4][0]));
    R[0] += (double)Math.atan2(J[4][1], J[4][0]);
    R[0] += -alphaR0;

    if (config[0]) {
      R[0] += 2 * alphaR0 - (double)Math.PI;
    };

    if (-this.J_initial_absolute[4][1] > this.length2(J[4][2], J[4][0])) {
      System.out.println("out of reach");
    };


    // ---- J1 ----
    // # R0;

    J[1][0] = (double)Math.cos(R[0]) * this.geometry[0][0] + (double)Math.sin(R[0]) * -this.geometry[0][1];
    J[1][1] = (double)Math.sin(R[0]) * this.geometry[0][0] + (double)Math.cos(R[0]) * this.geometry[0][1];
    J[1][2] = this.geometry[0][2];
    //addSphere("J1", J[1], 0x00ff00);


    // ---- rotate J4 into x,z plane ----
    // # J4 R0;

    double[] J4_x_z = new double[3];

    J4_x_z[0] = (double)Math.cos(R[0]) * J[4][0] + (double)Math.sin(R[0]) * J[4][1];
    J4_x_z[1] = (double)Math.sin(R[0]) * J[4][0] + (double)Math.cos(R[0]) * -J[4][1]; // 0;
    J4_x_z[2] = J[4][2];
    //addSphere("J4_x_z", J4_x_z, 0xff0000);

    // ---- J1J4_projected_length_square ----
    // # J4 R0;

    double J1J4_projected_length_square = (double)Math.pow(J4_x_z[0] - this.J_initial_absolute[1][0], 2) + (double)Math.pow(J4_x_z[2] - this.J_initial_absolute[1][2], 2); // not using (double)Math.sqrt;


    // ---- R2 ----
    // # J4 R0;

    double J2J4_length_x_z = this.length2(this.geometry[2][0] + this.geometry[3][0], this.geometry[2][2] + this.geometry[3][2]);
    
    R[2] += ((config[1] ? !config[0] : config[0]) ? 1.0 : -1.0) * 
      (double)Math.acos((-J1J4_projected_length_square + (double)Math.pow(J2J4_length_x_z, 2) + (double)Math.pow(this.V1_length_x_z, 2)) 
      /(2.0 * (J2J4_length_x_z) * this.V1_length_x_z));
    
    System.out.println(J1J4_projected_length_square+":"+ (J2J4_length_x_z) +":"+ this.V1_length_x_z);
    R[2] -= 2 * (double)Math.PI;

    R[2] = ((R[2] + 3 * (double)Math.PI) % (2 * (double)Math.PI)) - (double)Math.PI; // clamp -180/180 degree;


    // ---- R1 ----
    // # J4 R0;

    double J1J4_projected_length = (double)Math.sqrt(J1J4_projected_length_square);
    R[1] -= (double)Math.atan2((J4_x_z[2] - this.J_initial_absolute[1][2]), (J4_x_z[0] - this.J_initial_absolute[1][0])); // a''
    R[1] += ((config[1] ? !config[0] : config[0]) ? 1.0 : -1.0) * (double)Math.acos((J1J4_projected_length_square - (double)Math.pow(J2J4_length_x_z, 2) + (double)Math.pow(this.V1_length_x_z, 2)) / (2.0 * J1J4_projected_length * this.V1_length_x_z)); // a;

    R[1] = ((R[1] + 3 * (double)Math.PI) % (2 * (double)Math.PI)) - (double)Math.PI;


    // ---- J2 ----
    // # R1 R0;

    double ta = (double)Math.cos(R[0]);
    double tb = (double)Math.sin(R[0]);
    double tc = this.geometry[0][0];
    double d = this.geometry[0][2];
    double e = -this.geometry[0][1];
    double f = (double)Math.cos(R[1]);
    double g = (double)Math.sin(R[1]);
    double h = this.geometry[1][0];
    double i = this.geometry[1][2];
    double j = -this.geometry[1][1];
    double k = (double)Math.cos(R[2]);
    double l = (double)Math.sin(R[2]);
    double m = this.geometry[2][0];
    double n = this.geometry[2][2];
    double o = -this.geometry[2][1];

    J[2][0] = ta * tc + tb * e + ta * f * h - ta * -g * i + tb * j;
    J[2][1] = -(-tb * tc + ta * e - tb * f * h + tb * -g * i + ta * j);
    J[2][2] = d + -g * h + f * i;
    //addSphere("J2", J[2], 0x0000ff);

    J[3][0] = J[2][0] + ta * f * k * m - ta * -g * -l * m - ta * -g * k * n - ta * f * -l * n + tb * o;
    J[3][1] = J[2][1] - (-tb * f * k * m + tb * -g * -l * m + tb * -g * k * n + tb * f * -l * n + ta * o);
    J[3][2] = J[2][2] + -g * k * m + f * -l * m + f * k * n + g * -l * n;
    //addSphere("J3", J[3], 0x0000ff);


    // ---- J4J3 J4J5 ----
    // # J3 J4 J5;

    double[] J4J5_vector =new double[]{J[5][0] - J[4][0], J[5][1] - J[4][1], J[5][2] - J[4][2]};
    double[] J4J3_vector =new double[]{J[3][0] - J[4][0], J[3][1] - J[4][1], J[3][2] - J[4][2]};


    // ---- R3 ----
    // # J3 J4 J5;

    double[] J4J5_J4J3_normal_vector = this.cross(J4J5_vector, J4J3_vector);

    //addVectorArrow("normal J4", J[4], J4J5_J4J3_normal_vector, 0xbada55, 8);

    double[] ZY_parallel_aligned_vector =new double[]{
      10 * -(double)Math.sin(R[0]),
      10 * (double)Math.cos(R[0]),
      0,
    };

    double[] ZY_aligned_J4J3_normal_vector = this.cross(ZY_parallel_aligned_vector, J4J3_vector);

    //addVectorArrow("normal J4 Y_vectors", J[4], ZY_aligned_J4J3_normal_vector, 0xff00ff);
    //addVectorArrow("XZ_parallel_aligned_vector", J[4], ZY_parallel_aligned_vector, 0x11ff11);

    R[3] = this.angleBetween(J4J5_J4J3_normal_vector, ZY_parallel_aligned_vector, ZY_aligned_J4J3_normal_vector);

    if (config[2]) // rotate 180 and clamp -180,180;
    {
      R[3] += (double)Math.PI;
    };
    R[3] = ((R[3] + 3 * (double)Math.PI) % (2 * (double)Math.PI)) - (double)Math.PI;


    // ---- R4 ----
    // # J4 J3 J5 R3;

    R[4] += ((config[2]) ? 1 : -1) * this.angleBetween2(J4J5_vector, J4J3_vector);

    // clamp -180,180;
    R[4] = ((R[4] + 3 * (double)Math.PI) % (2 * (double)Math.PI)) - (double)Math.PI;


    // ---- R5 ----
    // # J4 J5 J3;

    double[] targetVectorY =new double[]{-cb * sc,
      ca * cc - sa * sb * sc,
      sa * cc + ca * sb * sc,
    };

    R[5] -= this.angleBetween(J4J5_J4J3_normal_vector, targetVectorY, this.cross(targetVectorZ, targetVectorY));

    if (config[2]) R[5] += (double)Math.PI;

    R[5] = ((R[5] + 3 * (double)Math.PI) % (2 * (double)Math.PI)) - (double)Math.PI;
    // ---- Error handling ----

    boolean error = false;
    boolean[] outOfBounds =new boolean[]{false, false, false, false, false, false};


    angles[0] = R[0];
    angles[1] = R[1];
    angles[2] = R[2];
    angles[3] = R[3];
    angles[4] = R[4];
    angles[5] = R[5];
  };
  
  
  double[][] forward(double[]angles) {
    return forward(
      angles[0],angles[1],angles[2],
      angles[3],angles[4],angles[5]
    );
  }
  double[][] forward(double R0,double R1,double R2,double R3,double R4,double R5)
  {
    double[][] joints = new double[6][6];
    this.calculateCoordinates(R0, R1, R2, R3, R4, R5, joints);
    return joints;
  }
  void calculateTCP(double R0,double  R1,double  R2,double  R3,double  R4,double R5,double []jointsResult) {
    double[][] joints = new double[6][6];
    this.calculateCoordinates(R0, R1, R2, R3, R4, R5, joints);
    jointsResult[0] = joints[5][0];
    jointsResult[1] = joints[5][1];
    jointsResult[2] = joints[5][2];
    jointsResult[3] = joints[5][3];
    jointsResult[4] = joints[5][4];
    jointsResult[5] = joints[5][5];
  };
  void calculateCoordinates(double R0,double  R1,double  R2,double  R3,double  R4,double R5,double [][]jointsResult) {
  
    boolean []config=new boolean[]{false, false, false};
    calculateCoordinates(R0,R1,R2,R3,R4,R5,jointsResult,config);
  }
  void calculateCoordinates(double R0,double  R1,double  R2,double  R3,double  R4,double R5,double [][]jointsResult,boolean[] config) {

    // todo detect config;

    double a = (double)Math.cos(R0);
    double b = (double)Math.sin(R0);
    double c = this.geometry[0][0];
    double d = this.geometry[0][1];
    double e = this.geometry[0][2];
    double f = (double)Math.cos(R1);
    double g = (double)Math.sin(R1);
    double h = this.geometry[1][0];
    double i = this.geometry[1][1];
    double j = this.geometry[1][2];
    double k = (double)Math.cos(R2);
    double l = (double)Math.sin(R2);
    double m = this.geometry[2][0];
    double n = this.geometry[2][1];
    double o = this.geometry[2][2];
    double p = (double)Math.cos(R3);
    double q = (double)Math.sin(R3);
    double r = this.geometry[3][0];
    double s = this.geometry[3][1];
    double t = this.geometry[3][2];
    double u = (double)Math.cos(R4);
    double v = (double)Math.sin(R4);
    double w = this.geometry[4][0];
    double x = this.geometry[4][1];
    double y = this.geometry[4][2];
    double A = (double)Math.cos(R5);
    double B = (double)Math.sin(R5);

    jointsResult[0][0] = 0;
    jointsResult[0][1] = 0;
    jointsResult[0][2] = 0;

    jointsResult[1][0] = jointsResult[0][0] + a * c - b * d;
    jointsResult[1][1] = jointsResult[0][1] + b * c + a * d;
    jointsResult[1][2] = jointsResult[0][2] + e;

    jointsResult[2][0] = jointsResult[1][0] + a * f * h - b * i + a * g * j;
    jointsResult[2][1] = jointsResult[1][1] + b * f * h + a * i + b * g * j;
    jointsResult[2][2] = jointsResult[1][2] + -g * h + f * j;

    jointsResult[3][0] = jointsResult[2][0] + a * f * k * m - a * g * l * m - b * n + a * g * k * o + a * f * l * o;
    jointsResult[3][1] = jointsResult[2][1] + b * f * k * m - b * g * l * m + a * n + b * g * k * o + b * f * l * o;
    jointsResult[3][2] = jointsResult[2][2] - g * k * m - f * l * m + f * k * o - g * l * o;

    jointsResult[4][0] = jointsResult[3][0] + a * f * k * r - a * g * l * r - b * p * s + a * g * k * q * s + a * f * l * q * s + a * g * k * p * t + a * f * l * p * t + b * q * t;
    jointsResult[4][1] = jointsResult[3][1] + b * f * k * r - b * g * l * r + a * p * s + b * g * k * q * s + b * f * l * q * s + b * g * k * p * t + b * f * l * p * t - a * q * t;
    jointsResult[4][2] = jointsResult[3][2] - g * k * r - f * l * r + f * k * q * s - g * l * q * s + f * k * p * t - g * l * p * t;

    jointsResult[5][0] = jointsResult[4][0] + a * f * k * u * w - a * g * l * u * w - a * g * k * p * v * w - a * f * l * p * v * w - b * q * v * w - b * p * x + a * g * k * q * x + a * f * l * q * x + a * g * k * p * u * y + a * f * l * p * u * y + b * q * u * y + a * f * k * v * y - a * g * l * v * y;
    jointsResult[5][1] = jointsResult[4][1] + b * f * k * u * w - b * g * l * u * w - b * g * k * p * v * w - b * f * l * p * v * w + a * q * v * w + a * p * x + b * g * k * q * x + b * f * l * q * x + b * g * k * p * u * y + b * f * l * p * u * y - a * q * u * y + b * f * k * v * y - b * g * l * v * y;
    jointsResult[5][2] = jointsResult[4][2] - g * k * u * w - f * l * u * w - f * k * p * v * w + g * l * p * v * w + f * k * q * x - g * l * q * x + f * k * p * u * y - g * l * p * u * y - g * k * v * y - f * l * v * y;

    double [][]M = new double [][]{
      new double []{-B * b * p + B * a * g * k * q + B * a * f * l * q - A * a * g * k * p * u - A * a * f * l * p * u - A * b * q * u - A * a * f * k * v + A * a * g * l * v, -A * b * p + A * a * g * k * q + A * a * f * l * q + B * a * g * k * p * u + B * a * f * l * p * u + B * b * q * u + B * a * f * k * v - B * a * g * l * v, a * f * k * u - a * g * l * u - a * g * k * p * v - a * f * l * p * v - b * q * v},
      new double []{B * a * p + B * b * g * k * q + B * b * f * l * q - A * b * g * k * p * u - A * b * f * l * p * u + A * a * q * u - A * b * f * k * v + A * b * g * l * v, A * a * p + A * b * g * k * q + A * b * f * l * q + B * b * g * k * p * u + B * b * f * l * p * u - B * a * q * u + B * b * f * k * v - B * b * g * l * v, b * f * k * u - b * g * l * u - b * g * k * p * v - b * f * l * p * v + a * q * v},
      new double []{B * f * k * q - B * g * l * q - A * f * k * p * u + A * g * l * p * u + A * g * k * v + A * f * l * v, A * f * k * q - A * g * l * q + B * f * k * p * u - B * g * l * p * u - B * g * k * v - B * f * l * v, -g * k * u - f * l * u - f * k * p * v + g * l * p * v},
    };

    // https://www.geometrictools.com/Documentation/EulerAngles.pdf;
    double thetaY,
      thetaX,
      thetaZ;
    if (M[0][2] < 1) {
      if (M[0][2] > -1) {
        thetaY = (double)Math.asin(M[0][2]);
        thetaX = (double)Math.atan2(-M[1][2], M[2][2]);
        thetaZ = (double)Math.atan2(-M[0][1], M[0][0]);
      } else {
        thetaY = -(double)Math.PI / 2;
        thetaX = -(double)Math.atan2(M[1][0], M[1][1]);
        thetaZ = 0;
      };
    } else {
      thetaY = +(double)Math.PI / 2;
      thetaX = (double)Math.atan2(M[1][0], M[1][1]);
      thetaZ = 0;
    };


    jointsResult[5][3] = thetaX;
    jointsResult[5][4] = thetaY;
    jointsResult[5][5] = thetaZ;
  };

  double []cross(double []vectorA, double []vectorB)
  {
    double []result=new double[3];
    return cross(vectorA,vectorB,result);
  }
  double []cross(double []vectorA, double []vectorB, double []result) {
    result[0] = vectorA[1] * vectorB[2] - vectorA[2] * vectorB[1];
    result[1] = vectorA[2] * vectorB[0] - vectorA[0] * vectorB[2];
    result[2] = vectorA[0] * vectorB[1] - vectorA[1] * vectorB[0];
    return result;
  };

  double dot(double []vectorA, double []vectorB) {
    return vectorA[0] * vectorB[0] + vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2];
  };

  /**
    * @param  {array} vectorA         angle from;
    * @param  {array} vectorB         angle to;
    * @param  {array} referenceVector angle to set 0 degree from. coplanar with vecA and vecB;
    * @return {number}                 description;
    * @example angleBetween([1,0,0],[0,1,0],[0,0,1]) // PI/2;
    */
  double angleBetween(double[] vectorA,double[] vectorB,double[] referenceVector) {
    // angle = atan2(norm(cross(a, b)), dot(a, b));

    double norm = this.length3(this.cross(vectorA, vectorB));

    double angle = (double)Math.atan2(norm, (vectorB[0] * vectorA[0] + vectorB[1] * vectorA[1] + vectorB[2] * vectorA[2]));

    double tmp = referenceVector[0] * vectorA[0] + referenceVector[1] * vectorA[1] + referenceVector[2] * vectorA[2];

    double sign = (tmp > 0.0001) ? 1.0 : -1.0;

    return angle * sign;
  };

  double length3(double[] vector) {
    return (double)Math.sqrt((double)Math.pow(vector[0], 2) + (double)Math.pow(vector[1], 2) + (double)Math.pow(vector[2], 2));
  };

  double length2(double a,double b) {
    return (double)Math.sqrt((double)Math.pow(a, 2) + (double)Math.pow(b, 2));
  };

  double angleBetween2(double[] v1,double[] v2) {
    double angle;
    // turn vectors into unit vectors;
    // this.normalize(v1,v1);
    // this.normalize(v2,v2);
    //
    // double angle = (double)Math.acos(this.dot(v1, v2));
    // // if no noticable rotation is available return zero rotation;
    // // this way we avoid Cross product artifacts;
    // if ((double)Math.abs(angle) < 0.0001) return 0;
    // // in this case there are 2 lines on the same axis;
    // // // angle = atan2(norm(cross(a, b)), dot(a, b));
    double[] cross = this.cross(v1, v2);

    return (double)Math.atan2(this.length3(cross), this.dot(v1, v2));
  };
  void normalize(double[] vector,double[] result) {
    double length = (double)Math.sqrt((vector[0] * vector[0]) + (vector[1] * vector[1]) + (vector[2] * vector[2]));
    result[0] = vector[0] / length;
    result[1] = vector[1] / length;
    result[2] = vector[2] / length;
  };
};