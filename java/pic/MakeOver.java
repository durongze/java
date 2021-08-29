package mypkg;

import mypkg.AnimatedGifEncoder;

import java.awt.Graphics;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import javax.imageio.ImageIO;
 
 
public class MakeOver {
 
    public static String[] GetFileList(String dir)
    {
        File file = new File(dir);
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            String[] fileList = new String[files.length];
            for (int i = 0; i < files.length; i++) {
                if (files[i].isDirectory()) {
                    System.out.println("Dirs[" + i + "]：" + files[i].getPath());
                } else {
                    System.out.println("File[" + i + "]：" + files[i].getPath());
                    fileList[i] = files[i].getPath();
                }
            }
            return fileList;
        } else {
            String[] fileList = new String[1];
            fileList[0] = file.getPath();
            System.out.println("File：" + file.getPath());
            return fileList;
        }
    }

    public static final void main(String[] args) throws Exception{

        AnimatedGifEncoder encoder = new AnimatedGifEncoder();
        encoder.start("testout.gif");
        encoder.setDelay(1000);
        encoder.setRepeat(1000);
        encoder.setTransparent(0xffffff);
        
        String[] inputs = GetFileList("res");
        for( String input : inputs ) {
            if (input == null) continue;
            System.out.println("input:" + input);
            InputStream inputStream = MakeOver.class.getResourceAsStream(input);
            try {
                BufferedImage image = ImageIO.read(inputStream);
                int[] pixels = new int[image.getWidth() * image.getHeight()];
                image.getRGB(0, 0, image.getWidth(), image.getHeight(), pixels, 0, image.getWidth());
                encoder.addFrame(pixels, image.getWidth(), image.getHeight());
            } finally {
                inputStream.close();
            }
        }
        encoder.finish();
    }

}
