import java.net.*;
import java.io.*;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.text.SimpleDateFormat;

import processing.core.*;

public class UDP implements Runnable {
  
  
  // the current unicast/multicast datagram socket
  DatagramSocket ucSocket    = null;
  MulticastSocket mcSocket  = null;
  
  boolean log      = false;  // enable/disable output log
  boolean listen    = false;  // true, if the socket waits for packets
  int timeout      = 0;    // reception timeout > 0=infinite timeout
  int size      = 65507;  // the socket buffer size in bytes
  InetAddress group  = null;    // the multicast's group address to join
  
  // the reception Thread > wait automatically for incoming datagram packets
  // without blocking the current Thread.
  Thread thread    = null;
  
  // the parent object (could be an application, a componant, etc...)
  Object owner    = null;
  
   String receiveHandler    = "receive";
  String timeoutHandler    = "timeout";
  
   String header    = "";
  
  ///////////////////////////////// fields ///////////////////////////////
  
  /**
   * The default socket buffer length in bytes.
   */
  public static final int BUFFER_SIZE = 65507;
  
  
  ///////////////////////////// constructors ////////////////////////////
  
  /**
   * Create a new datagram socket and binds it to an available port and every 
   * address on the local host machine.
   *
   * @param owner  the target object to be call by the receive handler
   */
  public UDP( Object owner ) {
    this( owner, 0 );
  }
  
  /**
   * Create a new datagram socket and binds it to the specified port on the 
   * local host machine.
   * <p>
   * Pass <code>zero</code> as port number, will let the system choose an 
   * available port.
   *
   * @param owner  the target object to be call by the receive handler
   * @param port  local port to bind
   */
  public UDP( Object owner, int port ) {
    this( owner, port, null );
  }
  public UDP( Object owner, int port,int delay ) {
    this( owner, port, null );
  }
  
  public UDP( Object owner, int port, String ip ) {
    
    this.owner = owner;
    
    // register this object to the PApplet, 
    // if it's used with Processing
    try {
      if ( owner instanceof PApplet ) ((PApplet)owner).registerMethod("dispose", this);
    }
    catch( NoClassDefFoundError e ) {;}
    
    // open a new socket to the specified port/address
    // and join the group if the multicast socket is required
    try {
      
      InetAddress addr = InetAddress.getByName(ip);
      InetAddress host = (ip==null) ? (InetAddress)null: addr;
      
      if ( !addr.isMulticastAddress() ) {
        ucSocket = new DatagramSocket( port, host );  // as broadcast
        log( "bound socket to host:"+address()+", port: "+port() );
      }
      else {              
        mcSocket = new MulticastSocket( port );      // as multicast
        mcSocket.joinGroup( addr );
        this.group = addr;
        log( "bound multicast socket to host:"+address()+
           ", port: "+port()+", group:"+group );
      }
    }
    catch( IOException e ) { 
      // caught SocketException & UnknownHostException
      error( "opening socket failed!"+
           "\n\t> address:"+ip+", port:"+port+" [group:"+group+"]"+
           "\n\t> "+e.getMessage()
        ); 
    }
    catch( IllegalArgumentException e ) { 
      error( "opening socket failed!"+
           "\n\t> bad arguments: "+e.getMessage()
           );
    }
    catch( SecurityException e ) {
      error( (isMulticast()?"could not joined the group":"warning")+
          "\n\t> "+e.getMessage()  );
    }
    
  }
  
  /////////////////////////////// methods ///////////////////////////////
  
  /** 
   * Close the socket. This method is automatically called by Processing when 
   * the PApplet shuts down.
   *
   * @see UDP#close()
   */
  public void dispose() {
    close();
  }
  
