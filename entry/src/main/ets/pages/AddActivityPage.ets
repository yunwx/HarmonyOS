import { CommonTitle } from '../model/CommonStyle'
import chat, { ActivityOption } from '../model/Network';
import { promptAction } from '@kit.ArkUI';
import encryptor from '../model/Encryptor';
import validator from '../model/ContentValidator';

@Entry
@Component
struct AddActivityPage{
  @StorageLink('id') Id:string = ''
  @State category: Array<string> = ['运动','艺术','娱乐','科技','公益']
  // 分类映射
  @State categorizedLabels: Record<string, Array<string>> = {
    '运动': ['徒步旅行', '野营', '骑行', '攀岩', '游泳', '跑步', '滑板', '健身房训练', '瑜伽',
      '钓鱼', '跆拳道', '篮球', '足球', '羽毛球', '网球', '排球', '游泳', '自行车'],

    '艺术': ['绘画', '摄影', '舞蹈', '手工艺', '诗歌朗读', '阅读与写作'],

    '娱乐': ['电影欣赏', '聚会', '烧烤', '聚餐', '聚会游戏'],

    '科技': ['游戏开发', '电子产品DIY'],

    '公益': ['志愿者服务', '社区服务', '环保活动', '天文观察']
  };
  @State activityName: string = '';
  @State selectedCategory: string = '';
  @State startTime: string = '';
  @State endTime: string = '';
  @State maxParticipants: string = '';
  @State activityDescription: string = '';
  @State selectedLabels: Array<string> = [];
  @State labels: string = '';
  private selectedDate1: Date = new Date();
  private selectedDate2: Date = new Date();

