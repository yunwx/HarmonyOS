import { DataDialog, HobbiesDialog } from "./Dialog"
import { UpdateMe } from "./UpdateMe"
import { promptAction, router } from "@kit.ArkUI"
import { FriendOption, NetSearch, UpdateNet } from "./Network"

@Component
export struct Title {
  @StorageLink('name') name: string = ''
  @StorageLink('avatar_Url') head: string = ''

  build() {
    Row() {
      Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems: ItemAlign.Center  }) {
        Row(){
          Column() {
            Image(this.head)
              .borderRadius(50)
          }
          .height(50)
          .width(50)
          .borderRadius(50)
          .borderColor("#A9A9A9")
          .borderWidth(3)
          Text(this.name)
            .fontSize('18fp')
            .fontWeight('bold')
            .margin({left:10})
        }
        Row(){
          Image("Page_image/add.png")
            .width(30)
            .height(30)
            .onClick(()=>{
              router.pushUrl({
                url: 'pages/SearchPage'
              });
            })
        }
      }
      .padding(10)
      .width('100%')

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
              let update = new UpdateNet()
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


@Component
export struct ChatTitle {
  @State text: string = ''

  build() {
    Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(this.text).fontSize('18fp').padding('20px')
    }.height('160px').backgroundColor('#fff5f1f1')
  }
}

@Component
export struct CommonTitle {
  @State text: string = ''

  build() {
    Row(){
      Row(){
        Image('Page_image/back.png')
          .width(25)
          .height(25)
          .onClick(()=>{
            router.replaceUrl({
              url: 'pages/HomePage'
            });
          })
      }.width('10%')
      Row(){
        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text(this.text).fontSize('18fp').padding('20px')
        }
      }.width('80%')

    }.width('100%').height('160px').backgroundColor('#fff5f1f1')
  }
}

@Component
export struct CommonTitle1 {
  @State text: string = ''

  build() {
    Row(){
      Row(){
        Image('Page_image/back.png')
          .width(25)
          .height(25)
          .onClick(()=>{
            router.back({
              url: 'pages/HomePage'
            });
          })
      }.width('10%')
      Row(){
        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text(this.text).fontSize('18fp').padding('20px')
        }
      }.width('80%')

    }.width('100%').height('160px').backgroundColor('#fff5f1f1')
  }
}

@Component
export struct ContactItem {
  @State image: string =''
  @State text: string = ''

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
        Image(this.image).width('100px').height('100px').margin({ left: '50px' })
        Text(this.text).fontSize('15vp').margin({ left: '40px' }).flexGrow(1)
      }
      .height('150px')
      .width('100%')

      Row() {
        Text().width('190px').height('3px')
        Divider()
          .vertical(false)
          .color('#ffe2dfdf')
          .strokeWidth('3px')
      }
      .height('3px')
      .width('100%')
    }
  }
}

@Component
export struct NewFriendsItem {
  @StorageLink('NewFriends') NewFriend: string = ''
  @State str:string = ''
  @State image: string =''
  @State name: string = ''
  @State Username:string = ''
  @State state:boolean = false

  aboutToAppear(): void {
    if(this.NewFriend==''){
      return;
    }
    let arr = this.NewFriend.split(',');
    arr.splice(-3);
    this.str = arr.join(',');
  }

  build() {
    Column() {
      Row() {
        Text().width('100%').height('3px')
        Divider()
          .vertical(false)
          .color('#ff000000')
          .strokeWidth('3px')
      }
      .height('3px')
      .width('100%')
      Row(){
        Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems: ItemAlign.Center  }) {
          Row(){
            Image(this.image).width('100px').height('100px').margin({ left: '50px' })
            Text(this.name).fontSize('15vp').margin({ left: '40px' }).flexGrow(1)
          }
          .height('194px')
          .width('50%')
          Row(){
            Button('拒绝',{ stateEffect: !this.state })
              .width('15%')
              .backgroundColor(this.state?Color.Grey:Color.Blue)
              .height(30)
              .margin({right:10})
              .onClick(()=>{
                if (this.state){
                  return;
                }
                AppStorage.set('NewFriends',this.str)
                this.state=true;
                let friend = new FriendOption()
                friend.RejectFriend(this.Username)
              });

            Button('添加',{ stateEffect: !this.state })
              .width('15%')
              .backgroundColor(this.state?Color.Grey:Color.Blue)
              .height(30)
              .onClick(()=>{
                if (this.state){
                  return;
                }
                AppStorage.set('NewFriends',this.str)
                this.state=true;
                let friend = new FriendOption()
                friend.ConfirmFriend(this.Username)
              });
          }
        }
      }
      Row() {
        Text().width('100%').height('3px')
        Divider()
          .vertical(false)
          .color('#ff000000')
          .strokeWidth('3px')
      }
      .height('3px')
      .width('100%')
    }
    .width('100%').height('200px').backgroundColor('#ffeae9e9')
  }
}

@Component
export struct SearchItem {
  @State image: string =''
  @State text: string = ''
  @State Username:string = ''
  @State state:boolean = false

