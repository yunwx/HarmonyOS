import { router } from "@kit.ArkUI";
import { ActivityItem, AdminActivityItem, AdminActivityItem2, ContactItem, Friend } from "../model/CommonStyle";
import { NetSearch } from "../model/Network";

@Entry
@Component
export struct AdminPage {
  private tabsController: TabsController = new TabsController()
  @State isRefreshing: boolean = false
  @StorageLink('indexAdmin') index:number = 0
  @State currentIndex: number = this.index
  @StorageLink('管理用户') user: string = ''
  @State users: Friend[] = []
  @StorageLink('管理活动') activity: string = ''
  @State activities: Array<string> = []
  @StorageLink('待审核活动') decideActivity: string = ''
  @State decideActivities: Array<string> = []
  @State search1: string = ''
  @State search2: string = ''

  aboutToAppear(): void {
    if(this.user!==''){
      this.updateUsersList();
    }
    if(this.activity!==''){
      this.updateActivitiesList();
    }
    let search = new NetSearch()
    search.SearchDecideActivity()
    setTimeout(() => {
      this.updateDecideActivitiesList();
    }, 500);
  }

  updateUsersList(): void {
    const Users: Array<Friend> = [];
    if (this.user.length == 0) {
      return;
    }
    const usersArray: Array<string> = this.user.split(',');
    for (let i = 0; i < usersArray.length; i += 4) {
      const newFriend: Friend = {
        id: usersArray[i],
        Username: usersArray[i + 1],
        name: usersArray[i + 2] || '',
        avatar_Url: usersArray[i + 3] || '',
      };
      Users.push(newFriend);
    }
    this.users = Users;
  }

  updateActivitiesList(): void {
    this.activities = this.activity.split('||')
  }

  updateDecideActivitiesList(): void {
    this.decideActivities = this.decideActivity.split('||')
  }


  build() {
    Column() {
      Row() {
        Row() {
          Image('Page_image/back.png')
            .width(25)
            .height(25)
            .onClick(() => {
              router.replaceUrl({
                url: 'pages/LoginPage'
              });
            })
        }.width('10%')
        .margin({ left: 5 })

        Row() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text('管理员').fontSize('18fp').padding('20px')
          }
        }.width('80%')

        Row() {
          Image('Page_image/add.png')
            .width(25)
            .height(25)
            .onClick(() => {
              router.pushUrl({ url: 'pages/AdminAddActivityPage' })
            })
        }.width('10%')

      }.width('100%').height('180px').backgroundColor('#fff5f1f1')

      Tabs({ barPosition:BarPosition.End,controller: this.tabsController,index:this.index }) {
        TabContent() {
          Column(){
            Row() {
              Search({ placeholder: '搜索用户...' })
                .searchButton('搜索')
                .width('90%')
                .height(40)
                .backgroundColor(Color.White)
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: 14, weight: 400 })
                .textFont({ size: 14, weight: 400 })
                .onSubmit(async (value: string) => {
                  if(value!==''){
                    let search = new NetSearch()
                    await search.SearchUserOne(value);
                    setTimeout(() => {
                      this.updateUsersList()
                    }, 500);
                    this.search1 = ''
                  }
                })
                .onChange((value: string) => {
                  this.search1 = value;
                })
                .margin(20)
            }
            .backgroundColor('#fff5f1f1')
            .align(Alignment.Top)
            Column(){
              Button('查询全部')
                .width('60%')
                .backgroundColor("#ff08ae3c")
                .onClick(async ()=>{
                  let search = new NetSearch()
                  await search.SearchUserAll()
                  setTimeout(() => {
                    this.updateUsersList()
                  }, 1000);
                })
            }.width('100%').backgroundColor('#fff5f1f1')
            List() {
              if (this.user.length !== 0) {
                ForEach(this.users, (item: Friend) => {
                  ListItem() {
                    ContactItem({ image: item.avatar_Url, text: item.name })
                  }
                  .onClick(async () => {
                    let search = new NetSearch();
                    await search.SearchOne(item.Username)
                    setTimeout(() => {
                      AppStorage.setOrCreate('indexAdmin', 0)
                      router.replaceUrl({
                        url: 'pages/AdminPersonPage',
                        params: { username: item.Username }
                      });
                    }, 300);
                  })
                }, (item: Friend) => item.id)
              }
            }
            .height('80%')
            .width('100%')
          }
          .height('100%')
          .width('100%')
        }
        .tabBar(this.TabBuilder("管理用户", 0))

        TabContent() {
          Column(){
            Row() {
              Search({ placeholder: '搜索活动...' })
                .searchButton('搜索')
                .width('90%')
                .height(40)
                .backgroundColor(Color.White)
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: 14, weight: 400 })
                .textFont({ size: 14, weight: 400 })
                .onSubmit(async (value: string) => {
                  if(value!==''){
                    let search = new NetSearch()
                    await search.SearchActivityOne(value);
                    setTimeout(() => {
                      this.updateActivitiesList();
                    }, 500);
                    this.search2 = ''
                  }
                })
                .onChange((value: string) => {
                  this.search2 = value;
                })
                .margin(20)
            }
            .backgroundColor('#fff5f1f1')
            .align(Alignment.Top)
            Column(){
              Button('查询全部')
                .width('60%')
                .backgroundColor("#ff08ae3c")
                .onClick(async ()=>{
                  let search = new NetSearch()
                  await search.SearchActivityAll()
                  setTimeout(() => {
                    this.updateActivitiesList();
                  }, 1000);
                })
            }.width('100%').backgroundColor('#fff5f1f1')
            List() {
              if (this.activity !== '') {
                ForEach(this.activities, (item: string) => {
                  ListItem() {
                    AdminActivityItem({ str: item })
                  }
                }, (item: string) => item)
              }
            }
            .height('80%')
            .width('100%')
          }
          .height('100%')
          .width('100%')
        }
        .tabBar(this.TabBuilder("管理活动", 1))

        TabContent() {
          Column(){
            Refresh({ refreshing: $$this.isRefreshing }) {
              List() {
                if (this.decideActivity !== '') {
                  ForEach(this.decideActivities, (item: string) => {
                    ListItem() {
                      AdminActivityItem2({ str: item })
                    }
                  }, (item: string) => item)
                }
              }
              .height('100%')
              .width('100%')
            }
            .onRefreshing(async () => {
              let search = new NetSearch()
              await search.SearchDecideActivity()
              setTimeout(() => {
                this.updateDecideActivitiesList();
                this.isRefreshing = false
              }, 1000)
            })
          }
        }
        .tabBar(this.TabBuilder("审核", 2))

      }
      .onChange((index) => {
        this.currentIndex = index;
      })
      .scrollable(false)
      .width('100%')
      .height('95%')
    }.width('100%').height('100%')
  }

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title).fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
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