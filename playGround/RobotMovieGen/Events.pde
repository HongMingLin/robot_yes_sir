void mouseWheel(MouseEvent event) {
  //float e = event.getCount();
  for (int i=0; i<gbBoxs.length; i++)
    gbBoxs[i].handleMouseEvent(event);
}
void mousePressed() {
  if (mouseButton == LEFT) {
    
  } else if (mouseButton == RIGHT) {
    ALLMODE=ALLMODE.next();
  } else {
    
  }
}
void keyPressed() {
  switch(key) {
    case '+':
    circleTime+=500;
    println("circleTime="+circleTime);
    break;
    case '-':
    if(circleTime>6000)
    circleTime-=500;
    
    println("circleTime="+circleTime);
    break;
  case 'M':
  case 'm':
    ALLMODE=ALLMODE.next();
    break;
  case 'R':
    if (videoExport==null) {
      videoFilename=SDF.format(new java.util.Date())+".mp4";
      videoExport = new VideoExport(this, videoFilename);
      videoExport.startMovie();
      //recording = true;
      println("videoFilename="+videoFilename);
      
    } else {
      //recording=false;
      videoExport.endMovie();
      videoExport=null;
      
    }
    //recording = !recording;
    println("Recording is " + (videoExport!=null ? "RECing" : "PAUSE"));
    break;
  case 'q':
    
    break;
  case '1':

    break;
  }
}
