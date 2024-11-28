import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import  DbService, { USERINFO }  from './DbService';

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

    // 模拟本地验证逻辑
    try {
      let db = new DbService();

      // 查询用户信息
      let users = await db.queryOneByUsername(this.username);

      if (!users || users.length === 0) {
        // 用户名不存在
        promptAction.showToast({ message: '用户名不存在！', duration: 2000 });
        return;
      }

      const user:USERINFO = users[0];

      // 存储
      AppStorage.setOrCreate('id', user.id);
      AppStorage.setOrCreate('username', user.username);
      AppStorage.setOrCreate('password', user.password);
      AppStorage.setOrCreate('gender', user.gender);
      AppStorage.setOrCreate('avatar_Url', user.avatar_Url);
      AppStorage.setOrCreate('name', user.name);
      AppStorage.setOrCreate('birthday', user.birthday);
      AppStorage.setOrCreate('interests', user.interests);

      if (user.password === this.password) {
        // 登录成功，跳转页面
        router.replaceUrl({
          url: 'pages/HomePage'
        });
      } else {
        // 密码错误
        promptAction.showToast({ message: '密码错误，请重试。', duration: 2000 });
      }
    } catch (err) {
      console.error(`Login failed. Message: ${err.message}`);
      promptAction.showToast({ message: '登录失败，请稍后重试！', duration: 2000 });
    }
  }

  // 注册按钮的逻辑
  private navigateToRegister() {
    router.replaceUrl({
      url: 'pages/RegisterPage'
    });
  }
}