  build() {
    Column() {
      Row() {
        Text().width('100%').height('3px')
        Divider()
          .vertical(false)
          .color('#ff808080')
          .strokeWidth('3px')
      }
      .height('3px')
      .width('100%')
      Row(){
        Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems: ItemAlign.Center  }) {
          Row(){
            Image(this.image).width('100px').height('100px').margin({ left: '50px' })
            Text(this.text).fontSize('15vp').margin({ left: '40px' }).flexGrow(1)
          }
          .height('194px')
          .width('80%')
          Row(){
            Button('添加',{ stateEffect: !this.state })
              .width('20%')
              .height(30)
              .backgroundColor(this.state?Color.Grey:Color.Blue)
              .onClick(()=>{
                if (this.state){
                  return;
                }
                this.state=true;
                let friend = new FriendOption()
                friend.AddFriend(this.Username)
                });
              }
          }
      }
        Row() {
          Text().width('100%').height('3px')
          Divider()
            .vertical(false)
            .color('#ff808080')
            .strokeWidth('3px')
        }
        .height('3px')
        .width('100%')
      }
    .width('100%').height('200px').backgroundColor('#fff5f1f1')
  }
}

@Component
export struct ChatItem {
  @State Id:string = ''
  @State image: string = ''
  @State name: string = ''
  @State username: string = ''
  @State content:string = ''
  @State time:string = ''
  @State timeArray:Array<string> = []

  aboutToAppear(): void {
    this.timeArray = this.time.split(',')
  }

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Image(this.image).width('120px').height('120px').margin({ left: '50px', right: "50px" })

        Column() {
          Text(this.name).fontSize('16fp')
          Text(this.content).fontSize('12fp').width('620px').fontColor("#c2bec2").maxLines(1)
        }.alignItems(HorizontalAlign.Start).flexGrow(1)
        Column(){
          Text(this.timeArray[0]).fontSize('12fp')
            .fontColor("#c2bec2")
          Text(this.timeArray[1]).fontSize('12fp')
            .margin({ top: "5px" }).fontColor("#c2bec2")
        }.margin({ right: "40px" })

      }
      .height('180px')
      .width('100%')

      Row() {
        Text().width('190px').height('3px')
        Divider()
          .vertical(false)
          .color('#ffe2dfdf')
          .strokeWidth('3px')
      }
      .height('3px')
      .width('100%')
    }.onClick(() => {
      setTimeout(() => {
        router.replaceUrl({ url: 'pages/ChatPage',
          params: { id:this.Id,username:this.username ,name: this.name ,image:this.image}
        })
      }, 50);

    })
  }
}

export interface Friend {
  id:string
  Username: string;
  name: string;
  avatar_Url: string
}

@Component
export struct ContactPage {
  @StorageLink('friends') friends: string = ''
  @State friend:Friend[] = []
  @State friendName: string = ''
  @State search: string = ''

  aboutToAppear(): void {
    this.updateFriendsList();
  }

  onPageShow(): void {
    this.updateFriendsList();
  }


  updateFriendsList(): void {
    this.friend = [];
    if (this.friends.length == 0) {
      return;
    }
    const friendsArray: Array<string> = this.friends.split(',');
    for (let i = 0; i < friendsArray.length; i += 4) {
      const newFriend: Friend = {
        id:friendsArray[i],
        Username: friendsArray[i + 1],
        name: friendsArray[i + 2] || '',
        avatar_Url: friendsArray[i + 3] || '',
      };
      this.friend.push(newFriend);
    }
  }


  build() {
    Column() {
      Title()
      Scroll() {
        Column() {
          Row() {
            Search({placeholder: '搜索好友...'})
              .searchButton('搜索')
              .width('90%')
              .height(40)
              .backgroundColor(Color.White)
              .placeholderColor(Color.Grey)
              .placeholderFont({ size: 14, weight: 400 })
              .textFont({ size: 14, weight: 400 })
              .onSubmit((value: string) => {

              })
              .onChange((value: string) => {
                this.search = value;
              })
              .margin(20)
          }
          .backgroundColor('#fff5f1f1')
          .padding(10)
          .align(Alignment.Top)

          Text("      推荐").fontSize('12fp').backgroundColor('#fff5f1f1').height('80px').width('100%')

          Row(){
            Flex({ justifyContent: FlexAlign.SpaceBetween,alignItems: ItemAlign.Center  }) {
              Row(){
                Text("    新朋友").fontSize('15fp').backgroundColor(Color.White)
              }
              Row(){
                Image('Page_image/right.png')
                  .width(20)
                  .height(20)
              }
            }
          }.height('100px').width('100%')
          .onClick(()=>{
            AppStorage.setOrCreate('index',1)
            router.replaceUrl({
              url: 'pages/NewFriendsPage'
            });
          })


          Text("      我的好友").fontSize('12fp').backgroundColor('#fff5f1f1').height('80px').width('100%')
          List() {
            if(this.friend.length!==0){
              ForEach(this.friend, (item: Friend) => {
                ListItem() {
                  ContactItem({ image: item.avatar_Url, text: item.name })
                }
                .onClick(() => {
                  let search = new NetSearch();
                  search.SearchOne(item.Username)
                  setTimeout(() => {
                    router.pushUrl({
                      url: 'pages/PersonPage',
                      params: { username: item.Username }
                    });
                  }, 70);
                })
              }, (item: Friend) => item.id)
            }
          }
          .height('100%')
          .width('100%')
        }
      }

    }.alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }

}