  aboutToAppear(): void {
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
    Column(){
      CommonTitle({ text:'创建活动' })
      Row(){
        Text('活动名:')
        TextInput({ placeholder: '请输入活动名', text: this.activityName})
          .onChange((value: string) => {
            this.activityName = value;
          })
          .maxLength(10)
          .margin({left:10})
          .width('80%')
      }
      .margin({top:20})
      .width('90%')
      Row(){
        Text('活动类别:')
        Grid(){
          ForEach(this.category, (category: string, index) => {
            GridItem() {
              Text(category)
                .onClick(() => {
                  this.toggleCategory(category); // 选择或取消选中
                })
                .padding(5)
                .backgroundColor(this.selectedCategory==category ? '#ff21a2de' : '#FFFFFF') // 判断是否选中
                .borderRadius(50)
                .borderColor('#ff21a2de')
                .borderWidth(2)
            }
            .width('17%')
          }, (category: string): string => category)
        }
        .rowsTemplate('1fr')
      }
      .height('10%')
      .width('95%')
      Row(){
        Text('活动标签:')
          .width('20%')
        Grid(){
          ForEach(this.categorizedLabels[this.selectedCategory], (label: string) => {
            GridItem() {
              Text(label)
                .onClick(() => {
                  this.toggleLabels(label); // 选择或取消选中
                })
                .padding(5)
                .backgroundColor(this.selectedLabels.includes(label) ? '#ff4ca0af' : '#FFFFFF') // 判断是否选中
                .borderRadius(50)
                .borderColor('#ff4ca0af')
                .borderWidth(2)
            }
            .width('10%')
            .height('40%')
          }, (label: string): string => label)
        }
        .width('80%')
        .columnsTemplate('1fr 1fr 1fr')
      }
      .height('18%')
      .width('95%')
      Row(){
        Text('开始时间')
        TextInput({ placeholder: '请选择开始时间', text: this.startTime})
          .onClick(() => {
            DatePickerDialog.show({
              start: new Date(),
              end: new Date("2026-1-1"),
              selected: this.selectedDate1,
              showTime:true,
              useMilitaryTime:true,
              onDateAccept: (value: Date) => {
                this.selectedDate1 = value
                this.startTime = this.formatDate(value);
                console.info("DatePickerDialog:onDateAccept()" + value.toString())
              },
              onCancel: () => {
                console.info("DatePickerDialog:onCancel()")
              },
              onDateChange: (value: Date) => {
              }
            })
          })
          .margin({left:10})
          .width('80%')
      }
      .margin({top:20})
      .width('95%')
      Row(){
        Text('结束时间')
        TextInput({ placeholder: '请选择结束时间', text: this.endTime})
          .onClick(() => {
            DatePickerDialog.show({
              start: new Date(this.selectedDate1),
              end: new Date("2026-1-1"),
              selected: this.selectedDate2,
              showTime:true,
              useMilitaryTime:true,
              onDateAccept: (value: Date) => {
                this.selectedDate2 = value
                this.endTime = this.formatDate(value);
                console.info("DatePickerDialog:onDateAccept()" + value.toString())
              },
              onCancel: () => {
                console.info("DatePickerDialog:onCancel()")
              },
              onDateChange: (value: Date) => {
              }
            })
          })
          .margin({left:10})
          .width('80%')
      }
      .margin({top:20})
      .width('95%')
      Row(){
        Text('参与人数')
        TextInput({
          placeholder: '请输入最大参与人数',
          text: this.maxParticipants
        })
          .margin({left:10})
          .width('80%')
          .type(InputType.Number)
          .maxLength(3)
          .onChange((value: string) => {
            this.maxParticipants = value;
          });
      }
      .margin({top:20})
      .width('95%')
      Row(){
        TextArea({
          placeholder: '请输入活动描述...',
          text: this.activityDescription
        })
          .height('100%')
          .width('100%')
          .padding(10)
          .maxLength(200)
          .showCounter(true, { thresholdPercentage: 50, highlightBorder: true })//计数器
          .onChange((value: string) => {
            this.activityDescription = value;
          });

      }
      .margin({top:20})
      .height('15%')
      Button('创建')
        .width('80%')
        .margin({top:20})
        .onClick(()=>{
          this.labels = this.selectedLabels.join(' ');
          if(this.activityName==''){
            promptAction.showToast({ message: '活动名不能为空！', duration: 2000 });
            return;
          }
          if (!validator.isContentValid(this.activityName)) {
            promptAction.showToast({ message: '活动名中存在违禁词！', duration: 2000 });
            return;
          }
          if(this.selectedCategory==''){
            promptAction.showToast({ message: '请选择活动类别！', duration: 2000 });
            return;
          }
          if(this.labels==''){
            promptAction.showToast({ message: '至少选择一个标签！', duration: 2000 });
            return;
          }
          if(this.startTime==''){
            promptAction.showToast({ message: '请选择开始时间！', duration: 2000 });
            return;
          }
          if(this.endTime==''){
            promptAction.showToast({ message: '请选择结束时间！', duration: 2000 });
            return;
          }
          if(this.maxParticipants==''){
            promptAction.showToast({ message: '请输入最大参与人数！', duration: 2000 });
            return;
          }
          if (!validator.isContentValid(this.activityDescription)) {
            promptAction.showToast({ message: '活动描述中存在违禁词！', duration: 2000 });
            return;
          }
          let activity = new ActivityOption()
          activity.addActivity(this.activityName,this.selectedCategory,this.labels,this.activityDescription,this.startTime,this.endTime,this.maxParticipants,this.Id)
        })
    }
  }
  // 切换选中状态
  toggleCategory(category: string) {
    if (this.selectedCategory==category) {
      // 如果已经选中，取消选择
      this.selectedCategory = ''
    } else {
      this.selectedCategory=category;
    }
  }
  // 切换标签的选中状态
  toggleLabels(label: string) {
    if (this.selectedLabels.includes(label)) {
      // 如果已经选中，取消选择
      this.selectedLabels = this.selectedLabels.filter(item => item !== label);
    } else {
      // 如果没有选中，添加到选中列表
      this.selectedLabels.push(label);
    }
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