import { DataDialog, HobbiesDialog } from "./Dialog"
import { UpdateMe } from "./UpdateMe"
import { promptAction, router } from "@kit.ArkUI"
import chat, { ActivityOption, FriendOption, NetSearch, UpdateNet } from "./Network"
import encryptor from "./Encryptor"

@Component
export struct Title {
  @StorageLink('name') name: string = ''
  @StorageLink('avatar_Url') head: string = ''

  build() {
    Row() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Row() {
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
            .margin({ left: 10 })
        }

        Row() {
          Image("Page_image/add_people.png")
            .width(30)
            .height(30)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/SearchFriendsPage'
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
          if (data == '男') {
            this.gender = 'man';
          } else {
            this.gender = 'woman';
          }
        }
      }
    }),
    autoCancel: false
  })
  HobbiesDialogController: CustomDialogController = new CustomDialogController({
    builder: HobbiesDialog({
      selectedInterests: this.interestsArray,
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
                this.object = '姓名'
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
          router.pushUrl({
            url: 'pages/SettingPage'
          });
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
              localDate.setHours(0, 0, 0, 0); // 设置为当天的零点时刻
              this.selectedDate = localDate
              this.birthday = `${localDate.getFullYear()}-${(localDate.getMonth() + 1).toString()
                .padStart(2, '0')}-${localDate.getDate().toString().padStart(2, '0')}`;
              let update = new UpdateNet()
              update.updateBirthday(this.birthday)
              console.info("DatePickerDialog:onDateAccept()" + value.toString())
            },
            onCancel: () => {
              console.info("DatePickerDialog:onCancel()")
            },
            onDateChange: (value: Date) => {
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
          this.object = '性别'
          this.dialogController.open()
        })

        Row() {
          Text('兴趣爱好')
            .fontSize(20)
          Image($r('app.media.add'))
            .width(25)
            .height(25)
            .position({ x: '50%' })
            .onClick(() => {
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
    Row() {
      Row() {
        Image('Page_image/back.png')
          .width(25)
          .height(25)
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/HomePage'
            });
          })
      }.width('10%')

      Row() {
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
    Row() {
      Row() {
        Image('Page_image/back.png')
          .width(25)
          .height(25)
          .onClick(() => {
            router.back({
              url: 'pages/HomePage'
            });
          })
      }.width('10%')

      Row() {
        Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text(this.text).fontSize('18fp').padding('20px')
        }
      }.width('80%')

    }.width('100%').height('160px').backgroundColor('#fff5f1f1')
  }
}

@Component
export struct ContactItem {
  @State image: string = ''
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
  @State str: string = ''
  @State image: string = ''
  @State name: string = ''
  @State Username: string = ''
  @State state: boolean = false

