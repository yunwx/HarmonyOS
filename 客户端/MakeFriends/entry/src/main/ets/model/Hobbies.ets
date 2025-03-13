@Entry
@Component
export struct Hobbies {
  @State interests: Array<string> = ['徒步旅行','野营','骑行','攀岩','游泳','跑步','滑板','健身房训练','瑜伽','钓鱼','跆拳道','篮球','足球',
  '羽毛球','网球','排球','游泳','自行车','绘画','摄影','电影欣赏','舞蹈','手工艺','诗歌朗读','阅读与写作','聚会', '烧烤','聚餐','聚会游戏',
  '游戏开发','电子产品DIY','志愿者服务','社区服务','环保活动','天文观察'];  // 兴趣选择项
  @State selectedInterests: Array<string> = [];  // 存储已选中的兴趣

  // 父组件传递的回调函数
  onInterestsChange?: (selectedInterests: Array<string>) => void;

  build() {
    Column({ space: 2 }) {
      Grid() {
        ForEach(this.interests, (interest: string, index) => {
          GridItem() {
            Text(interest)
              .onClick(() => {
                this.toggleInterest(interest); // 选择或取消选中该兴趣
                this.notifyInterestsChange(); // 通知父组件兴趣更改
              })
              .padding(5)
              .backgroundColor(this.selectedInterests.includes(interest) ? '#ff4ca0af' : '#FFFFFF') // 判断是否选中
              .borderRadius(50)

          }
          .width('32%')
        }, (interest: string): string => interest)
      }
      .rowsTemplate('1fr 1fr 1fr')  // 设置 Grid 行布局

    }
    .borderRadius(20)
    .backgroundColor('#fff1f0f0')
  }

  // 切换兴趣的选中状态
  toggleInterest(interest: string) {
    if (this.selectedInterests.includes(interest)) {
      // 如果已经选中，取消选择
      this.selectedInterests = this.selectedInterests.filter(item => item !== interest);
    } else {
      // 如果没有选中，添加到选中列表
      this.selectedInterests.push(interest);
    }
  }

  // 通知父组件兴趣列表变化
  notifyInterestsChange() {
    if (this.onInterestsChange) {
      this.onInterestsChange(this.selectedInterests);  // 将选中的兴趣传递给父组件
    }
  }
}