  /**
   * Close the actuel datagram socket and all associate resources.
   */
  public void close() {
    if ( isClosed() ) return;
    
    int port  = port();
    String ip  = address();
    
    // stop listening if needed
    //listen( false );
    
    // close the socket
    try {
      if ( isMulticast() ) {
        if ( group!=null ) {
          mcSocket.leaveGroup( group );
          log( "leave group < address:"+group+" >" );
        }
        mcSocket.close();
        mcSocket = null;
      }
      else {
        ucSocket.close();
        ucSocket = null;
      }
    }
    catch( IOException e ) {
      error( "Error while closing the socket!\n\t> " + e.getMessage() ); 
    }
    catch( SecurityException e ) {;}
    finally {
      log( "close socket < port:"+port+", address:"+ip+" >\n" );
    }
  }
  
  /**
   * Returns whether the current socket is closed or not.
   * @return boolean
   **/
  public boolean isClosed() {
    if ( isMulticast() ) return mcSocket==null ? true : mcSocket.isClosed();
    return ucSocket==null ? true : ucSocket.isClosed();
  }
  
  /**
   * Return the actual socket's local port, or -1 if the socket is closed.
   * @return int
   */
  public int port() {
    if ( isClosed() ) return -1;
    return isMulticast()? mcSocket.getLocalPort() : ucSocket.getLocalPort();
  }
  
  /**
   * Return the actual socket's local address, or <code>null</code> if the 
   * address correspond to any local address.
   *
   * @return String
   */
  public String address() {
    if ( isClosed() ) return null;
    
    InetAddress laddr = isMulticast() ? mcSocket.getLocalAddress(): 
                      ucSocket.getLocalAddress();
    return laddr.isAnyLocalAddress() ? null : laddr.getHostAddress();
  }
  
  /**
   * Send message to the current socket. Explicitly, send message to the 
   * multicast group/port or to itself.
   *
   * @param message  the message to be send
   *
   * @see  UDP#send(String message, String ip)
   * @see  UDP#send(String message, String ip, int port)
   *
   * @return boolean
   */
  public boolean send( String message ) {
    return send( message.getBytes() );
  }
  
  /**
   * Send data to the current socket. Explicitly, send data to the multicast 
   * group/port or to itself.
   *
   * @param buffer  data to be send
   *
   * @see  UDP#send(byte[] data, String ip)
   * @see  UDP#send(byte[] data, String ip, int port)
   *
   * @return boolean
   */
  public boolean send( byte[] buffer ) {
    // probably if the group could not be joined for a security reason
    if ( isMulticast() && group==null ) return false;
    
    String ip = isMulticast() ? group.getHostAddress() : address();
    return send( buffer, ip, port() );
  }
  
  /**
   * Send message to the requested IP address, to the current socket port.
   *
   * @param message  the message to be send
   * @param ip    the destination host's IP address
   *
   * @see  UDP#send(String message)
   * @see  UDP#send(String message, String ip, int port)
   *
   * @return boolean
   */
  public boolean send( String message, String ip ) {
    return send( message.getBytes(), ip );
  }
  
  /**
   * Send data to the requested IP address, to the current socket port.
   *
   * @param buffer  data to be send
   * @param ip    the destination host's IP address
   *
   * @see  UDP#send(byte[] buffer)
   * @see  UDP#send(byte[] buffer, String ip, int port)
   *
   * @return boolean
   */
  public boolean send( byte[] buffer, String ip ) {
    return send( buffer, ip, port() );
  }
  
  
  public boolean send( String message, String ip, int port ) {
    return send( message.getBytes(), ip, port );
  }
  
  
  public boolean send( byte[] buffer, String ip, int port ) {
    
    boolean success  = false;
    DatagramPacket pa = null;
    
    try {
      
      pa  = new DatagramPacket( buffer, buffer.length, InetAddress.getByName(ip), port );
        
      // send
      if ( isMulticast() ) mcSocket.send( pa );
      else ucSocket.send( pa );
      
      success = true;
      log( "send packet -> address:"+pa.getAddress()+
         ", port:"+ pa.getPort() +
        ", length: "+ pa.getLength()
         );
    }
    catch( IOException e ) {
      error( "could not send message!"+
           "\t\n> port:"+port+
          ", ip:"+ip+
          ", buffer size: "+size+
          ", packet length: "+pa.getLength()+
           "\t\n> "+e.getMessage()
          );
    }
    finally{ return success; }
  }
  
