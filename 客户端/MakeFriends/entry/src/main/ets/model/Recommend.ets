import { UpdateNet } from './Network';

class Recommend{
  private interest: Record<string, number> = {};

  updateUserInterests(label: string, action: string): void {
    const  interests: string |undefined = AppStorage.get('interests');
    const labelArray = label.split(' ');
    for (let index = 0; index < labelArray.length; index++){
      if(!this.interest[labelArray[index]]){
        this.interest[labelArray[index]]=0;
      }
      switch (action) {
        case "browse":
          this.interest[labelArray[index]]=this.interest[labelArray[index]]+1;
          break;
        case "like":
          this.interest[labelArray[index]]=this.interest[labelArray[index]]+2;
          break;
        case "comment":
          this.interest[labelArray[index]]=this.interest[labelArray[index]]+3;
          break;
        case "join":
          this.interest[labelArray[index]]=this.interest[labelArray[index]]+5;
          break;
      }
      if(this.interest[labelArray[index]]>=10){
        const currentInterests = interests || "";
        this.interest[labelArray[index]] = 0;
        if (!currentInterests.split(' ').includes(labelArray[index])) {
          let update = new UpdateNet();
          let newInterests = interests+' '+labelArray[index]
          update.updateInterests(newInterests)
        }
      }
    }
  }

  //查看兴趣值
  getInterestValues(): Record<string, number> {
    return this.interest;
  }

}
const recommend = new Recommend()
export default recommend as Recommend