import socket from '@ohos.net.socket';
import util from '@ohos.util';
import { Address } from '../model/Send';
import { promptAction, router } from '@kit.ArkUI';
import { Friend } from './CommonStyle';
import Network from '@system.network';
import encryptor from './Encryptor';


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
                let State = textDecoder.decodeToString(byteArray).trim()
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
                let State = textDecoder.decodeToString(byteArray).trim()
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
                let State = textDecoder.decodeToString(byteArray).trim()
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
                let State = textDecoder.decodeToString(byteArray).trim()
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
                let State = textDecoder.decodeToString(byteArray).trim()
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
                let State = textDecoder.decodeToString(byteArray).trim()
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
                let State = textDecoder.decodeToString(byteArray).trim()
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

export class LoginAndRegister {

  Login(username:string,password:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "登录,"+username+","+password+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                console.log("数据:", value.message);
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码的数据:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  const parts: string[] = result.split("||");
                  console.log("用户信息:", parts[0]);
                  console.log("用户好友:", parts[1]);
                  console.log("好友申请:", parts[2]);
                  console.log("聊天记录:", parts[3]);
                  console.log("推荐好友:", parts[4]);
                  console.log("推荐活动:", parts[5]);
                  const parts0Array = parts[0].split(',');
                  // 存储
                  AppStorage.setOrCreate('id', parts0Array[0]);
                  AppStorage.setOrCreate('username', parts0Array[1]);
                  AppStorage.setOrCreate('password', parts0Array[2]);
                  AppStorage.setOrCreate('gender', parts0Array[3]);
                  AppStorage.setOrCreate('avatar_Url', parts0Array[4]);
                  AppStorage.setOrCreate('name', parts0Array[5]);
                  if(parts0Array[6]=='null'){
                    AppStorage.setOrCreate('birthday','');
                  }else {
                    AppStorage.setOrCreate('birthday', parts0Array[6]);
                  }
                  AppStorage.setOrCreate('interests', parts0Array[7]);
                  AppStorage.setOrCreate('friends', parts[1]);
                  AppStorage.setOrCreate('NewFriends', parts[2]);
                  AppStorage.setOrCreate('init','no');
                  const parts3Array = parts[3].split('|X|');
                  for (let index = 0; index < parts3Array.length; index++) {
                    let  array = parts3Array[index].split('^^');
                    let str:string = array[0]+"->"+array[1]
                    let str2:string|undefined =AppStorage.get(str)
                    const timestamp = parseInt(array[3], 10); // 时间戳，单位毫秒

                    // 转换时间戳为可读时间
                    const readableTime = new Date(timestamp).toLocaleString();

                    if(str2!==undefined){
                      AppStorage.set(str,str2+"^||^"+array[2]+"#|#"+timestamp+'#|#'+readableTime)
                    }else {
                      AppStorage.setOrCreate(str,array[2]+"#|#"+timestamp+'#|#'+readableTime)
                    }
                  }
                  AppStorage.setOrCreate('recommendFriends', parts[4]);
                  AppStorage.setOrCreate('推荐', parts[5]);
                  promptAction.showToast({ message: '登录成功！', duration: 2000 });
                  router.replaceUrl({
                    url: 'pages/HomePage'
                  });
                }
                if(State==='absent'){
                  promptAction.showToast({ message: '用户不存在！', duration: 2000 });
                }
                if(State==='incorrect'){
                  promptAction.showToast({ message: '密码错误，请重试。', duration: 2000 });
                }
                if(State==='block'){
                  promptAction.showToast({ message: '账号已被封禁！', duration: 2000 });
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

      /*let db = new DbService();

      // 查询用户信息
      let users = await db.queryOneByUsername(this.username);

      if (!users || users.length === 0) {
        // 用户名不存在
        promptAction.showToast({ message: '用户名不存在！', duration: 2000 });
        return;
      }

      const user:USERINFO = users[0];

      // 存储
      AppStorage.setOrCreate('id', user.id);
      AppStorage.setOrCreate('username', user.username);
      AppStorage.setOrCreate('password', user.password);
      AppStorage.setOrCreate('gender', user.gender);
      AppStorage.setOrCreate('avatar_Url', user.avatar_Url);
      AppStorage.setOrCreate('name', user.name);
      AppStorage.setOrCreate('birthday', user.birthday);
      AppStorage.setOrCreate('interests', user.interests);

      if (user.password === this.password) {
        // 登录成功，跳转页面
        router.replaceUrl({
          url: 'pages/HomePage'
        });
      } else {
        // 密码错误
        promptAction.showToast({ message: '密码错误，请重试。', duration: 2000 });
      }
      */
    } catch (err) {
      console.error(`Login failed. Message: ${err.message}`);
      promptAction.showToast({ message: '登录失败，请稍后重试！', duration: 2000 });
    }
  }

  Register(username:string,password:string,gender:string|null,avatar_Url:string,name:string|null,birthday:string|null,interests:string|null){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "注册,"+username+","+password+","+gender+","+avatar_Url
            +","+name+","+birthday+","+interests+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State=="yes"){
                  promptAction.showToast({ message: '注册成功！', duration: 2000 });
                  router.replaceUrl({
                    url: 'pages/LoginPage'
                  });
                }
                if(State=='reuse'){
                  promptAction.showToast({ message: '用户名已存在！', duration: 2000 });
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

      /*let db = new DbService()
      const userExists = await db.queryOneByUsername(this.param.username);
      if (userExists.length > 0) {
        promptAction.showToast({ message: '用户名已存在！', duration: 2000 });
        return;
      }

      await db.insertUser(this.param);
      promptAction.showToast({ message: '注册成功！', duration: 2000 });
      router.replaceUrl({
        url: 'pages/LoginPage'
      });*/

    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '注册失败，请稍后重试！', duration: 2000 });
    }
  }
}

