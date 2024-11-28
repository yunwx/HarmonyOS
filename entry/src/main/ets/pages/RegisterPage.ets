import promptAction from '@ohos.promptAction';
import DbService,{  USERINFO } from './DbService';
import router from '@ohos.router';


@Entry
@Component
struct RegisterPage {
  @State confirmPassword: string = '';
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
      Image($r('app.media.back'))
        .width(40)
        .height(40)
        .position({ x: '0%' })
        .margin({top:10})
        .onClick(()=>{
          router.replaceUrl({
            url: 'pages/LoginPage'
          })
        })

      Text("注册")
        .fontSize(50)
        .fontWeight('bold')
        .margin({ top: 170, bottom: 50 });

      Text("海内存知己，天涯若比邻")
        .fontSize(20)
        .fontColor(Color.White)
        .margin({ top: 20 });

      TextInput({ placeholder: '请输入用户名' })
        .maxLength(20)
        .onChange((value) => { this.param.username = value; })
        .width('90%')
        .height(50)
        .padding(10)
        .backgroundColor(Color.White)
        .opacity(0.5)
        .fontColor(Color.Black)
        .margin({ top: 40, bottom: 15 });

      TextInput({ placeholder: '请输入密码' })
        .maxLength(20)
        .onChange((value) => { this.param.password = value; })
        .width('90%')
        .height(50)
        .padding(10)
        .backgroundColor(Color.White)
        .opacity(0.5)
        .margin({ bottom: 15 })
        .fontColor(Color.Black);

      TextInput({ placeholder: '请确认密码'})
        .maxLength(20)
        .onChange((value) => { this.confirmPassword = value; })
        .width('90%')
        .height(50)
        .padding(10)
        .backgroundColor(Color.White)
        .opacity(0.5)
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

    try {
      let db = new DbService()
      const userExists = await db.queryOneByUsername(this.param.username);
      if (userExists.length > 0) {
        promptAction.showToast({ message: '用户名已存在！', duration: 2000 });
        return;
      }
      if(this.param.gender=='man'){
        this.param.avatar_Url='Page_image/man.png'
      }else {
        this.param.avatar_Url='Page_image/woman.png'
      }
      await db.insertUser(this.param);
      promptAction.showToast({ message: '注册成功！', duration: 2000 });
      router.replaceUrl({
        url: 'pages/LoginPage'
      });
    } catch (err) {
      console.error(`Registration failed. Message: ${err.message}`);
      promptAction.showToast({ message: '注册失败，请稍后重试！', duration: 2000 });
    }
  }
}
