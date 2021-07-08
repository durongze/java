package mypkg;
import java.net.*;
import java.io.*;

public class SocketClient {
	
	public static void main(String[] args) throws InterruptedException {
		try {
			Socket socket = new Socket("localhost",8088);
			OutputStream os = socket.getOutputStream();
			PrintWriter pw = new PrintWriter(os);
			pw.write(" cli msg");
			pw.flush();
			
			socket.shutdownOutput();
			
			InputStream is = socket.getInputStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			String info = null;
			while((info = br.readLine())!=null){
				System.out.println("cli rcv:"+info);
			}
			
			br.close();
			is.close();
			os.close();
			pw.close();
			socket.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}