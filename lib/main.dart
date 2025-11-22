import 'package:flutter/material.dart';
import 'screen/onboarding_page.dart';
import 'package:intl/date_symbol_data_local.dart';


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff605EA1)),
      ),
      home: const OnboardingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}







