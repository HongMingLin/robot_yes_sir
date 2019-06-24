StringBuffer tsb = new StringBuffer("");
boolean log = true;
static boolean ALLLOG = false;
StringBuffer logSB = new StringBuffer("");
public static boolean[] concat(boolean[] a, boolean[] b) {
  boolean[] c = new boolean[a.length + b.length];
  System.arraycopy(a, 0, c, 0, a.length);
  System.arraycopy(b, 0, c, a.length, b.length);
  return c;
}
public static byte[] concat(byte[] a, byte[] b) {
  byte[] c = new byte[a.length + b.length];
  System.arraycopy(a, 0, c, 0, a.length);
  System.arraycopy(b, 0, c, a.length, b.length);
  return c;
}
private void log(Thread o, String out) {
  if (log) {
    logSB.append(new java.text.SimpleDateFormat("yy-MM-dd HH:mm:ss.S").format(new java.util.Date()));

    System.out.println(logSB.append(out).toString());
  }
}

static  public float absValue(PVector p2) {

  return sqrt(sq(p2.x) + sq(p2.y) + sq(p2.z));
}

static  public float dist(PVector p1, PVector p2) {

  return sqrt(sq(p2.x - p1.x) + sq(p2.y - p1.y) + sq(p2.z - p1.z));
}

float distx(float x1, float y1, float z1, float x2, float y2, float z2) {
  return sqrt(sq(x2 - x1) + sq(y2 - y1) + sq(z2 - z1));
}


private static boolean getBitBoolean(byte[] data, int pos) {
      int posByte = pos/8; 
      int posBit = pos%8;
      byte valByte = data[posByte];
      int valInt = valByte>>(8-(posBit+1)) & 0x0001;
      return valInt==0?false:true;
   }


String hex(byte[] value) {
  String s = "";
  for (int i = 0; i < value.length; i++)
    s += hex(value[i], 2) + " ";
  return s.trim();
}

String hexx(byte value) {
  return hex(value, 2);
}

String hexx(char value) {
  return hex(value, 4);
}

String hexx(int value) {
  return hex(value, 8);
}

String hexx(int value, int digits) {
  String stuff = Integer.toHexString(value).toUpperCase();
  if (digits > 8) {
    digits = 8;
  }

  int length = stuff.length();
  if (length > digits) {
    return stuff.substring(length - digits);
  } else if (length < digits) {
    return "00000000".substring(8 - (digits - length)) + stuff;
  }
  return stuff;
}



String binaryx(byte value) {
  return binary(value, 8);
}

String binaryx(char value) {
  return binary(value, 16);
}

String binaryx(int value) {
  return binary(value, 32);
}

String binaryx(int value, int digits) {
  String stuff = Integer.toBinaryString(value);
  if (digits > 32) {
    digits = 32;
  }

  int length = stuff.length();
  if (length > digits) {
    return stuff.substring(length - digits);
  } else if (length < digits) {
    int offset = 32 - (digits - length);
    return "00000000000000000000000000000000".substring(offset) + stuff;
  }
  return stuff;
}

int unbinaryx(String value) {
  return Integer.parseInt(value, 2);
}

int destLED = 0;

public static float valueApproach(float nowVal, float destVal, float speed) { // speed=0-1
  return (float) ((nowVal * (1.0 - speed)) + (destVal * speed));
}

public static float valueApproach2(float nowVal, float destVal, float speed) { // speed=0-1
  // return (nowVal*(1-speed)) + ( destVal*speed );
  if (Math.abs(nowVal - destVal) <= speed)
    return destVal;
  if (nowVal > destVal)
    return nowVal -= speed;

  return nowVal += speed;
}

long getFileSize(String filename) {
  File file = new File(filename);
  if (!file.exists() || !file.isFile()) {
    System.out.println("File doesn\'t exist");
    return -1;
  }
  return file.length();
}

boolean overRect(int mouseX, int mouseY, int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height) {
    return true;
  } else {
    return false;
  }
}

java.text.NumberFormat int_nf;
int int_nf_digits;
boolean int_nf_commas;

String[] nfx(int num[], int digits) {
  String formatted[] = new String[num.length];
  for (int i = 0; i < formatted.length; i++) {
    formatted[i] = nfx(num[i], digits);
  }
  return formatted;
}

