import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;

public class DbService2 {

    // MySQL数据库连接信息
    private static final String URL = "jdbc:mysql://localhost:3306/makefriends";
    private static final String USER = "root";
    private static final String PASSWORD = "025354";
    private Connection connection;

    private static final String CREATE_ACTIVITY_TABLE_SQL = "CREATE TABLE IF NOT EXISTS ACTIVITY ("
            + "ACTIVITY_ID INT AUTO_INCREMENT PRIMARY KEY, "
            + "ACTIVITY_NAME VARCHAR(255) NOT NULL, "
            + "CATEGORY VARCHAR(100) NOT NULL, " //类别
            + "TAGS VARCHAR(255), "//标签
            + "DESCRIPTION TEXT, "//描述
            + "START_TIME DATETIME, "
            + "END_TIME DATETIME, "
            + "CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "//创建时间
            + "UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, "//更新时间
            + "PARTICIPANTS_COUNT INT DEFAULT 0, "//参与人数
            + "LIKES_COUNT INT DEFAULT 0, "//点赞
            + "COMMENTS_COUNT INT DEFAULT 0, "//评论
            + "STATUS ENUM('active', 'inactive', 'decide') DEFAULT 'active', "
            + "CREATOR_ID INT NOT NULL, " // 创建者ID
            + "FOREIGN KEY (CREATOR_ID) REFERENCES USERS(ID) ON DELETE CASCADE"
            + ")";

    // 活动参与表
    private static final String CREATE_ACTIVITY_PARTICIPANTS_TABLE_SQL = "CREATE TABLE IF NOT EXISTS ACTIVITY_PARTICIPANTS ("
            + "PARTICIPANT_ID INT AUTO_INCREMENT PRIMARY KEY, "
            + "ACTIVITY_ID INT, "
            + "USER_ID INT, "
            + "JOINED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
            + "FOREIGN KEY (ACTIVITY_ID) REFERENCES ACTIVITY(ACTIVITY_ID) ON DELETE CASCADE, "
            + "FOREIGN KEY (USER_ID) REFERENCES USERS(ID), "
            + "UNIQUE (ACTIVITY_ID, USER_ID)" // 添加唯一约束
            + ")";

    // 活动评论表
    private static final String CREATE_ACTIVITY_COMMENTS_TABLE_SQL = "CREATE TABLE IF NOT EXISTS ACTIVITY_COMMENTS ("
            + "COMMENT_ID INT AUTO_INCREMENT PRIMARY KEY, "
            + "ACTIVITY_ID INT, "
            + "USER_ID INT, "
            + "COMMENT_TEXT TEXT, "
            + "CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
            + "FOREIGN KEY (ACTIVITY_ID) REFERENCES ACTIVITY(ACTIVITY_ID) ON DELETE CASCADE, "
            + "FOREIGN KEY (USER_ID) REFERENCES USERS(ID)"
            + ")";

    // 活动点赞表
    private static final String CREATE_ACTIVITY_LIKES_TABLE_SQL = "CREATE TABLE IF NOT EXISTS ACTIVITY_LIKES ("
            + "LIKE_ID INT AUTO_INCREMENT PRIMARY KEY, "
            + "ACTIVITY_ID INT, "
            + "USER_ID INT, "
            + "LIKED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
            + "FOREIGN KEY (ACTIVITY_ID) REFERENCES ACTIVITY(ACTIVITY_ID) ON DELETE CASCADE, "
            + "FOREIGN KEY (USER_ID) REFERENCES USERS(ID), "
            + "UNIQUE (ACTIVITY_ID, USER_ID)" // 添加唯一约束
            + ")";

