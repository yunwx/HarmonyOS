import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;


public class DbService {

    // MySQL数据库连接信息
    private static final String URL = "jdbc:mysql://localhost:3306/makefriends";
    private static final String USER = "root";
    private static final String PASSWORD = "025354";
    private Connection connection;

    // 用户表
    private static final String CREATE_USER_TABLE_SQL = "CREATE TABLE IF NOT EXISTS USERS ("
            + "ID INT AUTO_INCREMENT PRIMARY KEY, "
            + "USERNAME VARCHAR(255) NOT NULL UNIQUE, "
            + "PASSWORD VARCHAR(255) NOT NULL, "
            + "GENDER VARCHAR(10), "
            + "AVATAR_URL VARCHAR(255), "
            + "NAME VARCHAR(100), "
            + "BIRTHDAY DATE, "
            + "INTERESTS TEXT,"
            + "STATUS ENUM('normal', 'block') DEFAULT 'normal'"
            + ")";

    // 聊天记录表
    private static final String CREATE_MESSAGES_TABLE_SQL = "CREATE TABLE IF NOT EXISTS MESSAGES ("
            + "MESSAGE_ID INT AUTO_INCREMENT PRIMARY KEY, "
            + "SENDER_ID INT NOT NULL, "
            + "RECEIVER_ID INT NOT NULL, "
            + "MESSAGE TEXT NOT NULL, "
            + "CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
            + "FOREIGN KEY (SENDER_ID) REFERENCES USERS (ID) ON DELETE CASCADE,"
            + "FOREIGN KEY (RECEIVER_ID) REFERENCES USERS (ID) ON DELETE CASCADE"
            + ")";

    // 好友表
    private static final String CREATE_FRIENDS_TABLE_SQL = "CREATE TABLE IF NOT EXISTS FRIENDS ("
            + "USER_ID INT NOT NULL, "
            + "FRIEND_ID INT NOT NULL, "
            + "STATUS ENUM('pending', 'accepted') DEFAULT 'pending', " //发送请求，同意请求
            + "ADDED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
            + "PRIMARY KEY (USER_ID, FRIEND_ID), "
            + "FOREIGN KEY (USER_ID) REFERENCES USERS(ID), "
            + "FOREIGN KEY (FRIEND_ID) REFERENCES USERS(ID)"
            + ")";

