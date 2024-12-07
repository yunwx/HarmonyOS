import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import  DbService, { USERINFO }  from '../SQLite/DbService';
import socket from '@ohos.net.socket';
import util from '@ohos.util';
import { Address } from '../model/Send';
import { LoginAndRegister } from '../model/Network';


@Entry
@Component
struct LoginPage {
  @State username: string = ''
  @State password: string = ''


  build() {
    Column() {
      Column(){
        Image($r('app.media.logo'))
          .width(94)
          .height(94)
          .margin(12)
        Text("知心")
          .fontSize(50)
          .fontWeight('bold')
          .margin({top:10,bottom:30})
        Text("人之相识，贵在相知")
          .fontSize(18)
          .fontColor(Color.Gray)
        Text("人之相知，贵在知心")
          .fontSize(18)
          .fontColor(Color.Gray)
      }
      .margin({top:80})
      .width('100%')
      .height('30%')


        TextInput({ placeholder: '请输入用户名' })
          .maxLength(20)
          .onChange((value) => {
            this.username = value;
          })
          .margin({ top: 70, bottom: 15 })
          .width('90%')
          .height(50)
          .padding(10)
          .backgroundColor(Color.White)
          .opacity(0.5)
          .fontColor(Color.Black)

        // 密码输入框
        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)
          .maxLength(20)
          .onChange((value) => {
            this.password = value;
          })
          .margin({ bottom: 30 })
          .width('90%')
          .height(50)
          .padding(10)
          .backgroundColor(Color.White)
          .opacity(0.5)
          .fontColor(Color.Black)

        Button("登录")
          .onClick(() => this.handleLogin())
          .fontSize(20)
          .fontColor(Color.White)
          .width('90%')
          .height(50)
          .margin({ bottom: 15 })

        Text('没有账号？马上注册')
          .fontSize(14)
          .fontColor(Color.Blue)
          .margin({ top: 12 })
          .onClick(() => this.navigateToRegister())


    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundImage($r('app.media.login')).backgroundImageSize({height:'100%',width:'100%'})
  }

  // 登录按钮的逻辑（本地验证）
  private async handleLogin() {
    if (!this.username || !this.password) {
      promptAction.showToast({message:'用户名和密码不能为空！',duration:2000})
      return;
    }
    let login = new LoginAndRegister()
    login.Login(this.username,this.password)
  }

  // 注册按钮的逻辑
  private navigateToRegister() {
    router.replaceUrl({
      url: 'pages/RegisterPage'
    });
  }
}
