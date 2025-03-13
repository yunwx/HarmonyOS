import { router } from "@kit.ArkUI"
import { NewPerson } from "../model/CommonStyle";

interface username {
  username: string;
}

@Entry
@Component
export struct NewPersonPage {
  @State username: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as username;
    if (params.username) {
      this.username = params.username;
    }
  }

  build() {
    Column(){
      NewPerson({username:this.username})
    }.width("100%")
    .height("100%")
  }

}