  /**
   * Set the maximum size of the packet that can be sent or receive on the 
   * current socket. This value must be greater than 0, otherwise the buffer 
   * size is set to the his default value.
   * <p>
   * return <code>true</code> if the new buffer value have been correctly set, 
   * <code>false</code> otherwise.
   * <p>
   * <i>note : this method has no effect if the socket is listening. To define
   * a new buffer size, call this method before implementing a new buffer in 
   * memory. Explicitly before calling a receive methods.</i>
   *
   * @param size  the buffer size value in bytes or n<=0
   * @return boolean
   * @see UDP#getBuffer()
   */
  public boolean setBuffer( int size ) {
    boolean done = false;
    
    // do nothing if listening (block the thread otherwise)
    if ( isListening() ) return done;
    
    try {
      // set the SO_SNDBUF and SO_RCVBUF value
      if ( isMulticast() ) {
        mcSocket.setSendBufferSize( size>0 ? size : BUFFER_SIZE );
        mcSocket.setReceiveBufferSize( size>0 ? size : BUFFER_SIZE );
      }
      else {
        ucSocket.setSendBufferSize( size>0 ? size : BUFFER_SIZE );
        ucSocket.setReceiveBufferSize( size>0 ? size : BUFFER_SIZE );
      }
      // set the current buffer size
      this.size = size>0 ? size : BUFFER_SIZE;
      done = true;
    }
    catch( SocketException e ) {
      error( "could not set the buffer!"+
           "\n> "+e.getMessage()
          );
    }
    finally{ return done; }
  }
  
  /**
   * Return the actual socket buffer length
   * @return int
   * @see UDP#setBuffer(int size)
   */
  public int getBuffer() {
    return size;
  }
  
  /**
   * Returns whether the socket wait for incoming data or not.
   * @return boolean
   */
  public boolean isListening() {
    return listen;
  }
  
    
  /**
   * Start/stop waiting constantly for incoming data.
   *
   * @param on  the required listening status.
   *
   * @see UDP#listen()
   * @see UDP#listen(int millis)
   * @see UDP#setReceiveHandler(String name)
   */
  public void listen( boolean on ) {
    
    listen  = on;
    timeout  = 0;
    
    // start
    if ( on && thread==null && !isClosed() ) {
      thread = new Thread( this );
      thread.start();
    }
    // stop
    if ( !on && thread!=null  ) { 
      send( new byte[0] ); // unblock the thread with a dummy message
      thread.interrupt();
      thread = null;
    }
  }
  
  
  public void listen( int millis ) {
    if ( isClosed() ) return;
    
    listen  = true;
    timeout = millis;
    
    // unblock the thread with a dummy message, if already listening
    if ( thread!=null ) send( new byte[0] );
    if ( thread==null ) {
      thread = new Thread( this );
      thread.start();
    }
  }
  
