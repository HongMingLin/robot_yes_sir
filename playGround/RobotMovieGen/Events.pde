void keyPressed() {
  switch(key) {
  case 'M':
  case 'm':
    ALLMODE=ALLMODE.next();
    break;
  case 'R':
    if (videoExport==null) {
      videoFilename=SDF.format(new java.util.Date())+".mp4";
      videoExport = new VideoExport(this, videoFilename);
      videoExport.startMovie();
      println("videoFilename="+videoFilename);
    }
    recording = !recording;
    println("Recording is " + (recording ? "RECing" : "PAUSE"));
  case 'q':
    videoExport.endMovie();
    videoExport=null;
    break;
  case '1':

    break;
  }
}
