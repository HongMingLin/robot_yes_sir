
//translate the js code from https://github.com/glumb/kinematics



/*
^y
>X
@Z (toward you)

R/J2{-Y}---[v2]--R/J3{-Y}---[v3]---R/J4{-Y}---R/J5{-Y}
  |
  |
  |
  |
[v1]
  |
  |
  |
R/J1{-Y}
  |
[v0]
 |
R/J0{-Y}
*/
class Kinematics {
  /**
   * @param {Array} geometry [5][3] Array including geometry information [x,y,z]
   */
  boolean debug=false;
  double sq(double num){return num*num;}
  double [][]geometry;
  double [][]J_initial_absolute;
  double []R_corrected;
  double V1_length_x_z;
  double V4_length_x_y_z;
  Kinematics(double [][]geometry) {
    if (geometry.length != 5) {
      throw new Error("geometry array must have 5 entries");
    }

    if (geometry[3][1] != 0 || geometry[3][2] != 0 || geometry[4][1] != 0 || geometry[4][2] != 0) {
      throw new Error("geometry 3 and 4 must be one dimensional geo[3] = [a,0,0] geo[4] = [a,0,0]");
    }

    this.V1_length_x_z = Math.sqrt(Math.pow(geometry[1][0], 2) + Math.pow(geometry[1][2], 2));
    this.V4_length_x_y_z = Math.sqrt(Math.pow(geometry[4][0], 2) + Math.pow(geometry[4][2], 2) + Math.pow(-geometry[4][1], 2));

    this.geometry = geometry;

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

    this.R_corrected[1] += Math.PI / 2;
    this.R_corrected[1] -= Math.atan2(geometry[1][0], geometry[1][2]); // correct offset bone

    this.R_corrected[2] += Math.PI / 2;
    this.R_corrected[2] += Math.atan2((geometry[2][2] + geometry[3][2]), (geometry[2][0] + geometry[3][0])); // correct offset bone V2,V3
    this.R_corrected[2] += Math.atan2(geometry[1][0], geometry[1][2]); // correct bone offset of V1

    this.R_corrected[4] += Math.PI;
  }

  /**
   * calculateAngles - calculate robot angles based on TCP and geometry
   *
   * @param  {number} x             coordinate
   * @param  {number} y             coordinate
   * @param  {number} z             coordinate
   * @param  {number} a             euler angle rotation order abc
   * @param  {number} b             euler angle rotation order abc
   * @param  {number} c             euler angle rotation order abc
   * todo @param  {String} configuration S1 S2 S3
   * @return {Array}                angles
   */
   
  double[] inverse(double []cord_abc) {
    return inverse(
    cord_abc[0],cord_abc[1],cord_abc[2],
    cord_abc[3],cord_abc[4],cord_abc[5]);
  }
   
