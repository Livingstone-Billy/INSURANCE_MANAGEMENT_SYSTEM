import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

/// @author OCHARDIX LIVINGSTONE

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyC9lCA2aGBufwTns7rao9KHYTwvh17kxjQ",
          authDomain: "flutter-backend-cf57b.firebaseapp.com",
          databaseURL:
              "https://flutter-backend-cf57b-default-rtdb.firebaseio.com",
          projectId: "flutter-backend-cf57b",
          storageBucket: "flutter-backend-cf57b.appspot.com",
          messagingSenderId: "853385139486",
          appId: "1:853385139486:web:d8eab6769abc830355650f",
          measurementId: "G-H6LM0PEZ9F"));
  runApp(const InsuranceApp());
}