  aboutToAppear(): void {
    if (this.NewFriend == '') {
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

      Row() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Row() {
            Image(this.image).width('100px').height('100px').margin({ left: '50px' })
            Text(this.name).fontSize('15vp').margin({ left: '40px' }).flexGrow(1)
          }
          .height('194px')
          .width('50%')

          Row() {
            Button('拒绝', { stateEffect: !this.state })
              .width('15%')
              .backgroundColor(this.state ? Color.Grey : Color.Blue)
              .height(30)
              .margin({ right: 10 })
              .onClick(() => {
                if (this.state) {
                  return;
                }
                AppStorage.set('NewFriends', this.str)
                this.state = true;
                let friend = new FriendOption()
                friend.RejectFriend(this.Username)
              });

            Button('添加', { stateEffect: !this.state })
              .width('15%')
              .backgroundColor(this.state ? Color.Grey : Color.Blue)
              .height(30)
              .onClick(() => {
                if (this.state) {
                  return;
                }
                AppStorage.set('NewFriends', this.str)
                this.state = true;
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
  @State image: string = ''
  @State text: string = ''
  @State Username: string = ''
  @State state: boolean = false

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

      Row() {
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          Row() {
            Image(this.image).width('100px').height('100px').margin({ left: '50px' })
            Text(this.text).fontSize('15vp').margin({ left: '40px' }).flexGrow(1)
          }
          .height('194px')
          .width('80%')

          Row() {
            Button('添加', { stateEffect: !this.state })
              .width('20%')
              .height(30)
              .backgroundColor(this.state ? Color.Grey : Color.Blue)
              .onClick(() => {
                if (this.state) {
                  return;
                }
                this.state = true;
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
  @State Id: string = ''
  @State image: string = ''
  @State name: string = ''
  @State username: string = ''
  @State content: string = ''
  @State time: string = ''
  @State timeArray: Array<string> = []

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

        Column() {
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
      AppStorage.setOrCreate('index', 0)
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/ChatPage',
          params: {
            id: this.Id,
            username: this.username,
            name: this.name,
            image: this.image
          }
        })
      }, 50);

    })
  }
}

export interface Friend {
  id: string
  Username: string;
  name: string;
  avatar_Url: string
}

@Component
export struct Contact {
  @State isRefreshing: boolean = false
  @StorageLink('friends') friends: string = ''
  @State friend: Friend[] = []
  @StorageLink('recommendFriends') recommendFriend: string = ''
  @State recommendFriends: Friend[] = []
  @State friendName: string = ''
  @State search: string = ''
  @StorageLink('username') username: string = ''
  @StorageLink('id') Id: string = ''
  @StorageLink('interests') interests: string = ''

  aboutToAppear(): void {
    this.updateFriendsList();
    this.updateRecommendList();
  }

  updateFriendsList(): void {
    this.friend = [];
    let friend = new FriendOption();
    friend.queryFriends();
    const Friend: Array<Friend> = [];
    if (this.friends.length == 0) {
      return;
    }
    const friendsArray: Array<string> = this.friends.split(',');
    for (let i = 0; i < friendsArray.length; i += 4) {
      const newFriend: Friend = {
        id: friendsArray[i],
        Username: friendsArray[i + 1],
        name: friendsArray[i + 2] || '',
        avatar_Url: friendsArray[i + 3] || '',
      };
      Friend.push(newFriend);
    }
    setTimeout(() => {
      this.friend = Friend;
    }, 20);
  }

  updateRecommendList(): void {
    this.recommendFriends = [];
    const recommendFriend: Array<Friend> = [];
    if (this.recommendFriend.length == 0) {
      return;
    }
    const recommendArray: Array<string> = this.recommendFriend.split(',');
    for (let i = 0; i < recommendArray.length; i += 3) {
      const newRecommendFriend: Friend = {
        id: '',
        Username: recommendArray[i],
        name: recommendArray[i + 1] || '',
        avatar_Url: recommendArray[i + 2] || '',
      };
      recommendFriend.push(newRecommendFriend);
    }
    setTimeout(() => {
      this.recommendFriends = recommendFriend;
    }, 20);
  }

  build() {
    Column() {
      Title()
      Refresh({ refreshing: $$this.isRefreshing }) {
        Scroll() {
          Column() {
            Row() {
              Search({ placeholder: '搜索好友...' })
                .searchButton('搜索')
                .width('90%')
                .height(40)
                .backgroundColor(Color.White)
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: 14, weight: 400 })
                .textFont({ size: 14, weight: 400 })
                .onSubmit((value: string) => {
                  AppStorage.setOrCreate('index', 1)
                  router.replaceUrl({
                    url: 'pages/SearchPage',
                    params: { name: this.search }
                  })
                  this.search = ''
                })
                .onChange((value: string) => {
                  this.search = value;
                })
                .margin(20)
            }
            .backgroundColor('#fff5f1f1')
            .align(Alignment.Top)

            if (this.recommendFriend.length !== 0) {
              Text("      推荐").fontSize('12fp').backgroundColor(Color.White).height('80px').width('100%')
              Divider()
                .vertical(false)
                .color('#ffe2dfdf')
                .strokeWidth('2px')

              List() {
                ForEach(this.recommendFriends, (item: Friend) => {
                  ListItem() {
                    ContactItem({ image: item.avatar_Url, text: item.name })
                  }
                  .onClick(async () => {
                    let search = new NetSearch();
                    await search.SearchOne(item.Username)
                    AppStorage.setOrCreate('index', 1)
                    setTimeout(() => {
                      router.replaceUrl({
                        url: 'pages/PersonPage1',
                        params: { username: item.Username }
                      });
                    }, 300);
                  })
                }, (item: Friend) => item.Username)
              }
              .backgroundColor('#fff5f1f1')
              .height('15%')
              .width('100%')
            }


            Row() {
              Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
                Row() {
                  Text("    新朋友").fontSize('15fp').backgroundColor(Color.White)
                }

                Row() {
                  Image('Page_image/right.png')
                    .width(20)
                    .height(20)
                }
              }
            }.height('100px').width('100%')
            .onClick(async () => {
              let friend = new FriendOption();
              await friend.queryNewFriends(this.username)
              AppStorage.setOrCreate('index', 1)
              setTimeout(() => {
                router.replaceUrl({
                  url: 'pages/NewFriendsPage'
                });
              }, 500);
            })


            Text("      我的好友").fontSize('12fp').backgroundColor('#fff5f1f1').height('80px').width('100%')
            List() {
              if (this.friend.length !== 0) {
                ForEach(this.friend, (item: Friend) => {
                  ListItem() {
                    ContactItem({ image: item.avatar_Url, text: item.name })
                  }
                  .onClick(async () => {
                    let search = new NetSearch();
                    await search.SearchOne(item.Username)
                    AppStorage.setOrCreate('index', 1)
                    setTimeout(() => {
                      router.replaceUrl({
                        url: 'pages/PersonPage',
                        params: { username: item.Username }
                      });
                    }, 300);
                  })
                }, (item: Friend) => item.id)
              }
            }
            .height('73%')
            .width('100%')
          }
        }
      }
      .onRefreshing(() => {
        let friends = new FriendOption();
        friends.searchRecommends(this.Id,this.interests);
        setTimeout(() => {
          this.updateRecommendList();
          this.updateFriendsList();
          this.isRefreshing = false
        }, 1000)
      })

    }.alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}

@Component
export struct NewPerson {
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

