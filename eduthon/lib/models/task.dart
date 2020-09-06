import 'dart:convert';

class Task {
  String title;
  String description;
  bool progress;
  String id;

  Task({this.title, this.description, this.progress, this.id});

  Task.fromJson(String jsonString) {
    Map<dynamic, dynamic> parsedResponse = json.decode(jsonString);
    title = parsedResponse["title"];
    id = parsedResponse["id"];
    description = parsedResponse["description"];
    if (parsedResponse["progress"] != null) {
      parsedResponse["progress"] == 0 ? progress = false : progress = true;
    }
  }
}
