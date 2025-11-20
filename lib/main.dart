import 'package:flutter/material.dart';
import 'screen/login_page.dart';


void main() {
  runApp(const RentalCar());
}

class RentalCar extends StatelessWidget {
  const RentalCar({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Rental App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xff605EA1)),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}