  aboutToAppear(): void {
    const person: string | undefined = AppStorage.get(this.username)
    console.log("person数据：" + person);
    if (person !== undefined) {
      let personArray: Array<string> = person.split(',')
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
      Row() {
        Image('Page_image/back.png')
          .width(30)
          .height(30)
          .position({ x: '0%' })
          .onClick(() => {
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
          .margin({ top: 10, bottom: 5 })
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

          Row() {
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

        Row() {
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
      }.width('100%').height('100%').backgroundColor('#ffe6ecee').margin({ top: 10 })

    }.width('100%')
    .height('100%')
  }
}

@Component
export struct person {
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
  @StorageLink('id') Id: string = ''

  aboutToAppear(): void {
    const person: string | undefined = AppStorage.get(this.username)
    console.log("username数据：" + person);
    if (person !== undefined) {
      let personArray: Array<string> = person.split(',')
      this.ID = personArray[0];
      this.gender = personArray[2];
      this.head = personArray[3];
      this.name = personArray[4];
      this.birthday = personArray[5];
      this.interests = personArray[6];
    }
    this.interestsArray = this.interests.split(' ')

    //删除好友的本地逻辑
    let arr = this.friends.split(',');
    // 每四个元素分为一组
    let groupedFriends: Array<Array<string>> = [];
    for (let i = 0; i < arr.length; i += 4) {
      groupedFriends.push(arr.slice(i, i + 4));
    }
    groupedFriends = groupedFriends.filter(friend => friend[1] !== this.username);
    this.str = groupedFriends.map(friend => friend.join(',')).join(',');
    console.log("删除后的好友:", this.str);

    chat.onMessageReceived = (receivedMessage: string) => {
      console.log("收到的消息:", receivedMessage);

      // 获取当前时间戳
      const timestamp1 = Date.now(); // 当前时间的毫秒数 (Unix 时间戳)
      // 获取当前时间的可读格式 (可选)
      const readableTime = new Date(timestamp1).toLocaleString(); // 格式化为本地时间
      const messageArray: Array<string> = receivedMessage.split('|#|')
      const str = messageArray[0] + '->' + this.Id;
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
    Column() {
      Row() {
        Image('Page_image/back.png')
          .width(30)
          .height(30)
          .position({ x: '0%' })
          .onClick(() => {
            router.replaceUrl({
              url: 'pages/HomePage'
            })
          })
        Image('Page_image/people_delete.png')
          .width(30)
          .height(30)
          .position({ x: '90%' })
          .onClick(() => {
            const str1 = this.Id + '->' + this.ID;
            const str2 = this.ID + '->' + this.Id;
            AppStorage.set(str1, '')
            AppStorage.set(str2, '')
            AppStorage.set('friends', this.str)
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
          .margin({ top: 10, bottom: 5 })
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

          Row() {
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

        Row() {
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

        Column() {
          Button('发消息')
            .width('90%')
            .onClick(() => {
              router.replaceUrl({
                url: 'pages/ChatPage',
                params: {
                  id: this.ID,
                  username: this.username,
                  name: this.name,
                  image: this.head
                }
              })
            })
        }
        .width('100%')
        .height('15%')

      }.width('100%').height('100%').backgroundColor('#ffe6ecee').margin({ top: 10 })

    }.width('100%')
    .height('100%')
  }
}

@Component
export struct person1 {
  @State name: string = ''
  @State username: string = ''
  @State head: string = ''
  @State birthday: string = ''
  @State gender: string = ''
  @State interests: string = ''
  @State interestsArray: Array<string> = []
  @State ID: string = ''
  @State str: string = ''
  @StorageLink('recommendFriends') friends: string = ''
  @StorageLink('id') Id: string = ''

  aboutToAppear(): void {
    const person: string | undefined = AppStorage.get(this.username)
    console.log("username数据：" + person);
    if (person !== undefined) {
      let personArray: Array<string> = person.split(',')
      this.ID = personArray[0];
      this.gender = personArray[2];
      this.head = personArray[3];
      this.name = personArray[4];
      this.birthday = personArray[5];
      this.interests = personArray[6];
    }
    this.interestsArray = this.interests.split(' ')

    let arr = this.friends.split(',');
    // 每四个元素分为一组
    let groupedFriends: Array<Array<string>> = [];
    for (let i = 0; i < arr.length; i += 3) {
      groupedFriends.push(arr.slice(i, i + 3));
    }
    groupedFriends = groupedFriends.filter(friend => friend[0] !== this.username);
    this.str = groupedFriends.map(friend => friend.join(',')).join(',');
    console.log("删除后:", this.str);

    chat.onMessageReceived = (receivedMessage: string) => {
      console.log("收到的消息:", receivedMessage);

      // 获取当前时间戳
      const timestamp1 = Date.now(); // 当前时间的毫秒数 (Unix 时间戳)
      // 获取当前时间的可读格式 (可选)
      const readableTime = new Date(timestamp1).toLocaleString(); // 格式化为本地时间
      const messageArray: Array<string> = receivedMessage.split('|#|')
      const str = messageArray[0] + '->' + this.Id;
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
    Column() {
      Row() {
        Image('Page_image/back.png')
          .width(30)
          .height(30)
          .position({ x: '0%' })
          .onClick(() => {
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
          .margin({ top: 10, bottom: 5 })
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

          Row() {
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

        Row() {
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

        Column() {
          Button('加好友')
            .width('90%')
            .onClick(() => {
              let friend = new FriendOption()
              friend.AddFriend(this.username)
              AppStorage.set('recommendFriends', this.str)
              router.replaceUrl({
                url: 'pages/HomePage',
              })
            })
        }
        .width('100%')
        .height('15%')

      }.width('100%').height('100%').backgroundColor('#ffe6ecee').margin({ top: 10 })

    }.width('100%')
    .height('100%')
  }
}

@Component
export struct person2 {
  @State name: string = ''
  @State username: string = ''
  @State head: string = ''
  @State birthday: string = ''
  @State gender: string = ''
  @State interests: string = ''
  @State interestsArray: Array<string> = []
  @State ID: string = ''
  @StorageLink('id') Id: string = ''

  aboutToAppear(): void {
    const person: string | undefined = AppStorage.get(this.username)
    console.log("username数据：" + person);
    if (person !== undefined) {
      let personArray: Array<string> = person.split(',')
      this.ID = personArray[0];
      this.gender = personArray[2];
      this.head = personArray[3];
      this.name = personArray[4];
      this.birthday = personArray[5];
      this.interests = personArray[6];
    }
    this.interestsArray = this.interests.split(' ')

  }

  build() {
    Column() {
      Row() {
        Image('Page_image/back.png')
          .width(30)
          .height(30)
          .position({ x: '0%' })
          .onClick(() => {
            router.back();
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
          .margin({ top: 10, bottom: 5 })
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

          Row() {
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

        Row() {
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

        Column() {
          Button('加好友')
            .width('90%')
            .onClick(() => {
              let friend = new FriendOption()
              friend.AddFriend(this.username)
              router.back();
            })
        }
        .width('100%')
        .height('15%')

      }.width('100%').height('100%').backgroundColor('#ffe6ecee').margin({ top: 10 })

    }.width('100%')
    .height('100%')
  }
}

@Component
export struct Activity {
  @StorageLink('id') Id: string = ''
  @StorageLink('interests') interests: string = ''
  private tabsController: TabsController = new TabsController()
  @State currentIndex: number = 0
  @StorageLink('运动') sport: string = ''
  @State sportArray: Array<string> = []
  @StorageLink('艺术') art: string = ''
  @State artArray: Array<string> = []
  @StorageLink('娱乐') recreation: string = ''
  @State recreationArray: Array<string> = []
  @StorageLink('科技') technology: string = ''
  @State technologyArray: Array<string> = []
  @StorageLink('公益') public: string = ''
  @State publicArray: Array<string> = []
  @StorageLink('推荐') recommend: string = ''
  @State recommendArray: Array<string> = []
  @StorageLink('热门') hot: string = ''
  @State hotArray: Array<string> = []
  @State isRefreshing: boolean = false

  aboutToAppear(): void {
    this.update();
  }

  update() {
    this.sportArray = this.sport.split('||')
    this.artArray = this.art.split('||')
    this.recreationArray = this.recreation.split('||')
    this.technologyArray = this.technology.split('||')
    this.publicArray = this.public.split('||')
    this.hotArray = this.hot.split('||')
    this.recommendArray = this.recommend.split('|*|')
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image('Page_image/record.png')
            .width(25)
            .height(25)
            .onClick(() => {
              let activity = new ActivityOption()
              activity.searchCreated(this.Id);
              activity.searchJoin(this.Id);
              AppStorage.setOrCreate('index', 2)
              setTimeout(() => {
                router.replaceUrl({
                  url: 'pages/MyActivityPage'
                });
              }, 400);
            })
        }.width('10%')
        .margin({ left: 5 })

        Row() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text('活动').fontSize('18fp').padding('20px')
          }
        }.width('80%')

        Row() {
          Image('Page_image/add.png')
            .width(25)
            .height(25)
            .onClick(() => {
              AppStorage.setOrCreate('index', 2)
              router.replaceUrl({ url: 'pages/AddActivityPage' })
            })
        }.width('10%')

      }.width('100%').height('180px').backgroundColor('#fff5f1f1')

      Swiper() {
        Image("Page_image/swiper1.jpg")
          .width('100%')
          .height('100%')
        Image("Page_image/swiper2.jpg")
          .width('100%')
          .height('100%')
        Image("Page_image/swiper3.jpg")
          .width('100%')
          .height('100%')
        Image("Page_image/swiper4.jpg")
          .width('100%')
          .height('100%')
      }
      .width('100%')
      .height('30%')
      .loop(true)
      .autoPlay(true) //自动轮播
      .interval(3000) //轮播间隔

      Tabs({ controller: this.tabsController }) {
        TabContent() {
          Refresh({ refreshing: $$this.isRefreshing }) {
            if (this.recommend !== '') {
              List() {
                ForEach(this.recommendArray, (item: string) => {
                  ListItem() {
                    ActivityItem({ str: item })
                  }
                }, (item: string) => item)
              }
              .height('100%')
              .width('100%')
            }
          }
          .onRefreshing(() => {
            let activity = new ActivityOption();
            activity.searchRecommends(this.Id, this.interests);
            setTimeout(() => {
              this.update();
              this.isRefreshing = false
            }, 1000)
          })
        }
        .tabBar(this.TabBuilder("推荐", 0))

        TabContent() {
          if (this.hot !== '') {
            List() {
              ForEach(this.hotArray, (item: string) => {
                ListItem() {
                  ActivityItem({ str: item })
                }
              }, (item: string) => item)
            }
            .height('100%')
            .width('100%')
          }
        }
        .tabBar(this.TabBuilder("热门", 1))

        TabContent() {
          if (this.sport !== '') {
            List() {
              ForEach(this.sportArray, (item: string) => {
                ListItem() {
                  ActivityItem({ str: item })
                }
              }, (item: string) => item)
            }
            .height('100%')
            .width('100%')
          }
        }
        .tabBar(this.TabBuilder("运动", 2))

        TabContent() {
          if (this.art !== '') {
            List() {
              ForEach(this.artArray, (item: string) => {
                ListItem() {
                  ActivityItem({ str: item })
                }
              }, (item: string) => item)
            }
            .height('100%')
            .width('100%')
          }
        }
        .tabBar(this.TabBuilder("艺术", 3))

        TabContent() {
          if (this.recreation !== '') {
            List() {
              ForEach(this.recreationArray, (item: string) => {
                ListItem() {
                  ActivityItem({ str: item })
                }
              }, (item: string) => item)
            }
            .height('100%')
            .width('100%')
          }
        }
        .tabBar(this.TabBuilder("娱乐", 4))

        TabContent() {
          if (this.technology !== '') {
            List() {
              ForEach(this.technologyArray, (item: string) => {
                ListItem() {
                  ActivityItem({ str: item })
                }
              }, (item: string) => item)
            }
            .height('100%')
            .width('100%')
          }
        }
        .tabBar(this.TabBuilder("科技", 5))

        TabContent() {
          if (this.public !== '') {
            List() {
              ForEach(this.publicArray, (item: string) => {
                ListItem() {
                  ActivityItem({ str: item })
                }
              }, (item: string) => item)
            }
            .height('100%')
            .width('100%')
          }
        }
        .tabBar(this.TabBuilder("公益", 6))
      }
      .onChange((index) => {
        this.currentIndex = index;
      })
      .scrollable(false) //限制滑动切换
      .width('100%')
      .height('62%')
    }.width('100%')
    .height('100%')
  }

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (title !== "推荐") {
        let activity = new ActivityOption();
        activity.searchByCategory(title);
      }
      setTimeout(() => {
        this.update();
        this.currentIndex = targetIndex;
        this.tabsController.changeIndex(this.currentIndex);
      }, 200);
    })
  }
}

@Component
export struct ActivityItem {
  @State str: string = ''
  @State Id: string = ''
  @State name: string = ''
  @State content: string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State max: string = ''
  @State count: string = ''

  aboutToAppear(): void {
    if (this.str !== '') {
      const array = this.str.split(',')
      this.Id = array[0]
      this.name = array[1]
      this.content = array[4]
      this.startTime = array[5]
      this.endTime = array[6]
      this.max = array[9]
      this.count = array[14]
    }
  }

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Column() {
          Text(this.name).fontSize('20fp').fontWeight('bold')
          Text(this.content)
            .fontSize('12fp')
            .width('620px')
            .fontColor("#c2bec2")
            .maxLines(1)
            .margin({ top: 20 })
        }.alignItems(HorizontalAlign.Start).flexGrow(1).margin({ left: 20 })

        Column() {
          Text(this.startTime).fontSize('12fp')
            .fontColor("#c2bec2")
          Text('至').fontSize('12fp')
            .fontColor("#ff000000")
          Text(this.endTime).fontSize('12fp')
            .margin({ top: "5px" }).fontColor("#c2bec2")
          Text(`参与人数:${this.count}/${this.max}`).fontSize('14fp').margin({ top: "5px" })
        }.margin({ right: "40px" })

      }
      .height('250px')
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
      AppStorage.setOrCreate('index', 2)
      let activity = new ActivityOption();
      activity.searchComments(this.Id);
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/ActivityPage',
          params: { str: this.str }
        })
      }, 50);

    })
  }
}

@Component
export struct ActivityItem1 {
  @State str: string = ''
  @State Id: string = ''
  @State name: string = ''
  @State content: string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State max: string = ''
  @State count: string = ''

  aboutToAppear(): void {
    if (this.str !== '') {
      const array = this.str.split(',')
      this.Id = array[0]
      this.name = array[1]
      this.content = array[4]
      this.startTime = array[5]
      this.endTime = array[6]
      this.max = array[9]
      this.count = array[14]
    }
  }

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Column() {
          Text(this.name).fontSize('20fp').fontWeight('bold')
          Text(this.content)
            .fontSize('12fp')
            .width('620px')
            .fontColor("#c2bec2")
            .maxLines(1)
            .margin({ top: 20 })
        }.alignItems(HorizontalAlign.Start).flexGrow(1).margin({ left: 20 })

        Column() {
          Text(this.startTime).fontSize('12fp')
            .fontColor("#c2bec2")
          Text('至').fontSize('12fp')
            .fontColor("#ff000000")
          Text(this.endTime).fontSize('12fp')
            .margin({ top: "5px" }).fontColor("#c2bec2")
          Text(`参与人数:${this.count}/${this.max}`).fontSize('14fp').margin({ top: "5px" })
        }.margin({ right: "40px" })

      }
      .height('250px')
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
      AppStorage.setOrCreate('indexMyActivity', 0)
      let activity = new ActivityOption();
      activity.searchComments(this.Id);
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/MyActivityPage1',
          params: { str: this.str }
        })
      }, 50);

    })
  }
}