export class NetChat {

  private tcpSocket: socket.TCPSocket | null = null;  // 存储 tcpSocket 实例

  // 这个回调函数用于接收消息
  onMessageReceived?: (receivedMessage: string) => void;


  // 初始化时连接到服务器（只会连接一次）
  private connectToServer(): Promise<void> {
    if (this.tcpSocket !== null) {
      console.log("已经连接，不需要重新连接");
      return Promise.resolve();  // 如果已有连接，直接返回已连接状态
    }

    this.tcpSocket = socket.constructTCPSocketInstance();
    return this.tcpSocket.connect({ address: serverAddress })
      .then(() => {
        console.log("连接成功");
        this.tcpSocket?.on("close", () => {
          console.log("Socket 已关闭");
          this.tcpSocket = null;  // 连接关闭后清空 socket 实例
        });
      })
      .catch((e: Error) => {
        console.log("连接失败", e);
        throw e;  // 连接失败时抛出错误
      });
  }

  // 发送消息
  Chat(username: string, friendName: string, message: string): void {
    // 确保连接已建立
    this.connectToServer()
      .then(() => {
        // 发送消息
        if (this.tcpSocket) {
          // 加密消息
          const encryptedMessage = encryptor.encrypt(message);
          this.tcpSocket.send({ data: `聊天,${username},@${friendName} ${encryptedMessage}\r\n` })
            .then(() => {
              console.log("发送成功");
            })
            .catch((e: Error) => {
              console.log("发送失败", e);
            });

          // 监听服务器返回的消息
          this.tcpSocket.on("message", (value) => {
            let byteArray = new Uint8Array(value.message);
            let textDecoder = util.TextDecoder.create("utf-8");
            let State = textDecoder.decodeToString(byteArray).trim();
            if (State && this.onMessageReceived) {
              this.onMessageReceived(State); // 传递收到的消息
            }
          });
        }
      })
      .catch((e: Error) => {
        console.log("聊天连接失败", e);
      });
  }

  disconnect(): void {
    if (this.tcpSocket !== null) {
      console.log("正在断开连接...");
      this.tcpSocket.close()
        .then(() => {
          console.log("连接已关闭");
        })
        .catch((e: Error) => {
          console.log("关闭连接失败", e);
        });
    } else {
      console.log("没有连接可关闭");
    }
  }

}
const  chat = new NetChat()
export default chat as NetChat

