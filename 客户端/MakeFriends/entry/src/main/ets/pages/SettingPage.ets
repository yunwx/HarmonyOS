import { router } from '@kit.ArkUI'
import { PasswordDialog } from '../model/Dialog'
import chat from '../model/Network'

@Entry
@Component
struct SettingPage {

  PasswordDialogController: CustomDialogController = new CustomDialogController({
    builder: PasswordDialog(),
    autoCancel: false
  })

  build() {
    Column(){
      Row() {
        Row() {
          Image('Page_image/back.png')
            .width(25)
            .height(25)
            .onClick(() => {
              router.back();
            })
        }.width('10%')
        .margin({ left: 5 })

        Row() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text('设置').fontSize('18fp').padding('20px')
          }
        }.width('80%')
      }.width('100%').height('180px').backgroundColor('#fff5f1f1')

      Row() {
          Row() {
            Image('Page_image/password.png')
              .width(30)
              .height(30)
            Text('修改密码').fontSize(20)
          }
          Row() {
            Image('Page_image/right.png')
              .width(20)
              .height(20)
          }
      }
      .borderRadius(10)
      .padding(10)
      .justifyContent(FlexAlign.SpaceBetween)
      .height('7%')
      .width('90%')
      .margin({top:10})
      .backgroundColor(Color.White)
      .onClick(()=>{
        this.PasswordDialogController.open()
      })

      Button('退出登录')
        .margin({top:500})
        .width('90%')
        .onClick(()=>{
          chat.disconnect();
          AppStorage.setOrCreate('index', 0)
          router.replaceUrl({
            url: 'pages/LoginPage'
          });
        })
    }
    .backgroundColor('#fff5f1f1')
  }
}