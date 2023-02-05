import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insurance_management_system/utilities/utilities.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final Utilities utilities = Utilities();
  int _selectedIndex = 0;

  List<Widget> widgets = const <Widget>[
    AdminDashboard(),
    Customers(),
    AddPolicyCategory(),
    PolicyCategories(),
    PolicyPage(),
    AddPolicy(),
    InquiriesPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Admin Home Page",
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/admin.png"),
                                radius: 50,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Text(
                                  "Admin",
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                        WidgetListTile(
                            title: "Dashboard",
                            icon: Icons.palette_sharp,
                            action: () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            }),
                        WidgetListTile(
                            title: "Customer",
                            icon: Icons.people,
                            action: () => setState(() {
                                  _selectedIndex = 1;
                                })),
                        WidgetListTile(
                            title: "Category",
                            icon: Icons.list_alt_rounded,
                            trailing: InkWell(
                              onTap: (() => setState(() {
                                    _selectedIndex = 2;
                                  })),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white60,
                                size: 18,
                              ),
                            ),
                            action: () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                            }),
                        WidgetListTile(
                            title: "Policy",
                            icon: Icons.local_parking,
                            trailing: InkWell(
                              onTap: (() => setState(() {
                                    _selectedIndex = 5;
                                  })),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white60,
                                size: 18,
                              ),
                            ),
                            action: () {
                              setState(() {
                                _selectedIndex = 4;
                              });
                            }),
                        WidgetListTile(
                            title: "Inquiries",
                            icon: Icons.help,
                            action: () {
                              setState(() {
                                _selectedIndex = 6;
                              });
                            }),
                      ],
                    ),
                  ),
                ),
                Positioned(left: 250, top: 20, child: widgets[_selectedIndex])
              ],
            ),
          ),
        ));
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    Utilities utilities = Utilities();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
              future: utilities.getCollectionCount("customer"),
              builder: (_, snapshot) {
                int number = 0;
                if (snapshot.hasData) {
                  number = snapshot.data!;
                }
                return InfoContainer(
                    dimensions: const [250, 150],
                    text: "Total registered user",
                    icon: Icons.people_alt,
                    value: number,
                    action: (() => true));
              },
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: FutureBuilder(
                  future: utilities.getCollectionCount("policy"),
                  builder: (_, snapshot) {
                    int number = 0;
                    if (snapshot.hasData) {
                      number = snapshot.data!;
                    }
                    return InfoContainer(
                        dimensions: const [250, 150],
                        text: "Listed Policies",
                        icon: Icons.local_parking,
                        value: number,
                        action: (() => true));
                  },
                )),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: FutureBuilder(
                future: utilities.getCollectionCount("policyCategory"),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("No data Available");
                  }
                  int? value = 0;
                  if (snapshot.hasData) {
                    value = snapshot.data;
                  }
                  return InfoContainer(
                      dimensions: const [250, 150],
                      text: "Policy Categories",
                      icon: Icons.local_parking,
                      value: value!,
                      action: (() => true));
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: FutureBuilder(
                  future: utilities.getCollectionCount("inquiry"),
                  builder: (_, snapshot) {
                    int number = 0;
                    if (snapshot.hasData) {
                      number = snapshot.data!;
                    }
                    return InfoContainer(
                        dimensions: const [250, 150],
                        text: "Total inquiries",
                        icon: Icons.help,
                        value: number,
                        action: (() => true));
                  },
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FutureBuilder(
                future: utilities.getCollectionCount("history"),
                builder: (_, snapshot) {
                  int number = 0;
                  if (snapshot.hasData) {
                    number = snapshot.data!;
                  }
                  return InfoContainer(
                      dimensions: const [250, 150],
                      text: "Total Applied Policy\nHolder",
                      icon: Icons.manage_accounts_sharp,
                      value: number,
                      action: (() => Navigator.of(context).push(
                          CupertinoPageRoute(
                              builder: (context) =>
                                  const TotalAppliedPolicies()))));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: FutureBuilder(
                  future: utilities.getCollectionCountWithFilter(
                      "history", "status", Status.approved.name),
                  builder: (_, snapshot) {
                    int number = 0;
                    if (snapshot.hasData) {
                      number = snapshot.data!;
                    }
                    return InfoContainer(
                        dimensions: const [250, 150],
                        text: "Approved Policy\nHolder",
                        icon: Icons.library_add_check,
                        value: number,
                        action: (() => Navigator.of(context).push(
                            CupertinoPageRoute(
                                builder: (context) => const PolicyHolderPage(
                                    status: Status.approved)))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: FutureBuilder(
                  future: utilities.getCollectionCountWithFilter(
                      "history", "status", Status.rejected.name),
                  builder: (_, snapshot) {
                    int number = 0;
                    if (snapshot.hasData) {
                      number = snapshot.data!;
                    }
                    return InfoContainer(
                        dimensions: const [250, 150],
                        text: "Disapproved Policy\nHolder",
                        icon: Icons.close_rounded,
                        value: number,
                        action: (() => Navigator.of(context).push(
                            CupertinoPageRoute(
                                builder: (context) => const PolicyHolderPage(
                                    status: Status.rejected)))));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: FutureBuilder(
                  future: utilities.getCollectionCountWithFilter(
                      "history", "status", Status.pending.name),
                  builder: (_, snapshot) {
                    int number = 0;
                    if (snapshot.hasData) {
                      number = snapshot.data!;
                    }
                    return InfoContainer(
                        dimensions: const [250, 150],
                        text: "Policy Holder Waiting\nFor Approval",
                        icon: Icons.close_rounded,
                        value: number,
                        action: (() => Navigator.of(context).push(
                            CupertinoPageRoute(
                                builder: (context) => const PolicyHolderPage(
                                    status: Status.pending)))));
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class PolicyCategories extends StatelessWidget {
  const PolicyCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection("policyCategory").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Error retrieving data!",
            style: TextStyle(color: Colors.red),
          );
        }
        if (!snapshot.hasData) {
          return const Text(
            "No available data!",
            style: TextStyle(color: Colors.red),
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
              "Category Name",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            )),
          ],
          rows: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

            return DataRow(cells: [
              DataCell(Text(data['name'])),
            ]);
          }).toList(),
        );
      },
    );
  }
}

class AddPolicyCategory extends StatefulWidget {
  const AddPolicyCategory({super.key});

  @override
  State<AddPolicyCategory> createState() => _AddPolicyCategoryState();
}

class _AddPolicyCategoryState extends State<AddPolicyCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    categoryController.dispose();

    super.dispose();
  }

  Future<DocumentReference<Object?>> addCategory() async {
    final CollectionReference ref =
        FirebaseFirestore.instance.collection("policyCategory");

    return ref.add({"name": categoryController.text});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
          width: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "ADD CATEGORY",
                style: TextStyle(
                    color: Color(0xff6750a4),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                child: TextFormField(
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return "Category name cannot be empty";
                    } else {
                      return null;
                    }
                  }),
                  controller: categoryController,
                  decoration: InputDecoration(
                      labelText: "Category Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: (() {
                    if (_formKey.currentState!.validate()) {
                      addCategory().then((value) => showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              content: SizedBox(
                                height: 90,
                                child: Center(
                                  child: Text(
                                    "Category added successfully",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            );
                          }));
                      categoryController.clear();
                    }
                  }),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      backgroundColor: const Color(0xff6750a4),
                      minimumSize: const Size(100, 45)),
                  child: const Text("ADD"),
                ),
              )
            ],
          ),
        ));
  }
}