String nfx(String num, int digits) {
  return nfx(Integer.parseInt(num), digits);
}

String nfx(int num, int digits) {
  if ((int_nf != null) && (int_nf_digits == digits) && !int_nf_commas) {
    return int_nf.format(num);
  }

  int_nf = java.text.NumberFormat.getInstance();
  int_nf.setGroupingUsed(false); // no commas
  int_nf_commas = false;
  int_nf.setMinimumIntegerDigits(digits);
  int_nf_digits = digits;
  return int_nf.format(num);
}

boolean overCircle(int mouseX, int mouseY, float x, float y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (Math.sqrt((disX * disX) + (disY * disY)) < diameter / 2) {
    return true;
  } else {
    return false;
  }
}

static int whichSplitInt(String[] arr, String index, int offset) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i].equals(index)) {
      if ((i + offset) < arr.length)
        return Integer.parseInt(arr[i + offset].trim());
    }
  }
  return (Integer) null;
}

static String whichSplit(String[] arr, String index, int offset) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i].equals(index)) {
      if ((i + offset) < arr.length)
        return arr[i + offset].trim();
    }
  }
  return null;
}

//  byte[] printBB(MachineLists mList, String header, int commandSize, byte[] bb) {
//
//    if (!xlinx.whichLOGShowSet.contains(mList)) {
//      System.out.print(mList.toString() + "_CmdQ=" + commandSize + ":");
//      System.out.print(header + " \t");
//      for (int i = 0; i < bb.length; i++)
//        System.out.print("[" + (i) + "](" + hex(bb[i]) + ") ");
//      System.out.println();
//    }
//    return bb;
//  }
void hashmapYWalker(HashMap<Integer, IO> map) {
  java.util.Iterator iter = map.entrySet().iterator(); 
  int index=1;
  String ss="";
  while (iter.hasNext()) { 
    java.util.Map.Entry entry = (java.util.Map.Entry) iter.next(); 
    int key = (int)entry.getKey(); 
    IO val = (IO)entry.getValue();
    ss+=key+"."+val.name+"="+(val.on_off?"1 ":"0 ");
    toggles[key].setValue(val.on_off);
    //print(ss);
  }
  YNamestr=ss;
}

void hashmapWalker(HashMap map) {
  java.util.Iterator iter = map.entrySet().iterator(); 
  int index=1;
  while (iter.hasNext()) { 
    java.util.Map.Entry entry = (java.util.Map.Entry) iter.next(); 
    String key = (String)entry.getKey(); 
    Object val = entry.getValue();
    println(index+++">"+key);
  }
}
byte[] setBit(byte[] data, int pos, boolean val) {
  int posByte = pos/8; 
  int posBit = pos%8;

  byte mask = (byte)(1 << posBit);
  if (val)
    data[posByte] |= mask;
  else
    data[posByte] &= ~mask;
  return data;
}
public static void getColorFromInt(int i) {
  int B_MASK = 255;
  int G_MASK = 255 << 8;
  int R_MASK = 255 << 16;
  int r = (i & R_MASK) >> 16;
  int g = (i & G_MASK) >> 8;
  int b = i & B_MASK;
  System.err.println("r:" + r + " g:" + g + " b:" + b);

  // return color(r,g,b);
}
byte[] printBBb(boolean print, String header, byte[] bb) {
  printBBs(print, header, bb);
  return bb;
}
String printBBs(boolean b, String header, byte[] bb) {
  tsb.setLength(0);
  tsb.append(header + ">>Len=" + bb.length +" \t");
  for (int i = 0; i < bb.length; i++)
    tsb.append("[" + (i)+(i==5?"Len":"") + "](" + hex(bb[i]) + ") ");
  if (b)
    System.out.println(tsb.toString());
  return tsb.toString();
}
byte[] Arr_Arr(byte[] a, byte[] b) {
  byte[] result = new byte[a.length + b.length]; 
  //System.arraycopy(來源, 起始索引, 目的, 起始索引, 複製長度)
  System.arraycopy(a, 0, result, 0, a.length); 
  System.arraycopy(b, 0, result, a.length, b.length); 
  return result;
} 
