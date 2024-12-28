import { promptAction, router } from "@kit.ArkUI";
import validator from '../model/ContentValidator';
import encryptor from '../model/Encryptor';
import chat, { ActivityOption } from "../model/Network";

interface activity {
  str: string;
}

@Entry
@Component
struct MyActivityPage2 {
  @State str: string = ''
  @State Id: string = ''
  @State name: string = ''
  @State category: string = ''
  @State label: string = ''
  @State labels: string = '';
  @State labelArray: Array<string> = []
  @State description: string = ''
  @State max: string = ''
  @State count: string = ''
  @State likeCount:string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State creatorId:string = ''
  @State creatorName:string = ''
  @State status:string = ''
  @StorageLink('id') ID: string = ''
  private selectedDate1: Date = new Date();
  private selectedDate2: Date = new Date();
  @State date1:number = 0
  @State date2:number = 0

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
    this.status = array[12]
    this.creatorId = array[13]
    this.count = array[14]
    this.likeCount = array[15]
    this.creatorName = array[16]
    this.labelArray = this.label.split(' ')
    this.date1 = new Date(this.startTime.replace(" ", "T")).getTime()
    this.date2 = new Date(this.endTime.replace(" ", "T")).getTime()

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
      Row(){
        Row(){
          Image('Page_image/back.png')
            .width(25)
            .height(25)
            .onClick(()=>{
              router.replaceUrl({
                url: 'pages/MyActivityPage'
              });
            })
        }.width('10%')
        .margin({left:5})
        Row(){
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text('活动详情').fontSize('18fp').padding('20px')
          }
        }.width('80%')
        Row(){
          Image('Page_image/clear.png')
            .width(25)
            .height(25)
            .onClick(()=>{
              let activity = new ActivityOption();
              activity.deleteActivity(this.Id)
              activity.searchCreated(this.ID)
              setTimeout(() => {
                router.replaceUrl({
                  url: 'pages/MyActivityPage'
                });
              }, 300);
            })
        }.width('10%')
      }.width('100%').height('180px').backgroundColor('#fff5f1f1')
      Column() {
        TextInput({text:this.name})
          .fontSize(25)
          .maxLength(10)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 5, bottom: 3 })
          .width('60%')
          .onChange((value)=>{
            this.name=value;
          })
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

      Column({ space: 4 }) {
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
          Row(){
            Text(`${this.count}/`)
              .fontSize(16)
            TextInput({text:this.max})
              .fontSize(16)
              .width('20%')
              .onChange((value)=>{
                this.max=value
              })
          }

        }
        .onClick(async ()=>{
          let activity = new ActivityOption();
          await activity.searchParticipants(this.Id);
          setTimeout(() => {
            router.pushUrl({
              url: 'pages/ParticipantsPage',
              params: {activityId:this.Id}
            });
          }, 200)
        })
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
        .onClick(() => {
          DatePickerDialog.show({
            start: new Date(),
            end: new Date("2026-1-1"),
            selected: this.selectedDate1,
            showTime:true,
            useMilitaryTime:true,
            onDateAccept: (value: Date) => {
              this.selectedDate1 = value
              this.date1 = value.getTime()
              this.startTime = this.formatDate(value);
              console.info("DatePickerDialog:onDateAccept()" + value.toString())
            },
            onCancel: () => {
              console.info("DatePickerDialog:onCancel()")
            }
          })
        })
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
        .onClick(() => {
          DatePickerDialog.show({
            start: new Date(this.selectedDate1),
            end: new Date("2026-1-1"),
            selected: this.selectedDate2,
            showTime:true,
            useMilitaryTime:true,
            onDateAccept: (value: Date) => {
              this.selectedDate2 = value
              this.date2 = value.getTime()
              this.endTime = this.formatDate(value);
              console.info("DatePickerDialog:onDateAccept()" + value.toString())
            },
            onCancel: () => {
              console.info("DatePickerDialog:onCancel()")
            },
            onDateChange: (value: Date) => {
            }
          })
        })
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)

        Row() {
          Text('活动状态:')
            .fontSize(23)
          Text(this.status=='active'?'正常':this.status=='decide'?'审核中':'封禁')
            .fontSize(23)
            .fontColor(this.status=='active'?"#ff08ae3c":this.status=='decide'?Color.Black:Color.Red)
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
              TextArea({ text:this.description })
                .fontSize(16)
                .maxLength(200)
                .showCounter(true, { thresholdPercentage: 50, highlightBorder: true })//计数器
                .onChange((value: string) => {
                  this.description = value;
                });
            }
            .width('100%')
            .height('100%')
          }
          .width('100%')
          .height('100%')
        }
        .borderRadius(10)
        .height('8%')
        .width('90%')
        .margin({top:5})
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.White)

        Row() {
          Row(){
            Image('Page_image/good1.png')
              .width(25)
              .height(25)
            Text(this.likeCount)
              .fontSize(16)
          }
          Image('Page_image/comments.png')
            .width(25)
            .height(25)
            .onClick(() => {
              setTimeout(() => {
                router.pushUrl({ url: 'pages/CommentsPage',
                  params: {Id:this.Id}
                })
              }, 50);
            })
        }
        .margin({top:5})
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')

        Button('修改')
          .backgroundColor(Color.Blue)
          .width('80%')
          .onClick(() => {
            if(this.name==''){
              promptAction.showToast({ message: '活动名不能为空！', duration: 2000 });
              return;
            }
            if (!validator.isContentValid(this.name)) {
              promptAction.showToast({ message: '活动名中存在违禁词！', duration: 2000 });
              return;
            }
            if(Number(this.max)<Number(this.count)){
              promptAction.showToast({ message: '最大参与人数不能低于已参加人数！', duration: 2000 });
              return;
            }
            if(this.date2 < this.date1){
              promptAction.showToast({ message: '结束时间需要大于开始时间！', duration: 2000 });
              return;
            }
            if (!validator.isContentValid(this.description)) {
              promptAction.showToast({ message: '活动描述中存在违禁词！', duration: 2000 });
              return;
            }
            this.labels = this.labelArray.join(' ');
            let activity = new ActivityOption();
            activity.updateActivity(this.Id,this.name,this.category,this.labels,this.description,this.startTime,this.endTime,this.max,this.creatorId)
            activity.searchCreated(this.ID)
          })
      }.backgroundColor('#ffe6ecee')
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ffe6ecee')
  }
  // 格式化日期的函数
  formatDate(date: Date): string {
    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 补零两位
    const day = date.getDate().toString().padStart(2, '0'); // 补零两位
    const hour = date.getHours().toString().padStart(2, '0'); // 补零两位
    const minute = date.getMinutes().toString().padStart(2, '0'); // 补零两位
    const second = date.getSeconds().toString().padStart(2, '0'); // 补零两位

    return `${year}/${month}/${day} ${hour}:${minute}:${second}`;
  }
}