    public DbService2() {
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
            statement.execute(CREATE_ACTIVITY_TABLE_SQL);
            statement.execute(CREATE_ACTIVITY_PARTICIPANTS_TABLE_SQL);
            statement.execute(CREATE_ACTIVITY_COMMENTS_TABLE_SQL);
            statement.execute(CREATE_ACTIVITY_LIKES_TABLE_SQL);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 插入活动到数据库
    public void insertActivity(ACTIVITY activity) {
        String insertSQL = "INSERT INTO ACTIVITY (ACTIVITY_NAME, CATEGORY, TAGS, DESCRIPTION, START_TIME, END_TIME, PARTICIPANTS_COUNT, STATUS, CREATOR_ID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(insertSQL)) {
            pstmt.setString(1, activity.getActivityName());
            pstmt.setString(2, activity.getCategory());
            pstmt.setString(3, activity.getTags());
            pstmt.setString(4, activity.getDescription());
            pstmt.setString(5, activity.getStartTime());
            pstmt.setString(6, activity.getEndTime());
            pstmt.setInt(7, activity.getParticipantsCount());
            pstmt.setString(8, activity.getStatus());
            pstmt.setInt(9, activity.getCreatorId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 更新活动信息
    public void updateActivity(ACTIVITY activity) {
        String updateSQL = "UPDATE ACTIVITY SET "
                + "ACTIVITY_NAME = ?, CATEGORY = ?, TAGS = ?, DESCRIPTION = ?, START_TIME = ?, END_TIME = ?, "
                + "PARTICIPANTS_COUNT = ?, STATUS = ?, CREATOR_ID = ? WHERE ACTIVITY_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(updateSQL)) {
            pstmt.setString(1, activity.getActivityName());
            pstmt.setString(2, activity.getCategory());
            pstmt.setString(3, activity.getTags());
            pstmt.setString(4, activity.getDescription());
            pstmt.setString(5, activity.getStartTime());
            pstmt.setString(6, activity.getEndTime());
            pstmt.setInt(7, activity.getParticipantsCount());
            pstmt.setString(8, activity.getStatus());
            pstmt.setInt(9, activity.getCreatorId());
            pstmt.setInt(10, activity.getActivityId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //修改活动状态
    public boolean updateActivityStatus(int activityId, String newStatus) {
        if (!newStatus.equals("active") && !newStatus.equals("inactive") && !newStatus.equals("decide")) {
            System.out.println("status格式不对: " + newStatus);
            return false;
        }

        String sql = "UPDATE ACTIVITY SET STATUS = ? WHERE ACTIVITY_ID = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, activityId);

            // 执行更新操作，返回更新的行数
            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 查询指定 ID 的活动
    public ACTIVITY getActivityById(int activityId) {
        String selectSQL = "SELECT * FROM ACTIVITY WHERE ACTIVITY_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(selectSQL)) {
            pstmt.setInt(1, activityId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return new ACTIVITY(
                        rs.getInt("ACTIVITY_ID"),
                        rs.getString("ACTIVITY_NAME"),
                        rs.getString("CATEGORY"),
                        rs.getString("TAGS"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("START_TIME"),
                        rs.getString("END_TIME"),
                        rs.getString("CREATED_AT"),
                        rs.getString("UPDATED_AT"),
                        rs.getInt("PARTICIPANTS_COUNT"),
                        rs.getInt("LIKES_COUNT"),
                        rs.getInt("COMMENTS_COUNT"),
                        rs.getString("STATUS"),
                        rs.getInt("CREATOR_ID")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 根据类别查询未截止的活动
    public ArrayList<ACTIVITY> getOngoingActivitiesByCategory(String category) {
        ArrayList<ACTIVITY> activities = new ArrayList<>();
        String selectSQL = "SELECT * FROM ACTIVITY WHERE CATEGORY = ? AND END_TIME > CURRENT_TIMESTAMP AND STATUS = 'active'";
        try (PreparedStatement pstmt = connection.prepareStatement(selectSQL)) {
            pstmt.setString(1, category);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                activities.add(new ACTIVITY(
                        rs.getInt("ACTIVITY_ID"),
                        rs.getString("ACTIVITY_NAME"),
                        rs.getString("CATEGORY"),
                        rs.getString("TAGS"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("START_TIME"),
                        rs.getString("END_TIME"),
                        rs.getString("CREATED_AT"),
                        rs.getString("UPDATED_AT"),
                        rs.getInt("PARTICIPANTS_COUNT"),
                        rs.getInt("LIKES_COUNT"),
                        rs.getInt("COMMENTS_COUNT"),
                        rs.getString("STATUS"),
                        rs.getInt("CREATOR_ID")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    // 搜索指定用户创建的所有活动
    public ArrayList<ACTIVITY> getActivitiesCreatedByUser(int userId) {
        ArrayList<ACTIVITY> activities = new ArrayList<>();
        String selectSQL = "SELECT * FROM ACTIVITY WHERE CREATOR_ID = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(selectSQL)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                activities.add(new ACTIVITY(
                        rs.getInt("ACTIVITY_ID"),
                        rs.getString("ACTIVITY_NAME"),
                        rs.getString("CATEGORY"),
                        rs.getString("TAGS"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("START_TIME"),
                        rs.getString("END_TIME"),
                        rs.getString("CREATED_AT"),
                        rs.getString("UPDATED_AT"),
                        rs.getInt("PARTICIPANTS_COUNT"),
                        rs.getInt("LIKES_COUNT"),
                        rs.getInt("COMMENTS_COUNT"),
                        rs.getString("STATUS"),
                        rs.getInt("CREATOR_ID")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    // 查询所有活动(除待审核)
    public ArrayList<ACTIVITY> getAllActivities() {
        ArrayList<ACTIVITY> activities = new ArrayList<>();
        String selectSQL = "SELECT * FROM ACTIVITY WHERE STATUS != 'decide'";
        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(selectSQL);
            while (rs.next()) {
                activities.add(new ACTIVITY(
                        rs.getInt("ACTIVITY_ID"),
                        rs.getString("ACTIVITY_NAME"),
                        rs.getString("CATEGORY"),
                        rs.getString("TAGS"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("START_TIME"),
                        rs.getString("END_TIME"),
                        rs.getString("CREATED_AT"),
                        rs.getString("UPDATED_AT"),
                        rs.getInt("PARTICIPANTS_COUNT"),
                        rs.getInt("LIKES_COUNT"),
                        rs.getInt("COMMENTS_COUNT"),
                        rs.getString("STATUS"),
                        rs.getInt("CREATOR_ID")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    // 查询待审核活动
    public ArrayList<ACTIVITY> getDecideActivities() {
        ArrayList<ACTIVITY> activities = new ArrayList<>();
        String selectSQL = "SELECT * FROM ACTIVITY WHERE STATUS = 'decide'";
        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(selectSQL);
            while (rs.next()) {
                activities.add(new ACTIVITY(
                        rs.getInt("ACTIVITY_ID"),
                        rs.getString("ACTIVITY_NAME"),
                        rs.getString("CATEGORY"),
                        rs.getString("TAGS"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("START_TIME"),
                        rs.getString("END_TIME"),
                        rs.getString("CREATED_AT"),
                        rs.getString("UPDATED_AT"),
                        rs.getInt("PARTICIPANTS_COUNT"),
                        rs.getInt("LIKES_COUNT"),
                        rs.getInt("COMMENTS_COUNT"),
                        rs.getString("STATUS"),
                        rs.getInt("CREATOR_ID")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    // 搜索指定用户参与的所有活动
    public ArrayList<ACTIVITY> getActivitiesParticipatedByUser(int userId) {
        ArrayList<ACTIVITY> activities = new ArrayList<>();
        String selectSQL = "SELECT a.* FROM ACTIVITY a "
                + "JOIN ACTIVITY_PARTICIPANTS ap ON a.ACTIVITY_ID = ap.ACTIVITY_ID "
                + "WHERE ap.USER_ID = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(selectSQL)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                activities.add(new ACTIVITY(
                        rs.getInt("ACTIVITY_ID"),
                        rs.getString("ACTIVITY_NAME"),
                        rs.getString("CATEGORY"),
                        rs.getString("TAGS"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("START_TIME"),
                        rs.getString("END_TIME"),
                        rs.getString("CREATED_AT"),
                        rs.getString("UPDATED_AT"),
                        rs.getInt("PARTICIPANTS_COUNT"),
                        rs.getInt("LIKES_COUNT"),
                        rs.getInt("COMMENTS_COUNT"),
                        rs.getString("STATUS"),
                        rs.getInt("CREATOR_ID")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return activities;
    }

    //推荐活动
    public ArrayList<ACTIVITY> recommendActivities(int currentUserId, String currentUserInterests) {
        ArrayList<ACTIVITY> recommendedActivities = new ArrayList<>();

        // 分割当前用户的兴趣标签
        String[] interests = currentUserInterests.split(" ");

        // 构建 SQL 查询
        StringBuilder query = new StringBuilder("SELECT * FROM ACTIVITY WHERE END_TIME > CURRENT_TIMESTAMP AND STATUS = 'active' AND ACTIVITY_ID NOT IN (");
        query.append("SELECT ACTIVITY_ID FROM ACTIVITY_PARTICIPANTS WHERE USER_ID = ?"); // 排除已参加的活动
        query.append(") AND (");

        // 处理兴趣标签的匹配条件
        for (int i = 0; i < interests.length; i++) {
            query.append("TAGS LIKE ? ");
            if (i < interests.length - 1) {
                query.append("OR ");
            }
        }
        query.append(")");

        // 执行 SQL 查询
        try (PreparedStatement stmt = connection.prepareStatement(query.toString())) {
            stmt.setInt(1, currentUserId);  // 设置排除当前用户已参加的活动

            // 设置兴趣标签条件
            for (int i = 0; i < interests.length; i++) {
                stmt.setString(i + 2, "%" + interests[i] + "%");  // 设置兴趣标签匹配条件
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ACTIVITY activity = new ACTIVITY(
                        rs.getInt("ACTIVITY_ID"),
                        rs.getString("ACTIVITY_NAME"),
                        rs.getString("CATEGORY"),
                        rs.getString("TAGS"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("START_TIME"),
                        rs.getString("END_TIME"),
                        rs.getString("CREATED_AT"),
                        rs.getString("UPDATED_AT"),
                        rs.getInt("PARTICIPANTS_COUNT"),
                        rs.getInt("LIKES_COUNT"),
                        rs.getInt("COMMENTS_COUNT"),
                        rs.getString("STATUS"),
                        rs.getInt("CREATOR_ID")
                );
                recommendedActivities.add(activity);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 按照兴趣交集数量进行排序
        recommendedActivities.sort((activity1, activity2) -> {
            int intersection1 = countInterestIntersection(activity1.getTags(), currentUserInterests);
            int intersection2 = countInterestIntersection(activity2.getTags(), currentUserInterests);
            return Integer.compare(intersection2, intersection1);  // 按交集大小降序排序
        });

        return recommendedActivities;
    }

    // 计算兴趣交集数量
    private int countInterestIntersection(String userInterests, String currentUserInterests) {
        HashSet<String> userSet = new HashSet<>(Arrays.asList(userInterests.split(" ")));
        HashSet<String> currentUserSet = new HashSet<>(Arrays.asList(currentUserInterests.split(" ")));
        userSet.retainAll(currentUserSet);  // 获取交集
        return userSet.size();
    }

    // 删除指定 ID 的活动
    public void deleteActivity(int activityId) {
        String deleteSQL = "DELETE FROM ACTIVITY WHERE ACTIVITY_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(deleteSQL)) {
            pstmt.setInt(1, activityId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //查询参与人数
    public int getParticipantsCount(int activityId) {
        String query = "SELECT COUNT(*) AS participant_count FROM ACTIVITY_PARTICIPANTS WHERE ACTIVITY_ID = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, activityId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("participant_count");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 获取活动允许的最大参与人数
    public int getMaxParticipantsCount(int activityId) {
        String query = "SELECT PARTICIPANTS_COUNT FROM ACTIVITY WHERE ACTIVITY_ID = ?";
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, activityId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("PARTICIPANTS_COUNT");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 插入活动参与记录
    public String insertActivityParticipant(int activityId, int userId) {

        int currentCount = getParticipantsCount(activityId);
        int maxParticipantsCount = getMaxParticipantsCount(activityId);

        if (currentCount >= maxParticipantsCount) {
            System.out.println("参与人数已达上限，无法添加新的参与者");
            return "not";
        }

        String insertSQL = "INSERT INTO ACTIVITY_PARTICIPANTS (ACTIVITY_ID, USER_ID) VALUES (?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(insertSQL)) {
            pstmt.setInt(1, activityId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
            return "yes";
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "no";
    }

    // 查询活动的所有参与用户
    public ArrayList<Integer> getParticipantsByActivityId(int activityId) {
        ArrayList<Integer> participants = new ArrayList<>();
        String selectSQL = "SELECT USER_ID FROM ACTIVITY_PARTICIPANTS WHERE ACTIVITY_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(selectSQL)) {
            pstmt.setInt(1, activityId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                participants.add(rs.getInt("USER_ID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return participants;
    }

    // 删除用户参与的活动记录
    public void deleteActivityParticipant(int activityId, int userId) {
        String deleteSQL = "DELETE FROM ACTIVITY_PARTICIPANTS WHERE ACTIVITY_ID = ? AND USER_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(deleteSQL)) {
            pstmt.setInt(1, activityId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 插入活动评论
    public boolean insertActivityComment(int activityId, int userId, String commentText) {
        String insertSQL = "INSERT INTO ACTIVITY_COMMENTS (ACTIVITY_ID, USER_ID, COMMENT_TEXT) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(insertSQL)) {
            pstmt.setInt(1, activityId);
            pstmt.setInt(2, userId);
            pstmt.setString(3, commentText);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 查询活动的所有评论
    public ArrayList<Comment> getAllCommentsForActivity(int activityId) {
        ArrayList<Comment> comments = new ArrayList<>();
        String sql = "SELECT c.COMMENT_ID, c.COMMENT_TEXT, c.CREATED_AT, u.USERNAME, u.NAME, u.AVATAR_URL "
                + "FROM ACTIVITY_COMMENTS c "
                + "JOIN USERS u ON c.USER_ID = u.ID "
                + "WHERE c.ACTIVITY_ID = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, activityId);  // 设置活动ID
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int commentId = rs.getInt("COMMENT_ID");
                    String commentText = rs.getString("COMMENT_TEXT");
                    long createdAt = rs.getTimestamp("CREATED_AT").getTime();
                    String username = rs.getString("USERNAME");
                    String name = rs.getString("NAME");
                    String avatarUrl = rs.getString("AVATAR_URL");

                    Comment comment = new Comment(commentId, commentText, createdAt, username, name, avatarUrl);
                    comments.add(comment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return comments;
    }

    // 删除指定评论
    public boolean deleteActivityComment(int commentId) {
        String deleteSQL = "DELETE FROM ACTIVITY_COMMENTS WHERE COMMENT_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(deleteSQL)) {
            pstmt.setInt(1, commentId);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 插入活动点赞记录
    public boolean insertActivityLike(int activityId, int userId) {
        String insertSQL = "INSERT INTO ACTIVITY_LIKES (ACTIVITY_ID, USER_ID) VALUES (?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(insertSQL)) {
            pstmt.setInt(1, activityId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 查询活动点赞数
    public int getActivityLikes(int activityId) {
        String sql = "SELECT COUNT(*) AS LIKE_COUNT FROM ACTIVITY_LIKES WHERE ACTIVITY_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, activityId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("LIKE_COUNT");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 查询活动的所有点赞用户
    public ArrayList<Integer> getLikesByActivityId(int activityId) {
        ArrayList<Integer> likes = new ArrayList<>();
        String selectSQL = "SELECT USER_ID FROM ACTIVITY_LIKES WHERE ACTIVITY_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(selectSQL)) {
            pstmt.setInt(1, activityId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                likes.add(rs.getInt("USER_ID"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return likes;
    }

    // 删除活动点赞记录
    public void deleteActivityLike(int activityId, int userId) {
        String deleteSQL = "DELETE FROM ACTIVITY_LIKES WHERE ACTIVITY_ID = ? AND USER_ID = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(deleteSQL)) {
            pstmt.setInt(1, activityId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ArrayList<ACTIVITY> recommendHotActivities() {
        ArrayList<ACTIVITY> recommendedActivities = new ArrayList<>();

        String sql = "SELECT * FROM ACTIVITY WHERE END_TIME > CURRENT_TIMESTAMP AND STATUS = 'active'";

        // 执行 SQL 查询获取活动数据
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            // 遍历查询结果，获取活动信息
            while (rs.next()) {
                int activityId = rs.getInt("ACTIVITY_ID");
                ACTIVITY activity = new ACTIVITY(
                        activityId,
                        rs.getString("ACTIVITY_NAME"),
                        rs.getString("CATEGORY"),
                        rs.getString("TAGS"),
                        rs.getString("DESCRIPTION"),
                        rs.getString("START_TIME"),
                        rs.getString("END_TIME"),
                        rs.getString("CREATED_AT"),
                        rs.getString("UPDATED_AT"),
                        rs.getInt("PARTICIPANTS_COUNT"),
                        0,  // 默认点赞数，稍后会更新
                        rs.getInt("COMMENTS_COUNT"),
                        rs.getString("STATUS"),
                        rs.getInt("CREATOR_ID")
                );

                // 获取当前活动的点赞数
                int likeCount = getActivityLikes(activityId);
                activity.setLikesCount(likeCount);  // 更新活动的点赞数

                // 添加到推荐活动列表
                recommendedActivities.add(activity);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        recommendedActivities.sort((a1, a2) -> Integer.compare(a2.getLikesCount(), a1.getLikesCount()));

        return recommendedActivities;
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

    public static class ACTIVITY {

        private int activityId; // 活动ID
        private String activityName; // 活动名称
        private String category; // 活动类别
        private String tags; // 活动标签
        private String description; // 活动描述
        private String startTime; // 活动开始时间
        private String endTime; // 活动结束时间
        private String createdAt; // 创建时间
        private String updatedAt; // 更新时间
        private int participantsCount; // 参与人数
        private int likesCount; // 点赞数
        private int commentsCount; // 评论数
        private String status; // 活动状态
        private int creatorId;


        public ACTIVITY(int activityId, String activityName, String category, String tags, String description,
                        String startTime, String endTime, int participantsCount,String status, int creatorId) {
            this.activityId = activityId;
            this.activityName = activityName;
            this.category = category;
            this.tags = tags;
            this.description = description;
            this.startTime = startTime;
            this.endTime = endTime;
            this.participantsCount = participantsCount;
            this.status = status;
            this.creatorId = creatorId;
        }

        public ACTIVITY(int activityId, String activityName, String category, String tags, String description,
                        String startTime, String endTime, String createdAt, String updatedAt, int participantsCount,
                        int likesCount, int commentsCount,String status, int creatorId) {
            this.activityId = activityId;
            this.activityName = activityName;
            this.category = category;
            this.tags = tags;
            this.description = description;
            this.startTime = startTime;
            this.endTime = endTime;
            this.createdAt = createdAt;
            this.updatedAt = updatedAt;
            this.participantsCount = participantsCount;
            this.likesCount = likesCount;
            this.commentsCount = commentsCount;
            this.status = status;
            this.creatorId = creatorId;
        }

        public int getActivityId() {
            return activityId;
        }

        public void setActivityId(int activityId) {
            this.activityId = activityId;
        }

        public String getActivityName() {
            return activityName;
        }

        public void setActivityName(String activityName) {
            this.activityName = activityName;
        }

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public String getTags() {
            return tags;
        }

        public void setTags(String tags) {
            this.tags = tags;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getStartTime() {
            return startTime;
        }

        public void setStartTime(String startTime) {
            this.startTime = startTime;
        }

        public String getEndTime() {
            return endTime;
        }

        public void setEndTime(String endTime) {
            this.endTime = endTime;
        }

        public String getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(String createdAt) {
            this.createdAt = createdAt;
        }

        public String getUpdatedAt() {
            return updatedAt;
        }

        public void setUpdatedAt(String updatedAt) {
            this.updatedAt = updatedAt;
        }

        public int getParticipantsCount() {
            return participantsCount;
        }

        public void setParticipantsCount(int participantsCount) {
            this.participantsCount = participantsCount;
        }

        public int getLikesCount() {
            return likesCount;
        }

        public void setLikesCount(int likesCount) {
            this.likesCount = likesCount;
        }

        public int getCommentsCount() {
            return commentsCount;
        }

        public void setCommentsCount(int commentsCount) {
            this.commentsCount = commentsCount;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public int getCreatorId() {
            return creatorId;
        }

        public void setCreatorId(int creatorId) {
            this.creatorId = creatorId;
        }

        @Override
        public String toString() {
            return activityId + "," + activityName + "," + category + "," + tags + "," + description + ","
                    + startTime + "," + endTime + "," + createdAt + "," + updatedAt + "," + participantsCount
                    + "," + likesCount + "," + commentsCount + "," + status + "," + creatorId;
        }
    }


    public class Comment {
        private int commentId;
        private String commentText;
        private long createdAt;
        private String username;
        private String name;
        private String avatarUrl;

        public Comment(int commentId, String commentText, long createdAt, String username, String name, String avatarUrl) {
            this.commentId = commentId;
            this.commentText = commentText;
            this.createdAt = createdAt;
            this.username = username;
            this.name = name;
            this.avatarUrl = avatarUrl;
        }

        public int getCommentId() {
            return commentId;
        }

        public String getCommentText() {
            return commentText;
        }

        public long getCreatedAt() {
            return createdAt;
        }

        public String getUsername() {
            return username;
        }

        public String getName() {
            return name;
        }

        public String getAvatarUrl() {
            return avatarUrl;
        }

        @Override
        public String toString() {
            return commentId + "," + commentText + "," + createdAt + "," + username + "," + name + "," + avatarUrl;
        }
    }

}