  double[] inverse(double x,double y,double z,double a,double b,double c) {
    /*if (this.debug) {
      console.log(x, y, z, a, b, c)
    }*/

    boolean[] config = new boolean[]{
      false,
      false,
      true,
    };

    //HIWIN Robot rotation to euler.
    double[] deg = new double[3];
    deg = StaticToEuler(a, b, c);

    double ca = Math.cos(deg[0]);
    double sa = Math.sin(deg[0]);
    double cb = Math.cos(deg[1]);
    double sb = Math.sin(deg[1]);
    double cc = Math.cos(deg[2]);
    double sc = Math.sin(deg[2]);

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
    // vector

    J[4][0] = x - this.V4_length_x_y_z * targetVectorZ[0];
    J[4][1] = y - this.V4_length_x_y_z * targetVectorZ[1];
    J[4][2] = z - this.V4_length_x_y_z * targetVectorZ[2];
    
    // ---- R0 ----
    // # J4
    double alphaR0 = Math.asin(this.J_initial_absolute[4][1] / this.length2(J[4][1], J[4][0]));
    R[0] += Math.atan2(J[4][1], J[4][0]);
    R[0] += -alphaR0;
    
    if (config[0]) {
        R[0] += 2 * alphaR0 - Math.PI;
    }
    
    if (-this.J_initial_absolute[4][1] > this.length2(J[4][2], J[4][0]) && this.debug) {
      DEBUG("out of reach");
    }
    
    // ---- J1 ----
    // # R0

    J[1][0] = Math.cos(R[0]) * this.geometry[0][0] + Math.sin(R[0]) * -this.geometry[0][1];
    J[1][1] = Math.sin(R[0]) * this.geometry[0][0] + Math.cos(R[0]) * this.geometry[0][1];
    J[1][2] = this.geometry[0][2];


    // ---- rotate J4 into x,y plane ----
    // # J4 R0

    double []J4_x_z = new double[]{
      Math.cos(R[0]) * J[4][0] + Math.sin(R[0]) * J[4][1],
      Math.sin(R[0]) * J[4][0] + Math.cos(R[0]) * -J[4][1],
      J[4][2],
    };
    
    // ---- J1J4_projected_length_square ----
    // # J4 R0

    double J1J4_projected_length_square = Math.pow(J4_x_z[0] - this.J_initial_absolute[1][0], 2) + Math.pow(J4_x_z[2] - this.J_initial_absolute[1][2], 2); // not using Math.sqrt

    // ---- R2 ----
    // # J4 R0

    double J2J4_length_x_z = this.length2(this.geometry[2][0] + this.geometry[3][0], this.geometry[2][2] + this.geometry[3][2]);
    R[2] += ((config[1] ? !config[0] : config[0]) ? 1.0 : -1.0) * Math.acos((-J1J4_projected_length_square + Math.pow(J2J4_length_x_z, 2) + Math.pow(this.V1_length_x_z, 2)) / (2.0 * (J2J4_length_x_z) * this.V1_length_x_z));
    R[2] -= 2 * Math.PI;
    
    R[2] = ((R[2] + 3 * Math.PI) % (2 * Math.PI)) - Math.PI; // clamp -180/180 degree
    
    // ---- R1 ----
    // # J4 R0

    double J1J4_projected_length = Math.sqrt(J1J4_projected_length_square);
    R[1] -= Math.atan2((J4_x_z[2] - this.J_initial_absolute[1][2]), (J4_x_z[0] - this.J_initial_absolute[1][0]));
    R[1] += ((config[1] ? !config[0] : config[0]) ? 1.0 : -1.0) * Math.acos((J1J4_projected_length_square - Math.pow(J2J4_length_x_z, 2) + Math.pow(this.V1_length_x_z, 2)) / (2.0 * J1J4_projected_length * this.V1_length_x_z));

    R[1] = ((R[1] + 3 * Math.PI) % (2 * Math.PI)) - Math.PI;
    
    // ---- J2 ----
    // # R1 R0

    double ta = (double)Math.cos(R[0]);
    double tb = (double)Math.sin(R[0]);
    double tc = this.geometry[0][0];
    double d = this.geometry[0][2];
    double e = this.geometry[0][1];
    double f = (double)Math.cos(R[1]);
    double g = (double)Math.sin(R[1]);
    double h = this.geometry[1][0];
    double i = this.geometry[1][2];
    double j = this.geometry[1][1];
    double k = (double)Math.cos(R[2]);
    double l = (double)Math.sin(R[2]);
    double m = this.geometry[2][0];
    double n = this.geometry[2][2];
    double o = this.geometry[2][1];

    J[2][0] = ta * tc + tb * e + ta * f * h - ta * -g * i + tb * j;
    J[2][1] = -(-tb * tc + ta * e - tb * f * h + tb * -g * i + ta * j);
    J[2][2] = d + -g * h + f * i;
    
    // ---- J3 ----
    // # R0 R1 R2

    J[3][0] = J[2][0] + ta * f * k * m - ta * -g * -l * m - ta * -g * k * n - ta * f * -l * n + tb * o;
    J[3][1] = J[2][1] - (-tb * f * k * m + tb * -g * -l * m + tb * -g * k * n + tb * f * -l * n + ta * o);
    J[3][2] = J[2][2] + -g * k * m + f * -l * m + f * k * n + g * -l * n;

    // ---- J4J3 J4J5 ----
    // # J3 J4 J5

    double []J4J5_vector = new double[]{J[5][0] - J[4][0], J[5][1] - J[4][1], J[5][2] - J[4][2]};
    double []J4J3_vector = new double[]{J[3][0] - J[4][0], J[3][1] - J[4][1], J[3][2] - J[4][2]};

    // ---- R3 ----
    // # J3 J4 J5

    double[] J4J5_J4J3_normal_vector = this.cross(J4J5_vector, J4J3_vector);
    
    double[] ZY_parallel_aligned_vector = new double[]{
      10 * -Math.sin(R[0]),
      10 * Math.cos(R[0]),
      0,
    };
    
    double[] ZY_aligned_J4J3_normal_vector  = this.cross(ZY_parallel_aligned_vector, J4J3_vector);

    R[3] = this.angleBetween(J4J5_J4J3_normal_vector, ZY_parallel_aligned_vector, ZY_aligned_J4J3_normal_vector);

    if (config[2]) // rotate 180 and clamp -180,180
    {
      R[3] += Math.PI;
    }
    R[3] = ((R[3] + 3 * Math.PI) % (2 * Math.PI)) - Math.PI;
    
    // ---- R4 ----
    // # J4 J3 J5

    R[4] += ((config[2]) ? 1 : -1) * this.angleBetween2(J4J5_vector, J4J3_vector);

    // clamp -180,180
    R[4] = ((R[4] + 3 * Math.PI) % (2 * Math.PI)) - Math.PI;


    // ---- R5 ----
    // # J3 J4 J5

    double[] targetVectorY = new double[]{
      -cb * sc,
      ca * cc - sa * sb * sc,
      sa * cc + ca * sb * sc,
    };

    R[5] -= this.angleBetween(J4J5_J4J3_normal_vector, targetVectorY, this.cross(targetVectorZ, targetVectorY));
    
    if (config[2])
    {
      R[5] += Math.PI;
    }
    
    R[5] = ((R[5] + 3 * Math.PI) % (2 * Math.PI)) - Math.PI;

    // --- return angles ---

    //swap joint direction.
    R[1] *= -1;
    R[2] *= -1;
    R[4] *= -1;
    
    return R;
  }

