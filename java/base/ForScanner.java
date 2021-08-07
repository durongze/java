package mypkg;
import java.util.*;
class ForScanner{
    public static void main(String argv[])
    {
        int arr[] = new int[10];
        int i = 0;
        for (i = 0; i < 10; i++) {
            Scanner scan = new Scanner(System.in);
            System.out.println("input number " + i + " : ");
            arr[i] = scan.nextInt();
            System.out.println(arr[i]);
        }
    }
}