@Component
export struct ActivityItem2 {
  @State str: string = ''
  @State Id: string = ''
  @State name: string = ''
  @State content: string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State max: string = ''
  @State count: string = ''

  aboutToAppear(): void {
    if (this.str !== '') {
      const array = this.str.split(',')
      this.Id = array[0]
      this.name = array[1]
      this.content = array[4]
      this.startTime = array[5]
      this.endTime = array[6]
      this.max = array[9]
      this.count = array[14]
    }
  }

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Column() {
          Text(this.name).fontSize('20fp').fontWeight('bold')
          Text(this.content)
            .fontSize('12fp')
            .width('620px')
            .fontColor("#c2bec2")
            .maxLines(1)
            .margin({ top: 20 })
        }.alignItems(HorizontalAlign.Start).flexGrow(1).margin({ left: 20 })

        Column() {
          Text(this.startTime).fontSize('12fp')
            .fontColor("#c2bec2")
          Text('至').fontSize('12fp')
            .fontColor("#ff000000")
          Text(this.endTime).fontSize('12fp')
            .margin({ top: "5px" }).fontColor("#c2bec2")
          Text(`参与人数:${this.count}/${this.max}`).fontSize('14fp').margin({ top: "5px" })
        }.margin({ right: "40px" })

      }
      .height('250px')
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
      AppStorage.setOrCreate('indexMyActivity', 1)
      let activity = new ActivityOption();
      activity.searchComments(this.Id);
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/MyActivityPage2',
          params: { str: this.str }
        })
      }, 50);

    })
  }
}