  /**
   * Wait for incoming data, and call the appropriate handlers each time a 
   * message is received. If the owner's class own the appropriate target 
   * handler, this method send it the receive message as byte[], the sender 
   * IP address and port.
   * <p>
   * This method force the current <code>Thread</code> to be ceased for a 
   * temporary period. If you prefer listening without blocking the current 
   * thread, use the {@link UDP#listen(int millis)} or 
   * {@link UDP#listen(boolean on)} method instead.
   *
   * @see UDP#listen()
   * @see UDP#listen(boolean on)
   * @see UDP#setReceiveHandler(String name)
   */
  public void listen() {
    try {
      
      byte[] buffer    = new byte[ size ];
      DatagramPacket pa  = new DatagramPacket(buffer,buffer.length);
      
      // wait
      if ( isMulticast() ) {
        mcSocket.setSoTimeout( timeout );
        mcSocket.receive( pa );  // <-- block the Thread
      }
      else {
        ucSocket.setSoTimeout( timeout );
        ucSocket.receive( pa ); // <-- block
      }

      
      log( "receive packet <- from "+pa.getAddress()+
         ", port:"+ pa.getPort() +
         ", length: "+ pa.getLength()
         );
      
    
      // get the required data only (not all the buffer)
      // and send it to the appropriate target handler, if needed
      if ( pa.getLength()!=0 ) {
        
        byte[] data = new byte[ pa.getLength() ];
        System.arraycopy( pa.getData(), 0, data, 0, data.length );
        
        try { 
          //callReceiveHandler( data, pa.getAddress().getHostAddress(), pa.getPort());
          callReceiveHandler( data, pa.getAddress().getHostAddress(), port());
        }
        catch( NoSuchMethodException e ) {
          // try with many argument > byte[], String, int
          callReceiveHandler( data );
          
        }
      }
    }
    catch( NullPointerException e ) {
      // *socket=null from the close() method;
      listen = false;
      thread = null;
    }
    catch( IOException e ) {
      
      listen = false;
      thread = null;
      
      if ( e instanceof SocketTimeoutException ) callTimeoutHandler();
      else {
         // do not print "Socket closed" error 
        // if the method close() has been called
        if ( ucSocket!=null && mcSocket!=null )
          error( "listen failed!\n\t> "+e.getMessage() );
      }
    }
    catch( Exception e ) {
      System.out.println("[X]haha me again");
      e.printStackTrace();
    }
  }
  
  /**
   * Wait for incoming datagram packets. This method is called automaticlly,
   * you do not need to call it.
   */
  public void run() {
    while ( listen ) listen();
  }
  
  
  public void setReceiveHandler( String name ) {
    this.receiveHandler = name;
  }
  
  /**
   * Call the default receive target handler method.
   *
   * @param data  the data to be passed
   * @throws NoSuchMethodException
   */
  private void callReceiveHandler( byte[] data ) {
    
    Class[] types;    // arguments class types
    Object[] values;  // arguments values
    Method method;
    
    try {
      types  = new Class[]{ data.getClass() };
      values  = new Object[]{ data };
      method  = owner.getClass().getMethod(receiveHandler, types);
      method.invoke( owner, values );
    }
    catch( NoSuchMethodException e )    {;}
    catch( IllegalAccessException e )    { error(e.getMessage()); }
    catch( InvocationTargetException e )  { e.printStackTrace(); }
  }

  /**
   * Call the receive target handler implemented with the optional arguments.
   *
   * @param data    the data to be passed
   * @param ip    the IP adress to be passed
   * @param port    the port number to be passed
   */
  private void callReceiveHandler( byte[] data, String ip, int port )throws NoSuchMethodException  {
    
    Class[] types;    // arguments class types
    Object[] values;  // arguments values
    Method method;
    
    try {
      types  = new Class[]{  data.getClass(),
                  ip.getClass(), 
                  Integer.TYPE
                };
      values  = new Object[]{ data, 
                  ip, 
                  new Integer(port)
                };
      method  = owner.getClass().getMethod(receiveHandler, types);
      method.invoke( owner, values );
    }
    
    catch( IllegalAccessException e )    { error(e.getMessage()); }
    catch( InvocationTargetException e )  { e.printStackTrace(); }
  }
  
  /**
   * Register the target's timeout handler. By default, this method name is 
   * "timeout" with no argument.
   *
   * @param name  the timeout handler name
   * @see UDP#setReceiveHandler(String name)
   */
  public void setTimeoutHandler( String name ) {
    this.timeoutHandler = name;
  }
  
  /**
   * Call the timeout target method when the socket received a timeout event.
   * The method name to be implemented in your code is <code>timeout()</code>.
   */
  private void callTimeoutHandler() {
    try {
      Method m = owner.getClass().getDeclaredMethod(timeoutHandler, null);
      m.invoke( owner, null );
    }
    catch( NoSuchMethodException e )    {;}
    catch( IllegalAccessException e )    { error(e.getMessage()); }
    catch( InvocationTargetException e )  { e.printStackTrace(); }
  }
  
