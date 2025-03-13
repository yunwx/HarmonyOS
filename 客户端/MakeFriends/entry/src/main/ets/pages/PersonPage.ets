import { router } from "@kit.ArkUI"
import { person } from "../model/CommonStyle";

interface username {
  username: string;
}

@Entry
@Component
export struct PersonPage {
  @State username: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as username;
    if (params.username) {
      this.username = params.username;
    }
  }

  build() {
    Column(){
      person({username:this.username})
    }.width("100%")
    .height("100%")
  }

}
