import 'package:eduthon/models/task.dart';
import 'package:eduthon/models/user.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ApiProvider {
  String baseUrl = "http://eduthon2.azurewebsites.net/graphql/";

  Future<dynamic> interactWithApiQuery(String payload) async {
    Response response = await post(baseUrl, body: {"query": payload});
    // print(response.body);
    return response.body;
  }

  Future<dynamic> interactWithApiMutation(String payload) async {
    Response response = await post(baseUrl, body: {"query": payload});
    // print(response.body);
    return response.body;
  }
}

int decodeId(String id) {
  var base64encoded = base64.decode(id);
  var bytesInLatin1 = latin1.decode(base64encoded);
  return int.parse(bytesInLatin1.split(':')[1]);
}

String encodeId(String key, int id) {
  String finalId = key + ':' + id.toString();
  var bytesInLatin1 = latin1.encode(finalId);
  var base64encoded = base64.encode(bytesInLatin1);
  return base64encoded;
}

class RegisterAPI {
  Future<User> register(String email, String username, String password,
      bool isTeamAdmin, int teamId) async {
    User user;
    String mutationQuery = """mutation{
      createUser(input: {username: "$username", password1: "$password", password2: "$password", isTeamAdmin: $isTeamAdmin, team: $teamId, email: "$email"}){
      user{
          username
          }
        }
        }""";
    ApiProvider apiProvider = ApiProvider();
    print(mutationQuery);
    String response = await apiProvider.interactWithApiQuery(mutationQuery);
    print(response);
    user = await UserAPI().userQuery(username);

    return user;
  }
}

class UserAPI {
  Future<User> userQuery(String username) async {
    String query = """
    query{
  allUsers(username: "$username"){
    edges{
      node{
        username
        id
        email
        isTeamAdmin
      team {
        id
      }
      }
    }
  }
}
    """;

    ApiProvider apiProvider = ApiProvider();
    User user;
    String response = await apiProvider.interactWithApiQuery(query);
    print(response);
    user = User.fromJson(response);
    user.teamCode = encodeId('TeamPortfolio', user.team);
    user.taskList = await CreateIndividualTask().taskList(user.id);
    user.teamTaskList =
        await CreateIndividualTask().teamTaskList(user.teamCode);
    return user;
  }
}

class LoginAPI {
  Future<User> login(String username, String password) async {
    String mutationQuery = """
    mutation{
  tokenAuth(username: "$username", password: "$password")
  {
    token
  }
}""";
    ApiProvider apiProvider = ApiProvider();

    String response = await apiProvider.interactWithApiQuery(mutationQuery);
    print(response);
    Map<dynamic, dynamic> parsedResponse = json.decode(response);
    try {
      if (parsedResponse["data"]["tokenAuth"]["token"] != null) {
        print("logged in");
        User user = await UserAPI().userQuery(username);
        return user;
      }
    } catch (e) {
      return null;
    }
  }
}

class CreateNewTeamAndRegister {
  Future<User> createNewTeamAndRegister(User user, String teamName) async {
    String mutationQuery = """mutation{
    createTeam(input: {name: "$teamName", members: 1})
      {
      clientMutationId  
      }
    }""";
    ApiProvider apiProvider = ApiProvider();
    String response = await apiProvider.interactWithApiQuery(mutationQuery);
    print(response);
    Map<dynamic, dynamic> parsedResponse = json.decode(response);
    if (parsedResponse["data"]["createTeam"]["clientMutationId"] == null) {
      String teamQuery = """
      query{
        allTeams(name: "$teamName")
          {
            edges{
               node{
                id
          }
        }
      }
    }
      """;
      String teamResponse = await apiProvider.interactWithApiQuery(teamQuery);
      Map<dynamic, dynamic> newResponse = json.decode(teamResponse);
      print(newResponse);
      User registered = await RegisterAPI().register(
          user.email,
          user.username,
          user.password,
          true,
          decodeId(newResponse["data"]["allTeams"]["edges"][0]["node"]["id"]));
      registered.teamCode =
          newResponse["data"]["allTeams"]["edges"][0]["node"]["id"];
      return registered;
    }
    return null;
  }
}

