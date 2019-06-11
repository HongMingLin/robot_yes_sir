void keyPressed() {
  switch(key) {
  case 'M':
  case 'm':
    ALLMODE=ALLMODE.next();
    break;
  case 'R':
    if (videoExport==null&&recording==false) {
      videoFilename=SDF.format(new java.util.Date())+".mp4";
      videoExport = new VideoExport(this, videoFilename);
      videoExport.startMovie();
      recording = true;
      println("videoFilename="+videoFilename);
      println("Recording is " + (recording ? "RECing" : "PAUSE"));
    } else {
      recording=false;
      videoExport.endMovie();
      videoExport=null;
    }
    recording = !recording;
    println("Recording is " + (recording ? "RECing" : "PAUSE"));
    break;
  case 'q':
    videoExport.endMovie();
    videoExport=null;
    break;
  case '1':

    break;
  }
}