class AddPolicy extends StatefulWidget {
  const AddPolicy({super.key});

  @override
  State<AddPolicy> createState() => _AddPolicyState();
}

class _AddPolicyState extends State<AddPolicy> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController policyNameController = TextEditingController();
  TextEditingController sumAssuredController = TextEditingController();
  TextEditingController premiumController = TextEditingController();
  TextEditingController tenureController = TextEditingController();
  TextEditingController policyCategoryController = TextEditingController();

  @override
  void dispose() {
    policyNameController.dispose();
    sumAssuredController.dispose();
    premiumController.dispose();
    tenureController.dispose();
    policyCategoryController.dispose();

    super.dispose();
  }

  Future<DocumentReference<Object?>> savePolicy() async {
    CollectionReference policy =
        FirebaseFirestore.instance.collection("policy");
    return policy.add({
      "category": policyCategoryController.text,
      "name": policyNameController.text,
      "sumAssured": double.tryParse(sumAssuredController.text),
      "premium": int.tryParse(premiumController.text),
      "tenure": int.tryParse(tenureController.text),
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "ADD POLICY",
                  style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return "policy category cannot be empty";
                    } else {
                      return null;
                    }
                  }),
                  controller: policyCategoryController,
                  decoration: InputDecoration(
                      labelText: 'Policy Category',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return "policy name cannot be empty";
                    } else {
                      return null;
                    }
                  }),
                  controller: policyNameController,
                  decoration: InputDecoration(
                      labelText: 'Policy Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return "sum assured cannot be empty";
                    } else {
                      return null;
                    }
                  }),
                  controller: sumAssuredController,
                  decoration: InputDecoration(
                      labelText: 'Sum Assured',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return "premium amount cannot be empty";
                    } else {
                      return null;
                    }
                  }),
                  controller: premiumController,
                  decoration: InputDecoration(
                      labelText: 'Premium',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return "tenure cannot be empty";
                    } else {
                      return null;
                    }
                  }),
                  controller: tenureController,
                  decoration: InputDecoration(
                      labelText: 'Tenure',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    onPressed: (() {
                      if (_formKey.currentState!.validate()) {
                        savePolicy().then((value) {
                          policyNameController.clear();
                          sumAssuredController.clear();
                          premiumController.clear();
                          tenureController.clear();
                          policyCategoryController.clear();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text(
                                    "Feedback",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  content: SizedBox(
                                    height: 100,
                                    child: Center(
                                      child: Text(
                                        "Policy added successfully!",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        });
                      }
                    }),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      minimumSize: const Size(140, 50),
                      backgroundColor: const Color(0xff6750a4),
                    ),
                    child: const Text("ADD"),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          ],
          rows: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return DataRow(cells: [
              DataCell(Text(data['name'])),
              DataCell(Text(data['category'])),
              DataCell(Text(data['sumAssured'].toString())),
              DataCell(Text(data['premium'].toString())),
              DataCell(Text(data['tenure'].toString())),
            ]);
          }).toList(),
        );
      },
    );
  }
}

