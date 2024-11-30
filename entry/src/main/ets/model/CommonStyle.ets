import { DataDialog, HobbiesDialog } from "../pages/Dialog"
import { UpdateMe } from "./UpdateMe"

@Component
export struct Title {
  @StorageLink('name') name: string = ''
  @StorageLink('avatar_Url') head: string = ''

  build() {
    Row() {
      // 图片部分
      Column() {
        Image(this.head)
          .borderRadius(50)
      }
      .height(60)
      .width(60)
      .borderRadius(50)
      .borderColor("#A9A9A9")
      .borderWidth(3)

      Text(this.name)
        .fontSize('18fp')
        .fontWeight('bold')
    }.width('100%').height('180px').backgroundColor('#fff5f1f1')
  }
}

@Component
export struct ME {
  @StorageLink('name') name: string = ''
  @StorageLink('avatar_Url') head: string = ''
  @StorageLink('birthday') birthday: string = ''
  @StorageLink('gender') gender: string = ''
  @StorageLink('interests') interests: string = ''
  @State interestsArray: Array<string> = this.interests.split(' ')
  @State ID: number | undefined = AppStorage.get('id');
  @State object: string = ''
  private selectedDate: Date = new Date();

  dialogController: CustomDialogController = new CustomDialogController({
    builder: DataDialog({
      object: this.object,
      onDataSelected: (data: string) => {
        if (this.object == '姓名') {
          this.name = data;
        }
        if (this.object == '性别') {
          if(data=='男'){
            this.gender = 'man';
          }else {
            this.gender = 'woman';
          }
        }
      }
    }),
    autoCancel: false
  })

  HobbiesDialogController: CustomDialogController = new CustomDialogController({
    builder: HobbiesDialog({
      selectedInterests:this.interestsArray,
      onDataSelected: (data: Array<string>) => {
        this.interestsArray = data
      }
    }),
    autoCancel: false
  })

  build() {
    Column({ space: 10 }) {
      Row() {
        Column() {
          Image(this.head).borderRadius(50)
        }
        .height(100)
        .width(100)
        .borderRadius(50)
        .borderColor("#A9A9A9")
        .borderWidth(3)

        Column() {
          Row() {
            Text(this.name)
              .fontSize(28)
              .fontWeight('bold')
              .onClick(() => {
                this.object='姓名'
                this.dialogController.open()
              })
          }

          Row() {
            Text(`ID:${this.ID}`).fontSize(18).fontColor('white').fontWeight('bold')
          }
          .width(100)
          .height(40)
          .justifyContent(FlexAlign.Center)
          .margin({ top: 10 })
          .borderRadius(20)
          .linearGradient({
            angle: 90,
            colors: [
              ["#FFA000", 0.0],
              ["#FFB300", 0.3],
              ["#FFC107", 0.6],
              ["#FFD700", 1.0]
            ]
          })
        }.height(90).margin({ left: 10 })

        Row() {
          Image($r('app.media.setting')).width(25).height(25)

        }
        .borderRadius(20)
        .borderWidth(1)
        .borderColor("#D3D3D3")
        .padding(5)
        .position({ x: '100%' })
        .markAnchor({ x: 40 })
        .onClick(() => {

        })
      }.width('90%')
      .margin(10)


      Column({ space: 20 }) {
        Text('个人信息')
          .fontSize(20)
          .fontWeight('bold')
          .margin({ top: 10 })
        Row() {
          Text('出生日期:')
            .fontSize(23)
          Text(this.birthday)
            .fontSize(23)
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)
        .onClick(() => {
          DatePickerDialog.show({
            start: new Date("2000-1-1"),
            end: new Date(),
            selected: this.selectedDate,
            onDateAccept: (value: Date) => {
              // 将日期部分的时间归零，避免时区影响
              const localDate = new Date(value);
              localDate.setHours(0, 0, 0, 0);  // 设置为当天的零点时刻
              this.selectedDate = localDate
              console.info("DatePickerDialog:onDateAccept()" + value.toString())
            },
            onCancel: () => {
              console.info("DatePickerDialog:onCancel()")
            },
            onDateChange: (value: Date) => {
              const localDate = new Date(value);
              this.birthday = `${localDate.getFullYear()}-${(localDate.getMonth() + 1).toString().padStart(2, '0')}-${localDate.getDate().toString().padStart(2, '0')}`;
              let update = new UpdateMe()
              update.updateBirthday(this.birthday)
            }
          })
        })

        Row() {
          Text('性别:')
            .fontSize(23)
          if (this.gender == 'man') {
            Text('男')
              .fontSize(23)
          } else {
            Text('女')
              .fontSize(23)
          }
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)
        .onClick(() => {
          this.object='性别'
          this.dialogController.open()
        })
        Row(){
          Text('兴趣爱好')
            .fontSize(20)
          Image($r('app.media.add'))
            .width(25)
            .height(25)
            .position({ x: '50%' })
            .onClick(()=>{
              this.HobbiesDialogController.open()
            })
        }

        Row() {
          Grid() {
            ForEach(this.interestsArray, (interest: string, index) => {
              GridItem() {
                Text(interest)
                  .fontSize(20)
                  .fontWeight('medium')
                  .fontColor('#ffffff')
                  .backgroundColor('#ff4c93af')
                  .padding(10)
                  .borderRadius(50)
                  .onClick(() => {
                    console.log(`${interest} clicked`);
                  })
              }
            }, (interest: string): string => interest)
          }
          .width('100%')
          .height('50%')
          .columnsTemplate('1fr 1fr 1fr')
          .rowsGap(10) //行间距
          .padding(10)
        }

      }.width('100%').height('100%').backgroundColor('#ffe6ecee')

    }.width('100%')
    .height('100%')
  }
}
