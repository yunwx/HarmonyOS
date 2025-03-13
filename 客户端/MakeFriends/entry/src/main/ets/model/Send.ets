import socket from '@ohos.net.socket';
import systemDateTime from '@ohos.systemDateTime';
import { ValuesBucket } from '@kit.ArkData';
import util from '@ohos.util';

let tcpSocket = socket.constructTCPSocketInstance();


export interface Address extends ValuesBucket {
  address:string,
  port: number,
  family:number
}

@Component
export struct Send {
  //连接、通讯历史记录
  @State msgHistory: string = ''
  //要发送的信息
  @State sendMsg: string = ''
  //本地端口
  @State localPort: number = 0
  //服务端IP地址
  @State serverIp: string = "192.168.1.109"
  //服务端端口
  @State serverPort: number = 8888
  //是否可以连接
  @State canConnect: boolean = false
  //是否可以发送消息
  @State canSend: boolean = false
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Text("服务端地址：")
          .fontSize(14)
          .width(90)
          .flexGrow(1)

        TextInput({ text: this.serverIp })
          .onChange((value) => {
            this.serverIp = value
          })
          .width(110)
          .fontSize(12)
          .flexGrow(4)

        Text(":")
          .width(5)
          .flexGrow(0)

        TextInput({ text: this.serverPort.toString() })
          .type(InputType.Number)
          .onChange((value) => {
            this.serverPort = parseInt(value)
          })
          .fontSize(12)
          .flexGrow(2)
          .width(50)

        Button("连接")
          .onClick(() => {
            this.connect2Server()
          })

          .width(70)
          .fontSize(14)
          .flexGrow(0)
      }
      .width('100%')
      .padding(10)

      Flex({ justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        TextInput({ placeholder: "输入要发送的消息" }).onChange((value) => {
          this.sendMsg = value
        })
          .width(200)
          .flexGrow(1)

        Button("发送")
          .enabled(this.canSend)
          .width(70)
          .fontSize(14)
          .flexGrow(0)
          .onClick(() => {
              this.sendMsg2Server()

          })
      }

      .width('100%')
      .padding(10)

      Scroll(this.scroller) {
        Text(this.msgHistory)
          .textAlign(TextAlign.Start)
          .padding(10)
          .width('100%')
          .backgroundColor(0xeeeeee)
      }
      .align(Alignment.Top)
      .backgroundColor(0xeeeeee)
      .height(300)
      .flexGrow(1)
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .scrollBarWidth(20)
    }
  }

  async bind2Port() {
    // 本地地址
    let localAddress : Address= { address: "0.0.0.0", port: this.localPort, family: 1 };

    try {
      // 绑定本地端口
      await tcpSocket.bind(localAddress);
      this.msgHistory = '绑定成功' + "\r\n";
      this.canConnect = true;


      // 监听接收到的消息
      tcpSocket.on("message", async (value) => {
        let msg = buf2String(value.message);  // 转换字节数据为字符串
        let time = await getCurrentTimeString();
        this.msgHistory += "服务端: " + msg + time + "\r\n";
        this.scroller.scrollEdge(Edge.Bottom);
      });

    } catch (e) {
      this.msgHistory = '绑定失败 ' + e.message + "\r\n";
    }
  }

  connect2Server() {
    // 本地地址
    let serverAddress: Address = { address: this.serverIp, port: this.serverPort, family: 1 };

    tcpSocket.connect({ address: serverAddress })
      .then(() => {
        this.msgHistory = '连接成功' + "\r\n";
        this.canSend = true;
        tcpSocket.on("close", () => {
          console.log("Socket 已关闭");
          this.msgHistory += "连接已断开\n";
        });
      })
      .catch((e: Error) => {
        this.msgHistory = '连接失败 ' + e.message + "\r\n";
      });

  }


  //发送消息到服务端
  sendMsg2Server() {

    tcpSocket.send({ data: this.sendMsg + "\r\n" })
      .then(async () => {
        this.msgHistory += "我:" + this.sendMsg + await getCurrentTimeString() + "\r\n"
        tcpSocket.on("message", async (value) => {
          //let msg = buf2String(value.message);  // 转换字节数据为字符串
          let byteArray = new Uint8Array(value.message);
          let textDecoder = util.TextDecoder.create("utf-8");
          let State = textDecoder.decodeToString(byteArray)
          let time = await getCurrentTimeString();
          let message = byteArray.join(',');  // 将字节数组转换为逗号分隔的字符串，方便查看
          let result= State.slice(State.indexOf("yes,") + "yes,".length);
          this.msgHistory += "服务端: " + result + time + "\r\n";

          //this.msgHistory += "服务端: " + msg + time + "\r\n";
          //this.msgHistory += "服务端: " + value.message + time + "\r\n";
          //this.scroller.scrollEdge(Edge.Bottom);  // 滚动到最底部
        });
      })
      .catch((e:Error) => {
        this.msgHistory += '发送失败' + e.message + "\r\n";
      })
  }

}


async function getCurrentTimeString() {
  let time = ""
  await  systemDateTime.getDate().then(
    (date) => {
      time = date.getHours().toString() + ":" + date.getMinutes().toString()
        + ":" + date.getSeconds().toString()
    }
  )
  return "[" + time + "]"
}

//ArrayBuffer转utf8字符串
function buf2String(buf: ArrayBuffer) {
  let msgArray = new Uint8Array(buf);
  let textDecoder = util.TextDecoder.create("utf-8");
  return textDecoder.decodeWithStream(msgArray)
}