export class FriendOption {
  async SearchFriend(username: string): Promise<Friend | null> {
    let friend: Friend = {
      id:'',
      Username: '',
      name: '',
      avatar_Url: ''
    };

    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      await tcpSocket.connect({ address: serverAddress });  // 等待连接完成
      console.log("连接成功");

      await tcpSocket.send({ data: "查找好友," + username + "\r\n" });  // 等待发送完成
      console.log("发送成功");

      return new Promise<Friend | null>((resolve, reject) => {
        tcpSocket.on("message", (value) => {
          try {
            tcpSocket.close();  // 处理完消息后关闭连接

            let byteArray = new Uint8Array(value.message);
            let textDecoder = util.TextDecoder.create("utf-8");
            let State = textDecoder.decodeToString(byteArray).trim();

            if (State.indexOf("yes,") !== -1) {
              const result = State.slice(State.indexOf("yes,") + "yes,".length);
              const resultArray = result.split(',');

              friend = {
                id:'',
                Username: resultArray[0],
                name: resultArray[1] || '',  // 如果没有值，使用空字符串
                avatar_Url: resultArray[2] || '',
              };
              promptAction.showToast({ message: '查找成功！', duration: 2000 });
              resolve(friend);  // 成功时返回 friend
            } else if (State === 'not') {
              promptAction.showToast({ message: '没有该用户！', duration: 2000 });
              resolve(null);  // 没有找到用户时返回 null
            } else {
              resolve(null);  // 其他情况也返回 null
            }
          } catch (err) {
            console.error("处理消息时发生错误: ", err);
            reject(err);  // 出现异常时抛出错误
          }
        });

        tcpSocket.on("close", () => {
          console.log("Socket 已关闭");
        });
      });
    } catch (err) {
      console.error(`查找好友失败. 错误信息: ${err.message}`);
      promptAction.showToast({ message: '查找好友失败，请稍后重试！', duration: 2000 });
      return null;  // 返回 null，表示查找失败
    }
  }

  AddFriend(friendUsername:string){
    let Id:number|undefined = AppStorage.get('id')
    let IdStr: string = ''
    if(Id!=undefined){
      IdStr = Id.toString();
    }
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "添加好友,"+IdStr+","+friendUsername+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State == 'yes'){
                  promptAction.showToast({ message: '添加消息已发出！', duration: 2000 });
                }
                if(State == 'not'){
                  promptAction.showToast({ message: '你已添加过该好友！', duration: 2000 });
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
      promptAction.showToast({ message: '添加好友失败，请稍后重试！', duration: 2000 });
    }
  }

  queryNewFriends(username:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查看好友请求,"+username+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate('NewFriends', result);
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
      promptAction.showToast({ message: '查看好友请求失败，请稍后重试！', duration: 2000 });
    }
  }

  queryFriends(){
    let username:string|undefined = AppStorage.get('username')
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查看好友列表,"+username+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.set('friends', result);
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
      promptAction.showToast({ message: '查看好友列表失败，请稍后重试！', duration: 2000 });
    }
  }

  ConfirmFriend(FriendName:string){
    let Id:number|undefined = AppStorage.get('id')
    let IdStr: string = ''
    if(Id!=undefined){
      IdStr = Id.toString();
    }
    let friend:string | undefined = AppStorage.get('friends')
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "确定添加好友,"+IdStr+","+FriendName+"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  const resultArray = result.split(',');
                  if(friend==''||friend==undefined){
                    friend=resultArray.join(',');
                  }else {
                    friend=friend + "," + resultArray.join(',')
                  }
                  AppStorage.set('friends',friend)
                  promptAction.showToast({ message: '你有新好友啦！', duration: 2000 });
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
      promptAction.showToast({ message: '添加好友失败，请稍后重试！', duration: 2000 });
    }
  }

  RejectFriend(friendUsername:string){
    let Id:number|undefined = AppStorage.get('id')
    let IdStr: string = ''
    if(Id!=undefined){
      IdStr = Id.toString();
    }
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "拒绝添加好友,"+IdStr+","+friendUsername+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State == 'yes'){
                  console.log("删除成功")
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
      promptAction.showToast({ message: '拒绝好友失败，请稍后重试！', duration: 2000 });
    }
  }

  async searchRecommends(userId:string,userInterests:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询推荐好友," + userId + "," + userInterests + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate('recommendFriends', result);
                  console.log("存储的数据是:"+AppStorage.get('recommendFriends'))
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

}

export class NetSearch {

  async SearchOne(FriendName:string): Promise<string>{
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询具体信息,"+FriendName+"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message",async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  let resultArray: Array<string> = result.split(',')
                  AppStorage.setOrCreate(resultArray[1],result)
                  console.log("存储的数据是："+AppStorage.get(resultArray[1]));
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
    return 'yes';
  }

