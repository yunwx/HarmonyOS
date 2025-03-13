import { CommonTitle } from '../model/CommonStyle'
import { router } from '@kit.ArkUI';
import chat, { ActivityOption } from '../model/Network';
import encryptor from '../model/Encryptor';
import recommend from '../model/Recommend';

interface activity {
  str: string;
}

@Entry
@Component
struct ActivityPage {
  @State str: string = ''
  @State Id: string = ''
  @State name: string = ''
  @State category: string = ''
  @State label: string = ''
  @State labelArray: Array<string> = []
  @State description: string = ''
  @State max: string = ''
  @State count: string = ''
  @State likeCount:string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State creatorId:string = ''
  @State creatorName:string = ''
  @State state: boolean = false
  @State State: boolean = false
  @StorageLink('id') ID: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as activity;
    if (params.str) {
      this.str = params.str;
    }
    const array = this.str.split(',')
    this.Id = array[0]
    this.name = array[1]
    this.category = array[2]
    this.label = array[3]
    this.description = array[4]
    this.startTime = array[5]
    this.endTime = array[6]
    this.max = array[9]
    this.creatorId = array[13]
    this.count = array[14]
    this.likeCount = array[15]
    this.creatorName  =array[16]
    this.labelArray = this.label.split(' ')

    recommend.updateUserInterests(this.label,'browse')
    console.log("Interest:",JSON.stringify(recommend.getInterestValues()));

    chat.onMessageReceived = (receivedMessage: string) => {
      console.log("收到的消息:", receivedMessage);

      // 获取当前时间戳
      const timestamp1 = Date.now(); // 当前时间的毫秒数 (Unix 时间戳)
      // 获取当前时间的可读格式 (可选)
      const readableTime = new Date(timestamp1).toLocaleString(); // 格式化为本地时间
      const messageArray: Array<string> = receivedMessage.split('|#|')
      const str = messageArray[0] + '->' + this.ID;
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
    Column({ space: 5 }) {
      CommonTitle({ text: '活动详情' })
      Column() {
        Text(this.name)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 5, bottom: 3 })
        Text(`ID:${this.Id}`)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Gray)
          .margin({ bottom: 5 })
      }
      .height('15%')
      .justifyContent(FlexAlign.Center)
      .backgroundImage('Page_image/activity.jpg')
      .width('100%')

      Column({ space: 10 }) {
        Text('活动信息')
          .fontSize(20)
          .fontWeight('bold')
          .margin({ top: 5 })

        Row() {
          Text('创建者:')
            .fontSize(23)
          Text(this.creatorName)
            .fontSize(23)
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)

        Row() {
          Text('类别:')
            .fontSize(23)
          Text(this.category)
            .fontSize(23)
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)

        Row() {
          Text('参与人数:')
            .fontSize(23)
          Text(`${this.count}/${this.max}`)
            .fontSize(16)
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)

        Row() {
          Text('开始时间:')
            .fontSize(23)
          Text(this.startTime)
            .fontSize(16)
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)

        Row() {
          Text('结束时间:')
            .fontSize(23)
          Text(this.endTime)
            .fontSize(16)
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)

        Text('标签')
          .fontSize(20)
          .fontWeight('bold')
        Row() {
          Grid() {
            ForEach(this.labelArray, (label: string, index) => {
              GridItem() {
                Text(label)
                  .fontSize(15)
                  .fontWeight('medium')
                  .fontColor('#ffffff')
                  .backgroundColor('#ff4c93af')
                  .padding(10)
                  .borderRadius(50)
              }
              .width('25%')
            }, (label: string): string => label)
          }
          .width('100%')
          .height('100%')
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .rowsGap(10)
          .padding(10)
        }
        .width('100%')
        .height('8%')

        Row() {
          List(){
            ListItem(){
              Text(this.description)
                .fontSize(16)
                .lineHeight(22)
            }
          }
          .width('100%')
          .height('100%')
        }
        .height('10%')
        .width('90%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)

        Row() {
          Row(){
            Image(this.state ? 'Page_image/good2.png' : 'Page_image/good1.png')
              .width(25)
              .height(25)
              .onClick(() => {
                if (this.state) {
                  let currentCount = Number(this.likeCount) || 0;
                  this.likeCount = (currentCount - 1).toString();
                  this.state = false
                  let activity = new ActivityOption();
                  activity.unlike(this.Id, this.ID)
                } else {
                  let currentCount = Number(this.likeCount) || 0;
                  this.likeCount = (currentCount + 1).toString();
                  this.state = true
                  let activity = new ActivityOption();
                  activity.like(this.Id, this.ID)
                  recommend.updateUserInterests(this.label,'like')
                  console.log("Interest:",JSON.stringify(recommend.getInterestValues()));
                }
              })
            Text(this.likeCount)
              .fontSize(16)
          }
          Image('Page_image/comments.png')
            .width(25)
            .height(25)
            .onClick(() => {
              setTimeout(() => {
                router.pushUrl({ url: 'pages/CommentsPage',
                  params: {Id:this.Id,label:this.label}
                })
              }, 50);
            })
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')

        Button('参加', { stateEffect: !this.State })
          .backgroundColor(this.State ? Color.Grey : Color.Blue)
          .width('80%')
          .onClick(() => {
            if (this.State) {
              return;
            }
            let activity = new ActivityOption();
            activity.Join(this.Id, this.ID)
            this.State = true;
            recommend.updateUserInterests(this.label,'join')
            console.log("Interest:",JSON.stringify(recommend.getInterestValues()));
          })
      }.backgroundColor('#ffe6ecee')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ffe6ecee')
  }
}