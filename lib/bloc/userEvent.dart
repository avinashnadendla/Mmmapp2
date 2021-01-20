import 'dart:io';

import 'package:mmmapp/Models/User.dart';

abstract class UserEvent {}

class AddUser extends UserEvent {
  final User user;
 // final File file;
  AddUser({this.user});
}
class EditUser extends UserEvent{
  final String name;
  final String userId;
 // final File file;
  EditUser({this.name,this.userId});
}

class FetchUser extends UserEvent {
  final String userID;

  FetchUser({this.userID});
}

class FetchAllUser extends UserEvent {}
class FetchSubjects extends UserEvent{}