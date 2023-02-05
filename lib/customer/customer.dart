import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insurance_management_system/utilities/utilities.dart';

import '../app.dart';
import '../policy/policy.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key, required this.email}) : super(key: key);

  final String email;
  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final Utilities utilities = Utilities();

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> childrens = [
      CustomerDashboard(
        email: widget.email,
      ),
      ApplyPolicy(
        email: widget.email,
      ),
      PolicyHistory(email: widget.email),
      MakeInquiry(
        email: widget.email,
      ),
      Inquiries(email: widget.email)
    ];
    return MaterialApp(
        title: "Customer Page",
        debugShowCheckedModeBanner: false,
        home: CustomerScaffold(
          title: "INSURANCE MANAGEMENT",
          isRoute: false,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 200,
                    color: Colors.grey.shade900,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("customer")
                                  .doc(widget.email.trim())
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Text(
                                    "Error retrieving data",
                                    style: TextStyle(color: Colors.red),
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                Map<String, dynamic> data = {};
                                if (snapshot.hasData) {
                                  data = snapshot.data!.data()
                                      as Map<String, dynamic>;
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(data['imgUrl']),
                                      radius: 50,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        data['firstname'],
                                        style: const TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )),
                        WidgetListTile(
                            title: "Dashboard",
                            icon: Icons.palette_sharp,
                            action: () {
                              setState(() {
                                currentPageIndex = 0;
                              });
                            }),
                        WidgetListTile(
                            title: "Apply policy",
                            icon: Icons.local_parking_rounded,
                            action: () {
                              setState(() {
                                currentPageIndex = 1;
                              });
                            }),
                        WidgetListTile(
                            title: "History",
                            icon: Icons.history,
                            action: () {
                              setState(() {
                                currentPageIndex = 2;
                              });
                            }),
                        WidgetListTile(
                            title: "Inquiry",
                            icon: Icons.help,
                            action: () => setState(() {
                                  currentPageIndex = 3;
                                })),
                        WidgetListTile(
                            title: "Inquiries made",
                            icon: Icons.restart_alt_rounded,
                            action: () {
                              setState(() {
                                currentPageIndex = 4;
                              });
                            }),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 30.0, left: 250.0, child: childrens[currentPageIndex])
              ],
            ),
          ),
        ));
  }
}

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({Key? key, required this.email}) : super(key: key);

  final String email;
  @override
  Widget build(BuildContext context) {
    final Utilities utilities = Utilities();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FutureBuilder(
          future: utilities.getCollectionCount("policy"),
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const Text(
                "No available data!",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            int value = snapshot.data!;
            return InfoContainer(
                dimensions: const [250, 150],
                text: "Available Policy",
                icon: Icons.local_parking,
                value: value,
                action: (() => true));
          },
        ),
        Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FutureBuilder(
              future: utilities.getCollectionCountWithFilter(
                  "history", "email", email),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    "No available data!",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                int value = snapshot.data!;
                return InfoContainer(
                    dimensions: const [250, 150],
                    text: "Policy Applied",
                    icon: Icons.local_parking,
                    value: value,
                    action: (() => true));
              },
            )),
        Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FutureBuilder(
              future: utilities.getCollectionCount("policyCategory"),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    "No available data!",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                int value = snapshot.data!;
                return InfoContainer(
                    dimensions: const [250, 150],
                    text: "Policy Categories",
                    icon: Icons.list_alt,
                    value: value,
                    action: (() => true));
              },
            )),
        Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: FutureBuilder(
              future: utilities.getCollectionCountWithFilter(
                  "inquiry", "email", email),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    "No available data!",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                int value = snapshot.data!;
                return InfoContainer(
                    dimensions: const [250, 150],
                    text: "Total Inquiries made",
                    icon: Icons.help,
                    value: value,
                    action: (() => true));
              },
            ))
      ],
    );
  }
}

class CustomerSignUp extends StatefulWidget {
  const CustomerSignUp({Key? key}) : super(key: key);

  @override
  State<CustomerSignUp> createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  final UserType user = UserType.customer;

  final Utilities _utilities = Utilities();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final CollectionReference _customerReference =
      FirebaseFirestore.instance.collection("customer");

  TextEditingController idNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController imageUrl = TextEditingController();

  bool _isUser = false;
  static const double fieldWidth = 500.0;
  static const double rightPadding = 20.0;
  static const double leftPadding = 135.0;

