class User {
  String email;
  String name;
  String userId;
  //String photoPath;
  String userType;
  String whatsappNumber;
  String number;
  String countryName;
 // List<String> subjects;
  User(
      {this.email,
      this.name,
      this.userId,
      this.userType,
      this.whatsappNumber,
      this.number,
      this.countryName});

  User.fromMap(Map<String, dynamic> map) {
    this.userId = map["userId"];
    this.email = map["email"];
    this.name = map["name"];
   // this.photoPath = map["photoPath"];
    this.userType = map["userType"];
    this.whatsappNumber = map["whatsappNumber"];
    this.number = map["number"];
    this.countryName = map["countryName"];

    /*this.subjects = List<String>();
    for (var i = 0; i < map["subjects"].length; i++) {
      this.subjects.add((map["subjects"][i]));
    }*/
  }

  toJson(String userId) {
    return {
      "userId": userId,
      "email": this.email,
      //"photoPath":this.photopath,
      "name": this.name,
      "userType": this.userType,
      "whatsappNumber": this.whatsappNumber,
      "number": this.number,
      "countryName": this.countryName,

     // "subjects": List<String>.from(this.subjects),
    };
  }
}

class Subjects {
  List<String> subjects;
  Subjects({this.subjects});

  Subjects.fromMap(Map<String, dynamic> map) {
    this.subjects = List<String>();
    for (var i = 0; i < map["subjects"].length; i++) {
      this.subjects.add(map["subjects"][i]);
    }
  }
  toJson() {
    return {
      "subjects": List<String>.from(this.subjects),
    };
  }
}
