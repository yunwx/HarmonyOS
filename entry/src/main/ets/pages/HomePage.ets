import { Activity, ChatItem, ContactPage, Friend, ME, Title} from '../model/CommonStyle'
import {  Send } from '../model/Send';
import { DataDialog, HomeDialog } from '../model/Dialog';
import chat from  '../model/Network'

interface Chat {
  id:string
  Username: string;
  name: string;
  avatar_Url: string;
  content: string;
  timestamp:number;
  time: string

}

@Entry
@Component
struct HomePage{
  private tabsController : TabsController = new TabsController()
  @StorageLink('id') Id:string = ''
  @StorageLink('index') index:number = 0
  @StorageLink('friends') friends: string = ''
  @StorageLink('username') username:string = ''
  @State Chat:Chat[] = []
  @State currentIndex:number = this.index;
  @State name: string | undefined = AppStorage.get('name');
  @State friend:string = ''
  @State message:string = ''


  dialogController: CustomDialogController  = new CustomDialogController({
    builder: HomeDialog(),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false
  })

aboutToAppear(): void {
    this.updateFriendsList()
  if(AppStorage.get('init')===undefined){
    chat.Chat(this.username, this.friend,this.message)
    AppStorage.setOrCreate('init',1)
  }

    if(this.name!=undefined && this.name.length==0){
      this.dialogController.open()
    }

  chat.onMessageReceived = (receivedMessage: string) => {
    console.log("收到的消息:", receivedMessage);
    // 获取当前时间戳
    const timestamp1 = Date.now();  // 当前时间的毫秒数 (Unix 时间戳)
    // 获取当前时间的可读格式 (可选)
    const readableTime = new Date(timestamp1).toLocaleString();  // 格式化为本地时间
    const messageArray:Array<string> = receivedMessage.split('|#|')
    const str = messageArray[0] + '->' + this.Id;
    let friend: string = AppStorage.get(str) || '';
    if(friend!==''){
      let newMessage:string = friend+'^||^'+messageArray[1]+'#|#'+timestamp1+'#|#'+readableTime;
      AppStorage.set(str,newMessage);
    }else {
      let newMessage:string = messageArray[1]+'#|#'+timestamp1+'#|#'+readableTime;
      AppStorage.setOrCreate(str,newMessage)
    }
    this.updateFriendsList()
  }
}

onPageShow(): void {

}

  updateFriendsList(): void {
    this.Chat = [];
    const Chat: Array<Chat> = [];
    if (this.friends.length == 0) {
      return;
    }

    const friendsArray: Array<string> = this.friends.split(',');

    for (let i = 0; i < friendsArray.length; i += 4) {
      const str1 = this.Id + '->' + friendsArray[i];
      const str2 = friendsArray[i] + '->' + this.Id;

      let me: string = AppStorage.get(str1) || '';
      let friend: string = AppStorage.get(str2) || '';
      let all: string = me + '^||^' + friend;

      if (me != '' || friend != '') {
        const array = all.split('^||^');
        console.log("all拆分后的消息", array);
        let size: number = array.length - 1;
        console.log("array[size]的消息", array[size]);

        if (array[size] == '') {
          size--;
        }

        let maxTimestamp = 0;
        let latestContent = '';
        let latestTime = '';

        // 遍历所有的聊天记录，找出最新的消息
        for (let j = 0; j < array.length; j++) {
          const value = array[j].split('#|#');
          console.log("array[" + j + "]拆分后的消息", value);

          const currentTimestamp = parseInt(value[1], 10);

          if (currentTimestamp > maxTimestamp) {
            maxTimestamp = currentTimestamp;
            latestContent = value[0];
            latestTime = value[2];
          }
        }

        // 将最新的消息内容和时间信息作为聊天内容
        const newChat: Chat = {
          id: friendsArray[i],
          Username: friendsArray[i + 1],
          name: friendsArray[i + 2] || '',
          avatar_Url: friendsArray[i + 3] || '',
          content: latestContent,
          timestamp: maxTimestamp,
          time: latestTime
        };

        Chat.push(newChat);
      }
    }

    Chat.sort((a, b) => b.timestamp - a.timestamp);
    setTimeout(() => {
      this.Chat = Chat;
    }, 10);
    console.log("最终的Chat列表:", JSON.stringify(this.Chat, null, 2));
  }

  build(){
    Column(){
        Tabs({barPosition:BarPosition.End,index:this.index,controller: this.tabsController}){
          TabContent() {
            Column() {
              Title()
              List() {
                ForEach(this.Chat, (item: Chat) => {
                  ListItem() {
                    ChatItem({ Id:item.id,image:item.avatar_Url, name:item.name ,username:item.Username,content:item.content,time:item.time})
                  }
                }, (item: Chat) => item.id)
              }
              .height('100%')
              .width('100%')
            }
          }
          .tabBar(this.TabBuilder('首页', 0, "Page_image/home1.png", "Page_image/home2.png"))

          TabContent() {
            ContactPage()
          }
          .tabBar(this.TabBuilder('通讯录', 1, "Page_image/address_book1.png", "Page_image/address_book2.png"))

          TabContent() {
            Activity()
          }
          .tabBar(this.TabBuilder('活动', 2, "Page_image/planet1.png", "Page_image/planet2.png"))

          TabContent() {
            ME()
          }
          .tabBar(this.TabBuilder('我的', 3, "Page_image/me1.png", "Page_image/me2.png"))
        }
        .onChange((index) => {
          this.currentIndex = index;
        })
    }
  }
  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: string, normalImg: string) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }

}
