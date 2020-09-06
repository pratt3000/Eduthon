import 'package:eduthon/models/task.dart';
import 'package:eduthon/models/team.dart';
import 'dart:convert';

class GroupTask {
  Task groupTask;
  Team team;

  GroupTask({this.groupTask, this.team});

  GroupTask.fromJson(String jsonString) {
    Map<dynamic, dynamic> parsedResponse = json.decode(jsonString);
    groupTask = Task.fromJson(parsedResponse["task"]);
    team = Team.fromJson(parsedResponse["team"]);
  }
}