@Component
export struct NewPerson{
  @State name: string = ''
  @State username: string = ''
  @State head: string = ''
  @State birthday: string = ''
  @State gender: string = ''
  @State interests: string = ''
  @State interestsArray: Array<string> = []
  @State ID: string = ''
  @State str: string = ''
  @StorageLink('friends') friends: string = ''
  @State person :string |undefined= AppStorage.get("person")

  aboutToAppear(): void {
    console.log("person数据："+this.person);
    if(this.person!==undefined){
      let personArray:Array<string> = this.person.split(',')
      this.ID = personArray[0];
      this.gender = personArray[2];
      this.head = personArray[3];
      this.name = personArray[4];
      this.birthday = personArray[5];
      this.interests = personArray[6];
    }
    this.interestsArray = this.interests.split(' ')
    let arr = this.friends.split(',');
    arr.splice(-3);
    this.str = arr.join(',');
  }

  build() {
    Column() {
      Row(){
        Image('Page_image/back.png')
          .width(30)
          .height(30)
          .position({ x: '0%'})
          .onClick(()=>{
            router.back()
          })
      }
      .height('4%')
      .width('100%')

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
          }

          Row() {
            Text(`ID:${this.ID}`).fontSize(18).fontColor('white').fontWeight('bold')
          }
          .width(100)
          .height(40)
          .justifyContent(FlexAlign.Center)
          .margin({ top: 10,bottom:5 })
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
          Row(){
            Text(`用户名:${this.username}`).fontSize(18).fontColor(Color.Gray).fontWeight('bold')
          }
        }.height(90).margin({ left: 10 })

      }.width('90%')
      .margin(10)


      Column({ space: 15 }) {
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

        Row(){
          Text('兴趣爱好')
            .fontSize(20)
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
          .height('60%')
          .columnsTemplate('1fr 1fr 1fr')
          .rowsGap(10)
          .padding(10)
        }
      }.width('100%').height('100%').backgroundColor('#ffe6ecee').margin({top:10})

    }.width('100%')
    .height('100%')
  }
}

@Component
export struct person{
  @State name: string = ''
  @State username: string = ''
  @State head: string = ''
  @State birthday: string = ''
  @State gender: string = ''
  @State interests: string = ''
  @State interestsArray: Array<string> = []
  @State ID: string = ''
  @State str: string = ''
  @StorageLink('friends') friends: string = ''
  @State person :string |undefined= AppStorage.get("person")

  aboutToAppear(): void {
    console.log("person数据："+this.person);
    if(this.person!==undefined){
      let personArray:Array<string> = this.person.split(',')
      this.ID = personArray[0];
      this.gender = personArray[2];
      this.head = personArray[3];
      this.name = personArray[4];
      this.birthday = personArray[5];
      this.interests = personArray[6];
    }
    this.interestsArray = this.interests.split(' ')
    let arr = this.friends.split(',');
    arr.splice(-3);
    this.str = arr.join(',');
  }

  build() {
    Column() {
      Row(){
        Image('Page_image/back.png')
          .width(30)
          .height(30)
          .position({ x: '0%'})
          .onClick(()=>{
            router.back()
          })
        Image('Page_image/people_delete.png')
          .width(30)
          .height(30)
          .position({ x: '90%'})
          .onClick(()=>{
            AppStorage.set('friends',this.str)
            let friend = new FriendOption()
            friend.RejectFriend(this.username)
            router.replaceUrl({
              url: 'pages/HomePage'
            })
          })
      }
      .height('4%')
      .width('100%')

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
          }

          Row() {
            Text(`ID:${this.ID}`).fontSize(18).fontColor('white').fontWeight('bold')
          }
          .width(100)
          .height(40)
          .justifyContent(FlexAlign.Center)
          .margin({ top: 10,bottom:5 })
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
          Row(){
            Text(`用户名:${this.username}`).fontSize(18).fontColor(Color.Gray).fontWeight('bold')
          }
        }.height(90).margin({ left: 10 })

      }.width('90%')
      .margin(10)


      Column({ space: 15 }) {
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

        Row(){
          Text('兴趣爱好')
            .fontSize(20)
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
          .height('40%')
          .columnsTemplate('1fr 1fr 1fr')
          .rowsGap(10)
          .padding(10)
        }

        Column(){
          Button('发消息')
            .width('90%')
            .onClick(()=>{
              router.replaceUrl({
                url:'pages/ChatPage',
                params: { id:this.ID,username:this.username ,name: this.name ,image:this.head}
              })
            })
        }
        .width('100%')
        .height('15%')

      }.width('100%').height('100%').backgroundColor('#ffe6ecee').margin({top:10})

    }.width('100%')
    .height('100%')
  }
}