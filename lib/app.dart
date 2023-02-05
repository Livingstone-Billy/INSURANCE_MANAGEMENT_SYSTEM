import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insurance_management_system/admin/home.dart';
import 'package:insurance_management_system/utilities/utilities.dart';

import 'customer/customer.dart';

class InsuranceApp extends StatelessWidget {
  const InsuranceApp({Key? key}) : super(key: key);

  static final Utilities utilities = Utilities();

  Route<dynamic> route(Widget widget) {
    return CupertinoPageRoute(builder: (context) {
      return widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Insurance Management System",
        debugShowCheckedModeBanner: false,
        home: Builder(
            builder: (context) => Scaffold(
                appBar: utilities.mainAppBar(context, false),
                body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/insurance.jpg"),
                      fit: BoxFit.cover,
                    )),
                    child: Stack(
                      children: const [
                        Positioned(
                          top: 30.0,
                          left: 200.0,
                          child: Text(
                            "'Life Insurance is like a parachute, If you don't have it when you need it, you will never need it again!'",
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    )))));
  }
}

class ActionPage extends StatelessWidget {
  const ActionPage({Key? key, required this.userType}) : super(key: key);

  final UserType userType;
  @override
  Widget build(BuildContext context) {
    final Utilities utilities = Utilities();
    return MaterialApp(
      title: "Action Page",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: utilities.mainAppBar(context, true),
          body: Container(
            decoration: BoxDecoration(color: Colors.blueGrey[100]),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Hello, Customer",
                    style: TextStyle(
                      fontSize: 50,
                    ),
                  ),
                  Text(
                    "Welcome to Relative Insurance Agency",
                    style: TextStyle(color: Colors.blueGrey[500], fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      "You can access our services after login",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const CustomerSignUp()));
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              minimumSize: const Size(150, 50),
                            ),
                            child: const Text(
                              "Create Account",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(const InsuranceApp()
                                .route(const LoginPage(
                                    userType: UserType.customer)));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
          )),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.userType}) : super(key: key);

  final UserType userType;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Utilities utilities = Utilities();
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool _isUser = false;

  Future<void> _userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (userCredential.user != null) {
        setState(() {
          _isUser = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: ((context) {
              return const AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      "Incorrect Credentials",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.red),
                    ),
                  ),
                ),
              );
            }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "${widget.userType.name} Login",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: utilities.mainAppBar(context, true),
        body: Center(
          child: SizedBox(
            height: 350,
            width: 300,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "${widget.userType.name} Login",
                        style:
                            const TextStyle(fontSize: 19, color: Colors.blue),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "email cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "password cannot be empty";
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: (() {
                          if (_formKey.currentState!.validate()) {
                            _userLogin().then((value) {
                              if (_isUser &&
                                  widget.userType == UserType.customer) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    const InsuranceApp().route(CustomerPage(
                                        email: emailController.text)),
                                    (route) => false);
                              } else if (_isUser &&
                                  widget.userType == UserType.admin) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    const InsuranceApp()
                                        .route(const AdminHome()),
                                    ((route) => false));
                              }
                            });
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          backgroundColor: Colors.red[900],
                          minimumSize: const Size(150, 45),
                        ),
                        child: const Text("Login"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
