import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:eduthon/backend/api_provider.dart';
import 'package:eduthon/models/task.dart';
import 'package:eduthon/models/user.dart';
import 'package:flutter/material.dart';
import 'package:eduthon/theme/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ToDo extends StatefulWidget {
  // List<String> _todoItems = [];
  User user;
  ToDo(this.user);

  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> with SingleTickerProviderStateMixin {
  TabController tabController;
  var tabHeaderStyle = TextStyle(fontSize: 15, color: mainColor);
  Stream<List<Task>> get personalTasks => _personalTask.stream;

  final _personalTask = BehaviorSubject<List<Task>>();

  Stream<List<Task>> get groupTasks => _groupTask.stream;

  final _groupTask = BehaviorSubject<List<Task>>();

  TextEditingController titleController,
      descController,
      groupTitleController,
      groupDescController;
  User user;
  List<Task> individual, group;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    tabController = TabController(length: 2, vsync: this);
    titleController = TextEditingController();
    descController = TextEditingController();
    groupDescController = TextEditingController();
    groupTitleController = TextEditingController();
    _personalTask.add(user.taskList);
    _groupTask.add(user.taskList);
    individual = user.taskList;
    group = user.teamTaskList;
  }

  TabBar _getTabBar() {
    return TabBar(
      indicatorColor: iconColor,
      indicatorWeight: 3,
      tabs: <Widget>[
        Tab(child: Text("Group", style: tabHeaderStyle)),
        Tab(child: Text("Personal", style: tabHeaderStyle)),
      ],
      controller: tabController,
    );
  }

  TabBarView _getTabBarView(List<Widget> tabs) {
    return TabBarView(
      children: tabs,
      controller: tabController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 55, child: _getTabBar()),
                SizedBox(
                    height: 525,
                    child: _getTabBarView([groupTodo(), personalTodo()]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget personalTodo() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40), topLeft: Radius.circular(40)),
            ),
            child: StreamBuilder<List<Task>>(
                // initialData: individual,
                stream: _personalTask,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  if (snapshot.hasData)
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                snapshot.data[index].title,
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                snapshot.data[index].description ?? "",
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    decoration: snapshot.data[index].progress
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                              ),
                              leading: Checkbox(
                                  value: snapshot.data[index].progress,
                                  onChanged: (val) {
                                    setState(() {
                                      snapshot.data[index].progress =
                                          !snapshot.data[index].progress;
                                    });
                                    print("call API");
                                  },
                                  activeColor: Colors.green),
                              isThreeLine: true,
                            ),
                            Divider(color: iconColor, height: 2)
                          ],
                        );
                      },
                      itemCount: snapshot.data.length,
                    );
                  else if (snapshot.hasError)
                    return Center(child: Text("Something went wrong :("));
                  else
                    return Center(child: SpinKitChasingDots(color: mainColor));
                }),
          ),
          Positioned(
            child: addPersonalTask(),
            bottom: 30,
            right: 20,
          )
        ],
      ),
    );
  }

  Widget addGroupTask() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text("Set new group task!",
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    print("api call");
                    Task task = Task(
                        progress: false,
                        title: groupTitleController.value.text,
                        description: groupDescController.value.text);
                    user.taskList = await CreateIndividualTask()
                        .createGroupTask(user, task);

                    _groupTask.add(user.teamTaskList);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Done",
                        style: TextStyle(fontSize: 17, color: mainColor)),
                  ))
            ],
            content: Container(
              height: 250,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      // textAlign: TextAlign.center,
                      controller: groupTitleController,
                      validator: (value) {
                        if (value.isEmpty) return "Please enter a title";
                        return null;
                      },
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.purple[300])),
                          hintText: "Task title",
                          hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.normal,
                              fontSize: 18)),
                    ),
                  ),
                  // SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: groupDescController,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.purple[300])),
                          hintText: "Add a description (optional)",
                          hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.normal,
                              fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
        child: Card(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          elevation: 5,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: iconColor, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.purple[200],
            ),
          ),
        ),
      ),
    );
  }

  Widget addPersonalTask() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text("Set new task!",
                      style: TextStyle(fontWeight: FontWeight.normal)),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    print("api call");
                    Task task = Task(
                        progress: false,
                        title: titleController.value.text,
                        description: descController.value.text);
                    user.taskList =
                        await CreateIndividualTask().createTask(user, task);
                    _personalTask.add(user.taskList);

                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Done",
                        style: TextStyle(fontSize: 17, color: mainColor)),
                  ))
            ],
            content: Container(
              height: 250,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      // textAlign: TextAlign.center,
                      controller: titleController,
                      validator: (value) {
                        if (value.isEmpty) return "Please enter a title";
                        return null;
                      },
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.purple[300])),
                          hintText: "Task title",
                          hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.normal,
                              fontSize: 18)),
                    ),
                  ),
                  // SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: descController,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey[300])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.purple[300])),
                          hintText: "Add a description (optional)",
                          hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.normal,
                              fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
        child: Card(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          elevation: 5,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: iconColor, width: 2),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.purple[200],
            ),
          ),
        ),
      ),
    );
  }

  Widget groupTodo() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              child: StreamBuilder<List<Task>>(
                  stream: _groupTask,
                  // initialData: group,
                  builder: (context, snapshot) {
                    print(snapshot.data);
                    if (snapshot.hasData)
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  snapshot.data[index].title,
                                  style: TextStyle(
                                      color: mainColor,
                                      fontWeight: FontWeight.bold,
                                      decoration: snapshot.data[index].progress
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                                ),
                                subtitle: Text(
                                  snapshot.data[index].description ?? "",
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      decoration: snapshot.data[index].progress
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none),
                                ),
                                leading: Checkbox(
                                    value: snapshot.data[index].progress,
                                    onChanged: (val) {
                                      setState(() {
                                        snapshot.data[index].progress =
                                            !snapshot.data[index].progress;
                                      });
                                      print("call API");
                                    },
                                    activeColor: Colors.green),
                              ),
                              Divider(color: iconColor, height: 2)
                            ],
                          );
                        },
                        itemCount: snapshot.data.length,
                      );
                    else if (snapshot.hasError)
                      return Center(child: Text("Something went wrong :("));
                    else
                      return Center(
                          child: SpinKitChasingDots(color: mainColor));
                  }),
            ),
            Positioned(
              child: user.isTeamAdmin ? addGroupTask() : Container(),
              bottom: 30,
              right: 20,
            )
          ],
        ));
  }
}
