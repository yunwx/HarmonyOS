import java.io.*;
import java.net.*;

public class ChatClient {
    private static Socket socket;
    private static PrintWriter out;
    private static BufferedReader in;

    public static void main(String[] args) throws IOException {

        socket = new Socket("192.168.8.202", 8888);  // 连接到服务器
        in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        out = new PrintWriter(socket.getOutputStream(), true);

        BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));

        out.println("聊天,"+124);  // 发送用户名到服务器
        //out.println("确定添加好友,"+2+","+123);
        // 启动一个线程来接收服务器消息
        new Thread(new ServerListener()).start();
        Encryptor encryptor = new Encryptor("ZhangDongQing");
        // 主线程用于发送消息
        String message;
        while ((message = userInput.readLine()) != null) {
            if (message.equalsIgnoreCase("exit")) {
                break;
            }
            String encryptedMessage = encryptor.encrypt(message);
            out.println("聊天,124,@123 "+encryptedMessage);  // 发送消息到服务器
        }

        socket.close();
    }

    // 用于监听服务器消息的线程
    static class ServerListener implements Runnable {
        @Override
        public void run() {
            try {
                String message;
                Encryptor encryptor = new Encryptor("ZhangDongQing");
                while ((message = in.readLine()) != null) {
                    String[] message1 = message.split("\\|#\\|",2);
                    String decryptedMessage = encryptor.decrypt(message1[1]);
                    System.out.println("收到服务器消息: " + decryptedMessage);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
