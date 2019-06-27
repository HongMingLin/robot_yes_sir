long nowQmillis=0;
///cue/RG/3all_robots/4home
///cue/RG/3all_robots/4stop

///cue/RG/3movie/4load/xxx.mp4
///cue/RG/3movie/4play
///cue/RG/3movie/4pause
void Q_all_robots(String[] ss) {
  if (ss[4].equals("home")) {
    R_home();
  } else if (ss[4].equals("stop")) {
    STOP_STOP_STOP_ALL();
  }else if (ss[4].equals("go")) {
    
    robotGo();
  }
}
void Q_movie(String[] ss) {
  if (ss[4].equals("load")&&ss.length==6) {
    //loadMovie(ss[5]);
    println("Q_movie..."+ss[5]);

  } else if (ss[4].equals("play")) {
    if (myMovie!=null) {
      myMovie.play();
      //robotGo();
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
      Q_all_robots(ss);
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
