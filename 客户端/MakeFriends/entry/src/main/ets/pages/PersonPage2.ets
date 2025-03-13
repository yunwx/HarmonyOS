import { router } from "@kit.ArkUI"
import { person2 } from "../model/CommonStyle";

interface username {
  username: string;
}

@Entry
@Component
export struct PersonPage2 {
  @State username: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as username;
    if (params.username) {
      this.username = params.username;
    }
  }

  build() {
    Column(){
      person2({username:this.username})
    }.width("100%")
    .height("100%")
  }

}
