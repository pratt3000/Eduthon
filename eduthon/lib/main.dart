import 'package:eduthon/backend/api_provider.dart';
import 'package:eduthon/models/user.dart';
import 'package:eduthon/screens/home.dart';
import 'package:eduthon/screens/joinorcreate.dart';
import 'package:eduthon/shared/fade_animation.dart';
import 'package:eduthon/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:validators/validators.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  User user;
  final fontSizeTextStyle = TextStyle(fontSize: 17);
  TabController tabController;
  var tabHeaderStyle = TextStyle(fontSize: 15, color: mainColor);
  TextEditingController emailController,
      usernameController,
      passwordController,
      usernameLoginController,
      passwordLoginController;
  FocusNode emailNode,
      usernameNode,
      passwordNode,
      usernameLoginNode,
      passwordLoginNode;
  final _formKey = GlobalKey<FormState>();
  final _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    tabController.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    emailNode = FocusNode();
    usernameNode = FocusNode();
    passwordNode = FocusNode();
    usernameLoginController = TextEditingController();
    passwordLoginController = TextEditingController();
    usernameLoginNode = FocusNode();
    passwordLoginNode = FocusNode();
  }

  TabBar _getTabBar() {
    return TabBar(
      indicatorColor: iconColor,
      tabs: <Widget>[
        Tab(child: Text("Register", style: tabHeaderStyle)),
        Tab(child: Text("Login", style: tabHeaderStyle)),
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
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(height: 190, child: WavyHeaderImage()),
                SizedBox(height: 45, child: _getTabBar()),
                SizedBox(
                    height: 480,
                    child: _getTabBarView([registerWidget(), loginWidget()]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          FadeAnimation(
              0.4,
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 20.0,
                          offset: Offset(0, 10))
                    ]),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[100]))),
                        child: TextFormField(
                          style: fontSizeTextStyle,
                          validator: (value) {
                            if (value.isEmpty) return "Please enter your email";
                            if (!isEmail(value))
                              return "Please enter a valid email";

                            return null;
                          },
                          textInputAction: TextInputAction.go,
                          controller: emailController,
                          focusNode: emailNode,
                          onFieldSubmitted: (value) {
                            usernameNode.requestFocus();
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email ID",
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[100]))),
                        child: TextFormField(
                          controller: usernameController,
                          focusNode: usernameNode,
                          onFieldSubmitted: (value) {
                            passwordNode.requestFocus();
                          },
                          style: fontSizeTextStyle,
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please enter your username";
                            return null;
                          },
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Username",
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty)
                              return "Please enter your password";
                            if (value.length < 8)
                              return "Please enter min 8 characters";
                            return null;
                          },
                          style: fontSizeTextStyle,
                          controller: passwordController,
                          focusNode: passwordNode,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 30,
          ),
          FadeAnimation(
            0.6,
            InkWell(
              onTap: () {
                print(passwordController.value.text);
                if (_formKey.currentState.validate()) {
                  user = User(
                      email: emailController.value.text,
                      password: passwordController.value.text,
                      username: usernameController.value.text,
                      isTeamAdmin: false);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JoinOrCreateTeam(user)));
                } else
                  print("do nothing");
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    iconColor,
                    Colors.purple[200],
                    mainColor,
                    // Colors.purple[400]
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          FadeAnimation(
              0.4,
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 20.0,
                          offset: Offset(0, 10))
                    ]),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[100]))),
                        child: TextFormField(
                          controller: usernameLoginController,
                          focusNode: usernameLoginNode,
                          validator: (value) {
                            if (value.isEmpty) return "Please enter a username";
                            return null;
                          },
                          style: fontSizeTextStyle,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Username",
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 20)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: passwordLoginController,
                          focusNode: passwordLoginNode,
                          style: fontSizeTextStyle,
                          validator: (value) {
                            if (value.isEmpty) return "Please enter a password";
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                ),
              )),
          SizedBox(
            height: 30,
          ),
          FadeAnimation(
            0.6,
            InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                if (_loginFormKey.currentState.validate())
                  user = await LoginAPI().login(
                      usernameLoginController.value.text,
                      passwordLoginController.value.text);
                setState(() {
                  isLoading = false;
                });
                if (user != null) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(user)));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Invalid credentials",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Retry",
                                  style: TextStyle(
                                      fontSize: 15, color: mainColor)),
                            ))
                      ],
                      content: Container(
                          height: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Please re-enter a valid username and password.",
                                textAlign: TextAlign.left,
                              ),
                            ],
                          )),
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    iconColor,
                    Colors.purple[200],
                    mainColor,
                    // Colors.purple[400]
                  ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isLoading
                      ? SpinKitChasingDots(size: 20, color: Colors.white)
                      : Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          // FadeAnimation(
          //     0.8,
          //     Text(
          //       "Forgot Password?",
          //       style: TextStyle(color: mainColor),
          //     )),
        ],
      ),
    );
  }
}

class WavyHeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [iconColor, mainColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
      ),
      clipper: BottomWaveClipper(),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