    public DbService() {
        try {
            // 创建数据库连接
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            createTables();  // 创建表
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 创建表
    private void createTables() {
        try (Statement statement = connection.createStatement()) {
            statement.execute(CREATE_USER_TABLE_SQL);
            statement.execute(CREATE_MESSAGES_TABLE_SQL);
            statement.execute(CREATE_FRIENDS_TABLE_SQL);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 清除表数据
    public void clearTable(String tableName) {
        String sql = "DELETE FROM " + tableName;
        String sql1 = "ALTER TABLE "+tableName+" AUTO_INCREMENT = 1";
        try (Statement statement = connection.createStatement()) {
            statement.executeUpdate(sql);
            statement.executeUpdate(sql1);
            System.out.println("Table " + tableName + " has been cleared successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 新增用户
    public boolean insertUser(USERINFO user) {
        String sql = "INSERT INTO USERS (USERNAME, PASSWORD, GENDER, AVATAR_URL, NAME, BIRTHDAY, INTERESTS) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, user.username);
            pstmt.setString(2, user.password);
            pstmt.setString(3, user.gender);
            pstmt.setString(4, user.avatar_Url);
            pstmt.setString(5, user.name);
            pstmt.setDate(6, user.birthday != null ? Date.valueOf(user.birthday) : null);
            pstmt.setString(7, user.interests);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 查询所有用户
    public ArrayList<USERINFO> queryUsers() {
        String sql = "SELECT * FROM USERS WHERE ID != 7";
        ArrayList<USERINFO> list = new ArrayList<>();
        try (Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                 list.add(new USERINFO(
                        rs.getInt("ID"),
                        rs.getString("USERNAME"),
                        rs.getString("PASSWORD"),
                        rs.getString("GENDER"),
                        rs.getString("AVATAR_URL"),
                        rs.getString("NAME"),
                        rs.getDate("BIRTHDAY") != null ? rs.getDate("BIRTHDAY").toString() : null,
                        rs.getString("INTERESTS")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 根据用户名查询用户
    public USERINFO queryUserByUsername(String username) {
        String sql = "SELECT * FROM USERS WHERE USERNAME = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new USERINFO(
                            rs.getInt("ID"),
                            rs.getString("USERNAME"),
                            rs.getString("PASSWORD"),
                            rs.getString("GENDER"),
                            rs.getString("AVATAR_URL"),
                            rs.getString("NAME"),
                            rs.getDate("BIRTHDAY") != null ? rs.getDate("BIRTHDAY").toString() : null,
                            rs.getString("INTERESTS"),
                            rs.getString("STATUS")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 根据id查询用户
    public USERINFO queryUserById(int id) {
        String sql = "SELECT * FROM USERS WHERE ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new USERINFO(
                            rs.getInt("ID"),
                            rs.getString("USERNAME"),
                            rs.getString("PASSWORD"),
                            rs.getString("GENDER"),
                            rs.getString("AVATAR_URL"),
                            rs.getString("NAME"),
                            rs.getDate("BIRTHDAY") != null ? rs.getDate("BIRTHDAY").toString() : null,
                            rs.getString("INTERESTS")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //根据id查找用户名
    public String getUsernameById(int id) {
        String username = null;
        String sql = "SELECT USERNAME FROM USERS WHERE ID = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                username = rs.getString("USERNAME");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return username;
    }

    // 更新用户信息
    public boolean updateUser(USERINFO user) {
        String sql = "UPDATE USERS SET PASSWORD = ?, GENDER = ?, AVATAR_URL = ?, NAME = ?, BIRTHDAY = ?, INTERESTS = ? "
                + "WHERE USERNAME = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, user.password);
            pstmt.setString(2, user.gender);
            pstmt.setString(3, user.avatar_Url);
            pstmt.setString(4, user.name);
            pstmt.setDate(5, user.birthday != null ? Date.valueOf(user.birthday) : null);
            pstmt.setString(6, user.interests);
            pstmt.setString(7, user.username);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUserStatus(int userId, String newStatus) {
        if (!newStatus.equals("normal") && !newStatus.equals("block")) {
            System.out.println("Invalid status: " + newStatus);
            return false;
        }

        String sql = "UPDATE USERS SET STATUS = ? WHERE ID = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, userId);

            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 删除用户
    public boolean deleteUser(String username) {
        String sql = "DELETE FROM USERS WHERE USERNAME = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 新增聊天记录
    public boolean insertChatRecord(CHATRECORD record) {
        String sql = "INSERT INTO MESSAGES (SENDER_ID, RECEIVER_ID, MESSAGE) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, record.senderId);
            pstmt.setInt(2, record.receiverId);
            pstmt.setString(3, record.message);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 查询聊天记录
    public ArrayList<CHATRECORD> queryChatRecords(int userId) {
        String sql = "SELECT * FROM MESSAGES WHERE SENDER_ID = ? OR RECEIVER_ID = ?";
        ArrayList<CHATRECORD> chatRecords = new ArrayList<>();
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("MESSAGE_ID");
                    int senderId = rs.getInt("SENDER_ID");
                    int receiverId = rs.getInt("RECEIVER_ID");
                    String message = rs.getString("MESSAGE");
                    long timestamp = rs.getTimestamp("CREATED_AT").getTime();
                    // 创建CHATRECORD对象并加入列表
                    chatRecords.add(new CHATRECORD(id, senderId, receiverId, message, timestamp));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return chatRecords;
    }

    // 删除聊天记录
    public boolean deleteChatRecord(int id) {
        String sql = "DELETE FROM MESSAGES WHERE MESSAGE_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 添加好友
    public boolean addFriend(int userId, int friendId) {
        String sql = "INSERT INTO FRIENDS (USER_ID, FRIEND_ID, STATUS) VALUES (?, ?, 'pending')";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            // 插入用户 A 向用户 B 的请求
            pstmt.setInt(1, userId);
            pstmt.setInt(2, friendId);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //同意好友请求
    public boolean acceptFriendRequest(int userId, int friendId) {
        String sql1 = "UPDATE FRIENDS SET STATUS = 'accepted' WHERE USER_ID = ? AND FRIEND_ID = ?";
        String sql2 = "INSERT INTO FRIENDS (USER_ID, FRIEND_ID, STATUS) VALUES (?, ?, 'accepted')";

        // 开始事务处理
        try {
            connection.setAutoCommit(false);  // 禁用自动提交

            // 更新好友请求的状态
            try (PreparedStatement pstmt1 = connection.prepareStatement(sql1)) {
                pstmt1.setInt(1, friendId);
                pstmt1.setInt(2, userId);

                int rowsAffected1 = pstmt1.executeUpdate();
                if (rowsAffected1 == 0) {  // 如果没有更新任何记录，说明没有待处理的请求
                    connection.rollback();
                    return false;
                }
            }

            // 插入对方的好友记录
            try (PreparedStatement pstmt2 = connection.prepareStatement(sql2)) {
                pstmt2.setInt(1, userId);
                pstmt2.setInt(2, friendId);

                int rowsAffected2 = pstmt2.executeUpdate();
                if (rowsAffected2 == 0) {  // 如果没有插入记录，回滚事务
                    connection.rollback();
                    return false;
                }
            }

            // 提交事务
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();  // 如果出现异常，回滚事务
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);  // 恢复自动提交
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 拒绝好友请求
    public boolean rejectFriendRequest(int userId, int friendId) {
        // 删除双方的好友请求记录
        String sql = "DELETE FROM FRIENDS WHERE (USER_ID = ? AND FRIEND_ID = ?) OR (USER_ID = ? AND FRIEND_ID = ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);    // 用户 A
            pstmt.setInt(2, friendId);  // 用户 B
            pstmt.setInt(3, friendId);  // 用户 B
            pstmt.setInt(4, userId);    // 用户 A
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;  // 如果确实有记录删除，返回 true
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 查询好友关系状态
    public String getFriendStatus(int userId, int friendId) {
        String sql = "SELECT STATUS FROM FRIENDS WHERE USER_ID = ? AND FRIEND_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, friendId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("STATUS");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //查询是否有好友申请
    public ArrayList<USERINFO> getNewFriends(int userId) {
        String sql = "SELECT * FROM USERS WHERE ID IN ("
                + "SELECT USER_ID FROM FRIENDS WHERE FRIEND_ID = ? AND STATUS = 'pending')";
        ArrayList<USERINFO> friendsList = new ArrayList<>();

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    USERINFO friend = new USERINFO(
                            rs.getInt("ID"),
                            rs.getString("USERNAME"),
                            rs.getString("PASSWORD"),
                            rs.getString("GENDER"),
                            rs.getString("AVATAR_URL"),
                            rs.getString("NAME"),
                            rs.getDate("BIRTHDAY") != null ? rs.getDate("BIRTHDAY").toString() : null,
                            rs.getString("INTERESTS")
                    );
                    friendsList.add(friend);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return friendsList;
    }

    // 查询当前用户的所有已接受好友
    public ArrayList<USERINFO> getAcceptedFriends(int userId) {
        String sql = "SELECT * FROM USERS WHERE ID IN ("
                + "SELECT FRIEND_ID FROM FRIENDS WHERE USER_ID = ? AND STATUS = 'accepted')";
        ArrayList<USERINFO> friendsList = new ArrayList<>();

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    USERINFO friend = new USERINFO(
                            rs.getInt("ID"),
                            rs.getString("USERNAME"),
                            rs.getString("PASSWORD"),
                            rs.getString("GENDER"),
                            rs.getString("AVATAR_URL"),
                            rs.getString("NAME"),
                            rs.getDate("BIRTHDAY") != null ? rs.getDate("BIRTHDAY").toString() : null,
                            rs.getString("INTERESTS")
                    );
                    friendsList.add(friend);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return friendsList;
    }

    //推荐好友
    public ArrayList<USERINFO> recommendFriends(int currentUserId, String currentUserInterests) {
        ArrayList<USERINFO> recommendedUsers = new ArrayList<>();

        // 分割当前用户的兴趣标签
        String[] interests = currentUserInterests.split(" ");

        // 构建 SQL 查询
        StringBuilder query = new StringBuilder("SELECT * FROM USERS WHERE ID != ? AND ID !=7 AND STATUS = 'normal' AND ID NOT IN (");
        query.append("SELECT FRIEND_ID FROM FRIENDS WHERE USER_ID = ? AND STATUS = 'accepted'"); // 排除已添加的好友
        query.append(") AND (");

        for (int i = 0; i < interests.length; i++) {
            query.append("INTERESTS LIKE ? ");
            if (i < interests.length - 1) {
                query.append("OR ");
            }
        }
        query.append(")");

        // 执行 SQL 查询
        try (PreparedStatement stmt = connection.prepareStatement(query.toString())) {
            stmt.setInt(1, currentUserId);  // 设置排除当前用户
            stmt.setInt(2, currentUserId);  // 设置排除当前用户的已添加好友

            // 设置兴趣标签
            for (int i = 0; i < interests.length; i++) {
                stmt.setString(i + 3, "%" + interests[i] + "%");  // 设置兴趣匹配条件
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                USERINFO friend = new USERINFO(
                        rs.getInt("ID"),
                        rs.getString("USERNAME"),
                        rs.getString("PASSWORD"),
                        rs.getString("GENDER"),
                        rs.getString("AVATAR_URL"),
                        rs.getString("NAME"),
                        rs.getDate("BIRTHDAY") != null ? rs.getDate("BIRTHDAY").toString() : null,
                        rs.getString("INTERESTS")
                );
                recommendedUsers.add(friend);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 按照兴趣交集数量进行排序
        recommendedUsers.sort((user1, user2) -> {
            int intersection1 = countInterestIntersection(user1.getInterests(), currentUserInterests);
            int intersection2 = countInterestIntersection(user2.getInterests(), currentUserInterests);
            return Integer.compare(intersection2, intersection1);  // 按交集大小降序排序
        });

        return recommendedUsers;
    }

    // 计算兴趣交集数量
    private int countInterestIntersection(String userInterests, String currentUserInterests) {
        HashSet<String> userSet = new HashSet<>(Arrays.asList(userInterests.split(" ")));
        HashSet<String> currentUserSet = new HashSet<>(Arrays.asList(currentUserInterests.split(" ")));
        userSet.retainAll(currentUserSet);  // 获取交集
        return userSet.size();
    }

    // 关闭连接
    public void close() {
        try {
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 用户信息类
    public static class USERINFO {
        private int id;
        private String username;
        private String password;
        private String gender;
        private String avatar_Url;
        private String name;
        private String birthday;
        private String interests;
        private String status;

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getPassword() {
            return password;
        }

        public void setPassword(String password) {
            this.password = password;
        }

        public String getGender() {
            return gender;
        }

        public void setGender(String gender) {
            this.gender = gender;
        }

        public String getAvatar_Url() {
            return avatar_Url;
        }

        public void setAvatar_Url(String avatar_Url) {
            this.avatar_Url = avatar_Url;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getBirthday() {
            return birthday;
        }

        public void setBirthday(String birthday) {
            this.birthday = birthday;
        }

        public String getInterests() {
            return interests;
        }

        public void setInterests(String interests) {
            this.interests = interests;
        }


        public USERINFO(int id, String username, String password, String gender, String avatar_Url, String name,
                        String birthday, String interests) {
            this.id = id;
            this.username = username;
            this.password = password;
            this.gender = gender;
            this.avatar_Url = avatar_Url;
            this.name = name;
            this.birthday = birthday;
            this.interests = interests;
        }

        public USERINFO(int id, String username, String password, String gender, String avatar_Url, String name,
                        String birthday, String interests, String status) {
            this.id = id;
            this.username = username;
            this.password = password;
            this.gender = gender;
            this.avatar_Url = avatar_Url;
            this.name = name;
            this.birthday = birthday;
            this.interests = interests;
            this.status = status;
        }

        @Override
        public String toString() {
            return id+","+username+","+password+","+gender+","+avatar_Url+","+name+","+birthday+","+interests;
        }
    }

    // 聊天记录类
    public static class CHATRECORD {
        private int id;
        private int senderId;
        private int receiverId;
        private String message;
        private long timestamp;

        public long getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(long timestamp) {
            this.timestamp = timestamp;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public int getSenderId() {
            return senderId;
        }

        public void setSenderId(int senderId) {
            this.senderId = senderId;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public CHATRECORD(int id, int senderId, int receiverId,String message, long timestamp) {
            this.id = id;
            this.senderId = senderId;
            this.receiverId = receiverId;
            this.message = message;
            this.timestamp = timestamp;
        }

        public String toString() {
            return senderId+"^^"+receiverId+"^^"+message+"^^"+timestamp;
        }

    }
}
