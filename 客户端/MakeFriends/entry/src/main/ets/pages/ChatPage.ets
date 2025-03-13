import { router } from "@kit.ArkUI"
import { CommonTitle } from "../model/CommonStyle"
import encryptor from "../model/Encryptor";
import chat from  '../model/Network'

interface Message {
  sender: string;
  content: string;
  timestamp:number;
  time:string;
}

interface friend {
  id:string,
  username:string;
  name: string;
  image:string;
}

@Entry
@Component
export struct ChatPage {
  @StorageLink('id') myId:string = ''
  @State friendId:string = ''
  @State image: string = ''
  @State name: string = ''
  @State content: string = ''
  @State message: string = ''
  @State friendName: string = ''
  @StorageLink('avatar_Url') MyImage: string = ''
  @StorageLink('username') username: string = ''
  scroller: Scroller = new Scroller()

  @State messages: Message[] = [];

  aboutToAppear(): void {
    const params = router.getParams() as friend;
    if (params.id) {
      this.friendId = params.id;
    }
    if (params.username) {
      this.friendName = params.username;
    }
    if (params.name) {
      this.name = params.name;
    }
    if (params.image) {
      this.image = params.image;
    }
    this.updateMessagesList();
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 50);

    chat.onMessageReceived = (receivedMessage: string) => {
      console.log("收到的消息:", receivedMessage);
      // 获取当前时间戳
      const timestamp1 = Date.now();  // 当前时间的毫秒数 (Unix 时间戳)
      // 获取当前时间的可读格式 (可选)
      const readableTime = new Date(timestamp1).toLocaleString();  // 格式化为本地时间
      // 将接收到的消息添加到 messages 数组
      const messageArray:Array<string> = receivedMessage.split('|#|')
      const decryptedMessage = encryptor.decrypt(messageArray[1]);
      console.log("解密后的消息:", decryptedMessage);
      if(messageArray[0]===this.friendId){
        this.messages.push({ sender: "friend", content: decryptedMessage ,timestamp:timestamp1,time:readableTime});
      }
      this.scroller.scrollEdge(Edge.Bottom);
      const str2 = messageArray[0] + '->' + this.myId;
      let friend: string = AppStorage.get(str2) || '';
      if(friend!==''){
        let newMessage:string = friend+'^||^'+decryptedMessage+'#|#'+timestamp1+'#|#'+readableTime;
        AppStorage.set(str2,newMessage);
      }else {
        let newMessage:string = decryptedMessage+'#|#'+timestamp1+'#|#'+readableTime;
        AppStorage.setOrCreate(str2,newMessage)
      }
    }
  }

  updateMessagesList(): void {
    // 确保清空消息列表
    this.messages = [];

    const messages: Array<Message> = [];
    // 获取存储的数据
    const str1 = this.myId + '->' + this.friendId;
    const str2 = this.friendId + '->' + this.myId;
    let me: string = AppStorage.get(str1) || '';
    let friend: string = AppStorage.get(str2) || '';

    // 打印调试信息
    console.log("me的数据", me);
    console.log("friend的数据", friend);

    // 处理 me 的消息
    if(me!==''){
      if (me.indexOf('^||^') !== -1) {
        const array1 = me.split('^||^');
        console.log("me拆分后的消息", array1);
        for (let index = 0; index < array1.length; index++) {
          let value = array1[index].split('#|#');
          messages.push({ sender: "me", content: value[0] ,timestamp:parseInt(value[1], 10),time:value[2] });
        }
      } else {
        console.log("me原始消息", me);
        let value = me.split('#|#');
        messages.push({ sender: "me", content: value[0] ,timestamp:parseInt(value[1], 10),time:value[2] });
      }
    }

    // 处理 friend 的消息
    if(friend!==''){
      if (friend.indexOf('^||^') !== -1) {
        const array2 = friend.split('^||^');
        console.log("friend拆分后的消息", array2);
        for (let index = 0; index < array2.length; index++) {
          let value = array2[index].split('#|#');
          messages.push({ sender: "friend", content: value[0],timestamp:parseInt(value[1], 10) ,time:value[2]});
        }
      } else {
        console.log("friend原始消息", friend);
        let value = friend.split('#|#');
        messages.push({ sender: "friend", content: value[0],timestamp:parseInt(value[1], 10) ,time:value[2]});
      }
    }
    // 排序 messages 数组
    messages.sort((a, b) => a.timestamp - b.timestamp);
    this.messages=messages

    // 打印最终的消息列表
    console.log("最终的消息列表:", JSON.stringify(this.messages, null, 2));
  }

  build() {
    Column() {
      Row(){
        Row(){
          Image('Page_image/back.png')
            .width(25)
            .height(25)
            .onClick(()=>{
              router.replaceUrl({
                url: 'pages/HomePage'
              });
            })
        }.width('10%')
        Row(){
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text(this.name).fontSize('18fp').padding('20px')
          }
        }.width('80%')

      }.width('100%').height('160px').backgroundColor('#fff5f1f1')

      // 聊天区域：显示消息
      Scroll(this.scroller) {
          // 循环遍历消息，动态显示
          List({scroller:this.scroller}){
            ForEach(this.messages, (item: Message) => {
              ListItem() {
                Row(){
                  // 判断消息的发送者，确定文本对齐
                  if (item.sender === "me") {
                    // 我的消息右对齐
                    Flex({ direction: FlexDirection.RowReverse }) {
                      Image(this.MyImage)
                        .width('120px')
                        .height('120px')
                        .margin({ left: '10px', right: '10px' })
                        .objectFit(ImageFit.Contain)

                      Flex({ direction: FlexDirection.RowReverse, justifyContent: FlexAlign.Start }) {
                        Text(item.content)
                          .fontSize('14fp')
                          .backgroundColor("#ff1ec13d")
                          .padding(10)
                          .borderRadius(10)
                          .margin({ left: '140px' })
                      }
                    }
                  }else {
                    Image(this.image).width('120px').height('120px').margin({ left: '10px', right: '10px' })
                    Text(item.content)
                      .fontSize('14fp')
                      .backgroundColor(Color.White)
                      .padding(10)
                      .borderRadius(10)
                      .margin({ right: '280px' })
                  }
                }
                .width("100%")
              }
              .width('100%')
              .margin({ top: '20px', bottom: '20px' })
            }, (item: Message) => item.time)
          }.height("100%")
          .width("100%")
          .nestedScroll({
            scrollForward: NestedScrollMode.PARENT_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
          })
      }
      .scrollable(ScrollDirection.Vertical)
      .backgroundColor('#fff5f1f1')
      .height('85%')
      .width('100%')

      // 输入框和发送按钮
      Row() {
        TextInput({ text:this.message })
          .onChange((value) => {
            this.message = value
          })
          .width('70%')
          .backgroundColor(Color.White)
          .margin({left:20,right:5})

        // 发送按钮
        Button("发送",{type: ButtonType.Normal})
          .onClick(() => {
            if (this.message.trim()) {
              chat.Chat(this.username, this.friendName,this.message)
              // 获取当前时间戳
              const timestamp1 = Date.now();  // 当前时间的毫秒数 (Unix 时间戳)
              const readableTime = new Date(timestamp1).toLocaleString();  // 格式化为本地时间
              this.messages.push({ sender: "me", content: this.message ,timestamp:timestamp1,time:readableTime});
              const str1 = this.myId + '->' + this.friendId;
              let me: string = AppStorage.get(str1) || '';
              if(me!==''){
                let newMessage:string = me+'^||^'+this.message+'#|#'+timestamp1+'#|#'+readableTime;
                AppStorage.set(str1,newMessage);
              }else {
                let newMessage:string = this.message+'#|#'+timestamp1+'#|#'+readableTime;
                AppStorage.setOrCreate(str1,newMessage)
              }
              this.scroller.scrollEdge(Edge.Bottom);
              this.message = ''
            }
          })
          .borderRadius(10)
          .backgroundColor("#ff08ae3c")
          .width('20%')
      }
      .height('10%')
      .width('100%')
      .backgroundColor('#fff5f1f1')
      .padding(10)
      .align(Alignment.Bottom)
    }
    .width("100%")
    .height("100%")
  }

}