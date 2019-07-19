long nowQmillis=0;
///cue/RG/all_robots/4home
///cue/RG/3all_robots/4stop

///cue/RG/3movie/4load/xxx.mp4
///cue/RG/3movie/4play
///cue/RG/3movie/4pause
void Q_all_robots(String[] ss,String s) {
  u3.send(s,"127.0.0.1",44444);
  
  
}

void loadMovie(String mFile) {
  if (myMovie!=null) {
    myMovie.stop();
    myMovie=null;
  }
  try {
    ///Users/xlinx/Movies/robotTest/Test 11-1.mp4
    mf = new File(System.getProperty("user.home")+"/Movies/"+mFile);
    if (mf.exists()) {
      myMovie=null;
      myMovie = new Movie(this, mf.getAbsolutePath());
      //myMovie.jump(10);
      //myMovie.stop();
      //myMovie.loop();
      //myMovie.pause();
      println("[DECADE][LoadMovie]OK="+mf.toString());
      myMovie.play();
      u3.send("/cue/RG/robots/go","127.0.0.1",44444);
      //myMovie.stop();
      
    } else {
      println("[DECADE][LoadMovie]Not found="+mf.toString());
    }
  }
  catch(Exception e) {
    myMovie=null;
    e.printStackTrace();
  }
}

void Q_movie(String[] ss) {
  if (ss[4].equals("load")&&ss.length==6) {
    loadMovie(ss[5]);


  } else if (ss[4].equals("play")) {
    if (myMovie!=null) {
      myMovie.play();
      
    }
  } else if (ss[4].equals("pause")) {
    if (myMovie!=null)
      myMovie.pause();
  }else if (ss[4].equals("stop")) {
    if (myMovie!=null)
      myMovie.stop();
  }
}

void processCUE(String s) {
  try {
    long nownowQ=millis();
    println("### [Q_RX]"+s+" ,@"+new Date());
    String[] ss=s.split("/");
    if (!ss[2].equals("RG") )return;
    
    if (ss[3].equals("robots")) {
      Q_all_robots(ss,s);
      
    } else if (ss[3].equals("movie")) {
      Q_movie(ss);
    } else {
      println("[Q][ohoh]Unknow Cue=>"+s+", len="+ss.length);
    }
  }catch(Exception e) {
    println("[CMD Exception]="+s);
    e.printStackTrace();
  }
}
