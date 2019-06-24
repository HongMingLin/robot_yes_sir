
/*
TXTCP>>Len=16   [0](00) [1](00) [2](00) [3](00) [4](00) [5Len](06) [6](01) [7](0F) [8](00) [9](00) [10](00) [11](13) [12](03) [13](00) [14](00) [15](80) 
RXTCP>>Len=32   [0](00) [1](00) [2](00) [3](00) [4](00) [5Len](03) [6](01) [7](8F) [8](03) [9](00) [10](00) [11](00) [12](00) [13](00) [14](00) [15](00) [16](00) [17](00) [18](00) [19](00) [20](00) [21](00) [22](00) [23](00) [24](00) [25](00) [26](00) [27](00) [28](00) [29](00) [30](00) [31](00) 





Y 與 M 的 MODBUS 位置
 要用的 功能碼
 0x 
 0x01 Read coil 
 0x05 write single coil
 
 X 的 MODBUS 位置
 要用的 功能碼
 01x 
 0x02 Read discrete input
 
 ControlP5 2.2.6 infos, comments, questions at http://www.sojamo.de/libraries/controlP5
 .TXTCP>>Len=12   [0](00) [1](01) [2](00) [3](00) [4](00) [5](06) [6=ADDR](01) [7Fn](01) [8Saddr](33) [9](00) [10RqLen](00) [11](20) 
 RXTCP>>Len=32   [0](00) [1](01) [2](00) [3](00) [4](00) [5](07) [6Addr](01) [7Fn](01) [8DLen](04) [9](FF) [10](7F) [11](07) [12](00) [13](00) [14](00) [15](00) [16](00) [17](00) [18](00) [19](00) [20](00) [21](00) [22](00) [23](00) [24](00) [25](00) [26](00) [27](00) [28](00) [29](00) [30](00) [31](00) 
 .TXTCP>>Len=12   [0](02) [1](03) [2](00) [3](00) [4](00) [5](06) [6](01) [7](01) [8](33) [9](00) [10](00) [11](20) 
 RXTCP>>Len=32   [0](02) [1](03) [2](00) [3](00) [4](00) [5](07) [6](01) [7](01) [8](04) [9](FF) [10](7F) [11](07) [12](00) [13](00) [14](00) [15](00) [16](00) [17](00) [18](00) [19](00) [20](00) [21](00) [22](00) [23](00) [24](00) [25](00) [26](00) [27](00) [28](00) [29](00) [30](00) [31](00) 

TXTCP>>Len=12   [0](04) [1](05) [2](00) [3](00) [4](00) [5](06) [6](01) [7](01) [8](33) [9](00) [10](00) [11](20) 
RXTCP>>Len=32   [0](04) [1](05) [2](00) [3](00) [4](00) [5](07) [6](01) [7](01) [8](04) [9](FF) [10](7F) [11](07) [12](00) [13](00) [14](00) [15](00) [16](00) [17](00) [18](00) [19](00) [20](00) [21](00) [22](00) [23](00) [24](00) [25](00) [26](00) [27](00) [28](00) [29](00) [30](00) [31](00) 
 
TXTCP>>Len=12   [0](00) [1](03) [2](00) [3](00) [4](00) [5Len](06) [6](01) [7](01) [8](33) [9](00) [10](00) [11](18) 
RXTCP>>Len=32   [0](00) [1](03) [2](00) [3](00) [4](00) [5Len](06) [6](01) [7](01) [8](03) [9](FB) [10](7F) [11](07) [12](00) [13](00) [14](00) [15](00) [16](00) [17](00) [18](00) [19](00) [20](00) [21](00) [22](00) [23](00) [24](00) [25](00) [26](00) [27](00) [28](00) [29](00) [30](00) [31](00) 
 */
int[] X0_X5={13312, 13317};
int[] Y0_Y22={13056, 13074};
int[] M0_M17={0, 17};
int SW_M_START_ADDR=M0_M17[0];
int SW_Y_START_ADDR=Y0_Y22[0];

