import promptAction from '@ohos.promptAction';
import DbService,{  USERINFO } from '../SQLite/DbService';
import router from '@ohos.router';
import socket from '@ohos.net.socket';
import util from '@ohos.util';
import { Address } from '../model/Send';
import { LoginAndRegister } from '../model/Network';



@Entry
@Component
struct RegisterPage {
  @State confirmPassword: string = '';
  @State warn1: string = '';
  @State warn2: string = '';
  @State param :USERINFO = {
    id: null,
    username: '',
    password: '',
    gender: 'man',
    avatar_Url: '',
    name: '',
    birthday: '',
    interests: ''
  }
  build() {
    Column() {
      Image("Page_image/back.png")
        .width(30)
        .height(30)
        .position({ x: '0%' })
        .margin({top:5})
        .onClick(()=>{
          router.replaceUrl({
            url: 'pages/LoginPage'
          })
        })

      Text("注册")
        .fontSize(50)
        .fontWeight('bold')
        .margin({ top: 150, bottom: 50 });

      Text("海内存知己，天涯若比邻")
        .fontSize(20)
        .fontColor(Color.White)
        .margin({ top: 20 });

      TextInput({ placeholder: '请输入用户名' })
        .maxLength(20)
        .onChange((value) => {
          const usernameRegex = /^[A-Za-z0-9]{8,16}$/; // 只允许字母和数字的正则表达式
          if (!usernameRegex.test(value)) {
            this.warn1 = '用户名只能包含字母和数字，且长度为8-16位！'
            return;
          }
          this.warn1 = ''
          this.param.username = value;
        })
        .width('90%')
        .height(50)
        .padding(10)
        .backgroundColor(Color.White)
        .opacity(0.5)
        .fontColor(Color.Black)
        .margin({ top: 40});

      Text(this.warn1)
        .fontColor(Color.White)
        .fontSize(14)

      TextInput({ placeholder: '请输入密码' })
        .maxLength(20)
        .onChange((value) => {
          const passwordRegex = /^[A-Za-z0-9!@#$%^&*()_+={}\[\]\\|;:'",<>\./?`~\-]{8,20}$/;// 密码规则正则表达式：允许字母、数字和特殊字符，长度为 8 到 20
          if (!passwordRegex.test(value)) {
            this.warn2 = '密码只能包含字母、数字和特殊字符，且长度为8-20位！'
            return;
          }
          this.warn2 = ''
          this.param.password = value;
        })
        .width('90%')
        .height(50)
        .padding(10)
        .backgroundColor(Color.White)
        .opacity(0.5)
        .margin({ top: 15 })
        .fontColor(Color.Black);

      Text(this.warn2)
        .fontColor(Color.White)
        .fontSize(14)

      TextInput({ placeholder: '请确认密码'})
        .maxLength(20)
        .onChange((value) => {
          const passwordRegex = /^[A-Za-z0-9!@#$%^&*()_+={}\[\]\\|;:'",<>\./?`~\-]{8,20}$/;
          if (!passwordRegex.test(value)) {
            return;
          }
          this.confirmPassword = value;
        })
        .width('90%')
        .height(50)
        .padding(10)
        .backgroundColor(Color.White)
        .opacity(0.5)
        .margin({ top: 15 })
        .fontColor(Color.Black);

      Row(){
        Text('性别:')
          .fontSize(20)
          .fontWeight('bold')
          .fontColor(Color.White);
        Row(){
          Text('男')
          Radio({ value: '男', group: 'radioGroup' }).checked(true)
            .onChange((isChecked: boolean) => {
              if(isChecked) {

              }
            })
          Text('女')
          Radio({ value: '女', group: 'radioGroup' })
            .onChange((isChecked: boolean) => {
              if(isChecked) {
                this.param.gender = 'woman'
              }
            })
        }.margin({left:20})
      }.width('90%')
      .margin({ top: 20 });

      Button("注册")
        .onClick(() => this.handleRegister())
        .width('90%')
        .height(50)
        .fontSize(18)
        .fontColor(Color.White)
        .margin({ top: 20 });
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.register'))
    .backgroundImageSize({ height: '100%',width:'100%' });
  }

  private async handleRegister() {
    if (this.param.password !== this.confirmPassword) {
      promptAction.showToast({ message: '两次密码输入不一致！', duration: 2000 });
      return;
    }
    if(this.param.gender=='man'){
      this.param.avatar_Url='Page_image/man.png'
    }else {
      this.param.avatar_Url='Page_image/woman.png'
    }
    let login = new LoginAndRegister()
    login.Register(this.param.username,this.param.password,this.param.gender,this.param.avatar_Url,this.param.name,this.param.birthday,this.param.interests)
  }
}
