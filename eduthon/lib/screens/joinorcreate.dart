import 'dart:async';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:eduthon/backend/api_provider.dart';
import 'package:eduthon/models/user.dart';
import 'package:eduthon/screens/home.dart';
import 'package:eduthon/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JoinOrCreateTeam extends StatefulWidget {
  final User user;
  JoinOrCreateTeam(this.user);
  @override
  _JoinOrCreateTeamState createState() => _JoinOrCreateTeamState();
}

class _JoinOrCreateTeamState extends State<JoinOrCreateTeam> {
  TextEditingController controller;
  TextEditingController textEditingController;
  StreamController<User> streamController;
  StreamController<User> newStream;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    textEditingController = TextEditingController();
    streamController = StreamController<User>();
    newStream = StreamController<User>();
    widget.user.teamCode = "Not yet generated";
    streamController.add(widget.user);
    newStream.add(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  InkWell(
                    onTap: () {
                      print("button tapped");
                      createNewTeam(widget.user);
                    },
                    child: Container(
                        height: 50,
                        width: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [iconColor, mainColor],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Icon(Icons.add,
                                    size: 30, color: iconColor)),
                            Expanded(
                              flex: 6,
                              child: Text("Create a team",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            )
                          ],
                        )),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [iconColor, mainColor],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                          ),
                          height: 2.0,
                          width: 130.0,
                        ),
                      ),
                      Text("OR", style: TextStyle(fontStyle: FontStyle.italic)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [mainColor, iconColor],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                          ),
                          height: 2.0,
                          width: 130.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60),
                  Container(
                      child: Column(
                    children: [
                      Text("Join an existing one!",
                          style: TextStyle(color: mainColor, fontSize: 20)),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(18.0),
                        child: SizedBox(
                          width: 280,
                          height: 50,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: controller,
                            validator: (value) {
                              if (value.isEmpty) return "Please enter a code";
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300])),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300])),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.purple[300])),
                                hintText: "Paste your code here",
                                hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                          onTap: () async {
                            print("button tapped");
                            setState(() {
                              isLoading = true;
                            });
                            user = await RegisterAPI().register(
                                user.email,
                                user.username,
                                user.password,
                                false,
                                decodeId(controller.value.text));
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(user)),
                                (route) => false);
                          },
                          child: Container(
                            height: 50,
                            width: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [iconColor, mainColor],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft),
                            ),
                            child: Center(
                              child: Text(
                                "Join team",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ))
                    ],
                  )),
                ]),
          ),
        ),
      ),
    );
  }

  createNewTeam(User user) {
    bool isCopied = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text("Create new team",
                  style: TextStyle(fontWeight: FontWeight.normal)),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                ClipboardManager.copyToClipBoard(user.teamCode).then((result) {
                  setState(() {
                    isCopied = true;
                  });
                });
              },
              child: Padding(
                padding: EdgeInsets.all(8),
                child: !isCopied
                    ? Icon(FontAwesomeIcons.clipboard, color: mainColor)
                    : Icon(FontAwesomeIcons.clipboardCheck, color: Colors.red),
              )),
          SizedBox(width: 80),
          StreamBuilder<User>(
              stream: newStream.stream,
              builder: (context, snapshot) {
                if (snapshot.data.teamCode == null ||
                    snapshot.data.teamCode == "Not yet generated" ||
                    snapshot.data.teamCode == "Generating..")
                  return FlatButton(
                      onPressed: () async {
                        user.isTeamAdmin = true;
                        user.teamCode = "Generating..";
                        streamController.add(user);
                        user = await CreateNewTeamAndRegister()
                            .createNewTeamAndRegister(
                                user, textEditingController.value.text);
                        streamController.add(user);
                      },
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Get code",
                              style:
                                  TextStyle(fontSize: 15, color: mainColor))));
                else {
                  return FlatButton(
                      onPressed: () async {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(user)),
                            (route) => false);
                      },
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Continue",
                              style:
                                  TextStyle(fontSize: 15, color: mainColor))));
                }
              })
        ],
        content: Container(
          height: 200,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  // textAlign: TextAlign.center,
                  controller: textEditingController,
                  validator: (value) {
                    if (value.isEmpty) return "Please enter a team name";
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
                          borderSide: BorderSide(color: Colors.purple[300])),
                      hintText: "Enter team name",
                      hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.normal,
                          fontSize: 18)),
                ),
              ),
              StreamBuilder<User>(
                  stream: streamController.stream,
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.data.teamCode != null ||
                        snapshot.data.teamCode != "Not yet generated" ||
                        snapshot.data.teamCode != "Generating..")
                      newStream.add(snapshot.data);
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey[300])),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey[300])),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.purple[300])),
                            hintText: snapshot.data.teamCode,
                            hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.normal,
                                fontSize: 18)),
                      ),
                    );
                  }),
            ],
          ),
        ),
        shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