  @override
  void dispose() {
    idNoController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNoController.dispose();
    emailController.dispose();
    imageUrl.dispose();

    super.dispose();
  }

  Future<void> _createCustomer() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (userCredential.user != null) {
        setState(() {
          _isUser = true;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
            context: context,
            builder: ((context) {
              return const AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      "Weak Password!, should be 8 chars long with alphanumeric chars",
                      overflow: TextOverflow.clip,
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
      if (e.code == 'email-already-in-use') {
        showDialog(
            context: context,
            builder: ((context) {
              return const AlertDialog(
                content: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      "Account for that e-mail already exists",
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

  Future<void> saveCustomer() {
    return _customerReference.doc(emailController.text.trim()).set({
      "idNo": idNoController.text,
      "firstname": firstNameController.text,
      "lastname": lastNameController.text,
      "phoneNo": phoneNoController.text,
      "imgUrl": imageUrl.text,
      "email": emailController.text
    });
  }

  Future<void> uploadFile(String lastName) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      String fileName = lastName.trim();
      Reference ref =
          FirebaseStorage.instance.ref().child('customer/$fileName.jpg');
      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.first.bytes;

        await ref.putData(fileBytes!);
        ref.getDownloadURL().then((value) {
          setState(() {
            imageUrl.text = value;
          });
        });
      }
    } on FirebaseException {
      debugPrint("Error while uploading file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Customer SignUp",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: _utilities.mainAppBar(context, true),
          body: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 50.0, right: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "CUSTOMER SIGNUP",
                          style: TextStyle(
                              color: Colors.red[800],
                              fontSize: 45,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: leftPadding, bottom: 20.0, top: 10.0),
                              child: SizedBox(
                                width: fieldWidth,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "ID/Passport no cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: idNoController,
                                  decoration: InputDecoration(
                                      labelText: 'ID/Passport',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: rightPadding, bottom: 20.0, top: 10.0),
                              child: SizedBox(
                                width: fieldWidth,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  obscureText: true,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: leftPadding, bottom: 20.0, top: 10.0),
                              child: SizedBox(
                                width: fieldWidth,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Firstname cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: firstNameController,
                                  decoration: InputDecoration(
                                      labelText: 'Firstname',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: rightPadding,
                                    bottom: 20.0,
                                    top: 10.0),
                                child: SizedBox(
                                  width: fieldWidth,
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Lastname cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    },
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                        labelText: "Lastname",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        )),
                                  ),
                                ))
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: leftPadding, bottom: 20.0, top: 10.0),
                              child: SizedBox(
                                width: fieldWidth,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Mobile no cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: phoneNoController,
                                  decoration: InputDecoration(
                                      labelText: 'Mobile',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: rightPadding, bottom: 20.0, top: 10.0),
                              child: SizedBox(
                                width: fieldWidth,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "email  address cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      labelText: 'E-mail',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: SizedBox(
                            width: fieldWidth * 2,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Select photo to continue";
                                } else {
                                  return null;
                                }
                              },
                              controller: imageUrl,
                              readOnly: true,
                              onTap: () {
                                uploadFile(lastNameController.text);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Profile Picture',
                                  prefixIcon: const Icon(Icons.image),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _createCustomer().then((value) {
                                    if (_isUser) {
                                      saveCustomer().then((value) => Navigator
                                              .of(context)
                                          .push(CupertinoPageRoute(
                                              builder: (context) => LoginPage(
                                                    userType: user,
                                                  ))));
                                    }
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(200, 55)),
                              child: const Text("Create Account"),
                            )),
                      ],
                    ),
                  )))),
    );
  }
}

class ApplyPolicy extends StatelessWidget {
  const ApplyPolicy({super.key, required this.email});

  final String email;

  Future<DocumentReference<Object?>> saveHistory(Policy policy) async {
    CollectionReference ref = FirebaseFirestore.instance.collection("history");
    return ref.add({
      "policyName": policy.policyName,
      "appliedDate": DateTime.now().toString().split(' ').first,
      "email": email,
      "category": policy.category,
      "status": Status.pending.name
    });
  }

