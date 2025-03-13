import { relationalStore, ValuesBucket, ValueType } from '@kit.ArkData'

// 定义用户信息数据结构
export interface USERINFO extends ValuesBucket {
  id: number | null
  username: string
  password: string
  gender: string | null
  avatar_Url: string | null
  name: string | null
  birthday: string | null
  interests: string | null
}

// 定义聊天记录数据结构
export interface CHATRECORD extends ValuesBucket {
  id: number | null
  userId: number
  message: string
  timestamp: number
}

export default class DbService {

  private store: relationalStore.RdbStore | null = null

  // 用户表 SQL
  private createUserTableSql: string = `
    CREATE TABLE IF NOT EXISTS USERS (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      USERNAME TEXT NOT NULL UNIQUE,
      PASSWORD TEXT NOT NULL,
      GENDER TEXT,
      AVATAR_URL TEXT,
      NAME TEXT,
      BIRTHDAY TEXT,
      INTERESTS TEXT
    )`;

  // 聊天记录表 SQL
  private createChatRecordsTableSql: string = `
    CREATE TABLE IF NOT EXISTS CHAT_RECORDS (
      ID INTEGER PRIMARY KEY AUTOINCREMENT,
      USER_ID INTEGER NOT NULL,
      MESSAGE TEXT NOT NULL,
      TIMESTAMP INTEGER NOT NULL,
      FOREIGN KEY (USER_ID) REFERENCES USERS (ID) ON DELETE CASCADE
    )`;

  // 获取数据库实例
  async getStoreInstance() {
    if (this.store) { return this.store }
    const store = await relationalStore.getRdbStore(getContext(), {
      name: 'FriendsApp.db',
      securityLevel: relationalStore.SecurityLevel.S1
    })
    store.executeSql(this.createUserTableSql)  // 创建用户表
    store.executeSql(this.createChatRecordsTableSql)  // 创建聊天记录表
    this.store = store
    return this.store
  }

  // 新增用户
  async insertUser(value: USERINFO) {
    const store = await this.getStoreInstance()
    return store.insert('USERS', value)
  }

  // 查询所有用户
  async queryUsers() {
    const store = await this.getStoreInstance()
    const predicates = new relationalStore.RdbPredicates('USERS')
    predicates.orderByDesc('ID')
    const resultSet = await store.query(predicates)
    const list: USERINFO[] = []
    while (resultSet.goToNextRow()) {
      list.push({
        id: resultSet.getLong(resultSet.getColumnIndex('ID')),
        username: resultSet.getString(resultSet.getColumnIndex('USERNAME')),
        password: resultSet.getString(resultSet.getColumnIndex('PASSWORD')),
        gender: resultSet.getString(resultSet.getColumnIndex('GENDER')) ,
        avatar_Url: resultSet.getString(resultSet.getColumnIndex('AVATAR_URL')),
        name: resultSet.getString(resultSet.getColumnIndex('NAME')),
        birthday: resultSet.getString(resultSet.getColumnIndex('BIRTHDAY')),
        interests: resultSet.getString(resultSet.getColumnIndex('INTERESTS'))
      })
    }
    return list
  }

  async queryOneByUsername(username:string) {
    const store = await this.getStoreInstance()
    const predicates = new relationalStore.RdbPredicates('USERS')
    predicates.equalTo("username",username)
    predicates.orderByDesc('id')
    const resultSet = await store.query(predicates)
    const list: USERINFO[] = []
    while (resultSet.goToNextRow()) {
      list.push({
        id: resultSet.getLong(resultSet.getColumnIndex('ID')),
        username: resultSet.getString(resultSet.getColumnIndex('USERNAME')),
        password: resultSet.getString(resultSet.getColumnIndex('PASSWORD')),
        gender: resultSet.getString(resultSet.getColumnIndex('GENDER')) ,
        avatar_Url: resultSet.getString(resultSet.getColumnIndex('AVATAR_URL')),
        name: resultSet.getString(resultSet.getColumnIndex('NAME')),
        birthday: resultSet.getString(resultSet.getColumnIndex('BIRTHDAY')),
        interests: resultSet.getString(resultSet.getColumnIndex('INTERESTS'))
      })
    }
    return list
  }

  // 更新用户
  async updateUser(value: Partial<USERINFO>) {
    if (!value.id) {
      return Promise.reject('id error')
    }
    const store = await this.getStoreInstance()
    const predicates = new relationalStore.RdbPredicates('USERS')
    predicates.equalTo('ID', value.id)
    return store.update(value, predicates)
  }

  // 删除用户
  async deleteUser(id: number) {
    if (!id) {
      return Promise.reject('id error')
    }
    const store = await this.getStoreInstance()
    const predicates = new relationalStore.RdbPredicates('USERS')
    predicates.equalTo('ID', id)
    return store.delete(predicates)
  }

  // 新增聊天记录
  async insertChatRecord(value: CHATRECORD) {
    const store = await this.getStoreInstance()
    return store.insert('CHAT_RECORDS', value)
  }

  // 查询聊天记录
  async queryChatRecords(userId: number) {
    const store = await this.getStoreInstance()
    const predicates = new relationalStore.RdbPredicates('CHAT_RECORDS')
    predicates.equalTo('USER_ID', userId)
    predicates.orderByDesc('ID')
    const resultSet = await store.query(predicates)
    const list: CHATRECORD[] = []
    while (resultSet.goToNextRow()) {
      list.push({
        id: resultSet.getLong(resultSet.getColumnIndex('ID')),
        userId: resultSet.getLong(resultSet.getColumnIndex('USER_ID')),
        message: resultSet.getString(resultSet.getColumnIndex('MESSAGE')),
        timestamp: resultSet.getLong(resultSet.getColumnIndex('TIMESTAMP'))
      })
    }
    return list
  }

  // 删除聊天记录
  async deleteChatRecord(id: number) {
    if (!id) {
      return Promise.reject('id error')
    }
    const store = await this.getStoreInstance()
    const predicates = new relationalStore.RdbPredicates('CHAT_RECORDS')
    predicates.equalTo('ID', id)
    return store.delete(predicates)
  }
}
