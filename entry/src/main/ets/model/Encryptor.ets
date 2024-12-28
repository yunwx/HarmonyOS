class Encryptor {
  private key: string;

  constructor(key: string) {
    this.key = key;
  }

  //加密
  encrypt(message: string): string {
    let encryptedMessage = "";
    for (let i = 0; i < message.length; i++) {
      const charCode = message.charCodeAt(i);
      const keyCode = this.key.charCodeAt(i % this.key.length);
      const newCharCode = charCode + keyCode;
      encryptedMessage += String.fromCharCode(newCharCode);
    }
    return encryptedMessage.split("").reverse().join("");
  }

  //解密
  decrypt(encryptedMessage: string): string {
    let reversedMessage = encryptedMessage.split("").reverse().join("");
    let decryptedMessage = "";
    for (let i = 0; i < reversedMessage.length; i++) {
      const charCode = reversedMessage.charCodeAt(i);
      const keyCode = this.key.charCodeAt(i % this.key.length);
      const originalCharCode = charCode - keyCode;
      decryptedMessage += String.fromCharCode(originalCharCode);
    }
    return decryptedMessage;
  }
}
const  encryptor = new Encryptor("ZhangDongQing")
export default encryptor as Encryptor