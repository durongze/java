package mypkg;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;

public class TxtParseUtils {
    public Map<String, Integer> map;
    public String m_fileName;
    public int age = 1;
    public void LoadFile(String fileName) {
        m_fileName = fileName;
        map = new HashMap<String, Integer>();
 
        /* 读取数据 */
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(new File(m_fileName)), "UTF-8"));
            String lineTxt = null;
            while ((lineTxt = br.readLine()) != null) {
                String[] names = lineTxt.split(",");
                for (String name : names) {
                    if (map.keySet().contains(name)) {
                        map.put(name, (map.get(name) + age));
                    } else {
                        map.put(name, age);
                    }
                }
            }
            br.close();
        } catch (Exception e) {
            System.err.println("read errors :" + e);
        }
    }
    
    public void StoreFile(String fileName){
        m_fileName = fileName;
        
        try {
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(new File(m_fileName)), "UTF-8"));
            for (String name : map.keySet()) {
                bw.write(name + " " + map.get(name));
                bw.newLine();
            }
            bw.close();
        } catch (Exception e) {
            System.err.println("write errors :" + e);
        }
    }
    
    public static void main(String[] args) {
        TxtParseUtils txt = new TxtParseUtils();
        txt.LoadFile("test.txt");
        txt.StoreFile("text2.txt");
    }
}