class CreateIndividualTask {
  Future<List<Task>> createTask(User user, Task task) async {
    String mutationQuery = """
    mutation {
  createIndvTask(input: {task: "${task.title}", desc: "${task.description}", user: ${user.primaryKey}, prog: 0}){
    indvTask{
      task
    }
  }
}""";
    ApiProvider apiProvider = ApiProvider();
    String response = await apiProvider.interactWithApiQuery(mutationQuery);
    print(mutationQuery);
    print(response);
    Map<dynamic, dynamic> parsedResponse = json.decode(response);
    if (parsedResponse["data"]["createIndvTask"]["indvTask"]["task"] ==
        task.title) {
      List<Task> tasks = await taskList(user.id);
      return tasks;
    } else
      return null;
  }

  Future<List<Task>> taskList(String userId) async {
    String taskList = """query{
  allIndvtasks(user: "$userId")
  {
    edges
    {
      node
      {
        task
        desc
        prog
      }
    }
  }
}""";
    ApiProvider apiProvider = ApiProvider();
    String taskListResponse = await apiProvider.interactWithApiQuery(taskList);
    Map<dynamic, dynamic> newResponse = json.decode(taskListResponse);
    List<dynamic> response = newResponse["data"]["allIndvtasks"]["edges"];
    print(response.toString());

    List<Task> tasks = response.map((e) {
      return Task(
          title: e["node"]["task"],
          description: e["node"]["desc"],
          progress: e["node"]["prog"] == 0 ? false : true);
    }).toList();
    print("\n\n\n\length for indvitasklist: ${tasks.length}\n\n\n");

    return tasks;
  }

  Future<List<Task>> teamTaskList(String teamId) async {
    print(teamId);
    String taskListQuery = """query{
  allGrouptasks(team: "$teamId")
  {
    edges
    {
      node
      {
        task
        description
        
      }
    }
  }
}""";
    ApiProvider apiProvider = ApiProvider();
    print(taskListQuery);

    String taskListResponse =
        await apiProvider.interactWithApiQuery(taskListQuery);

    print(taskListResponse);
    Map<dynamic, dynamic> newResponse = json.decode(taskListResponse);
    List<dynamic> responseList = newResponse["data"]["allGrouptasks"]["edges"];
    print(responseList.toString());
    List<Task> tasks = responseList.map((e) {
      // print(e["node"]["task"]);
      return Task(
          title: e["node"]["task"],
          description: e["node"]["description"],
          progress: false);
    }).toList();
    print("\n\n\n\length for teamtasklist: ${tasks.length}\n\n\n");
    return tasks;
  }

  Future<List<Task>> createGroupTask(User user, Task task) async {
    String mutationQuery = """
    mutation{
  createGroup(input: {task: "${task.title}", description: "${task.description}", team: ${user.team}}){
    groupTasks{
      task 
    }
  }
}""";
    ApiProvider apiProvider = ApiProvider();
    String response = await apiProvider.interactWithApiQuery(mutationQuery);
    print(mutationQuery);
    print(response);
    Map<dynamic, dynamic> parsedResponse = json.decode(response);
    if (parsedResponse["data"]["createGroup"]["groupTasks"]["task"] ==
        task.title) {
      List<Task> tasks = await teamTaskList(user.teamCode);
      return tasks;
    } else
      return null;
  }
}

class Misc {
  Future<List<dynamic>> allUsersFromTeam(String teamCode) async {
    String query = """query{
      allUsers(team: $teamCode)
      {
        edges{
          node{
            username
          }
        }
      }
    }""";
    ApiProvider apiProvider = ApiProvider();
    String response = await apiProvider.interactWithApiQuery(query);
    Map<dynamic, dynamic> parsedResponse = json.decode(response);
    List<dynamic> allUserNames = parsedResponse["data"]["allUsers"]["edges"];
  }
}
