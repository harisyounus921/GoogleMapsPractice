import 'package:flutter/material.dart';
import 'package:google_map/Screen/HomeScreen.dart';
import 'package:google_map/Screen/googleplaceapi.dart';
import 'package:google_map/Utitilies/get_user_current_location.dart';

import 'Utitilies/convert_latitues_to_address.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleplaceApi(),
    );
  }
}