  /**
   * Returns whether the opened datagram socket is a multicast socket or not.
   * @return boolean
   */
  public boolean isMulticast() {
    return ( mcSocket!=null );
  }
  
  /**
   * Returns whether the multicast socket is joined to a group address.
   * @return boolean
   */
  public boolean isJoined() {
    return ( group!=null );
  }
  
  /**
   * Returns whether the opened socket send broadcast message socket or not.
   * @return boolean
   */
  public boolean isBroadcast() {
    boolean result = false;
    try {
      result = (ucSocket==null) ? false : ucSocket.getBroadcast();
    }
    catch( SocketException e ) { error( e.getMessage() ); }
    finally { return result; }
  }
  
  /** 
   * Enables or disables the ability of the current process to send broadcast
   * messages.
   * @return boolean
   */
  public boolean broadcast( boolean on ) {
    boolean done = false;
    try {
      if ( ucSocket!=null ) {
        ucSocket.setBroadcast( on );
        done = isBroadcast();
      }
    }
    catch( SocketException e ) { error( e.getMessage() ); }
    finally { return done; }
  }
  
  
  public void loopback( boolean on ) {
    try {
      if ( isMulticast() ) mcSocket.setLoopbackMode( !on );
    }
    catch( SocketException e ) { 
      error( "could not set the loopback mode!\n\t>"+e.getMessage() ); 
    }
  }
  
  /**
   * Returns whether the multicast socket loopback mode is enable or not.
   * @return boolean
   */
  public boolean isLoopback() {
    try {
      if ( isMulticast() && !isClosed() ) 
        return !mcSocket.getLoopbackMode();
    }
    catch( SocketException e ) { 
      error( "could not get the loopback mode!\n\t> "+e.getMessage() ); 
    }
    return false;
  }
  
  
  public boolean setTimeToLive( int ttl ) {
    try {
      if ( isMulticast() && !isClosed() ) mcSocket.setTimeToLive( ttl );
      return true;
    }
    catch( IOException e ) { 
      error( "setting the default \"Time to Live\" value failed!"+
           "\n\t> "+e.getMessage() ); 
    }
    catch( IllegalArgumentException e ) {
      error( "\"Time to Live\" value must be in the range of 0-255" ); 
    }
    return false;
  }
  
  /**
   * Return the "Time to Live" value or -1 if an error occurred (or if 
   * the current socket is not a multicast socket).
   *
   * @return int
   * @see UDP#setTimeToLive(int ttl)
   */
  public int getTimeToLive() {
    try {
      if ( isMulticast() && !isClosed() ) 
        return mcSocket.getTimeToLive();
    }
    catch( IOException e ) { 
      error( "could not retrieve the current time-to-live value!"+
           "\n\t> "+ e.getMessage() ); 
    }
    return -1;
  }
  
  /**
   * Enable or disable output process log.
   */
  public void log( boolean on ) {
    log = on;
  }
  
  /**
   * Output message to the standard output stream.
   * @param out  the output message
   */
  private void log( String out ) {
    
    Date date = new Date();
    
    // define the "header" to retrieve at least the principal socket
    // informations : the host/port where the socket is bound.
    if ( !log && header.equals("") )
      header = "-- UDP session started at "+date+" --\n-- "+out+" --\n";
    
    // print out
    if ( log ) {
      
      String pattern  = "yy-MM-dd HH:mm:ss.S Z";
      String sdf    = new SimpleDateFormat(pattern).format( date );
      System.out.println( header+"["+sdf+"] "+out );
      header = ""; // forget header
    }
  }
  
  /**
   * Output error messages to the standard error stream.
   * @param err the error string
   */
  private void error( String err ) {
    System.err.println( err );
  }
}
