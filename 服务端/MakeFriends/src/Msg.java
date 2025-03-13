import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class Msg  implements Runnable{
    private final Socket socket;
    private String username;
    public Msg(Socket socket){
        this.socket=socket;
    }

    // 用于存储所有已连接客户端的用户名与对应的 OutputStream
    private static Map<String, PrintWriter> clientWriters = new ConcurrentHashMap<>();
    private static Map<String, Socket> clientSockets = new ConcurrentHashMap<>();

    @Override
    public void run() {
        this.Receive();
        System.out.println("已断开");
    }


    private void Receive(){
        BufferedReader reader = null;
        PrintWriter writer = null;
        try{
            reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            writer = new PrintWriter(new OutputStreamWriter(socket.getOutputStream(), StandardCharsets.UTF_8),true);
            String s = reader.readLine();
            String[] strings = s.split(",");
            for(String str:strings){
                System.out.print("客户端请求:"+str+" ");
            }
            String[] newStrings = Arrays.copyOfRange(strings, 1, strings.length);
            for(String str:newStrings){
                System.out.println("客户端:"+str+" ");
            }
            switch (strings[0]){
                case "注册":
                    DbService.USERINFO user = queryUserOne(newStrings[0]);
                    if(user!=null){
                        System.out.println("该用户名已被注册");
                        writer.println("reuse");
                    }else {
                        System.out.println("用户注册成功");
                        this.insert(newStrings);
                        writer.println("yes");
                    }
                    break;
                case "登录":
                    DbService.USERINFO user1 = queryUserOne(newStrings[0]);
                    if(user1!=null){
                        System.out.println("用户存在");
                        if(Objects.equals(newStrings[1], user1.getPassword())){
                            if(!Objects.equals(user1.getStatus(), "block")){
                                System.out.println("用户密码正确");
                                String str = this.queryUserFriends(user1.getId());
                                String str1 = this.queryNewFriends(user1.getId());
                                String str2 = this.queryUserMessage(user1.getId());
                                String str3 = this.recommendFriends(user1.getId(),user1.getInterests());
                                String str4 = this.recommendUserActivity(user1.getId(),user1.getInterests());
                                System.out.println("推荐活动:"+str4);
                                writer.println("yes,"+user1.toString()+"||"+str+"||"+str1+"||"+str2+"||"+str3+"||"+str4);
                            }else {
                                writer.println("block");
                            }
                        }else {
                            System.out.println("用户密码错误");
                            writer.println("incorrect");
                        }
                    }else{
                        System.out.println("用户不存在");
                        writer.println("absent");
                    }
                    break;
                case "修改":
                    this.update(newStrings);
                    writer.println("yes");
                    break;
                case "查询具体信息":
                    DbService.USERINFO user3 = queryUserOne(newStrings[0]);
                    if(user3!=null){
                        int id = user3.getId();
                        String Id2 = String.valueOf(id);
                        System.out.println("yes,"+Id2+","+user3.getUsername()+","+user3.getGender()+","+user3.getAvatar_Url()+","+user3.getName()+","+user3.getBirthday()+","+user3.getInterests()+","+user3.getStatus());
                        writer.println("yes,"+Id2+","+user3.getUsername()+","+user3.getGender()+","+user3.getAvatar_Url()+","+user3.getName()+","+user3.getBirthday()+","+user3.getInterests()+","+user3.getStatus());
                    }else {
                        writer.println("no");
                    }

                    break;
                case "查找好友":
                    DbService.USERINFO user2 = queryUserOne(newStrings[0]);
                    if(user2!=null){
                        writer.println("yes,"+user2.getUsername()+","+user2.getName()+","+user2.getAvatar_Url());
                        System.out.println("查找到该用户");
                    }else {
                        writer.println("not");
                        System.out.println("没查找到该用户");
                    }
                    break;
                case "添加好友":
                    String Id = newStrings[0];
                    int IdInt = Integer.parseInt(Id);
                    String friendName = newStrings[1];
                    if(this.AddFriend(IdInt,friendName)){
                        writer.println("yes");
                        System.out.println("发送好友请求成功");
                    }else{
                        writer.println("not");
                        System.out.println("发送好友请求失败");
                    }
                    break;
                case "确定添加好友":
                    String Id1 = newStrings[0];
                    int IdInt1 = Integer.parseInt(Id1);
                    String friendName1 = newStrings[1];
                    String friend = this.ConfirmFriend(IdInt1,friendName1);
                    writer.println("yes,"+friend);
                    break;
                case "查看好友列表":
                    DbService.USERINFO user5 = queryUserOne(newStrings[0]);
                    String str1 = this.queryUserFriends(user5.getId());
                    writer.println("yes,"+str1);
                    break;
                case "查看好友请求":
                    DbService.USERINFO user4 = queryUserOne(newStrings[0]);
                    String str = this.queryNewFriends(user4.getId());
                    writer.println("yes,"+str);
                    break;
                case "拒绝添加好友":
                    String Id3 = newStrings[0];
                    int IdInt3 = Integer.parseInt(Id3);
                    String friendName3 = newStrings[1];
                    this.RejectFriend(IdInt3,friendName3);
                    writer.println("yes");
                    break;
                case "新建活动":
                    this.insertActivity(newStrings);
                    writer.println("yes");
                    break;
                case "管理员新建活动":
                    this.AdminInsertActivity(newStrings);
                    writer.println("yes");
                    break;
                case "删除活动":
                    DbService2 db2_3 = new DbService2();
                    db2_3.deleteActivity(Integer.parseInt(newStrings[0]));
                    db2_3.close();
                    writer.println("yes");
                    break;
                case "类别查询":
                    String str2;
                    if(Objects.equals(newStrings[0], "热门")){
                        str2 = this.recommendHotActivity();
                    }else{
                        str2 = this.queryActivityByCategory(newStrings[0]);
                    }
                    writer.println("yes,"+str2);
                    break;
                case "查询推荐活动":
                    String str7 = this.recommendUserActivity(Integer.parseInt(newStrings[0]),newStrings[1]);
                    writer.println("yes,"+str7);
                    break;
                case "查询推荐好友":
                    String str12 = this.recommendFriends(Integer.parseInt(newStrings[0]),newStrings[1]);
                    writer.println("yes,"+str12);
                    break;
                case "创建活动查询":
                    String str3 = this.queryActivityCreatedByUser(Integer.parseInt(newStrings[0]));
                    writer.println("yes,"+str3);
                    break;
                case "参与活动查询":
                    String str4 = this.queryActivityParticipatedByUser(Integer.parseInt(newStrings[0]));
                    writer.println("yes,"+str4);
                    break;
                case "参与活动":
                    DbService2 db2 = new DbService2();
                    String b = db2.insertActivityParticipant(Integer.parseInt(newStrings[0]),Integer.parseInt(newStrings[1]));
                    db2.close();
                    if(Objects.equals(b, "yes")){
                        writer.println("yes");
                    }
                    else if(Objects.equals(b, "no")){
                        writer.println("no");
                    }else {
                        writer.println("not");
                    }
                    break;
                case "取消参加":
                    DbService2 db2_4 = new DbService2();
                    db2_4.deleteActivityParticipant(Integer.parseInt(newStrings[0]),Integer.parseInt(newStrings[1]));
                    db2_4.close();
                    writer.println("yes");
                    break;
                case "活动修改":
                    this.updateActivity(newStrings);
                    writer.println("yes");
                    break;
                case "管理员活动修改":
                    this.AdminUpdateActivity(newStrings);
                    writer.println("yes");
                    break;
                case "查询所有参与用户":
                    String str6 = this.queryParticipants(Integer.parseInt(newStrings[0]));
                    writer.println("yes,"+str6);
                    break;
                case "点赞":
                    DbService2 db2_1 = new DbService2();
                    boolean b1 = db2_1.insertActivityLike(Integer.parseInt(newStrings[0]),Integer.parseInt(newStrings[1]));
                    db2_1.close();
                    if(b1){
                        writer.println("yes");
                    }
                    else {
                        writer.println("no");
                    }
                    break;
                case "取消点赞":
                    DbService2 db2_2 = new DbService2();
                    db2_2.deleteActivityLike(Integer.parseInt(newStrings[0]),Integer.parseInt(newStrings[1]));
                    db2_2.close();
                    writer.println("yes");
                    break;
                case "活动评论查询":
                    String str5 = this.queryActivityComments(Integer.parseInt(newStrings[0]));
                    writer.println("yes,"+str5);
                    break;
                case "评论":
                    DbService2 db2_5 = new DbService2();
                    boolean b2 = db2_5.insertActivityComment(Integer.parseInt(newStrings[0]),Integer.parseInt(newStrings[1]),newStrings[2]);
                    db2_5.close();
                    if(b2){
                        writer.println("yes");
                    }
                    else {
                        writer.println("no");
                    }
                    break;
                case "删除评论":
                    DbService2 db2_7 = new DbService2();
                    boolean b6 = db2_7.deleteActivityComment(Integer.parseInt(newStrings[0]));
                    db2_7.close();
                    if(b6){
                        writer.println("yes");
                    }else {
                        writer.println("no");
                    }
                    break;
                case "聊天":
                    this.username = newStrings[0];
                    this.chat(reader,writer);
                case "查询全部用户":
                    String str8 = this.queryUserAll();
                    writer.println("yes,"+str8);
                    break;
                case "查询单个用户":
                    DbService.USERINFO user6 = queryUserOne(newStrings[0]);
                    if(user6!=null){
                        int id1 = user6.getId();
                        String Id4 = String.valueOf(id1);
                        System.out.println("yes,"+ Id4 +","+user6.getUsername()+","+user6.getGender()+","+user6.getAvatar_Url()+","+user6.getName()+","+user6.getBirthday()+","+user6.getInterests()+","+user6.getStatus());
                        writer.println("yes,"+ Id4 +","+user6.getUsername()+","+user6.getName()+","+user6.getAvatar_Url());
                    }else {
                        DbService db = new DbService();
                        DbService.USERINFO user7 = db.queryUserById(Integer.parseInt(newStrings[0]));
                        db.close();
                        if(user7!=null){
                            System.out.println("yes,"+ user7.getId() +","+user7.getUsername()+","+user7.getGender()+","+user7.getAvatar_Url()+","+user7.getName()+","+user7.getBirthday()+","+user7.getInterests()+","+user7.getStatus());
                            writer.println("yes,"+ user7.getId() +","+user7.getUsername()+","+user7.getName()+","+user7.getAvatar_Url());
                        }else {
                            writer.println("no");
                        }
                    }
                    break;
                case "查询全部活动":
                    String str9 = this.queryActivityAll();
                    writer.println("yes,"+str9);
                    break;
                case "查询待审核活动":
                    String str11 = this.queryDecideActivity();
                    writer.println("yes,"+str11);
                    break;
                case "查询单个活动":
                    String str10 = this.queryActivityById(Integer.parseInt(newStrings[0]));
                    if(str10!=null){
                        writer.println("yes,"+str10);
                    }else {
                        writer.println("no");
                    }
                    break;
                case "修改活动状态":
                    DbService2 db2_6 = new DbService2();
                    boolean b3 = db2_6.updateActivityStatus(Integer.parseInt(newStrings[0]),newStrings[1]);
                    db2_6.close();
                    if(b3){
                        writer.println("yes");
                    }
                    else {
                        writer.println("no");
                    }
                    break;
                case "删除用户":
                    DbService db3 = new DbService();
                    boolean b4 = db3.deleteUser(newStrings[0]);
                    db3.close();
                    if(b4){
                        writer.println("yes");
                    }
                    else {
                        writer.println("no");
                    }
                    break;
                case "修改用户状态":
                    DbService db4 = new DbService();
                    boolean b5 = db4.updateUserStatus(Integer.parseInt(newStrings[0]),newStrings[1]);
                    db4.close();
                    if(b5){
                        writer.println("yes");
                    }
                    else {
                        writer.println("no");
                    }
                    break;
            }
        }catch(Exception e){
            System.out.println(this.socket.getInetAddress()+"已掉线");
            e.printStackTrace();

        }finally {
            if(reader!=null){
                try {
                    reader.close();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
            if(writer!=null){
                writer.close();
            }
            if(socket!=null){
                try {
                    socket.close();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }

    private void insert(String[] s){
        DbService.USERINFO user = new DbService.USERINFO(
                0,// id
                s[0],// username
                s[1],// password
                s[2],// gender
                s[3],// avatar_Url
                "",// name
                null,// birthday
                "" // interests
        );
        DbService db = new DbService();
        db.insertUser(user);
        db.close();
    }

    private void update(String[] s){
        DbService.USERINFO user = new DbService.USERINFO(
                0,// id
                s[0],// username
                s[1],// password
                s[2],// gender
                s[3],// avatar_Url
                s[4],// name
                s[5],// birthday
                s[6] // interests
        );
        DbService db = new DbService();
        db.updateUser(user);
        db.close();
    }

    private DbService.USERINFO queryUserOne(String username){
        DbService db = new DbService();
        DbService.USERINFO user = db.queryUserByUsername(username);
        db.close();
        if (user != null) {
            return user;
        } else {
            return null;
        }
    }

    private String queryUserAll() {
        DbService db = new DbService();
        StringBuilder UserInfo = new StringBuilder();
        ArrayList<DbService.USERINFO> Users = db.queryUsers();
        db.close();
        int size = Users.size();
        int index = 0;
        if (Users.isEmpty()) {
            System.out.println("没有用户！");
        } else {
            for (DbService.USERINFO User : Users) {
                UserInfo.append(User.getId())
                        .append(",").append(User.getUsername())
                        .append(",").append(User.getName())
                        .append(",").append(User.getAvatar_Url());
                if (++index < size) {
                    UserInfo.append(",");
                }
            }
            System.out.println("搜索到"+size+"个用户！");
        }
        return UserInfo.toString();
    }

    private String queryUserMessage(int id){
        DbService db = new DbService();
        ArrayList<DbService.CHATRECORD> chatrecord = db.queryChatRecords(id);
        db.close();
        StringBuilder chatInfo = new StringBuilder();
        int size = chatrecord.size();
        int index = 0;
        if (chatrecord.isEmpty()) {
            System.out.println("你还没有任何聊天记录！");
        } else {
            for (DbService.CHATRECORD chat : chatrecord) {
                chatInfo.append(chat.toString());
                if (++index < size) {
                    chatInfo.append("|X|");
                }
            }
            System.out.println("你拥有"+size+"条聊天记录！");
        }
        System.out.println(chatInfo.toString());
        return chatInfo.toString();
    }

    private boolean AddFriend(int userId,String friendName){
        DbService db = new DbService();
        DbService.USERINFO user = db.queryUserByUsername(friendName);
        int friendId = user.getId();
        boolean state = db.addFriend(userId,friendId);
        db.close();
        return state;
    }

    private String queryUserFriends(int userId) {
        DbService db = new DbService();
        StringBuilder friendInfo = new StringBuilder();
        ArrayList<DbService.USERINFO> friends = db.getAcceptedFriends(userId);
        db.close();
        int size = friends.size();
        int index = 0;
        if (friends.isEmpty()) {
            System.out.println("你还没有添加任何好友！");
        } else {
            for (DbService.USERINFO friend : friends) {
                friendInfo.append(friend.getId())
                        .append(",").append(friend.getUsername())
                        .append(",").append(friend.getName())
                        .append(",").append(friend.getAvatar_Url());
                if (++index < size) {
                    friendInfo.append(",");
                }
            }
            System.out.println("你拥有"+size+"个好友！");
        }
        return friendInfo.toString();
    }

    private String queryNewFriends(int userId) {
        DbService db = new DbService();
        StringBuilder friendInfo = new StringBuilder();
        ArrayList<DbService.USERINFO> friends = db.getNewFriends(userId);
        db.close();
        int size = friends.size();
        int index = 0;
        if (friends.isEmpty()) {
            System.out.println("你没有收到好友申请！");
        } else {
            for (DbService.USERINFO friend : friends) {
                friendInfo.append(friend.getUsername())
                        .append(",").append(friend.getName())
                        .append(",").append(friend.getAvatar_Url());
                if (++index < size) {
                    friendInfo.append(",");
                }
            }
            System.out.println("你收到了"+size+"条好友申请！");
        }
        return friendInfo.toString();
    }

    private String ConfirmFriend(int userId,String friendName) {
        DbService db = new DbService();
        DbService.USERINFO user = db.queryUserByUsername(friendName);
        int friendId = user.getId();
        boolean State = db.acceptFriendRequest(userId,friendId);
        db.close();
        if (State) {
            System.out.println("添加成功！");
        } else {
            System.out.println("添加失败！");
        }
        return user.getId()+","+user.getUsername()+","+user.getName()+","+user.getAvatar_Url();
    }

    private void RejectFriend(int userId,String friendName) {
        DbService db = new DbService();
        DbService.USERINFO user = db.queryUserByUsername(friendName);
        int friendId = user.getId();
        boolean State = db.rejectFriendRequest(userId,friendId);
        db.close();
        if (State) {
            System.out.println("拒绝成功！");
        } else {
            System.out.println("拒绝失败！");
        }
    }

    //好友推荐
    private String recommendFriends(int userId,String userInterests) {
        DbService db = new DbService();
        StringBuilder recommendInfo = new StringBuilder();
        ArrayList<DbService.USERINFO> recommends = db.recommendFriends(userId,userInterests);
        db.close();
        int size = recommends.size();
        int index = 0;
        if (recommends.isEmpty()) {
            System.out.println("你没有推荐好友！");
        } else {
            for (DbService.USERINFO recommend : recommends) {
                recommendInfo.append(recommend.getUsername())
                        .append(",").append(recommend.getName())
                        .append(",").append(recommend.getAvatar_Url());
                if(index==1){
                    break;
                }
                if (++index < size) {
                    recommendInfo.append(",");
                }
            }
            System.out.println("你有"+(++index)+"个推荐好友！");
        }
        return recommendInfo.toString();
    }

    private void chat(BufferedReader reader, PrintWriter writer){
        try {
            DbService db = new DbService();
            Encryptor encryptor = new Encryptor("ZhangDongQing");
            String result;
            String message = "";
            String decryptedMessage;
            // 将用户名与输出流关联
                clientWriters.put(this.username, writer);
                clientSockets.put(this.username, socket);

            System.out.println(this.username + " 已连接");

            // 处理消息
            while (true) {
                result = reader.readLine();
                if (result.trim().isEmpty()) {
                    continue; // 忽略空消息
                }
                // 查找第一个逗号的位置
                int firstCommaIndex = result.indexOf(',');
                // 查找第二个逗号的位置
                int secondCommaIndex = result.indexOf(',', firstCommaIndex + 1);
                // 如果找到第二个逗号，则提取其后的子字符串
                if (secondCommaIndex != -1) {
                    message = result.substring(secondCommaIndex + 1);  // 从第二个逗号之后提取
                } else {
                    System.out.println("没有找到第二个逗号");
                }

                // 处理消息，如果包含目标用户名，则为私聊消息
                if (message.startsWith("@")) {
                    // 获取目标用户和消息内容
                    String[] parts = message.split(" ", 2);
                    if (parts.length > 1) {
                        String targetUsername = parts[0].substring(1).trim(); // 去掉@符号
                        String chatMessage = parts[1];
                        // 查找目标用户的输出流并发送消息
                        sendPrivateMessage(targetUsername, chatMessage);
                        DbService.USERINFO user1 = db.queryUserByUsername(username);
                        int Id1 = user1.getId();
                        DbService.USERINFO user2 = db.queryUserByUsername(targetUsername);
                        int Id2 = user2.getId();
                        decryptedMessage = encryptor.decrypt(chatMessage);
                        System.out.println("解密前内容:" + chatMessage);
                        System.out.println("消息内容:" + decryptedMessage);
                        DbService.CHATRECORD chatrecord = new DbService.CHATRECORD(
                                0,
                                Id1,
                                Id2,
                                decryptedMessage,
                                0
                        );
                        db.insertChatRecord(chatrecord);

                    }
                } else {
                    // 如果没有@符号，则表示不带目标用户名的消息，可以选择忽略
                }
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // 清理资源
            if (username != null) {
                clientWriters.remove(username);
                clientSockets.remove(username);
            }
        }
    }

    // 发送私聊消息给目标用户
    private void sendPrivateMessage(String targetUsername, String message) {
        PrintWriter targetWriter = clientWriters.get(targetUsername);
        if (targetWriter != null) {
            DbService.USERINFO user = this.queryUserOne(username);
            targetWriter.println(user.getId() + "|#|" + message);
        } else {
            System.out.println("目标用户不在线。");
        }
    }

    private void insertActivity(String[] s){
        DbService2.ACTIVITY activity = new DbService2.ACTIVITY(
                0,
                s[0],// 活动名称
                s[1],// 活动类别
                s[2],// 活动标签
                s[3],// 活动描述
                s[4],// 活动开始时间
                s[5],// 活动结束时间
                Integer.parseInt(s[6]), // 参与人数
                "decide",
                Integer.parseInt(s[7]) //创建者id
        );
        DbService2 db2 = new DbService2();
        db2.insertActivity(activity);
        db2.close();
    }

    private void AdminInsertActivity(String[] s){
        DbService2.ACTIVITY activity = new DbService2.ACTIVITY(
                0,
                s[0],// 活动名称
                s[1],// 活动类别
                s[2],// 活动标签
                s[3],// 活动描述
                s[4],// 活动开始时间
                s[5],// 活动结束时间
                Integer.parseInt(s[6]), // 参与人数
                "active",
                Integer.parseInt(s[7]) //创建者id
        );
        DbService2 db2 = new DbService2();
        db2.insertActivity(activity);
        db2.close();
    }

    private void updateActivity(String[] s){
        DbService2.ACTIVITY activity = new DbService2.ACTIVITY(
                Integer.parseInt(s[0]),
                s[1],// 活动名称
                s[2],// 活动类别
                s[3],// 活动标签
                s[4],// 活动描述
                s[5],// 活动开始时间
                s[6],// 活动结束时间
                Integer.parseInt(s[7]), // 参与人数
                "decide",
                Integer.parseInt(s[8]) //创建者id
        );
        DbService2 db2 = new DbService2();
        db2.updateActivity(activity);
        db2.close();
    }

    private void AdminUpdateActivity(String[] s){
        DbService2.ACTIVITY activity = new DbService2.ACTIVITY(
                Integer.parseInt(s[0]),
                s[1],// 活动名称
                s[2],// 活动类别
                s[3],// 活动标签
                s[4],// 活动描述
                s[5],// 活动开始时间
                s[6],// 活动结束时间
                Integer.parseInt(s[7]), // 参与人数
                "active",
                Integer.parseInt(s[8]) //创建者id
        );
        DbService2 db2 = new DbService2();
        db2.updateActivity(activity);
        db2.close();
    }

    private String queryActivityById(int activityId){
        DbService2 db2 = new DbService2();
        DbService2.ACTIVITY activity = db2.getActivityById(activityId);

        if (activity != null) {
            DbService db = new DbService();
            int i =db2.getParticipantsCount(activity.getActivityId());
            int i2 =db2.getActivityLikes(activity.getActivityId());
            String username = db.getUsernameById(activity.getCreatorId());
            db.close();
            db2.close();
            return activity.toString()+","+i+","+i2+","+username;
        } else {
            db2.close();
            return null;
        }
    }

    private String queryActivityAll(){
        DbService db = new DbService();
        DbService2 db2 = new DbService2();
        StringBuilder activityInfo = new StringBuilder();
        ArrayList<DbService2.ACTIVITY> activities = db2.getAllActivities();

        int size = activities.size();
        int index = 0;
        if (activities.isEmpty()) {
            System.out.println("没有活动！");
        } else {
            for (DbService2.ACTIVITY activity : activities) {
                int i =db2.getParticipantsCount(activity.getActivityId());
                int i2 =db2.getActivityLikes(activity.getActivityId());
                String username = db.getUsernameById(activity.getCreatorId());
                activityInfo.append(activity.toString()).append(",").append(i).append(",").append(i2).append(",").append(username);
                if (++index < size) {
                    activityInfo.append("||");
                }
            }
            System.out.println("查找到"+size+"个活动！");
        }
        db.close();
        db2.close();
        return activityInfo.toString();
    }

    private String queryParticipants(int activityId){
        DbService db = new DbService();
        DbService2 db2 = new DbService2();
        StringBuilder participantInfo = new StringBuilder();
        ArrayList<Integer> participants = db2.getParticipantsByActivityId(activityId);

        int size = participants.size();
        int index = 0;
        if (participants.isEmpty()) {
            System.out.println("该活动没人参加！");
        } else {
            for (Integer participant : participants) {
                DbService.USERINFO user = db.queryUserById(participant);
                participantInfo.append(user.getUsername())
                        .append(",").append(user.getName())
                        .append(",").append(user.getAvatar_Url());
                if (++index < size) {
                    participantInfo.append(",");
                }
            }
            System.out.println("该活动有"+size+"个人参加！");
        }
        db.close();
        db2.close();
        return participantInfo.toString();
    }

    private String queryActivityByCategory(String category){
        DbService db = new DbService();
        DbService2 db2 = new DbService2();
        StringBuilder activityInfo = new StringBuilder();
        ArrayList<DbService2.ACTIVITY> activities = db2.getOngoingActivitiesByCategory(category);

        int size = activities.size();
        int index = 0;
        if (activities.isEmpty()) {
            System.out.println("该类别没有活动！");
        } else {
            for (DbService2.ACTIVITY activity : activities) {
                int i =db2.getParticipantsCount(activity.getActivityId());
                int i2 =db2.getActivityLikes(activity.getActivityId());
                String username = db.getUsernameById(activity.getCreatorId());
                activityInfo.append(activity.toString()).append(",").append(i).append(",").append(i2).append(",").append(username);
                if (++index < size) {
                    activityInfo.append("||");
                }
            }
            System.out.println("该类别有"+size+"个活动！");
        }
        db.close();
        db2.close();
        return activityInfo.toString();
    }

    private String queryDecideActivity(){
        DbService db = new DbService();
        DbService2 db2 = new DbService2();
        StringBuilder activityInfo = new StringBuilder();
        ArrayList<DbService2.ACTIVITY> activities = db2.getDecideActivities();

        int size = activities.size();
        int index = 0;
        if (activities.isEmpty()) {
            System.out.println("没有待审核活动！");
        } else {
            for (DbService2.ACTIVITY activity : activities) {
                int i =db2.getParticipantsCount(activity.getActivityId());
                int i2 =db2.getActivityLikes(activity.getActivityId());
                String username = db.getUsernameById(activity.getCreatorId());
                activityInfo.append(activity.toString()).append(",").append(i).append(",").append(i2).append(",").append(username);
                if (++index < size) {
                    activityInfo.append("||");
                }
            }
            System.out.println("有"+size+"个活动需要审核！");
        }
        db.close();
        db2.close();
        return activityInfo.toString();
    }

    private String queryActivityCreatedByUser(int userId){
        DbService db = new DbService();
        DbService2 db2 = new DbService2();
        StringBuilder activityInfo = new StringBuilder();
        ArrayList<DbService2.ACTIVITY> activities = db2.getActivitiesCreatedByUser(userId);

        int size = activities.size();
        int index = 0;
        if (activities.isEmpty()) {
            System.out.println("你还没创建活动！");
        } else {
            for (DbService2.ACTIVITY activity : activities) {
                int i =db2.getParticipantsCount(activity.getActivityId());
                int i2 =db2.getActivityLikes(activity.getActivityId());
                String username = db.getUsernameById(activity.getCreatorId());
                activityInfo.append(activity.toString()).append(",").append(i).append(",").append(i2).append(",").append(username);
                if (++index < size) {
                    activityInfo.append("||");
                }
            }
            System.out.println("你创建了"+size+"个活动！");
        }
        db.close();
        db2.close();
        return activityInfo.toString();
    }

    private String queryActivityParticipatedByUser(int userId){
        DbService db = new DbService();
        DbService2 db2 = new DbService2();
        StringBuilder activityInfo = new StringBuilder();
        ArrayList<DbService2.ACTIVITY> activities = db2.getActivitiesParticipatedByUser(userId);

        int size = activities.size();
        int index = 0;
        if (activities.isEmpty()) {
            System.out.println("你还没参加活动！");
        } else {
            for (DbService2.ACTIVITY activity : activities) {
                int i =db2.getParticipantsCount(activity.getActivityId());
                int i2 =db2.getActivityLikes(activity.getActivityId());
                String username = db.getUsernameById(activity.getCreatorId());
                activityInfo.append(activity.toString()).append(",").append(i).append(",").append(i2).append(",").append(username);
                if (++index < size) {
                    activityInfo.append("||");
                }
            }
            System.out.println("你参加了"+size+"个活动！");
        }
        db.close();
        db2.close();
        return activityInfo.toString();
    }

    private String recommendHotActivity(){
        DbService db = new DbService();
        DbService2 db2 = new DbService2();
        StringBuilder activityInfo = new StringBuilder();
        ArrayList<DbService2.ACTIVITY> activities = db2.recommendHotActivities();

        int size = activities.size();
        int index = 0;
        if (activities.isEmpty()) {
            System.out.println("没有热门活动！");
        } else {
            for (DbService2.ACTIVITY activity : activities) {
                int i =db2.getParticipantsCount(activity.getActivityId());
                int i2 =db2.getActivityLikes(activity.getActivityId());
                String username = db.getUsernameById(activity.getCreatorId());
                activityInfo.append(activity.toString()).append(",").append(i).append(",").append(i2).append(",").append(username);
                if(index==2){
                    break;
                }
                if (++index < size) {
                    activityInfo.append("||");
                }
            }
            System.out.println("有"+(++index)+"个热门活动！");
        }
        db.close();
        db2.close();
        return activityInfo.toString();
    }

    private String recommendUserActivity(int userId,String userInterests){
        DbService db = new DbService();
        DbService2 db2 = new DbService2();
        StringBuilder activityInfo = new StringBuilder();
        ArrayList<DbService2.ACTIVITY> activities = db2.recommendActivities(userId,userInterests);

        int size = activities.size();
        int index = 0;
        if (activities.isEmpty()) {
            System.out.println("没有推荐活动！");
        } else {
            for (DbService2.ACTIVITY activity : activities) {
                int i =db2.getParticipantsCount(activity.getActivityId());
                int i2 =db2.getActivityLikes(activity.getActivityId());
                String username = db.getUsernameById(activity.getCreatorId());
                activityInfo.append(activity.toString()).append(",").append(i).append(",").append(i2).append(",").append(username);
                if(index==2){
                    break;
                }
                if (++index < size) {
                    activityInfo.append("|*|");
                }
            }
            System.out.println("有"+(++index)+"个推荐活动！");
        }
        db.close();
        db2.close();
        return activityInfo.toString();
    }

    private String queryActivityComments(int activityId){
        DbService2 db2 = new DbService2();
        StringBuilder commentInfo = new StringBuilder();
        ArrayList<DbService2.Comment> comments = db2.getAllCommentsForActivity(activityId);

        int size = comments.size();
        int index = 0;
        if (comments.isEmpty()) {
            System.out.println("该活动还没有评论！");
        } else {
            for (DbService2.Comment comment : comments) {

                commentInfo.append(comment.toString());
                if (++index < size) {
                    commentInfo.append("||");
                }
            }
            System.out.println("该活动有"+size+"个评论！");
        }
        db2.close();
        return commentInfo.toString();
    }

    public static void main(String[] args){
        ServerSocket serversocket = null;
        try{
            serversocket = new ServerSocket(8888);
            while (true) {
                Socket socket = serversocket.accept();
                new Thread(new Msg(socket)).start();
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(serversocket!=null){
                try {
                    serversocket.close();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        }
    }
}
