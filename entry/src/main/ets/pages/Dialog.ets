import { Hobbies } from "../model/Hobbies";
import { promptAction } from "@kit.ArkUI";
import { USERINFO } from "./DbService";
import { UpdateNet } from "../model/UpdateNet";



@CustomDialog
export struct DataDialog {
  @State object: string ='';
  @State data: string ='';
  controller?: CustomDialogController;
  onDataSelected?: (data: string) => void; // 添加回调函数，传递数据给调用者

  build() {
    Column() {
      Column() {
        Text(`请输入新的${this.object}`)
          .fontSize(16)
          .margin({ top:10,bottom: 10 });

        TextInput({ placeholder: `新${this.object}` })
          .onChange((value: string) => {
            this.data = value;
          })
          .width('90%')
          .backgroundColor("#F5F5F5")
          .padding(10)
          .borderRadius(20)
          .margin({ top:10,bottom: 10 });
        Row({ space: 30 }) {
          Button("取消")
            .onClick(() => {
              this.controller?.close();
            })
            .backgroundColor('#ffc6c6c6')
          Button("确认")
            .onClick(() => {
              if(this.object=='性别' && this.data!='男' && this.data!='女'){
                promptAction.showToast({ message: '请输入男或女', duration: 2000 })
                return;
              }
              let update = new UpdateNet()
              if(this.object=='性别'){
                if(this.data=='男'){
                  update.updateGender('man')
                }else {
                  update.updateGender('woman')
                }
              }else {
                update.updateName(this.data)
              }
              if (this.onDataSelected) {
                this.onDataSelected(this.data); // 通过回调函数传递数据
              }
              this.controller?.close()
            });
        }
        .margin({ bottom: 10 });
      }
    }
  }
}

@CustomDialog
export struct HobbiesDialog {
  @State selectedInterests: Array<string> = [];
  @State Interests: string ='';
  controller?: CustomDialogController;
  onDataSelected?: (data: Array<string>) => void;

  build() {
    Column() {
      Column() {
        Text('请选择兴趣')
          .fontSize(16)
          .margin({ top:10,bottom: 10 });
        Row(){
          Hobbies({
            selectedInterests:this.selectedInterests,
            onInterestsChange: (selectedInterests: Array<string>) => {
              this.selectedInterests = selectedInterests; // 更新父组件中的兴趣列表
              this.Interests = this.selectedInterests.join(' ')
              console.log('Selected interests:', this.selectedInterests); // 打印选中的兴趣
            }
          })
        }.height('70%')
        Row({ space: 30 }) {
          Button("取消")
            .onClick(() => {
              this.controller?.close();
            })
            .backgroundColor('#ffc6c6c6')
          Button("确认")
            .onClick(() => {
              if(this.Interests.length==0){
                promptAction.showToast({ message: '至少选择一个兴趣！', duration: 2000 });
                return;
              }

              let update = new UpdateNet()
              update.updateInterests(this.Interests)
              if (this.onDataSelected) {
                this.onDataSelected(this.selectedInterests); // 通过回调函数传递数据
              }
              this.controller?.close()
            });
        }
        .margin({ top:10 ,bottom: 10 });
      }
    }
  }
}

@CustomDialog
export struct HomeDialog {
  controller?: CustomDialogController;
  @State param :USERINFO = {
    id: null,
    username: '',
    password: '',
    gender: '',
    avatar_Url: '',
    name: '',
    birthday: '',
    interests: ''
  }
  @State isLunar: boolean = false;
  @StorageLink('birthday') birthday: string = '';
  @StorageLink('name') name: string = '';
  @State selectedInterests: Array<string> = [];
  @StorageLink('interests') Interests: string = '';
  @State ID: number |undefined = AppStorage.get('id');
  @State username: string |undefined = AppStorage.get('username');
  @State password: string |undefined = AppStorage.get('password');
  @State gender: string |undefined = AppStorage.get('gender');
  @State avatar_Url: string |undefined = AppStorage.get('avatar_Url');
  private selectedDate: Date = new Date();

  build() {
    Column({ space: 10 }) {
      Text('请完善信息')
        .fontSize(20)
        .fontWeight('bold')
        .margin({ top: 5 });
      Row() {
        Text('昵称:')
        TextInput({ placeholder: '请输入昵称'})
          .maxLength(12)
          .onChange((value) => { this.name = value; })
          .width('100%')
          .height(50)
          .padding(10)
          .backgroundColor(Color.White)
          .opacity(0.5)
          .fontColor(Color.Black);
      }
      .width('80%')

      Row() {
        Text('出生日期:');
        TextInput({
          placeholder: '请选择出生日期',
          text: this.birthday // 绑定 birthday
        })
          .maxLength(20)
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
              }
            })
          })
          .width('100%')
          .height(50)
          .padding(10)
          .backgroundColor(Color.White)
          .opacity(0.5)
          .fontColor(Color.Black);
      }.width('80%');

      Text('请选择兴趣');
      Row() {
        Hobbies({
          onInterestsChange: (selectedInterests: Array<string>) => {
            this.selectedInterests = selectedInterests; // 更新父组件中的兴趣列表
            this.Interests = this.selectedInterests.join(' ')
            console.log('Selected interests:', this.selectedInterests); // 打印选中的兴趣
          }
        });
      }.height('50%');

      /*Text(this.Interests)// 显示选中的兴趣
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ top: 10 });
        */

      Button('确定')
        .margin({ top: 30, bottom: 30 })
        .onClick(() => {
          this.Update()
          this.controller?.close()
        });
    }
  }
  private async Update(){

    if(this.name.length==0){
      promptAction.showToast({ message: '请输入昵称！', duration: 2000 });
      return;
    }else if (this.birthday.length == 0) {
      promptAction.showToast({ message: '请选择生日！', duration: 2000 });
      return;
    } else if (this.Interests.length == 0) {
      promptAction.showToast({ message: '至少选择一个兴趣！', duration: 2000 });
      return;
    }
    let update = new UpdateNet()
    update.updateOne(this.name,this.birthday,this.Interests)

      /*let update = new UpdateMe()
      update.updateOne(this.name,this.birthday,this.Interests)
      this.controller!.close();*/

  }
}