final HashMap<Integer, IO> X00_05 = new HashMap<Integer, IO>() {
  {
    Integer index=0;
    int offsetStart=13112;
    put(new Integer(index++),new IO("X_2F_12Stop",offsetStart++) );
    put(new Integer(index++),new IO("X_2F_4Stop",offsetStart++) );
    put(new Integer(index++),new IO("X_3F_12Stop",offsetStart++) );
    put(new Integer(index++),new IO("X_3F_4Stop",offsetStart++) );
    put(new Integer(index++),new IO("X_4F_12Stop",offsetStart++) );
    put(new Integer(index++),new IO("X_4F_4Stop",offsetStart++) );
  }
};

final HashMap<Integer, IO> Y00_22 = new HashMap<Integer, IO>() {
  {
    Integer index=0;
    int offsetStart=13056;
    put(new Integer(index++),new IO("Y_2F_RP1",offsetStart++) );
    put(new Integer(index++),new IO("Y_2F_RP2",offsetStart++) );
    put(new Integer(index++),new IO("Y_2F_RP3",offsetStart++) );
    put(new Integer(index++),new IO("Y_2F_RP4",offsetStart++) );
    
    put(new Integer(index++),new IO("Y_3F_RP1",offsetStart++) );
    put(new Integer(index++),new IO("Y_3F_RP2",offsetStart++) );
    put(new Integer(index++),new IO("Y_3F_RP3",offsetStart++) );
    put(new Integer(index++),new IO("Y_3F_RP4",offsetStart++) );
    
    put(new Integer(index++),new IO("Y_4F_RP1",offsetStart++) );
    put(new Integer(index++),new IO("Y_4F_RP2",offsetStart++) );
    put(new Integer(index++),new IO("Y_4F_RP3",offsetStart++) );
    put(new Integer(index++),new IO("Y_4F_RP4",offsetStart++) );
    
    put(new Integer(index++),new IO("Y_2F_Stop",offsetStart++) );
    put(new Integer(index++),new IO("Y_3F_Stop",offsetStart++) );
    put(new Integer(index++),new IO("Y_4F_Stop",offsetStart++) );
    put(new Integer(index++),new IO("null",offsetStart++) );
    
    put(new Integer(index++),new IO("Y_2F_LED",offsetStart++) );
    put(new Integer(index++),new IO("Y_3F_LED",offsetStart++) );
    put(new Integer(index++),new IO("Y_4F_LED",offsetStart++) );
  }
};

final HashMap<Integer, IO> M00_17 = new HashMap<Integer, IO>() {
  {
    Integer index=0;
    int offsetStart=0;
    put(new Integer(index++),new IO("M_2F_RP1",offsetStart++) );
    put(new Integer(index++),new IO("M_2F_RP2",offsetStart++) );
    put(new Integer(index++),new IO("M_2F_RP3",offsetStart++) );
    put(new Integer(index++),new IO("M_2F_RP4",offsetStart++) );
    put(new Integer(index++),new IO("M_2F_Stop",offsetStart++) );
    put(new Integer(index++),new IO("M_2F_LED",offsetStart++) );
    put(new Integer(index++),new IO("M_3F_RP1",offsetStart++) );
    put(new Integer(index++),new IO("M_3F_RP2",offsetStart++) );
    put(new Integer(index++),new IO("M_3F_RP3",offsetStart++) );
    put(new Integer(index++),new IO("M_3F_RP4",offsetStart++) );
    put(new Integer(index++),new IO("M_3F_Stop",offsetStart++) );
    put(new Integer(index++),new IO("M_3F_LED",offsetStart++) );
    put(new Integer(index++),new IO("M_4F_RP1",offsetStart++) );
    put(new Integer(index++),new IO("M_4F_RP2",offsetStart++) );
    put(new Integer(index++),new IO("M_4F_RP3",offsetStart++) );
    put(new Integer(index++),new IO("M_4F_RP4",offsetStart++) );
    put(new Integer(index++),new IO("M_4F_Stop",offsetStart++) );
    put(new Integer(index++),new IO("M_4F_LED",offsetStart++) );
  }
};


class IO {
  String name;
  boolean on_off=false;
  int memoryOffset=0;
  IO(String s,int o) {
    name=s;
    memoryOffset=o;
  }
}