  void calculateTCP(double R0,double R1,double R2,double R3,double R4,double R5,double[] jointsResult) {
    double [][]joints = this.calculateCoordinates(R0, R1, R2, R3, R4, R5);
    jointsResult[0] = joints[5][0];
    jointsResult[1] = joints[5][1];
    jointsResult[2] = joints[5][2];
    jointsResult[3] = joints[5][3];
    jointsResult[4] = joints[5][4];
    jointsResult[5] = joints[5][5];
  }


  /**
   * calculateCoordinates - calculate joint coordinates based on angles
   *
   * @param  {number} R0 angle for joint 0
   * @param  {number} R1 angle for joint 1
   * @param  {number} R2 angle for joint 2
   * @param  {number} R3 angle for joint 3
   * @param  {number} R4 angle for joint 4
   * @param  {number} R5 angle for joint 5
   * @return {Array}    [[x,z,z]...[x,y,z,a,b,c]]
   */
  double[][] calculateCoordinates(double R0,double R1,double R2,double R3,double R4,double R5)
  {
    return calculateCoordinates( R0, R1, R2, R3, R4, R5);
  }
  
  double[][] forward(double[]angles) {
    return forward(
      angles[0],angles[1],angles[2],
      angles[3],angles[4],angles[5]
    );
  }
  double[][] forward(double R0,double R1,double R2,double R3,double R4,double R5) {
    
    //swap joint direction.
    R1 *= -1;
    R2 *= -1;
    R4 *= -1;
    
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
    // double C = 0 // this.geometry[5][0]
    // double D = 0 // this.geometry[5][1]
    // double E = 0 // this.geometry[5][2]

    double [][]jointsResult = new double[6][6];

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

    double [][]M =new double[][]{
      {-B * b * p + B * a * g * k * q + B * a * f * l * q - A * a * g * k * p * u - A * a * f * l * p * u - A * b * q * u - A * a * f * k * v + A * a * g * l * v,
        -A * b * p + A * a * g * k * q + A * a * f * l * q + B * a * g * k * p * u + B * a * f * l * p * u + B * b * q * u + B * a * f * k * v - B * a * g * l * v,
        a * f * k * u - a * g * l * u - a * g * k * p * v - a * f * l * p * v - b * q * v},
      {B * a * p + B * b * g * k * q + B * b * f * l * q - A * b * g * k * p * u - A * b * f * l * p * u + A * a * q * u - A * b * f * k * v + A * b * g * l * v,
        A * a * p + A * b * g * k * q + A * b * f * l * q + B * b * g * k * p * u + B * b * f * l * p * u - B * a * q * u + B * b * f * k * v - B * b * g * l * v,
        b * f * k * u - b * g * l * u - b * g * k * p * v - b * f * l * p * v + a * q * v},
      {B * f * k * q - B * g * l * q - A * f * k * p * u + A * g * l * p * u + A * g * k * v + A * f * l * v,
        A * f * k * q - A * g * l * q + B * f * k * p * u - B * g * l * p * u - B * g * k * v - B * f * l * v,
        -g * k * u - f * l * u - f * k * p * v + g * l * p * v},
    };

    // http://www.staff.city.ac.uk/~sbbh653/publications/euler.pdf

    double _theta = 0;
    double _psi = 0;
    double _phi = 0;
    
    if (M[0][2] < 1) {
      if (M[0][2] > -1) {
        _theta = (double)(Math.asin(M[0][2]));
        _psi = (double)(Math.atan2(-M[1][2], M[2][2]));
        _phi = (double)(Math.atan2(-M[0][1], M[0][0]));
      } else {
        _theta = (double)(-Math.PI / 2);
        _psi = (double)(-Math.atan2(M[1][0], M[1][1]));
        _phi = 0;
      }
    } else {
      _theta = (double)(Math.PI / 2);
      _psi = (double)(Math.atan2(M[1][0], M[1][1]));
      _phi = 0;
    }


    jointsResult[5][3] = _psi;
    jointsResult[5][4] = _theta;
    jointsResult[5][5] = _phi;

    //Euler transfer to HIWIN Robot rotate
    double[] deg = new double[3];
    deg = EulerToStatic(jointsResult[5][3], jointsResult[5][4], jointsResult[5][5]);

    jointsResult[5][3] = deg[0];
    jointsResult[5][4] = deg[1];
    jointsResult[5][5] = deg[2];

    /*if (this.debug) {
      console.log("+++++++++forward KINEMATICS++++++++++")
      console.log(`J0 X ${jointsResult[0][0]} Y ${jointsResult[0][1]} Z ${jointsResult[0][2]}`)
      console.log(`J1 X ${jointsResult[1][0]} Y ${jointsResult[1][1]} Z ${jointsResult[1][2]}`)
      console.log(`J2 X ${jointsResult[2][0]} Y ${jointsResult[2][1]} Z ${jointsResult[2][2]}`)
      console.log(`J4 X ${jointsResult[4][0]} Y ${jointsResult[4][1]} Z ${jointsResult[4][2]}`)
      console.log(`J5 X ${jointsResult[5][0]} Y ${jointsResult[5][1]} Z ${jointsResult[5][2]}`)
      console.log(`J5 A ${jointsResult[5][3]} B ${jointsResult[5][4]} C ${jointsResult[5][5]}`)
      console.log(`---------forward KINEMATICS----------${jointsResult[1][1]}`)
    }*/

    return jointsResult;
  }

