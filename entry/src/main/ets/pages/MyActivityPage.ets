import { router } from "@kit.ArkUI"
import { ActivityItem1, ActivityItem2 } from "../model/CommonStyle"
import encryptor from "../model/Encryptor"
import chat, { ActivityOption } from "../model/Network"

@Entry
@Component
export struct MyActivityPage {
  @StorageLink('id') Id: string = ''
  private tabsController: TabsController = new TabsController()
  @State isRefreshing: boolean = false
  @StorageLink('indexMyActivity') index:number = 0
  @State currentIndex: number = this.index
  @StorageLink('Join') Join: string = ''
  @State JoinArray: Array<string> = []
  @StorageLink('Created') Created: string = ''
  @State CreatedArray: Array<string> = []

  aboutToAppear() {
    this.update();
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

  update() {
    this.JoinArray = this.Join.split('||')
    this.CreatedArray = this.Created.split('||')
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image('Page_image/back.png')
            .width(25)
            .height(25)
            .onClick(() => {
              AppStorage.setOrCreate('indexMyActivity', 0)
              router.replaceUrl({
                url: 'pages/HomePage'
              });
            })
        }.width('10%')
        .margin({ left: 5 })

        Row() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text('我的活动').fontSize('18fp').padding('20px')
          }
        }.width('80%')

      }.width('100%').height('180px').backgroundColor('#fff5f1f1')

      Refresh({ refreshing: $$this.isRefreshing }) {
        Tabs({ controller: this.tabsController,index:this.index }) {
          TabContent() {
            Column(){
              if (this.Join !== '') {
                List() {
                  ForEach(this.JoinArray, (item: string) => {
                    ListItem() {
                      ActivityItem1({ str: item })
                    }
                  }, (item: string) => item)
                }
                .height('100%')
                .width('100%')
              }
            }
            .height('100%')
            .width('100%')
          }
          .tabBar(this.TabBuilder("我参与的", 0))

          TabContent() {
            Column(){
              if (this.Created !== '') {
                List() {
                  ForEach(this.CreatedArray, (item: string) => {
                    ListItem() {
                      ActivityItem2({ str: item })
                    }
                  }, (item: string) => item)
                }
                .height('100%')
                .width('100%')
              }
            }
            .height('100%')
            .width('100%')
          }
          .tabBar(this.TabBuilder("我创建的", 1))

        }
        .onChange((index) => {
          this.currentIndex = index;
        })
        .scrollable(false)
        .width('100%')
        .height('95%')
      }
      .onRefreshing(() => {
        let activity = new ActivityOption();
        activity.searchJoin(this.Id);
        activity.searchCreated(this.Id)
        setTimeout(() => {
          this.update();
          this.isRefreshing = false
        }, 1000)
      })
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
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