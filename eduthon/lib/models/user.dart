import 'dart:convert';

import 'package:eduthon/backend/api_provider.dart';
import 'package:eduthon/models/task.dart';
import 'package:eduthon/models/team.dart';

class User {
  String username;
  String email;
  String password;
  String jwt;
  String id; //hashed
  int primaryKey; //1
  List<Task> taskList;
  List<Task> teamTaskList;
  int team;
  bool isTeamAdmin;
  String teamCode;

  void reset() {
    this.email = null;
    this.id = null;
    this.jwt = null;
    this.password = null;
    this.primaryKey = null;
    this.taskList = null;
    this.team = null;
    this.teamTaskList = null;
    this.isTeamAdmin = null;
    this.teamCode = null;
    this.username = null;
  }

  User(
      {this.email,
      this.id,
      this.jwt,
      this.password,
      this.primaryKey,
      this.teamTaskList,
      this.taskList,
      this.team,
      this.isTeamAdmin,
      this.teamCode,
      this.username});

  User.fromJson(String jsonString) {
    Map<dynamic, dynamic> parsedResponse = json.decode(jsonString);
    parsedResponse = parsedResponse["data"]["allUsers"]["edges"][0]["node"];
    print(parsedResponse.toString());
    email = parsedResponse["email"];
    id = parsedResponse["id"];
    isTeamAdmin = parsedResponse["isTeamAdmin"];
    username = parsedResponse["username"];
    primaryKey = decodeId(parsedResponse["id"] ?? "abc:-1");
    jwt = parsedResponse["jwt"] ?? "";
    team = int.parse(parsedResponse["team"]["id"]) ?? -1;
  }
}
