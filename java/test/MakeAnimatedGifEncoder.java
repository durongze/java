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
 
 
public class MakeAnimatedGifEncoder {
 
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

    public static void DecGifFile(String gifFile, String outputPath)
    {
        GifDecoder gifDecoder = new GifDecoder();
        gifDecoder.read(gifFile);
        int count = gifDecoder.getFrameCount();
        System.out.println(" DecGifFile count:" + count);
        for (int i = 0; i < count; i++)
        {
            BufferedImage frame = gifDecoder.getFrame(i);  // frame i
            String frameName = String.format("{0:000}", i); // Guid.NewGuid().ToString();
            File outputfile = new File(outputPath + "3" + frameName);
            try {
                ImageIO.write(frame, "png", outputfile);
            }catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
    
    public static final void main(String[] args) throws Exception{

        AnimatedGifEncoder encoder = new AnimatedGifEncoder();
        encoder.start("MakeAnimatedGifEncoder.gif");
        encoder.setDelay(1000);
        encoder.setRepeat(1000);
        encoder.setTransparent(0xffffff);
        
        String[] inputs = GetFileList("res/pos/");
        for( String input : inputs ) {
            if (input == null) { 
                continue;
            }
            File fileExt = new File(input);
            if (fileExt.exists()) {
                System.out.println(fileExt.getAbsolutePath());
            }
            InputStream inputStream = MakeAnimatedGifEncoder.class.getResourceAsStream(input);
            try {
                BufferedImage image = ImageIO.read(inputStream);
                int[] pixels = new int[image.getWidth() * image.getHeight()];
                image.getRGB(0, 0, image.getWidth(), image.getHeight(), pixels, 0, image.getWidth());
                encoder.addFrame(pixels, image.getWidth(), image.getHeight());
            } catch (Exception e) {
                e.printStackTrace();
                inputStream.close();
            }
        }
        encoder.finish();
    }

}
