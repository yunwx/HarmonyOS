import java.beans.Statement;
import java.io.*;
import java.net.*;
import java.util.ArrayList;
import java.util.Objects;

public class DbTest {
    public static void main(String[] args) {
        DbService db = new DbService();
        db.clearTable("MESSAGES");
        //db.rejectFriendRequest(1,2);
        /*DbService.USERINFO user = new DbService.USERINFO(
                0,// id
                "123",// username
                "123",// password
                "man",// gender
                "Page_image/man.png",// avatar_Url
                "",// name
                null,// birthday
                "" // interests
        );
        DbService.USERINFO user1 = new DbService.USERINFO(
                0,// id
                "124",// username
                "124",// password
                "woman",// gender
                "Page_image/woman.png",// avatar_Url
                "",// name
                null,// birthday
                "" // interests
        );
        db.insertUser(user);
        db.insertUser(user1);
        */

        /*ArrayList<DbService.USERINFO>  arrayList = db.queryUsers();

        for(DbService.USERINFO u:arrayList){
            System.out.println(u.toString());
        }*/

    }
}
