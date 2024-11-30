import socket from '@ohos.net.socket';
import util from '@ohos.util';
import { Address } from '../model/Send';
import { promptAction } from '@kit.ArkUI';


let  serverAddress :Address = {
  address:"192.168.1.109",
  port:8888,
  family:1
}

export class UpdateNet {

  private  ID: number |undefined = AppStorage.get('id');
  private username: string |undefined = AppStorage.get('username');
  private password: string |undefined = AppStorage.get('password');
  private gender: string |undefined = AppStorage.get('gender');
  private avatar_Url: string |undefined = AppStorage.get('avatar_Url');
  private name: string |undefined = AppStorage.get('name');
  private birthday: string |undefined = AppStorage.get('birthday');
  private interests: string |undefined = AppStorage.get('interests');

  updateOne(name: string, birthday: string,interests : string) {
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改,"+this.username+","+this.password+","+this.gender+","+this.avatar_Url
            +","+name+","+birthday+","+interests+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray)
                if(State=="yes"){
                  AppStorage.set('name',name)
                  AppStorage.set('birthday',birthday)
                  AppStorage.set('interests',interests)
                  promptAction.showToast({ message: '修改成功！', duration: 2000 });
                }
              });
            })
            .catch((e:Error) => {
              console.log("发送失败");
            })
          tcpSocket.on("close", () => {
            console.log("Socket 已关闭");
          });
        })
        .catch((e: Error) => {
          console.log("连接失败");
        });
    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '修改失败，请稍后重试！', duration: 2000 });
    }
  }

  updateName(name: string) {
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改,"+this.username+","+this.password+","+this.gender+","+this.avatar_Url
            +","+name+","+this.birthday+","+this.interests+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray)
                if(State=="yes"){
                  AppStorage.set('name',name)
                  promptAction.showToast({ message: '修改成功！', duration: 2000 });
                }
              });
            })
            .catch((e:Error) => {
              console.log("发送失败");
            })
          tcpSocket.on("close", () => {
            console.log("Socket 已关闭");
          });
        })
        .catch((e: Error) => {
          console.log("连接失败");
        });
    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '修改失败，请稍后重试！', duration: 2000 });
    }
  }

  updatePassword(password: string) {
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改,"+this.username+","+password+","+this.gender+","+this.avatar_Url
            +","+this.name+","+this.birthday+","+this.interests+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray)
                if(State=="yes"){
                  AppStorage.set('password',password)
                  promptAction.showToast({ message: '修改成功！', duration: 2000 });
                }
              });
            })
            .catch((e:Error) => {
              console.log("发送失败");
            })
          tcpSocket.on("close", () => {
            console.log("Socket 已关闭");
          });
        })
        .catch((e: Error) => {
          console.log("连接失败");
        });
    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '修改失败，请稍后重试！', duration: 2000 });
    }
  }

  updateAvatar_Url(avatar_Url: string) {
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改,"+this.username+","+this.password+","+this.gender+","+avatar_Url
            +","+this.name+","+this.birthday+","+this.interests+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray)
                if(State=="yes"){
                  AppStorage.set('avatar_Url',avatar_Url)
                  promptAction.showToast({ message: '修改成功！', duration: 2000 });
                }
              });
            })
            .catch((e:Error) => {
              console.log("发送失败");
            })
          tcpSocket.on("close", () => {
            console.log("Socket 已关闭");
          });
        })
        .catch((e: Error) => {
          console.log("连接失败");
        });
    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '修改失败，请稍后重试！', duration: 2000 });
    }
  }

  updateGender(gender: string) {
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改,"+this.username+","+this.password+","+gender+","+this.avatar_Url
            +","+this.name+","+this.birthday+","+this.interests+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray)
                if(State=="yes"){
                  AppStorage.set('gender',gender)
                  promptAction.showToast({ message: '修改成功！', duration: 2000 });
                }
              });
            })
            .catch((e:Error) => {
              console.log("发送失败");
            })
          tcpSocket.on("close", () => {
            console.log("Socket 已关闭");
          });
        })
        .catch((e: Error) => {
          console.log("连接失败");
        });
    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '修改失败，请稍后重试！', duration: 2000 });
    }
  }

  updateBirthday(birthday: string) {
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改,"+this.username+","+this.password+","+this.gender+","+this.avatar_Url
            +","+this.name+","+birthday+","+this.interests+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray)
                if(State=="yes"){
                  AppStorage.set('birthday',birthday)
                  promptAction.showToast({ message: '修改成功！', duration: 2000 });
                }
              });
            })
            .catch((e:Error) => {
              console.log("发送失败");
            })
          tcpSocket.on("close", () => {
            console.log("Socket 已关闭");
          });
        })
        .catch((e: Error) => {
          console.log("连接失败");
        });
    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '修改失败，请稍后重试！', duration: 2000 });
    }
  }

  updateInterests(interests: string) {
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改,"+this.username+","+this.password+","+this.gender+","+this.avatar_Url
            +","+this.name+","+this.birthday+","+interests+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray)
                if(State=="yes"){
                  AppStorage.set('interests',interests)
                  promptAction.showToast({ message: '修改成功！', duration: 2000 });
                }
              });
            })
            .catch((e:Error) => {
              console.log("发送失败");
            })
          tcpSocket.on("close", () => {
            console.log("Socket 已关闭");
          });
        })
        .catch((e: Error) => {
          console.log("连接失败");
        });
    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '修改失败，请稍后重试！', duration: 2000 });
    }
  }
}