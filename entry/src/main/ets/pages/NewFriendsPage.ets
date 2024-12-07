import {  CommonTitle, Friend, NewFriendsItem} from '../model/CommonStyle'
import { NetSearch } from '../model/Network'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct NewFriendsPage {
  @StorageLink('NewFriends') NewFriend: string = ''
  @State friendsArray: Array<string> = []
  @State NewFriends:Friend[] = []

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