@Component
export struct AdminActivityItem {
  @State str: string = ''
  @State Id: string = ''
  @State name: string = ''
  @State content: string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State max: string = ''
  @State count: string = ''

  aboutToAppear(): void {
    if (this.str !== '') {
      const array = this.str.split(',')
      this.Id = array[0]
      this.name = array[1]
      this.content = array[4]
      this.startTime = array[5]
      this.endTime = array[6]
      this.max = array[9]
      this.count = array[14]
    }
  }

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Column() {
          Text(this.name).fontSize('20fp').fontWeight('bold')
          Text(this.content)
            .fontSize('12fp')
            .width('620px')
            .fontColor("#c2bec2")
            .maxLines(1)
            .margin({ top: 20 })
        }.alignItems(HorizontalAlign.Start).flexGrow(1).margin({ left: 20 })

        Column() {
          Text(this.startTime).fontSize('12fp')
            .fontColor("#c2bec2")
          Text('至').fontSize('12fp')
            .fontColor("#ff000000")
          Text(this.endTime).fontSize('12fp')
            .margin({ top: "5px" }).fontColor("#c2bec2")
          Text(`参与人数:${this.count}/${this.max}`).fontSize('14fp').margin({ top: "5px" })
        }.margin({ right: "40px" })

      }
      .height('250px')
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
      AppStorage.setOrCreate('indexAdmin', 1)
      let activity = new ActivityOption();
      activity.searchComments(this.Id);
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/AdminActivityPage',
          params: { str: this.str }
        })
      }, 50);
    })
  }
}

