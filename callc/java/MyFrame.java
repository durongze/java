package mypkg;

import java.awt.*;
import javax.swing.*;

class MyFrame extends JFrame {
    JPanel jp;
    JButton btn;
    JLabel label;
    public MyFrame()
    {
        this.setVisible(true);
        this.setSize(250, 220);
        this.setVisible(true);
        this.setLocation(400, 200);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        InitPanel(new JPanel());
    }
    public void InitPanel(JPanel jp)
    {
        btn = new JButton("btn");
        label = new JLabel("label");
        jp.add(btn);
        jp.add(label);
        add(jp);
    }
    public static void main(String[] args)
    {
        MyFrame mf = new MyFrame();
        return ;
    }
}