import { promptAction, router } from '@kit.ArkUI';
import { CommentItem } from '../model/CommonStyle';
import validator from '../model/ContentValidator';
import { ActivityOption } from '../model/Network';
import recommend from '../model/Recommend';

interface Comment {
  commentId: string;
  commentText: string;
  createdAt:number;
  time:string;
  username:string;
  name:string;
  avatarUrl:string;
}

interface activity {
  Id: string;
  label: string;
}

@Entry
@Component
struct CommentsPage {
  @State activityId:string = ''
  @State comment: string = ''
  @State label: string = ''
  @State comments: Comment[] = [];
  @State str:string = ''
  @State max: number = 0
  @StorageLink('name') name: string = ''
  @StorageLink('avatar_Url') avatarUrl: string = ''
  @StorageLink('username') username: string = ''
  @StorageLink('id') Id:string = ''
  @State isRefreshing: boolean = false

  aboutToAppear(): void {
    const params = router.getParams() as activity;
    if (params.Id) {
      this.activityId = params.Id;
    }
    if (params.label) {
      this.label = params.label;
    }
    this.updateCommentsList()
  }

  updateCommentsList(): void {
    this.comments = [];
    const comments: Array<Comment> = [];
    const str = 'Activity_' + this.activityId;
    let comment: string = AppStorage.get(str) || '';
    this.str = comment
    console.log("comment的数据",comment);

    if(comment!==''){
      const commentArray = comment.split('||');
      this.max = commentArray.length+1
      console.log("max的数据",this.max);
      for (let index = 0; index < commentArray.length; index++) {
        let value = commentArray[index].split(',');
        let time = parseInt(value[2], 10);
        const date = new Date(time);
        const formattedTime = date.getFullYear() + '-' +
        String(date.getMonth() + 1).padStart(2, '0') + '-' +
        String(date.getDate()).padStart(2, '0') + ' ' +
        String(date.getHours()).padStart(2, '0') + ':' +
        String(date.getMinutes()).padStart(2, '0') + ':' +
        String(date.getSeconds()).padStart(2, '0');
        comments.push({commentId:value[0],commentText:value[1],createdAt:time,time:formattedTime,username:value[3],name:value[4],avatarUrl:value[5]});
      }
    }
    comments.sort((a, b) => a.createdAt - b.createdAt);
    this.comments=comments;
  }

  build() {
    Column() {
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
            Text('活动评论').fontSize('18fp').padding('20px')
          }
        }.width('80%')
      }.width('100%').height('180px').backgroundColor('#fff5f1f1')
      Refresh({ refreshing: $$this.isRefreshing }) {
      List() {
        if(this.str!==''){
          ForEach(this.comments,(item: Comment) =>{
            ListItem() {
              CommentItem({Id:item.commentId,image:item.avatarUrl,username:item.username,name:item.name,time:item.time,commentText:item.commentText,activityId:this.activityId})
            }
          }, (item: Comment) => item.commentId)
        }
      }.height('85%')
      .width('100%')
      }
      .onRefreshing(() => {
        let activity = new ActivityOption();
        activity.searchComments(this.activityId);
        setTimeout(() => {
          this.updateCommentsList();
          this.isRefreshing = false
        }, 1000)
      })
      // 输入框和发送按钮
      Row() {
        TextArea({
          placeholder: '请输入你的评论...',
          text: this.comment
        })
          .onChange((value) => {
            this.comment = value
          })
          .width('70%')
          .backgroundColor(Color.White)
          .margin({ left: 20, right: 5 })

        // 发送按钮
        Button("发送", { type: ButtonType.Normal })
          .onClick(() => {
            if (this.comment.trim()) {
              if(validator.isContentValid(this.comment)){
                let activity = new ActivityOption();
                activity.AddComment(this.activityId,this.Id,this.comment)
                const timestamp = Date.now();  // 当前时间的毫秒数 (Unix 时间戳)
                const date = new Date(timestamp);
                const formattedTime = date.getFullYear() + '-' +
                String(date.getMonth() + 1).padStart(2, '0') + '-' +
                String(date.getDate()).padStart(2, '0') + ' ' +
                String(date.getHours()).padStart(2, '0') + ':' +
                String(date.getMinutes()).padStart(2, '0') + ':' +
                String(date.getSeconds()).padStart(2, '0');
                this.comments.push({commentId:this.max.toString(),commentText:this.comment,createdAt:timestamp,time:formattedTime,username:this.username,name:this.name,avatarUrl:this.avatarUrl});
                let newComment = `${this.max.toString()},${this.comment},${timestamp},${this.username},${this.name},${this.avatarUrl}`;
                let existingComments = this.str ? `${this.str}||${newComment}` : newComment;
                AppStorage.set('Activity_' + this.activityId, existingComments);
                this.max++;
                this.comment = ''
                this.updateCommentsList()
                recommend.updateUserInterests(this.label,'comment')
                console.log("Interest:",JSON.stringify(recommend.getInterestValues()));
              }else {
                promptAction.showToast({ message: '评论中存在违禁词！', duration: 2000 });
              }
            }

          })
          .borderRadius(10)
          .backgroundColor("#ff08ae3c")
          .width('20%')
      }
      .height('10%')
      .width('100%')
      .backgroundColor('#fff5f1f1')
      .padding(10)
      .align(Alignment.Bottom)
    }
    .height('100%')
    .width('100%')
  }
}
