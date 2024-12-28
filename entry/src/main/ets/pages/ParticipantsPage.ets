import { router } from '@kit.ArkUI'
import { ContactItem, Friend } from '../model/CommonStyle';
import { ActivityOption, NetSearch } from '../model/Network'

interface activity {
  activityId: string;
}

@Entry
@Component
struct ParticipantsPage {
  @State isRefreshing: boolean = false
  @State activityId:string = ''
  @State participants:Friend[] = []
  @State participant:string = ''

  aboutToAppear(): void {
    const params = router.getParams() as activity;
    if (params.activityId) {
      this.activityId = params.activityId;
    }
    this.updateParticipantsList();
  }

  updateParticipantsList(): void {
    this.participants = [];
    const participants: Array<Friend> = [];
    const str = 'Activity_Participants' + this.activityId;
    this.participant = AppStorage.get(str) || '';
    const participantArray: Array<string> = this.participant.split(',');
    for (let i = 0; i < participantArray.length; i += 4) {
      const newFriend: Friend = {
        id:'',
        Username: participantArray[i],
        name: participantArray[i + 1] || '',
        avatar_Url: participantArray[i + 2] || '',
      };
      participants.push(newFriend);
    }
    setTimeout(() => {
      this.participants = participants;
    }, 20);
  }

  build() {
    Column(){
      Row() {
        Row() {
          Image('Page_image/back.png')
            .width(25)
            .height(25)
            .onClick(() => {
              router.back();
            })
        }.width('10%')
        .margin({ left: 5 })

        Row() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
            Text('参与人员').fontSize('18fp').padding('20px')
          }
        }.width('80%')
      }.width('100%').height('180px').backgroundColor('#fff5f1f1')
      Refresh({ refreshing: $$this.isRefreshing }) {
        List() {
          if(this.participant!==''){
            ForEach(this.participants, (item: Friend) => {
              ListItem() {
                ContactItem({ image: item.avatar_Url, text: item.name })
              }
              .onClick(async () => {
                let search = new NetSearch();
                await search.SearchOne(item.Username)
                setTimeout(() => {
                  router.replaceUrl({
                    url: 'pages/NewPersonPage',
                    params: { username: item.Username }
                  });
                }, 200);
              })
            }, (item: Friend) => item.id)
          }
        }.height('100%')
        .width('100%')
      }
      .onRefreshing(() => {
        let activity = new ActivityOption();
        activity.searchParticipants(this.activityId);
        setTimeout(() => {
          this.updateParticipantsList();
          this.isRefreshing = false
        }, 1000)
      })
    }
  }
}