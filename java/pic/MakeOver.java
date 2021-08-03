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
 
    public static final void main(String[] args) throws Exception{

        AnimatedGifEncoder encoder = new AnimatedGifEncoder();
        encoder.start("testout.gif");
        encoder.setDelay(1000);
        encoder.setRepeat(1000);
        encoder.setTransparent(0xffffff);

        String[] inputs = new String[]{
                "res/1.png",
                "res/2.png",
                "res/3.png"
        };
        for( String input : inputs ) {
            System.out.println(input);
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
