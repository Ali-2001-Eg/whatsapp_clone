import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/controllers/auth_controller.dart';
import 'package:whatsapp_clone/screens/home_screen.dart';
import 'package:whatsapp_clone/screens/landing/landing_screen.dart';
import 'package:whatsapp_clone/shared/routes/routes.dart';
import 'package:whatsapp_clone/shared/utils/base/error_screen.dart';
import 'package:whatsapp_clone/shared/utils/colors.dart';
import 'package:whatsapp_clone/shared/widgets/custom_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //to listen to providers
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'WhatsApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            color: appBarColor,
            elevation: 0,
          )),
      onGenerateRoute: (settings) => generateRoute(settings),
      //watch to keep tracking user state
      home: ref.watch(userDataProvider).when(
        data: (user) {
          if (user == null) {
            return const LandingScreen();
          }
          return const HomeScreen();
        },
        error: (error, stackTrace) {
          return const Scaffold(
            body: ErrorScreen(error: 'This page doesn\'t exist'),
          );
        },
        loading: () {
          return const Scaffold(
            body: Center(
              child: CustomIndicator(),
            ),
          );
        },
      ),
    );
  }
}