  SearchUserAll(){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询全部用户,"+"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message",async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate('管理用户',result)
                  console.log("存储的数据是："+AppStorage.get('管理用户'));
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  SearchUserOne(user:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询单个用户,"+user+"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message",async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate('管理用户',result)
                  console.log("存储的数据是："+AppStorage.get('管理用户'));
                }
                if(State == 'no'){
                  promptAction.showToast({ message: '未搜索到！', duration: 2000 });
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  SearchActivityAll(){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询全部活动,"+"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message",async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate('管理活动',result)
                  console.log("存储的数据是："+AppStorage.get('管理活动'));
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  SearchActivityOne(activityId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询单个活动,"+activityId+"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message",async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate('管理活动',result)
                  console.log("存储的数据是："+AppStorage.get('管理活动'));
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  SearchDecideActivity(){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询待审核活动,"+"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message",async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate('待审核活动',result)
                  console.log("存储的数据是："+AppStorage.get('待审核活动'));
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  deleteUser(Username:string){
    let Id:number|undefined = AppStorage.get('id')
    let IdStr: string = ''
    if(Id!=undefined){
      IdStr = Id.toString();
    }
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "删除用户,"+IdStr+","+Username+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State == 'yes'){
                  promptAction.showToast({ message: '删除成功！', duration: 2000 });
                }
                if(State == 'no'){
                  promptAction.showToast({ message: '删除失败！', duration: 2000 });
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
      promptAction.showToast({ message: '删除用户失败，请稍后重试！', duration: 2000 });
    }
  }

  updateUserStatus(userId:string,newStatus:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改用户状态," + userId + ","+ newStatus + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '操作成功！', duration: 2000 });
                }
                if(State=="no"){
                  promptAction.showToast({ message: '操作失败！', duration: 2000 });
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

export class ActivityOption {

  addActivity(activityName:string,category:string,labels:string,description:string,startTime:string,endTime:string,maxParticipants:string,creatorId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "新建活动,"+activityName+","+category+","+labels+","+description
            +","+startTime+","+endTime+","+maxParticipants+","+creatorId+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State=="yes"){
                  promptAction.showToast({ message: '创建成功！', duration: 2000 });
                  router.replaceUrl({
                    url: 'pages/HomePage'
                  });
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
      promptAction.showToast({ message: '创建失败，请稍后重试！', duration: 2000 });
    }
  }

  AdminAddActivity(activityName:string,category:string,labels:string,description:string,startTime:string,endTime:string,maxParticipants:string,creatorId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "管理员新建活动,"+activityName+","+category+","+labels+","+description
            +","+startTime+","+endTime+","+maxParticipants+","+creatorId+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State=="yes"){
                  promptAction.showToast({ message: '创建成功！', duration: 2000 });
                  router.replaceUrl({
                    url: 'pages/AdminPage'
                  });
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
      promptAction.showToast({ message: '创建失败，请稍后重试！', duration: 2000 });
    }
  }

  updateActivity(activityId:string,activityName:string,category:string,labels:string,description:string,startTime:string,endTime:string,maxParticipants:string,creatorId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "活动修改,"+activityId+","+activityName+","+category+","+labels+","+description
            +","+startTime+","+endTime+","+maxParticipants+","+creatorId+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State=="yes"){
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

  AdminUpdateActivity(activityId:string,activityName:string,category:string,labels:string,description:string,startTime:string,endTime:string,maxParticipants:string,creatorId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "管理员活动修改,"+activityId+","+activityName+","+category+","+labels+","+description
            +","+startTime+","+endTime+","+maxParticipants+","+creatorId+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                if(State=="yes"){
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

  updateActivityStatus(activityId:string,newStatus:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "修改活动状态," + activityId + ","+ newStatus + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '操作成功！', duration: 2000 });
                }
                if(State=="no"){
                  promptAction.showToast({ message: '操作失败！', duration: 2000 });
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

  deleteActivity(activityId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "删除活动," + activityId + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '删除成功！', duration: 2000 });
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
      promptAction.showToast({ message: '删除失败，请稍后重试！', duration: 2000 });
    }
  }

  searchByCategory(category:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "类别查询," + category + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate(category,result)
                  let resultArray: Array<string> = result.split('||')
                  for (let index = 0; index < resultArray.length; index++) {
                    let array = resultArray[index].split(',')
                    AppStorage.setOrCreate(array[0],resultArray[index])
                    console.log("存储的数据是:"+AppStorage.get(array[0]))
                  }
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  searchCreated(userId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "创建活动查询," + userId + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate("Created",result)
                    console.log("存储的数据是:"+AppStorage.get("Created"))
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  searchJoin(userId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "参与活动查询," + userId + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate("Join",result)
                  console.log("存储的数据是:"+AppStorage.get("Join"))
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  searchComments(activityId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "活动评论查询," + activityId + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  let str = "Activity_"+activityId;
                  AppStorage.setOrCreate(str,result)
                  console.log("存储的数据是:"+AppStorage.get(str))
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  async searchParticipants(activityId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询所有参与用户," + activityId + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  let str = "Activity_Participants"+activityId;
                  AppStorage.setOrCreate(str,result)
                  console.log("存储的数据是:"+AppStorage.get(str))
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  async searchRecommends(userId:string,userInterests:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "查询推荐活动," + userId + "," + userInterests + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State.indexOf("yes,")!== -1){
                  const result= State.slice(State.indexOf("yes,") + "yes,".length);
                  AppStorage.setOrCreate('推荐', result);
                  console.log("存储的数据是:"+AppStorage.get('推荐'))
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
      promptAction.showToast({ message: '查询失败，请稍后重试！', duration: 2000 });
    }
  }

  AddComment(activityId:string,userId:string,commentText:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "评论," + activityId +","+userId+","+commentText+ "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '评论成功！', duration: 2000 });
                }
                if(State=="no"){
                  promptAction.showToast({ message: '评论失败！', duration: 2000 });
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
      promptAction.showToast({ message: '评论失败，请稍后重试！', duration: 2000 });
    }
  }

  deleteComment(commentId:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "删除评论," + commentId + "\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message",(value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '删除成功！', duration: 2000 });
                }
                if(State=="no"){
                  promptAction.showToast({ message: '删除失败！', duration: 2000 });
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
      promptAction.showToast({ message: '删除失败，请稍后重试！', duration: 2000 });
    }
  }

  Join(activityId:string,Id:string):boolean{
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "参与活动," + activityId +","+ Id +"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '参加成功！', duration: 2000 });
                  return true;
                }
                if(State=="no"){
                  promptAction.showToast({ message: '你已经参加了！', duration: 2000 });
                  return false;
                }
                if(State=="not"){
                  promptAction.showToast({ message: '参与人数已满！', duration: 2000 });
                  return false;
                }
                return false;
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
      promptAction.showToast({ message: '参加失败，请稍后重试！', duration: 2000 });
    }
    return false;
  }

  unJoin(activityId:string,Id:string):boolean{
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "取消参加," + activityId +","+ Id +"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '取消成功！', duration: 2000 });
                  return true;
                }
                return false;
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
      promptAction.showToast({ message: '取消失败，请稍后重试！', duration: 2000 });
    }
    return false;
  }

  like(activityId:string,Id:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "点赞," + activityId +","+ Id +"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '点赞成功！', duration: 2000 });
                }
                if(State=="no"){
                  promptAction.showToast({ message: '不能重复点赞！', duration: 2000 });
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
      promptAction.showToast({ message: '点赞失败，请稍后重试！', duration: 2000 });
    }
  }

  unlike(activityId:string,Id:string){
    try {
      let tcpSocket = socket.constructTCPSocketInstance();
      tcpSocket.connect({ address: serverAddress })
        .then(() => {
          console.log("连接成功");
          tcpSocket.send({ data: "取消点赞," + activityId +","+ Id +"\r\n"})
            .then(async () => {
              console.log("发送成功");
              tcpSocket.on("message", async (value) => {
                tcpSocket.close()
                let byteArray = new Uint8Array(value.message);
                let textDecoder = util.TextDecoder.create("utf-8");
                let State = textDecoder.decodeToString(byteArray).trim()
                console.log("解码后的 State:", State);
                if(State=="yes"){
                  promptAction.showToast({ message: '取消点赞成功！', duration: 2000 });
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
      promptAction.showToast({ message: '取消点赞失败，请稍后重试！', duration: 2000 });
    }
  }

}