@Component
export struct AdminActivityItem2 {
  @State str: string = ''
  @State Id: string = ''
  @State name: string = ''
  @State content: string = ''
  @State startTime: string = ''
  @State endTime: string = ''
  @State max: string = ''
  @State count: string = ''

  aboutToAppear(): void {
    if (this.str !== '') {
      const array = this.str.split(',')
      this.Id = array[0]
      this.name = array[1]
      this.content = array[4]
      this.startTime = array[5]
      this.endTime = array[6]
      this.max = array[9]
      this.count = array[14]
    }
  }

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Column() {
          Text(this.name).fontSize('20fp').fontWeight('bold')
          Text(this.content)
            .fontSize('12fp')
            .width('620px')
            .fontColor("#c2bec2")
            .maxLines(1)
            .margin({ top: 20 })
        }.alignItems(HorizontalAlign.Start).flexGrow(1).margin({ left: 20 })

        Column() {
          Text(this.startTime).fontSize('12fp')
            .fontColor("#c2bec2")
          Text('至').fontSize('12fp')
            .fontColor("#ff000000")
          Text(this.endTime).fontSize('12fp')
            .margin({ top: "5px" }).fontColor("#c2bec2")
          Text(`参与人数:${this.count}/${this.max}`).fontSize('14fp').margin({ top: "5px" })
        }.margin({ right: "40px" })

      }
      .height('250px')
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
      AppStorage.setOrCreate('indexAdmin', 2)
      let activity = new ActivityOption();
      activity.searchComments(this.Id);
      setTimeout(() => {
        router.replaceUrl({
          url: 'pages/AdminActivityPage',
          params: { str: this.str }
        })
      }, 50);
    })
  }
}

