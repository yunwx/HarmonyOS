import DbService, { USERINFO } from "../SQLite/DbService";

export class UpdateMe {
  private  param :USERINFO = {
    id: null,
    username: '',
    password: '',
    gender: '',
    avatar_Url: '',
    name: '',
    birthday: '',
    interests: ''
  }

  private  ID: number |undefined = AppStorage.get('id');
  private username: string |undefined = AppStorage.get('username');
  private password: string |undefined = AppStorage.get('password');
  private gender: string |undefined = AppStorage.get('gender');
  private avatar_Url: string |undefined = AppStorage.get('avatar_Url');
  private name: string |undefined = AppStorage.get('name');
  private birthday: string |undefined = AppStorage.get('birthday');
  private interests: string |undefined = AppStorage.get('interests');

  updateOne(name: string, birthday: string,interests : string) {
    if(this.ID!=undefined && this.username!=undefined && this.password!=undefined && this.gender!=undefined && this.avatar_Url!=undefined) {
      this.param.id = this.ID
      this.param.username = this.username
      this.param.password = this.password
      this.param.gender = this.gender
      this.param.avatar_Url = this.avatar_Url
      this.param.name = name
      this.param.birthday = birthday
      this.param.interests = interests
      AppStorage.set('name',name)
      AppStorage.set('birthday',birthday)
      AppStorage.set('interests',interests)
      let db = new DbService();
      db.updateUser(this.param)
    }
  }

  updateName(name: string) {
    if(this.ID!=undefined && this.username!=undefined && this.password!=undefined && this.gender!=undefined && this.avatar_Url!=undefined && this.birthday!=undefined && this.interests!=undefined) {
      this.param.id = this.ID
      this.param.username = this.username
      this.param.password = this.password
      this.param.gender = this.gender
      this.param.avatar_Url = this.avatar_Url
      this.param.name = name
      this.param.birthday = this.birthday
      this.param.interests = this.interests
      AppStorage.set('name',name)
      let db = new DbService();
      db.updateUser(this.param)
    }
  }

  updatePassword(password: string) {
    if(this.ID!=undefined && this.username!=undefined && this.name!=undefined && this.gender!=undefined && this.avatar_Url!=undefined && this.birthday!=undefined && this.interests!=undefined) {
      this.param.id = this.ID
      this.param.username = this.username
      this.param.password = password
      this.param.gender = this.gender
      this.param.avatar_Url = this.avatar_Url
      this.param.name = this.name
      this.param.birthday = this.birthday
      this.param.interests = this.interests
      AppStorage.set('password',password)
      let db = new DbService();
      db.updateUser(this.param)
    }
  }

  updateAvatar_Url(avatar_Url: string) {
    if(this.ID!=undefined && this.username!=undefined && this.password!=undefined && this.gender!=undefined && this.name!=undefined && this.birthday!=undefined && this.interests!=undefined) {
      this.param.id = this.ID
      this.param.username = this.username
      this.param.password = this.password
      this.param.gender = this.gender
      this.param.avatar_Url = avatar_Url
      this.param.name = this.name
      this.param.birthday = this.birthday
      this.param.interests = this.interests
      AppStorage.set('avatar_Url',avatar_Url)
      let db = new DbService();
      db.updateUser(this.param)
    }
  }

  updateGender(gender: string) {
    if(this.ID!=undefined && this.username!=undefined && this.password!=undefined && this.avatar_Url!=undefined && this.name!=undefined && this.birthday!=undefined && this.interests!=undefined) {
      this.param.id = this.ID
      this.param.username = this.username
      this.param.password = this.password
      this.param.gender = gender
      this.param.avatar_Url = this.avatar_Url
      this.param.name = this.name
      this.param.birthday = this.birthday
      this.param.interests = this.interests
      AppStorage.set('gender',gender)
      let db = new DbService();
      db.updateUser(this.param)
    }
  }

  updateBirthday(birthday: string) {
    if(this.ID!=undefined && this.username!=undefined && this.password!=undefined && this.avatar_Url!=undefined && this.name!=undefined && this.gender!=undefined && this.interests!=undefined) {
      this.param.id = this.ID
      this.param.username = this.username
      this.param.password = this.password
      this.param.gender = this.gender
      this.param.avatar_Url = this.avatar_Url
      this.param.name = this.name
      this.param.birthday = birthday
      this.param.interests = this.interests
      AppStorage.set('birthday',birthday)
      let db = new DbService();
      db.updateUser(this.param)
    }
  }

  updateInterests(interests: string) {
    if(this.ID!=undefined && this.username!=undefined && this.password!=undefined && this.avatar_Url!=undefined && this.name!=undefined && this.gender!=undefined && this.birthday!=undefined) {
      this.param.id = this.ID
      this.param.username = this.username
      this.param.password = this.password
      this.param.gender = this.gender
      this.param.avatar_Url = this.avatar_Url
      this.param.name = this.name
      this.param.birthday = this.birthday
      this.param.interests = interests
      AppStorage.set('interests',interests)
      let db = new DbService();
      db.updateUser(this.param)
    }
  }
}