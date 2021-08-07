package mypkg;

import java.io.*;
import java.net.*;

public class ServerThread extends Thread{
	
	private Socket socket = null;
	
	public ServerThread(Socket socket) {
		this.socket = socket;
	}
 
	@Override
	public void run() {
		InputStream is=null;
        InputStreamReader isr=null;
        BufferedReader br=null;
        OutputStream os=null;
        PrintWriter pw=null;
        try {
			is = socket.getInputStream();
			isr = new InputStreamReader(is);
			br = new BufferedReader(isr);
			
			String info = null;
			
			while((info=br.readLine())!=null){
				System.out.println("svr,cli:"+info);
			}
			socket.shutdownInput();
			
			os = socket.getOutputStream();
			pw = new PrintWriter(os);
			pw.write("服务器欢迎你");
			
			pw.flush();
        } catch (Exception e) {
			// TODO: handle exception
		} finally{
            try {
                if(pw!=null)
                    pw.close();
                if(os!=null)
                    os.close();
                if(br!=null)
                    br.close();
                if(isr!=null)
                    isr.close();
                if(is!=null)
                    is.close();
                if(socket!=null)
                    socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
		}
	}
 
}