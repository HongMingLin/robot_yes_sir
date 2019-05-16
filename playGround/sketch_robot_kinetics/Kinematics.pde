
//translate the js code from https://github.com/glumb/kinematics
class Kinematics {
  /**
   * @param {Array} geometry [5][3] Array including geometry information [x,y,z]
   */
  boolean debug=false;
  float sq(float num){return num*num;}
  float [][]geometry;
  float [][]J_initial_absolute;
  float []R_corrected;
  float V1_length_x_y;
  float V4_length_x_y_z;
  Kinematics(float [][]geometry) {
    if (geometry.length != 5) {
      throw new Error("geometry array must have 5 entries");
    }

    if (geometry[3][1] != 0 || geometry[3][2] != 0 || geometry[4][0] != 0 || geometry[4][2] != 0) {
      throw new Error("geometry 3 and 4 must be one dimensional geo[3] = [a,0,0] geo[4] = [0,b,0]");
    }

    this.V1_length_x_y = (float)Math.hypot((geometry[1][0] ) , (geometry[1][1]));
    this.V4_length_x_y_z = (float)Math.sqrt( (geometry[4][0] *geometry[4][0] ) + (geometry[4][1] *geometry[4][1]) + (geometry[4][2] *geometry[4][2]));

    this.geometry = geometry;

    float [] tmpPos = new float[]{0, 0, 0};
    J_initial_absolute=new float[geometry.length][];
    
    for (int i = 0; i < geometry.length; i++) {
      J_initial_absolute[i]=new float[3];
      J_initial_absolute[i][0]=tmpPos[0];
      J_initial_absolute[i][1]=tmpPos[1];
      J_initial_absolute[i][2]=tmpPos[2];
      
      tmpPos[0] += geometry[i][0];
      tmpPos[1] += geometry[i][1];
      tmpPos[2] += geometry[i][2];
    }

    R_corrected=new float[6];

    this.R_corrected[1] -= Math.PI / 2;
    this.R_corrected[1] += Math.atan2(geometry[1][0], geometry[1][1]); // correct offset bone

    this.R_corrected[2] -= Math.PI / 2;
    this.R_corrected[2] -= Math.atan2((geometry[2][1] + geometry[3][1]), (geometry[2][0] + geometry[3][0])); // correct offset bone V2,V3
    this.R_corrected[2] -= Math.atan2(geometry[1][0], geometry[1][1]); // correct bone offset of V1

    this.R_corrected[4] += Math.atan2(geometry[4][1], geometry[4][0]);
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
   
  float[] inverse(float []cord_abc) {
    return inverse(
    cord_abc[0],cord_abc[1],cord_abc[2],
    cord_abc[3],cord_abc[4],cord_abc[5]);
  }
   
  float[] inverse(float x,float y,float z,float a,float b,float c) {
    /*if (this.debug) {
      console.log(x, y, z, a, b, c)
    }*/

    float ca = (float)Math.cos(a);
    float sa = (float)Math.sin(a);
    float cb = (float)Math.cos(b);
    float sb = (float)Math.sin(b);
    float cc = (float)Math.cos(c);
    float sc = (float)Math.sin(c);

    float[] targetVectorX = new float[]{
      cb * cc,
      cb * sc, -sb,
    };

    float[] R = new float[]{
      this.R_corrected[0],
      this.R_corrected[1],
      this.R_corrected[2],
      this.R_corrected[3],
      this.R_corrected[4],
      this.R_corrected[5],
    };

    float[][] J  = new float[][]{
      new float[]{0, 0, 0},
      new float[]{0, 0, 0},
      new float[]{0, 0, 0},
      new float[]{0, 0, 0},
      new float[]{0, 0, 0},
      new float[]{0, 0, 0}
    };

    // ---- J5 ----

    J[5][0] = x;
    J[5][1] = y;
    J[5][2] = z;


    // ---- J4 ----
    // vector

    J[4][0] = x - this.V4_length_x_y_z * targetVectorX[0];
    J[4][1] = y - this.V4_length_x_y_z * targetVectorX[1];
    J[4][2] = z - this.V4_length_x_y_z * targetVectorX[2];


    // ---- R0 ----
    // # J4

    R[0] += (float)(Math.PI / 2 - Math.acos(this.J_initial_absolute[4][2] / length2(J[4][2], J[4][0])));
    R[0] += (float)(Math.atan2(-J[4][2], J[4][0]));
    
    if (this.J_initial_absolute[4][2] > length2(J[4][2], J[4][0]) && this.debug) {
      println("out of reach");
    }

    // ---- J1 ----
    // # R0

    J[1][0] = (float)(Math.cos(R[0]) * this.geometry[0][0] + Math.sin(R[0]) * this.geometry[0][2]);
    J[1][1] = (float)(this.geometry[0][1]);
    J[1][2] = (float)(-Math.sin(R[0]) * this.geometry[0][0] + Math.cos(R[0]) * this.geometry[0][2]);


    // ---- rotate J4 into x,y plane ----
    // # J4 R0

    float []J4_x_y = new float[]{
      (float)(Math.cos(R[0]) * J[4][0] + -Math.sin(R[0]) * J[4][2]),
      (float)(J[4][1]),
      (float)(Math.sin(R[0]) * J[4][0] + Math.cos(R[0]) * J[4][2])
    };


    // ---- J1J4_projected_length_square ----
    // # J4 R0

    float J1J4_projected_length_square = (sq(J4_x_y[0] - this.J_initial_absolute[1][0])) + (sq(J4_x_y[1] - this.J_initial_absolute[1][1])); // not using Math.sqrt

    // ---- R2 ----
    // # J4 R0

    float J2J4_length_x_y = length2(this.geometry[2][0] + this.geometry[3][0], this.geometry[2][1] + this.geometry[3][1]);
    R[2] += (float)Math.acos((-J1J4_projected_length_square + sq(J2J4_length_x_y) + sq(this.V1_length_x_y)) / (2.0 * (J2J4_length_x_y) * this.V1_length_x_y));

    // ---- R1 ----
    // # J4 R0

    float J1J4_projected_length = (float)Math.sqrt(J1J4_projected_length_square);
    R[1] += Math.atan2((J4_x_y[1] - this.J_initial_absolute[1][1]), (J4_x_y[0] - this.J_initial_absolute[1][0]));
    R[1] += Math.acos((+J1J4_projected_length_square - sq(J2J4_length_x_y) + sq(this.V1_length_x_y)) / (2.0 * J1J4_projected_length * this.V1_length_x_y));

    // ---- J2 ----
    // # R1 R0

    float ta = (float)Math.cos(R[0]);
    float tb = (float)Math.sin(R[0]);
    float tc = this.geometry[0][0];
    float d = this.geometry[0][1];
    float e = this.geometry[0][2];
    float f = (float)Math.cos(R[1]);
    float g = (float)Math.sin(R[1]);
    float h = this.geometry[1][0];
    float i = this.geometry[1][1];
    float j = this.geometry[1][2];
    float k = (float)Math.cos(R[2]);
    float l = (float)Math.sin(R[2]);
    float m = this.geometry[2][0];
    float n = this.geometry[2][1];
    float o = this.geometry[2][2];

    J[2][0] = ta * tc + tb * e + ta * f * h - ta * g * i + tb * j;
    J[2][1] = d + g * h + f * i;
    J[2][2] = -tb * tc + ta * e - tb * f * h + tb * g * i + ta * j;

    // ---- J3 ----
    // # R0 R1 R2

    J[3][0] = ta * tc + tb * e + ta * f * h - ta * g * i + tb * j + ta * f * k * m - ta * g * l * m - ta * g * k * n - ta * f * l * n + tb * o;
    J[3][1] = d + g * h + f * i + g * k * m + f * l * m + f * k * n - g * l * n;
    J[3][2] = -tb * tc + ta * e - tb * f * h + tb * g * i + ta * j - tb * f * k * m + tb * g * l * m + tb * g * k * n + tb * f * l * n + ta * o;

    // ---- J4J3 J4J5 ----
    // # J3 J4 J5

    float []J4J5_vector = new float[]{J[5][0] - J[4][0], J[5][1] - J[4][1], J[5][2] - J[4][2]};
    float []J4J3_vector = new float[]{J[3][0] - J[4][0], J[3][1] - J[4][1], J[3][2] - J[4][2]};

    // ---- R3 ----
    // # J3 J4 J5

    float[] J4J5_J4J3_normal_vector = cross(J4J5_vector, J4J3_vector);
    float[] XZ_parallel_aligned_vector = new float[]{
      (float)(10 * Math.cos(R[0] + (Math.PI / 2))),
      0, (float)(-10 * Math.sin(R[0] + (Math.PI / 2))),
    };

    float[] reference = cross(XZ_parallel_aligned_vector, J4J3_vector);

    R[3] = angleBetween(J4J5_J4J3_normal_vector, XZ_parallel_aligned_vector, reference);

    // ---- R4 ----
    // # J4 J3 J5

    float []referenceVector = cross(J4J3_vector, J4J5_J4J3_normal_vector);

    R[4] += angleBetween(J4J5_vector, J4J3_vector, referenceVector);

    // ---- R5 ----
    // # J3 J4 J5

    float[] targetVectorY = new float[]{
      sa * sb * cc - sc * ca,
      sa * sb * sc + cc * ca,
      sa * cb,
    };

    R[5] += Math.PI / 2;
    R[5] -= angleBetween(J4J5_J4J3_normal_vector, targetVectorY, cross(targetVectorY, targetVectorX));

    // --- return angles ---
    return R;
  }

  void calculateTCP(float R0,float R1,float R2,float R3,float R4,float R5,float[] jointsResult) {
    float [][]joints = this.calculateCoordinates(R0, R1, R2, R3, R4, R5);
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
  float[][] calculateCoordinates(float R0,float R1,float R2,float R3,float R4,float R5)
  {
    return calculateCoordinates( R0, R1, R2, R3, R4, R5);
  }
  
  float[][] forward(float[]angles) {
    return forward(
      angles[0],angles[1],angles[2],
      angles[3],angles[4],angles[5]
    );
  }
  float[][] forward(float R0,float R1,float R2,float R3,float R4,float R5) {
    float a = (float)Math.cos(R0);
    float b = (float)Math.sin(R0);
    float c = this.geometry[0][0];
    float d = this.geometry[0][1];
    float e = this.geometry[0][2];
    float f = (float)Math.cos(R1);
    float g = (float)Math.sin(R1);
    float h = this.geometry[1][0];
    float i = this.geometry[1][1];
    float j = this.geometry[1][2];
    float k = (float)Math.cos(R2);
    float l = (float)Math.sin(R2);
    float m = this.geometry[2][0];
    float n = this.geometry[2][1];
    float o = this.geometry[2][2];
    float p = (float)Math.cos(R3);
    float q = (float)Math.sin(R3);
    float r = this.geometry[3][0];
    float s = this.geometry[3][1];
    float t = this.geometry[3][2];
    float u = (float)Math.cos(R4);
    float v = (float)Math.sin(R4);
    float w = this.geometry[4][0];
    float x = this.geometry[4][1];
    float y = this.geometry[4][2];
    float A = (float)Math.cos(R5);
    float B = (float)Math.sin(R5);
    // float C = 0 // this.geometry[5][0]
    // float D = 0 // this.geometry[5][1]
    // float E = 0 // this.geometry[5][2]

    float [][]jointsResult = new float[6][6];

    jointsResult[0][0] = 0;
    jointsResult[0][1] = 0;
    jointsResult[0][2] = 0;

    jointsResult[1][0] = jointsResult[0][0] + a * c + b * e;
    jointsResult[1][1] = jointsResult[0][1] + d;
    jointsResult[1][2] = jointsResult[0][2] + -b * c + a * e;

    jointsResult[2][0] = jointsResult[1][0] + a * f * h - a * g * i + b * j;
    jointsResult[2][1] = jointsResult[1][1] + g * h + f * i;
    jointsResult[2][2] = jointsResult[1][2] - b * f * h + b * g * i + a * j;

    jointsResult[3][0] = jointsResult[2][0] + a * f * k * m - a * g * l * m - a * g * k * n - a * f * l * n + b * o;
    jointsResult[3][1] = jointsResult[2][1] + g * k * m + f * l * m + f * k * n - g * l * n;
    jointsResult[3][2] = jointsResult[2][2] - b * f * k * m + b * g * l * m + b * g * k * n + b * f * l * n + a * o;

    jointsResult[4][0] = jointsResult[3][0] + a * f * k * r - a * g * l * r - a * g * k * p * s - a * f * l * p * s + b * q * s + b * p * t + a * g * k * q * t + a * f * l * q * t;
    jointsResult[4][1] = jointsResult[3][1] + g * k * r + f * l * r + f * k * p * s - g * l * p * s - f * k * q * t + g * l * q * t;
    jointsResult[4][2] = jointsResult[3][2] - b * f * k * r + b * g * l * r + b * g * k * p * s + b * f * l * p * s + a * q * s + a * p * t - b * g * k * q * t - b * f * l * q * t;

    jointsResult[5][0] = jointsResult[4][0] + a * f * k * u * w - a * g * l * u * w - a * g * k * p * v * w - a * f * l * p * v * w + b * q * v * w - a * g * k * p * u * x - a * f * l * p * u * x + b * q * u * x - a * f * k * v * x + a * g * l * v * x + b * p * y + a * g * k * q * y + a * f * l * q * y;
    jointsResult[5][1] = jointsResult[4][1] + g * k * u * w + f * l * u * w + f * k * p * v * w - g * l * p * v * w + f * k * p * u * x - g * l * p * u * x - g * k * v * x - f * l * v * x - f * k * q * y + g * l * q * y;
    jointsResult[5][2] = jointsResult[4][2] - b * f * k * u * w + b * g * l * u * w + b * g * k * p * v * w + b * f * l * p * v * w + a * q * v * w + b * g * k * p * u * x + b * f * l * p * u * x + a * q * u * x + b * f * k * v * x - b * g * l * v * x + a * p * y - b * g * k * q * y - b * f * l * q * y;

    float [][]M =new float[][]{
      {a * g * k * p * u + a * f * l * p * u - b * q * u + a * f * k * v - a * g * l * v,
        -B * b * p - B * a * g * k * q - B * a * f * l * q + A * a * f * k * u - A * a * g * l * u - A * a * g * k * p * v - A * a * f * l * p * v + A * b * q * v,
        A * b * p + A * a * g * k * q + A * a * f * l * q + B * a * f * k * u - B * a * g * l * u - B * a * g * k * p * v - B * a * f * l * p * v + B * b * q * v},
      {-f * k * p * u + g * l * p * u + g * k * v + f * l * v,
        B * f * k * q - B * g * l * q + A * g * k * u + A * f * l * u + A * f * k * p * v - A * g * l * p * v,
        -A * f * k * q + A * g * l * q + B * g * k * u + B * f * l * u + B * f * k * p * v - B * g * l * p * v},
      {-b * g * k * p * u - b * f * l * p * u - a * q * u - b * f * k * v + b * g * l * v,
        -B * a * p + B * b * g * k * q + B * b * f * l * q - A * b * f * k * u + A * b * g * l * u + A * b * g * k * p * v + A * b * f * l * p * v + A * a * q * v,
        A * a * p - A * b * g * k * q - A * b * f * l * q - B * b * f * k * u + B * b * g * l * u + B * b * g * k * p * v + B * b * f * l * p * v + B * a * q * v},
    };

    // http://www.staff.city.ac.uk/~sbbh653/publications/euler.pdf

    float _theta = 0;
    float _psi = 0;
    float _phi = 0;
    if (M[2][0] != 1 || M[2][0] != -1) {
      _theta = (float)(Math.PI + Math.asin(M[2][0]));
      _psi = (float)(Math.atan2(M[2][1] / Math.cos(_theta), M[2][2] / Math.cos(_theta)));
      _phi = (float)(Math.atan2(M[1][0] / Math.cos(_theta), M[0][0] / Math.cos(_theta)));
    } else {
      _phi = 0; // anything; can set to
      if (M[2][0] == -1) {
        _theta = (float)(Math.PI / 2);
        _psi = (float)(_phi + Math.atan2(M[0][1], M[0][2]));
      } else {
        _theta = (float)(-Math.PI / 2);
        _psi = (float)(-_phi + Math.atan2(-M[0][1], -M[0][2]));
      }
    }

    jointsResult[5][3] = _psi;
    jointsResult[5][4] = _theta;
    jointsResult[5][5] = _phi;

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

  float[] cross(float[]vectorA,float[] vectorB) {
    return new float[]{
      vectorA[1] * vectorB[2] - vectorA[2] * vectorB[1],
      vectorA[2] * vectorB[0] - vectorA[0] * vectorB[2],
      vectorA[0] * vectorB[1] - vectorA[1] * vectorB[0],
    };
  }

  float dot(float[]vectorA,float[] vectorB) {
    return vectorA[0] * vectorB[0] + vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2];
  }

  /**
   * @param  {Array} vectorA         angle from
   * @param  {Array} vectorB         angle to
   * @param  {Array} referenceVector angle to set 0 degree from. coplanar with vecA and vecB
   * @return {number}                 description
   * @example angleBetween([1,0,0],[0,1,0],[0,0,1]) // PI/2
   */
  float angleBetween(float[] vectorA,float[]  vectorB,float[]  referenceVector) {
    // angle = atan2(norm(cross(a, b)), dot(a, b))

    float norm = length3(cross(vectorA, vectorB));

    float angle = (float)Math.atan2(norm, (this.dot(vectorA, vectorB)));

    float tmp = referenceVector[0] * vectorA[0] + referenceVector[1] * vectorA[1] + referenceVector[2] * vectorA[2];

    float sign = (tmp > 0) ? 1.0 : -1.0;

    return angle * sign;
  }

  float length3(float[] vector) {
    return (float)Math.sqrt(sq(vector[0] ) +sq(vector[1]) + sq(vector[2]));
  }

  float length2(float a,float b) {
    return (float)Math.sqrt(sq(a) + sq(b));
  }
  
  float[] eulerToVec(float b,float c) {
    float cb = (float)Math.cos(b);
    float sb = (float)Math.sin(b);
    float cc = (float)Math.cos(c);
    float sc = (float)Math.sin(c);
  
    return new float[]{
      cb * cc,
      cb * sc, -sb,
    };
  }

  
  void KinematicsTest(Kinematics kin,float[] targetPose)
  {
    float[] angles = kin.inverse(targetPose);
    float[][] calcPose = kin.forward(angles);
    float[] calcPose5 = calcPose[5];
    println("targetPose");
    println(targetPose);
    println("angles=inverse(targetPose)");
    println(angles);
    println("calcPose5=forward(angles)");
    println(calcPose5);
  }
  
}
