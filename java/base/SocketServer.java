package mypkg;
import java.net.*;
import java.io.*;

public class SocketServer {
	
	public static void main(String[] args) {
		try {
			ServerSocket serverSocket = new ServerSocket(8088);
			Socket socket = new Socket();	
			
            while(true){
            	socket = serverSocket.accept();
            	
            	ServerThread thread = new ServerThread(socket);
            	thread.start();
            	
            	InetAddress address=socket.getInetAddress();
                System.out.println("cli ip:"+address.getHostAddress());
            }
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
}