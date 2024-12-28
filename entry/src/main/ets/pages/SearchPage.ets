import { CommonTitle, ContactItem, Friend } from '../model/CommonStyle'
import chat, { NetSearch } from '../model/Network';
import { router } from '@kit.ArkUI';
import encryptor from '../model/Encryptor';

interface name {
  name: string;
}

@Entry
@Component
struct SearchPage{
  @State friend:Friend[] = []
  @State name:string = ''
  @StorageLink('friends') friends: string = ''
  @StorageLink('id') Id:string = ''

  aboutToAppear(): void {
    const params = router.getParams() as name;
    if (params.name) {
      this.name = params.name;
    }
    const Friend: Array<Friend> = [];
    let arr = this.friends.split(',');
    // 每四个元素分为一组
    let groupedFriends :Array<Array<string>> = [];
    for (let i = 0; i < arr.length; i += 4) {
      groupedFriends.push(arr.slice(i, i + 4));
    }
    groupedFriends = groupedFriends.filter(friend => friend[2] == this.name);
    for (let index = 0; index < groupedFriends.length; index++) {
      const newFriend: Friend = {
        id:groupedFriends[index][0],
        Username: groupedFriends[index][1],
        name: groupedFriends[index][2] || '',
        avatar_Url: groupedFriends[index][3] || '',
      };
      Friend.push(newFriend);
    }
    setTimeout(() => {
      this.friend = Friend;
    }, 20);

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
    Column(){
      CommonTitle({ text: '查找好友' })
      List() {
        if(this.friend.length!==0){
          ForEach(this.friend, (item: Friend) => {
            ListItem() {
              ContactItem({ image: item.avatar_Url, text: item.name })
            }
            .onClick(async () => {
              let search = new NetSearch();
              await search.SearchOne(item.Username)
              AppStorage.setOrCreate('index',1)
              setTimeout(() => {
                router.replaceUrl({
                  url: 'pages/PersonPage',
                  params: { username: item.Username }
                });
              }, 300);
            })
          }, (item: Friend) => item.id)
        }
      }
      .height('100%')
      .width('100%')
    }
  }
}