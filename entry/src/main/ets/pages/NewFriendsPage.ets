import {  CommonTitle, Friend, NewFriendsItem} from '../model/CommonStyle'
import chat, { NetSearch } from '../model/Network'
import { router } from '@kit.ArkUI'
import encryptor from '../model/Encryptor'

@Entry
@Component
struct NewFriendsPage {
  @StorageLink('NewFriends') NewFriend: string = ''
  @State friendsArray: Array<string> = []
  @State NewFriends:Friend[] = []
  @StorageLink('id') Id:string = ''

  aboutToAppear(): void {
    this.NewFriends = [];
    if(this.NewFriend.length==0){
      return;
    }
    this.friendsArray = this.NewFriend.split(',')
    for (let i = 0; i < this.friendsArray.length; i += 3) {
      const newFriend: Friend = {
        id:'',
        Username: this.friendsArray[i],
        name: this.friendsArray[i + 1] || '', //如果没有值，使用空字符串
        avatar_Url: this.friendsArray[i + 2] || '',
      };
      this.NewFriends.push(newFriend);
    }
    chat.onMessageReceived = (receivedMessage: string) => {
      console.log("收到的消息:", receivedMessage);

      // 获取当前时间戳
      const timestamp1 = Date.now(); // 当前时间的毫秒数 (Unix 时间戳)
      // 获取当前时间的可读格式 (可选)
      const readableTime = new Date(timestamp1).toLocaleString(); // 格式化为本地时间
      const messageArray: Array<string> = receivedMessage.split('|#|')
      const str = messageArray[0] + '->' + this.Id;
      const decryptedMessage = encryptor.decrypt(messageArray[1]);
      console.log("解密后的消息:", decryptedMessage);
      let friend: string = AppStorage.get(str) || '';
      if (friend !== '') {
        let newMessage: string = friend + '^||^' + decryptedMessage + '#|#' + timestamp1 + '#|#' + readableTime;
        AppStorage.set(str, newMessage);
      } else {
        let newMessage: string = decryptedMessage + '#|#' + timestamp1 + '#|#' + readableTime;
        AppStorage.setOrCreate(str, newMessage)
      }
    }
  }

  build() {
    Column() {
      CommonTitle({ text: '好友申请' })
      List(){
        ForEach(this.NewFriends, (item: Friend) => {
          ListItem() {
            NewFriendsItem({ name: item.name, image: item.avatar_Url, Username: item.Username})
          }
          .onClick(()=>{
            let search = new NetSearch();
            search.SearchOne(item.Username)
            setTimeout(() => {
              router.pushUrl({
                url: 'pages/NewPersonPage',
                params: { username: item.Username }
              });
            }, 50);
          })
        }, (item: Friend) => item.Username)
      }
    }
  }
}