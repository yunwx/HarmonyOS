import { promptAction, router } from "@kit.ArkUI";
import { ActivityOption, NetSearch } from "../model/Network";

interface activity {
  str: string;
}

@Entry
@Component
struct AdminActivityPage {
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
  @State state: boolean = false


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
  }

  build() {
    Column({ space: 5 }) {
      Row(){
        Row(){
          Image('Page_image/back.png')
            .width(25)
            .height(25)
            .onClick(async ()=>{
              let search = new NetSearch()
              await search.SearchActivityAll()
              setTimeout(() => {
                router.replaceUrl({
                  url: 'pages/AdminPage'
                });
              }, 50);
            })
        }.width('10%')
        .margin({left:5})
        Row(){
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
            Text('活动详情').fontSize('18fp').padding('20px')
          }
        }.width('50%')
        Row(){
          Image('Page_image/editor.png')
            .width(25)
            .height(25)
            .margin({right:10})
            .onClick(async ()=>{
              setTimeout(() => {
                router.replaceUrl({
                  url: 'pages/AdminUpdateActivityPage',
                  params: { str: this.str }
                });
              }, 10);
            })

          Image('Page_image/clear.png')
            .width(25)
            .height(25)
            .onClick(async ()=>{
              let activity = new ActivityOption();
              activity.deleteActivity(this.Id)
              let search = new NetSearch()
              await search.SearchActivityAll()
              setTimeout(() => {
                router.replaceUrl({
                  url: 'pages/AdminPage'
                });
              }, 300);
            })
        }.width('20%')
        .margin({left:80})
      }.width('100%').height('180px').backgroundColor('#fff5f1f1')
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
          Text(`${this.count}/${this.max}`)
            .fontSize(16)
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
              Text(this.description)
                .fontSize(16)
                .lineHeight(22)
            }
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

        Button(this.status=='inactive'?'解封':this.status=='active'?'封禁':'通过', { stateEffect: !this.state })
          .backgroundColor(this.state ? Color.Grey : Color.Blue)
          .width('80%')
          .onClick(() => {
            if (this.state) {
              return;
            }
            let activity = new ActivityOption();
            if(this.status=='active'){
              activity.updateActivityStatus(this.Id,"inactive");
              this.status='inactive'
            }else {
              activity.updateActivityStatus(this.Id,"active");
              if(this.status=='decide'){
                this.state = true;
              }else {
                this.status='active'
              }
            }
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