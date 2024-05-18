import 'package:flutter/material.dart';
import 'package:flutter_application_10/pages/cart_page.dart';
import 'package:flutter_application_10/pages/home_page.dart';
import 'package:flutter_application_10/pages/intro_page.dart';
import 'package:flutter_application_10/pages/login_page.dart';
import 'package:flutter_application_10/pages/my_orders_page.dart';
import 'package:flutter_application_10/pages/new_address.dart';
import 'package:flutter_application_10/pages/ny_wish_list.dart';
import 'package:flutter_application_10/pages/profile_page.dart';
import 'package:flutter_application_10/pages/regster.dart';
import 'package:flutter_application_10/providers/home_provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedin = prefs.getBool('is_loggedin') ?? false;
  print(isLoggedin);
  runApp(
    MultiProvider(
      child: Phoenix(
        child: MyApp(isLoggedin),
      ),
      providers: [
        ChangeNotifierProvider(
            create: (_) => HomeProvider()..loadInitialData()),
      ],
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedin;
  MyApp(this.isLoggedin);
// global key for SnackBar Problem
  static GlobalKey<NavigatorState> navKey = GlobalKey();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khaled Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        scaffoldBackgroundColor: Color(0xFFF5F5f3),
        useMaterial3: true,
      ),
      navigatorKey: navKey,
      home: isLoggedin ? HomePage() : IntroPage(),
      routes: {
        'login': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
        'home': (context) => HomePage(),
        'cart': (context) => CartPage(),
        'profile': (context) => ProfilePage(),
        'newaddress': (context) => AddNewAddress(),
        'wishlist': (context) => MyWishList(),
        'myorders': (context) => OrderScreen(),
      },
    );
  }
}