@Component
export struct CommentItem {
  @StorageLink('username') Username: string = ''
  @State Id: string = ''
  @State image: string = ''
  @State name: string = ''
  @State username: string = ''
  @State commentText: string = ''
  @State time: string = ''
  @State activityId:string =''
  @State timeArray: Array<string> = []
  @State delete: boolean = false

  aboutToAppear(): void {
    this.timeArray = this.time.split(' ')
  }

  build() {
    Column() {
      Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Image(this.image).width('100px').height('100px').borderRadius(50).margin({ left: '50px', right: "50px" })

        Column() {
          Text(this.name).fontSize('12fp').fontColor("#c2bec2")
          Text(this.commentText).fontSize('16fp').width(this.delete?'590px':'620px')
        }.alignItems(HorizontalAlign.Start).flexGrow(1)

        Column() {
          Text(this.timeArray[1]).fontSize('12fp').fontColor("#c2bec2")
          Text(this.timeArray[0]).fontSize('12fp').margin({ top: 3 }).fontColor("#c2bec2")
        }.margin({ right: "40px" }).alignItems(HorizontalAlign.Center)
        if(this.delete&&this.Username==this.username){
          Column() {
            Button('删除').backgroundColor(Color.Red).height('100px')
              .onClick(()=>{
                let activity = new ActivityOption();
                activity.deleteComment(this.Id);
              })
          }.alignItems(HorizontalAlign.Center)
        }
      }
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
    .gesture(
      LongPressGesture({ repeat: true })
        // 由于repeat设置为true，长按动作存在时会连续触发，触发间隔为duration（默认值500ms）
        // 长按动作
        .onAction((event: GestureEvent) => {
          if(this.delete){
            this.delete=false;
          }else {
            this.delete=true;
          }
        })
    )
  }
}

