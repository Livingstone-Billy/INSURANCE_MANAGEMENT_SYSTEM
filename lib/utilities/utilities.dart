import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insurance_management_system/app.dart';

enum UserType { customer, admin }

enum Status { pending, approved, rejected }

class Utilities {
  var user = UserType.customer;
  AppBar mainAppBar(BuildContext context, bool isRoute) {
    return AppBar(
      leading: (isRoute)
          ? InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back),
            )
          : null,
      title: Row(
        children: <Widget>[
          const Text("Relative Insurance"),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: TextButton(
              onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => ActionPage(
                        userType: user,
                      ))),
              child: const Text(
                "Customer",
                style: TextStyle(color: Colors.white70, fontSize: 17),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) =>
                    const LoginPage(userType: UserType.admin))),
            child: const Text(
              "Admin",
              style: TextStyle(color: Colors.white70, fontSize: 17),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[900],
      actions: [
        TextButton(
          onPressed: () => true,
          child: const Text(
            "About Us",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        TextButton(
          onPressed: () => true,
          child: const Text(
            "Contact Us",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Future<int> getCollectionCount(String collection) async {
    QuerySnapshot collectionSnapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    return collectionSnapshot.size;
  }

  Future<int> getCollectionCountWithFilter(
      String collection, String field, String value) async {
    QuerySnapshot collectionSnapshot = await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();
    return collectionSnapshot.size;
  }
}

class CustomerScaffold extends StatelessWidget {
  const CustomerScaffold(
      {super.key,
      required this.title,
      required this.isRoute,
      required this.body});

  final bool isRoute;
  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    var user = UserType.customer;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueGrey[800],
        leading: (isRoute)
            ? InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back),
              )
            : null,
        actions: [
          TextButton.icon(
              onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ActionPage(
                            userType: user,
                          ))),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"))
        ],
      ),
      body: body,
    );
  }
}

class WidgetListTile extends StatelessWidget {
  const WidgetListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.action,
      this.trailing});
  final String title;
  final IconData icon;
  final VoidCallback action;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white60,
      ),
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
      ),
      trailing: trailing,
      onTap: action,
    );
  }
}

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 100.0),
                    child: Text(
                      "Profile Picture",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Mobile",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Address",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 10.0,
                          left: MediaQuery.of(context).size.width / 2.0),
                      child: IconButton(
                        onPressed: () => true,
                        icon: const Icon(
                          Icons.edit_calendar,
                          color: Colors.indigo,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10),
                      child: IconButton(
                        onPressed: () => true,
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[900],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  const InfoContainer(
      {super.key,
      required this.dimensions,
      required this.text,
      required this.icon,
      required this.value,
      required this.action});

  final List<double> dimensions;
  final String text;
  final IconData icon;
  final int value;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dimensions.last,
      width: dimensions.first,
      child: InkWell(
        onTap: action,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.indigo,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 20.0,
                left: 20.0,
                child: Text(
                  text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ),
              Positioned(
                top: 70.0,
                left: 20.0,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Positioned(
                  top: 70.0,
                  right: 20.0,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
