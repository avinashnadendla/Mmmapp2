class Chat {
  String message;
  var date;
  String sendBy;
  String messageType;
  Chat({this.message, this.date, this.sendBy,this.messageType});

  Chat.fromMap(Map<String, dynamic> map) {
    this.message = map["message"];
    this.date = map["date"];
    this.sendBy = map["sendBy"];
    this.messageType=map["messageType"];
  }

  toJson() {
    return {
      "message": this.message,
      "date": this.date,
      "sendBy": this.sendBy,
      "messageType":this.messageType
    };
  }
}


class ChatImage {
  var date;
  String message;
  String sendBy;
  String messageType;
  ChatImage({ this.date, this.sendBy,this.messageType});

  ChatImage.fromMap(Map<String, dynamic> map) {
    this.date = map["date"];
    this.sendBy = map["sendBy"];
    this.message=map["message"];
    this.messageType=map["messageType"];
  }

  toJson() {
    return {
      "date": this.date,
      "sendBy": this.sendBy,
      "messageType":this.messageType
    };
  }
}

class GroupPeople {
  String docId;
  List<String> usersID;
  List<String> groupUsers;
  String groupName;
  String date;
  String photoPath;
  GroupPeople({
    this.groupUsers,
    this.usersID,
    this.groupName,
    this.date,
  });
  GroupPeople.fromMap(Map<String, dynamic> map) {
    this.docId = map["docId"];
    this.groupName = map["groupName"];
    this.photoPath = map["photoPath"];
    this.date = map["date"];
    this.groupUsers = List<String>();
    for (var i = 0; i < map["groupUsers"].length; i++) {
      this.groupUsers.add(map["groupUsers"][i]);
    }
    this.usersID = List<String>();
    for (var i = 0; i < map["usersId"].length; i++) {
      this.usersID.add((map["usersId"][i]));
    }
  }
  toJson() {
    return {
      "groupUsers": List<String>.from(this.groupUsers),
      "usersId": List<String>.from(this.usersID),
      "groupName": this.groupName,
      "date": this.date
    };
  }
}