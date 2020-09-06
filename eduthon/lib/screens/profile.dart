import 'package:eduthon/models/user.dart';
import 'package:flutter/material.dart';
import 'package:eduthon/theme/colors.dart';
import 'package:eduthon/main.dart';

class ProfileApp extends StatelessWidget {
  final User user;
  ProfileApp(this.user);
  final String url =
      "https://i.graphicmama.com/uploads/2017/12/5a2699827c42c-office-work-i-am-the-man.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        image: DecorationImage(
                            image: NetworkImage(url), fit: BoxFit.cover)),
                  ),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75.0),
                child: Divider(
                  color: iconColor,
                  thickness: 3,
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300], width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: 'Username: ',
                            style: DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: mainColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: user.username,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: 'Email: ',
                            style: DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: mainColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: user.email,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: 'Team-Code: ',
                            style: DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: mainColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: user.teamCode,
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            text: 'Status: ',
                            style: DefaultTextStyle.of(context).style.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: mainColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: user.isTeamAdmin ? 'Admin' : 'Member',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: InkWell(
                    onTap: () {
                      print("button tapped");
                      user.reset();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
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
                          "Logout",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
