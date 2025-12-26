// import 'package:admin_football_app/providers/team_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:provider/provider.dart';
// import 'firebase_options.dart';
// import 'providers/auth_provider.dart';
// import 'providers/match_provider.dart';
// import 'providers/tournament_provider.dart';
// import 'screens/auth/admin_login_screen.dart';
// import 'screens/home/admin_home_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => MatchProvider()),
//         ChangeNotifierProvider(create: (_) => TournamentProvider()),
//         ChangeNotifierProvider(create: (_) => TeamProvider())
//       ],
//       child: MaterialApp(
//         title: 'Admin Football App',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           fontFamily: 'Roboto',
//           scaffoldBackgroundColor: Colors.grey[50],
//         ),
//         home: const AuthWrapper(),
//       ),
//     );
//   }
// }
//
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AuthProvider>(
//       builder: (context, authProvider, child) {
//         if (authProvider.isLoading) {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//
//         if (authProvider.currentAdmin != null) {
//           return const AdminHomeScreen();
//         }
//
//         return const AdminLoginScreen();
//       },
//     );
//   }
// }

import 'package:admin_football_app/screens/home/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// আপনার প্রোজেক্টের ইমপোর্টগুলো (নিশ্চিত করুন পাথগুলো সঠিক আছে)
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/match_provider.dart';
import 'providers/tournament_provider.dart';
import 'providers/team_provider.dart';
import 'screens/auth/admin_login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ফায়ারবেস ইনিশিয়ালাইজেশন
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // আপনার সব প্রোভাইডার এখানে থাকবে
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MatchProvider()),
        ChangeNotifierProvider(create: (_) => TournamentProvider()),
        ChangeNotifierProvider(create: (_) => TeamProvider()),
      ],
      child: MaterialApp(
        title: 'Football Admin System',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange, // যেহেতু আপনার হোমসক্রিন অরেঞ্জ থিমের
          primaryColor: Colors.orange.shade700,
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        // সরাসরি AuthWrapper কে হোম হিসেবে সেট করা হয়েছে
        home: const AuthWrapper(),

        // যদি ভবিষ্যতে রাউট ব্যবহার করতে চান
        routes: {
          '/login': (context) => const AdminLoginScreen(),
          '/home': (context) => const MainNavigation(),
        },
      ),
    );
  }
}

/// [AuthWrapper] হলো আপনার অ্যাপের প্রবেশদ্বার।
/// এটি ডিসিশন নেয় ইউজার কি হোমে যাবে নাকি লগইন স্ক্রিনে।
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AuthProvider এর স্টেট মনিটর করা হচ্ছে
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {

        // ১. যদি অ্যাপ চেক করতে সময় নেয় (Loading State)
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'অনুমতি যাচাই করা হচ্ছে...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // ২. যদি ইউজার লগইন থাকে এবং সে 'admin' রোল প্রাপ্ত হয়
        // (এই চেকটি আপনার AuthProvider-এর ভেতর অলরেডি করা আছে)
        if (authProvider.currentAdmin != null) {
          return const MainNavigation();
        }

        // ৩. যদি ইউজার লগইন না থাকে অথবা সে অ্যাডমিন না হয়
        return const AdminLoginScreen();
      },
    );
  }
}