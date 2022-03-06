package mypkg;

import mypkg.AnimatedGifEncoder;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.ImageObserver;
import java.awt.BasicStroke;
import java.io.InputStream;
import java.awt.Graphics2D;
import java.awt.Color;
import java.awt.Checkbox;
import java.awt.geom.Line2D;
import java.awt.geom.Arc2D;
import java.util.*;
import java.awt.RenderingHints;
import java.io.*;

public class TestAnimatedGifEncoder {

    public static BufferedImage rotateImage(final BufferedImage bufferedimage,
        final int degree) {
        int w = bufferedimage.getWidth();
        int h = bufferedimage.getHeight();
        int type = bufferedimage.getColorModel().getTransparency();
        BufferedImage img = new BufferedImage(w, h, type);
        Graphics2D graphics2d = img.createGraphics();
        graphics2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
            RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        graphics2d.rotate(Math.toRadians(degree), w / 2, h / 2);
        
        graphics2d.drawImage(bufferedimage, 0, 0, null);
        ImageObserver observer = new Checkbox();
        graphics2d.drawImage(img, w / 4, h / 4, observer);
        float thick=3.0f;
        graphics2d.setStroke(new BasicStroke(thick, BasicStroke.CAP_SQUARE, BasicStroke.JOIN_ROUND));
        graphics2d.setColor(Color.green);
        Line2D line = new Line2D.Double(2,3,200,300);
        graphics2d.draw(line);
        Arc2D arc1 = new Arc2D.Double(8,30,85,60,5,90,Arc2D.OPEN);
        graphics2d.draw(arc1);
        graphics2d.drawString("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 40, 40);
        graphics2d.dispose();
        return img;
    }

    public static List<String> getFiles(String path) {
        List<String> files = new ArrayList();
        File file = new File(path);
        File[] tempList = file.listFiles();

        for (int i = 0; i < tempList.length; i++) {
            if (tempList[i].isFile()) {
                files.add(tempList[i].toString());
            }
            if (tempList[i].isDirectory()) {
            }
        }
        return files;
    }

    public static void DecGifFile(String gifFile, String outputPath)
    {
        GifDecoder gifDecoder = new GifDecoder();
        File fileExt = new File(gifFile);
        if (fileExt.exists()) {
            System.out.println(fileExt.getAbsolutePath());
        }
        gifDecoder.read(gifFile);
        int count = gifDecoder.getFrameCount();
        System.out.println(Thread.currentThread().getStackTrace()[1].getMethodName() + " " + gifFile + " count:" + count);
        for (int i = 0; i < count; i++)
        {
            BufferedImage frame = gifDecoder.getFrame(i);  // frame i
            String frameName = String.format("%04d", i) + ".png"; // Guid.NewGuid().ToString();
            try {
                File outputfile = new File(outputPath + "3" + frameName);
                ImageIO.write(frame, "png", outputfile);
                System.out.println(outputfile.getAbsolutePath());
            }catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static final void main(String[] args) throws Exception{

        AnimatedGifEncoder encoder = new AnimatedGifEncoder();
        String gifFileName = Thread.currentThread().getStackTrace()[1].getClassName().toLowerCase() + ".gif";
        String pic_path = "res/jpeg_ok/";

        encoder.start(gifFileName);
        encoder.setDelay(1000);
        encoder.setTransparent(0xffffff);
        encoder.setRepeat(10);

        String[] inputs = getFiles(pic_path).toArray(new String[getFiles(pic_path).size()]);
        int idx = 0;
        for( String input : inputs ) {
            if (input == null || !input.endsWith(".png") || !input.endsWith(".jpg")) {
                continue;
            }
            File fileExt = new File(input);
            if (fileExt.exists()) {
                System.out.println(fileExt.getAbsolutePath());
            } else {
                continue;
            }
            InputStream inputStream = TestAnimatedGifEncoder.class.getResourceAsStream(input);
            if (inputStream == null) {
                continue;
            }
            try {
                BufferedImage image;
                // if (idx == 0) {
                    image = ImageIO.read(inputStream);
                // } else {
                //    image = rotateImage(ImageIO.read(inputStream), idx * 90);
                // }
                idx++;
                int[] pixels = new int[image.getWidth() * image.getHeight()];
                image.getRGB(0, 0, image.getWidth(), image.getHeight(), pixels, 0, image.getWidth());
                encoder.addFrame(pixels, image.getWidth(), image.getHeight());
            } catch (Exception e) {
                e.printStackTrace();
                inputStream.close();
            }
        }
   
        encoder.finish();
        DecGifFile(gifFileName, pic_path);
    }
}