  @override
  Widget build(BuildContext context) {
    Policy policy = Policy('', 0, 0, '', 0);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("policy").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error retrieving data!",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "No Available data!",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return DataTable(
          dividerThickness: 2,
          decoration: BoxDecoration(border: Border.all()),
          columns: const [
            DataColumn(
                label: Text(
              "Policy Name",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Sum Assured",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Premium",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Tenure",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Apply",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
          ],
          rows: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return DataRow(cells: [
              DataCell(Text(data['name'])),
              DataCell(Text(data['category'])),
              DataCell(Text(data['sumAssured'].toString())),
              DataCell(Text(data['premium'].toString())),
              DataCell(Text(data['tenure'].toString())),
              DataCell(ElevatedButton(
                  onPressed: (() {
                    policy.policyName = data['name'];
                    policy.category = data['category'];
                    saveHistory(policy).then((value) => showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: const Text(
                              "Policy Application",
                              style: TextStyle(color: Colors.green),
                            ),
                            content: SizedBox(
                                height: 120,
                                width: 120,
                                child: Center(
                                  child: Text(
                                      style: const TextStyle(
                                          overflow: TextOverflow.clip,
                                          fontWeight: FontWeight.w500),
                                      "Policy application for ${policy.policyName} has been received, you will be notified after verification"),
                                )),
                          );
                        })));
                  }),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                  child: const Text(
                    "Apply",
                  )))
            ]);
          }).toList(),
        );
      },
    );
  }
}

class MakeInquiry extends StatefulWidget {
  const MakeInquiry({Key? key, required this.email}) : super(key: key);

  final String email;
  @override
  State<MakeInquiry> createState() => _MakeInquiryState();
}

class _MakeInquiryState extends State<MakeInquiry> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController questionController = TextEditingController();

  final Utilities utilities = Utilities();

  @override
  void dispose() {
    questionController.dispose();

    super.dispose();
  }

  Future<DocumentReference<Object?>> saveInquiry() async {
    CollectionReference inquiry =
        FirebaseFirestore.instance.collection("inquiry");
    return inquiry.add({
      "question": questionController.text,
      "email": widget.email,
      "date": DateTime.now(),
      "response": ""
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Text(
          "MAKE AN INQUIRY",
          style: TextStyle(fontSize: 30, color: Colors.indigo),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Form(
              key: _formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "inquiry cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  controller: questionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                      labelText: 'Question',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveInquiry().then((value) {
                    questionController.clear();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text(
                              "Feedback",
                              style: TextStyle(color: Colors.green),
                            ),
                            content: SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  "Your inquiry has been sent successfully!",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          );
                        });
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                minimumSize: const Size(100, 45),
                backgroundColor: const Color(0xff6750a4),
              ),
              child: const Text(
                "SEND",
              )),
        )
      ],
    );
  }
}

class Inquiries extends StatelessWidget {
  const Inquiries({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("inquiry")
          .where("email", isEqualTo: email)
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error retrieving data!",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "No Available data!",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return DataTable(
          dividerThickness: 2,
          decoration: BoxDecoration(border: Border.all()),
          columns: const [
            DataColumn(
                label: Text(
              "Question",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Asked On",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Response",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
          ],
          rows: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return DataRow(cells: [
              DataCell(Text(data['question'])),
              DataCell(Text((data['date'] as Timestamp)
                  .toDate()
                  .toString()
                  .split(' ')
                  .first)),
              DataCell(Text(
                data['response'].toString().isEmpty
                    ? "No Response Yet"
                    : data['response'],
                style: const TextStyle(color: Colors.red),
              )),
            ]);
          }).toList(),
        );
      }),
    );
  }
}

class PolicyHistory extends StatelessWidget {
  const PolicyHistory({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("history")
          .where("email", isEqualTo: email.trim())
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error retrieving data!",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "No Available data!",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return DataTable(
          dividerThickness: 2,
          decoration: BoxDecoration(border: Border.all()),
          columns: const [
            DataColumn(
                label: Text(
              "Policy Name",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Applied Date",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
            DataColumn(
                label: Text(
              "Status",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
          ],
          rows: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return DataRow(cells: [
              DataCell(Text(data['policyName'])),
              DataCell(Text(data['category'])),
              DataCell(Text(data['appliedDate'])),
              DataCell(Text(
                data['status'].toString().toUpperCase(),
                style: TextStyle(
                    color: data['status'].toString() == Status.pending.name
                        ? null
                        : Colors.red),
              )),
            ]);
          }).toList(),
        );
      },
    );
  }
}