@Component
export struct AdminPerson {
  @State name: string = ''
  @State username: string = ''
  @State head: string = ''
  @State birthday: string = ''
  @State gender: string = ''
  @State interests: string = ''
  @State interestsArray: Array<string> = []
  @State ID: string = ''
  @State status: string = ''
  @StorageLink('friends') friends: string = ''

  aboutToAppear(): void {
    const person: string | undefined = AppStorage.get(this.username)
    console.log("person数据：" + person);
    if (person !== undefined) {
      let personArray: Array<string> = person.split(',')
      this.ID = personArray[0];
      this.gender = personArray[2];
      this.head = personArray[3];
      this.name = personArray[4];
      this.birthday = personArray[5];
      this.interests = personArray[6];
      this.status = personArray[7];
    }
    this.interestsArray = this.interests.split(' ')
  }

  build() {
    Column() {
      Row() {
        Image('Page_image/back.png')
          .width(30)
          .height(30)
          .position({ x: '0%' })
          .onClick(() => {

            router.replaceUrl({
              url: 'pages/AdminPage'
            })
          })
        Image('Page_image/people_delete.png')
          .width(30)
          .height(30)
          .position({ x: '90%' })
          .onClick(() => {
            let net = new NetSearch()
            net.deleteUser(this.username)
            net.SearchUserAll()
            setTimeout(() => {
              router.replaceUrl({
                url: 'pages/AdminPage'
              })
            }, 300);
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
          .margin({ top: 10, bottom: 5 })
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

          Row() {
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

        Row() {
          Text('账号状态:')
            .fontSize(23)
          Text(this.status == 'normal' ? '正常' : '封禁')
            .fontSize(23)
        }
        .borderRadius(5)
        .padding(10)
        .justifyContent(FlexAlign.SpaceBetween)
        .width('90%')
        .backgroundColor(Color.White)

        Row() {
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
          .height('100%')
          .columnsTemplate('1fr 1fr 1fr')
          .rowsGap(10)
          .padding(10)
        }
        .height('30%')

        Row() {
          Button(this.status == 'normal' ? '封禁' : '解封')
            .width('80%')
            .onClick(() => {
              let net = new NetSearch()
              if (this.status == 'normal') {
                net.updateUserStatus(this.ID, "block")
              } else {
                net.updateUserStatus(this.ID, "normal")
              }
            })
        }
      }.width('100%').height('100%').backgroundColor('#ffe6ecee').margin({ top: 10 })

    }.width('100%')
    .height('100%')
  }
}