class TotalAppliedPolicies extends StatelessWidget {
  const TotalAppliedPolicies({super.key});

  Future<void> verifyPolicy(Status status, String docId) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("history").doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {"status": status.name});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Policy Holder Page",
      debugShowCheckedModeBanner: false,
      home: CustomerScaffold(
        title: "Applied Policy Holder Page",
        isRoute: false,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("history").snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Error retrieving data!",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  "No Available data!",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 70.0),
              child: DataTable(
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
                    "Applicant e-mail",
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
                  DataColumn(
                      label: Text(
                    "Approve",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  )),
                  DataColumn(
                      label: Text(
                    "Reject",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  )),
                ],
                rows: snapshot.data!.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;
                  return DataRow(cells: [
                    DataCell(Text(data['policyName'])),
                    DataCell(Text(data['category'])),
                    DataCell(Text(data['email'])),
                    DataCell(Text(data['appliedDate'])),
                    DataCell(Text(data['status'])),
                    DataCell(ElevatedButton(
                      onPressed: data['status'].toString() ==
                              Status.pending.name
                          ? (() => verifyPolicy(Status.approved, doc.id)
                              .then((value) => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${data['email']} application approved!",
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            TextButton(
                                                onPressed: (() =>
                                                    Navigator.of(context)
                                                        .pop()),
                                                child: const Text("OK"))
                                          ],
                                        ),
                                      ),
                                    );
                                  })))
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: const Size(120, 40)),
                      child: const Text("Approve"),
                    )),
                    DataCell(ElevatedButton(
                      onPressed: data['status'].toString() ==
                              Status.pending.name
                          ? (() => verifyPolicy(Status.rejected, doc.id)
                              .then((value) => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${data['email']} application rejected!",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            TextButton(
                                                onPressed: (() =>
                                                    Navigator.of(context)
                                                        .pop()),
                                                child: const Text("OK"))
                                          ],
                                        ),
                                      ),
                                    );
                                  })))
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minimumSize: const Size(120, 40)),
                      child: const Text("Reject"),
                    )),
                  ]);
                }).toList(),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class PolicyHolderPage extends StatelessWidget {
  const PolicyHolderPage({super.key, required this.status});

  final Status status;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Policy Holder Page",
      debugShowCheckedModeBanner: false,
      home: CustomerScaffold(
        isRoute: false,
        title: "Policy Holder [${status.name.toUpperCase()}]",
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("history")
              .where("status", isEqualTo: status.name)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "Error retrieving data!",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  "No Available data!",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 70.0),
              child: DataTable(
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
                    "Applicant e-mail",
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
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;
                  return DataRow(cells: [
                    DataCell(Text(data['policyName'])),
                    DataCell(Text(data['category'])),
                    DataCell(Text(data['email'])),
                    DataCell(Text(data['appliedDate'])),
                    DataCell(Text(
                      data['status'].toString().toUpperCase(),
                      style: const TextStyle(color: Colors.red),
                    )),
                  ]);
                }).toList(),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  final Utilities utilities = Utilities();

  Stream<QuerySnapshot> customers =
      FirebaseFirestore.instance.collection("customer").snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: customers,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Error retrieving data!",
            style: TextStyle(color: Colors.red),
          );
        }
        if (!snapshot.hasData) {
          return const Text(
            "No available data!",
            style: TextStyle(color: Colors.red),
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
              "Names",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Profile Picture",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Mobile",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "ID No",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Update",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Delete",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            )),
          ],
          rows: snapshot.data!.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            return DataRow(cells: [
              DataCell(Text('${data['firstname']} ${data['lastname']}')),
              DataCell(CircleAvatar(
                backgroundImage: NetworkImage(data['imgUrl']),
              )),
              DataCell(Text('${data['phoneNo']}')),
              DataCell(Text('${data['idNo']}')),
              DataCell(IconButton(
                onPressed: (() => true),
                icon: const Icon(
                  Icons.edit_note,
                  color: Colors.blue,
                ),
                tooltip: 'Update ${data['firstname']} ${data['lastname']}',
              )),
              DataCell(IconButton(
                  onPressed: (() => true),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  tooltip: 'Delete ${data['firstname']} ${data['lastname']}'))
            ]);
          }).toList(),
        );
      },
    );
  }
}

