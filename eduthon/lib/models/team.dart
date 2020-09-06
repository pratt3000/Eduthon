import 'dart:convert';

class Team {
  String name;
  int members;
  String id;
  String primaryKey;

  Team({this.id, this.members, this.primaryKey, this.name});

  Team.fromJson(String jsonString) {
    Map<dynamic, dynamic> parsedResponse = json.decode(jsonString);
    members = parsedResponse["members"];
    id = parsedResponse["id"];
    name = parsedResponse["name"];
    primaryKey = parsedResponse["primaryKey"];
  }
}
