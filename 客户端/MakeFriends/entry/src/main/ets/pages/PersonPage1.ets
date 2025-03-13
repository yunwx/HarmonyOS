import { router } from "@kit.ArkUI"
import { person1 } from "../model/CommonStyle";

interface username {
  username: string;
}

@Entry
@Component
export struct PersonPage1 {
  @State username: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as username;
    if (params.username) {
      this.username = params.username;
    }
  }

  build() {
    Column(){
      person1({username:this.username})
    }.width("100%")
    .height("100%")
  }

}