class InquiriesPage extends StatefulWidget {
  const InquiriesPage({super.key});

  @override
  State<InquiriesPage> createState() => _InquiriesPageState();
}

class _InquiriesPageState extends State<InquiriesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController responseController = TextEditingController();

  Future<void> sendResponse(String response, String docId) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("inquiry").doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {"response": response});
    });
  }

  @override
  void dispose() {
    responseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("inquiry").snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            "Error retrieving data!",
            style: TextStyle(color: Colors.red),
          );
        }
        if (!snapshot.hasData) {
          return const Text(
            "No available data!",
            style: TextStyle(color: Colors.red),
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
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Asked On",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Response",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Action",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
              DataCell(data['response'].toString().isEmpty
                  ? const Text("No Response Yet",
                      style: TextStyle(color: Colors.red))
                  : Text(data['response'],
                      style: const TextStyle(color: Colors.green))),
              DataCell(ElevatedButton(
                onPressed: data['response'].toString().isEmpty
                    ? (() => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: SizedBox(
                              height: 140,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(14.0),
                                      child: TextFormField(
                                        validator: ((value) {
                                          if (value == null || value.isEmpty) {
                                            return "Response cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        }),
                                        controller: responseController,
                                        decoration: const InputDecoration(
                                            labelText: 'Response'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              sendResponse(
                                                      responseController.text,
                                                      doc.id)
                                                  .then((value) =>
                                                      Navigator.of(context)
                                                          .pop());
                                            }
                                          },
                                          child: const Text("Send")),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }))
                    : null,
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    maximumSize: const Size(100, 40),
                    backgroundColor: Colors.red),
                child: const Text("Reply"),
              ))
            ]);
          }).toList(),
        );
      }),
    );
  }
}
