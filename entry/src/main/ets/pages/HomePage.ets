import { ME, Title} from '../model/CommonStyle'
import {  Send } from '../model/Send';
import { DataDialog, HomeDialog } from './Dialog';


@Entry
@Component
struct HomePage{
  private tabsController : TabsController = new TabsController()
  @State currentIndex:number = 0;
  @State name: string | undefined = AppStorage.get('name');

  dialogController: CustomDialogController  = new CustomDialogController({
    builder: HomeDialog(),
    cancel: this.exitApp,
    autoCancel: false,
    alignment: DialogAlignment.Center,
    gridCount: 4,
    customStyle: false
  })

aboutToAppear(): void {
    if(this.name!=undefined && this.name.length==0){
      this.dialogController.open()
    }
}
  onCancel() {
    console.info('Callback when the first button is clicked')
  }

  onAccept() {
    console.info('Callback when the second button is clicked')
  }

  exitApp() {
    console.info('Click the callback in the blank area')
  }

  build(){
    Column(){
        Tabs({barPosition:BarPosition.End,controller: this.tabsController}){
          TabContent() {
            Column() {
              Title()
              List() {
                  ListItem() {

                  }
              }
              .height('100%')
              .width('100%')
            }
          }
          .tabBar(this.TabBuilder('首页', 0, "Page_image/home1.png", "Page_image/home2.png"))

          TabContent() {
            Send()
          }
          .tabBar(this.TabBuilder('通讯录', 1, "Page_image/address_book1.png", "Page_image/address_book2.png"))

          TabContent() {
            Text('活动内容').fontSize(30)
          }
          .tabBar(this.TabBuilder('活动', 2, "Page_image/planet1.png", "Page_image/planet2.png"))

          TabContent() {
            ME()
          }
          .tabBar(this.TabBuilder('我的', 3, "Page_image/me1.png", "Page_image/me2.png"))
        }
        .onChange((index) => {
          this.currentIndex = index
        })
    }
  }
  @Builder TabBuilder(title: string, targetIndex: number, selectedImg: string, normalImg: string) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }
}