  double[] cross(double[]vectorA,double[] vectorB) {
    return new double[]{
      vectorA[1] * vectorB[2] - vectorA[2] * vectorB[1],
      vectorA[2] * vectorB[0] - vectorA[0] * vectorB[2],
      vectorA[0] * vectorB[1] - vectorA[1] * vectorB[0],
    };
  }

  double dot(double[]vectorA,double[] vectorB) {
    return vectorA[0] * vectorB[0] + vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2];
  }

  /**
   * @param  {Array} vectorA         angle from
   * @param  {Array} vectorB         angle to
   * @param  {Array} referenceVector angle to set 0 degree from. coplanar with vecA and vecB
   * @return {number}                 description
   * @example angleBetween([1,0,0],[0,1,0],[0,0,1]) // PI/2
   */
  double angleBetween(double[] vectorA,double[]  vectorB,double[]  referenceVector) {
    // angle = atan2(norm(cross(a, b)), dot(a, b))

    double norm = length3(cross(vectorA, vectorB));

    double angle = (double)Math.atan2(norm, (this.dot(vectorA, vectorB)));

    double tmp = referenceVector[0] * vectorA[0] + referenceVector[1] * vectorA[1] + referenceVector[2] * vectorA[2];

    double sign = (tmp > 0) ? 1.0 : -1.0;

    return angle * sign;
  }

  double angleBetween2(double[] v1,double[]  v2) {
    // turn vectors into unit vectors
    // this.normalize(v1,v1)
    // this.normalize(v2,v2)
    //
    // var angle = Math.acos(this.dot(v1, v2))
    // // if no noticable rotation is available return zero rotation
    // // this way we avoid Cross product artifacts
    // if (Math.abs(angle) < 0.0001) return 0
    // // in this case there are 2 lines on the same axis
    // // // angle = atan2(norm(cross(a, b)), dot(a, b))
    double[] cross = this.cross(v1, v2);

    return Math.atan2(this.length3(cross), this.dot(v1, v2));
  }

  double length3(double[] vector) {
    return (double)Math.sqrt(Math.pow(vector[0], 2) + Math.pow(vector[1], 2) + Math.pow(vector[2], 2));
  }

  double length2(double a,double b) {
    return (double)Math.sqrt(Math.pow(a, 2) + Math.pow(b, 2));
  }

  double[] EulerToStatic(double theta_x, double theta_y, double theta_z)
  {
    double sx = Math.sin(theta_x);
    double sy = Math.sin(theta_y);
    double sz = Math.sin(theta_z);
    double cx = Math.cos(theta_x);
    double cy = Math.cos(theta_y);
    double cz = Math.cos(theta_z);

    double[][] R = {
      { cy * cz,                  -cy * sz,                 sy        },
      { cz * sx * sy + cx * sz,   cx * cz - sx * sy * sz,   -cy * sx  },
      { -cx * cz * sy + sx * sz,  cz * sx + cx * sy * sz,   cx * cy   },
    };

    return new double[]{
      Math.atan2(R[2][1], R[2][2]),
      Math.asin(-R[2][0]),
      Math.atan2(R[1][0], R[0][0]),
    };
  }

  double[] StaticToEuler(double theta_x, double theta_y, double theta_z)
  {
    double sx = Math.sin(theta_x);
    double sy = Math.sin(theta_y);
    double sz = Math.sin(theta_z);
    double cx = Math.cos(theta_x);
    double cy = Math.cos(theta_y);
    double cz = Math.cos(theta_z);

    double [][]R =new double[][]{
      { cy * cz,  cz * sx * sy - cx * sz,   cx * cz * sy + sx * sz  },
      { cy * sz,  cx * cz + sx * sy * sz,   -cz * sx + cx * sy * sz },
      { -sy,      cy * sx,                  cx * cy                 },
    };

    return new double[]{
      Math.atan2(-R[1][2], R[2][2]),
      Math.asin(R[0][2]),
      Math.atan2(-R[0][1], R[0][0]),
    };
  }

  double[] RotationZ(double[] cartesian_position, double theta)
  {
    double ct = Math.cos(theta);
    double st = Math.sin(theta);

    double sx = Math.sin(cartesian_position[3]);
    double sy = Math.sin(cartesian_position[4]);
    double sz = Math.sin(cartesian_position[5]);
    double cx = Math.cos(cartesian_position[3]);
    double cy = Math.cos(cartesian_position[4]);
    double cz = Math.cos(cartesian_position[5]);

    double[][] a = {
      {ct, -st, 0},
      {st, ct, 0},
      {0, 0, 1},
    };

    double[][] b = {
      { cy * cz,  cz * sx * sy - cx * sz,   cx * cz * sy + sx * sz  },
      { cy * sz,  cx * cz + sx * sy * sz,   -cz * sx + cx * sy * sz },
      { -sy,      cy * sx,                  cx * cy                 },
    };

    double[][] R = {
      {0, 0, 0},
      {0, 0, 0},
      {0, 0, 0},
    };
    
    for (int m = 0; m < a.length; m++) {
     for (int p = 0; p < b[0].length; p++) {
      for (int n = 0; n < a[0].length; n++) {
       R[m][p] = R[m][p] + a[m][n] * b[n][p];
      }
     }
    }

    double[] position = {
      (ct * cartesian_position[0]) - (st * cartesian_position[1]),
      (st * cartesian_position[0]) + (ct * cartesian_position[1]),
      cartesian_position[2],
      Math.atan2(R[2][1], R[2][2]),
      Math.asin(-R[2][0]),
      Math.atan2(R[1][0], R[0][0]),
    };
    
    return position;
  }
  
  double[] eulerToVec(double b,double c) {
    double cb = (double)Math.cos(b);
    double sb = (double)Math.sin(b);
    double cc = (double)Math.cos(c);
    double sc = (double)Math.sin(c);
  
    return new double[]{
      cb * cc,
      cb * sc, -sb,
    };
  }

  
  void KinematicsTest(Kinematics kin,double[] targetPose)
  {
    double[] angles = kin.inverse(targetPose);
    double[][] calcPose = kin.forward(angles);
    double[] calcPose5 = calcPose[5];
    DEBUG("targetPose");
    println(targetPose);
    DEBUG("angles=inverse(targetPose)");
    println(angles);
    DEBUG("calcPose5=forward(angles)");
    println(calcPose5);
  }
  
}
