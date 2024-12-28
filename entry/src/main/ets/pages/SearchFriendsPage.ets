import {   CommonTitle1, Friend, SearchItem } from '../model/CommonStyle'
import chat, { FriendOption, NetSearch } from '../model/Network'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct SearchFriendsPage {
  @State search: string = ''
  @State friend: Friend = {
    id:'',
    Username: '',
    name: '',
    avatar_Url: ''
  }
  @State SearchedFriend:Friend[] = []

  aboutToAppear(): void {

  }

  build() {
    Column() {
      CommonTitle1({ text: '添加好友' })
      Row() {
        Search({ placeholder: '输入用户名进行查找' })
          .searchButton('搜索')
          .width('90%')
          .height(40)
          .backgroundColor(Color.White)
          .placeholderColor(Color.Grey)
          .placeholderFont({ size: 14, weight: 400 })
          .textFont({ size: 14, weight: 400 })
          .onSubmit(async(value: string) => {
            let friend = new FriendOption()
            const result:Friend|null = await friend.SearchFriend(value)
            if (result!==null) {
              this.friend = result
              this.SearchedFriend.push(this.friend)
            }
          })
          .onChange((value: string) => {
            if(value=='' && this.SearchedFriend.length>0){
              this.SearchedFriend.pop()
            }
            this.search = value;
          })
          .margin(20)
      }
      .backgroundColor('#fff8f6f6')
      .padding(10)
      .align(Alignment.Top)
        ForEach(this.SearchedFriend, (item: Friend) => {
          ListItem() {
            SearchItem({ text: item.name, image: item.avatar_Url, Username: item.Username})
          }
          .onClick(async () => {
            let search = new NetSearch();
            await search.SearchOne(item.Username)
            setTimeout(() => {
              router.pushUrl({
                url: 'pages/PersonPage2',
                params: { username: item.Username }
              });
            }, 300);
          })
        }, (item: Friend) => item.Username)
    }
  }
}