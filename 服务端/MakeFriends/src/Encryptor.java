public class Encryptor {
    private final String key;

    public Encryptor(String key) {
        this.key = key;
    }

    // 解密方法
    public String decrypt(String encryptedMessage) {
        String reversedMessage = new StringBuilder(encryptedMessage).reverse().toString();

        StringBuilder decryptedMessage = new StringBuilder();
        for (int i = 0; i < reversedMessage.length(); i++) {
            char charCode = reversedMessage.charAt(i); // 加密字符
            char keyCode = key.charAt(i % key.length()); // 密钥字符
            char originalCharCode = (char) (charCode - keyCode); // 反向偏移
            decryptedMessage.append(originalCharCode); // 生成原始字符
        }
        return decryptedMessage.toString(); // 返回解密后的消息
    }

    // 加密方法
    public String encrypt(String message) {
        StringBuilder encryptedMessage = new StringBuilder();
        for (int i = 0; i < message.length(); i++) {
            char charCode = message.charAt(i); // 原始字符
            char keyCode = key.charAt(i % key.length()); // 密钥字符
            char newCharCode = (char) (charCode + keyCode); // 偏移字符编码
            encryptedMessage.append(newCharCode); // 生成新字符
        }
        return encryptedMessage.reverse().toString(); // 倒序返回加密后的字符串
    }
}