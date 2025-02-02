import 'package:app1/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Mundo Pokemon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: appRoutes,
      initialRoute: "homepokemons",
      // A widget which will be started on application startup
      //home: HomePage(),
    );
  }
}
