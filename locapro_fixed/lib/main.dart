import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'core/providers/providers.dart';
import 'features/auth/presentation/screens/email_login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/proprietaire/presentation/screens/property_details_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'core/services/token_service.dart' hide tokenServiceProvider;
import 'features/proprietaire/data/providers/property_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/proprietaire/presentation/screens/proprietaire_dashboard_screen.dart';
import 'features/proprietaire/presentation/screens/proprietaire_statistics_screen.dart';
import 'features/proprietaire/presentation/screens/property_form_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'LocaPro',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const EmailLoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/proprietaire/dashboard': (context) => const ProprietaireDashboardScreen(),
        '/proprietaire/statistics': (context) => const ProprietaireStatisticsScreen(),
        '/proprietaire/property/form': (context) => const PropertyFormScreen(),
        '/setting': (context) => const SettingsScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/property/details': (context) => PropertyDetailsScreen(property: PropertyDetailsScreen.getMockProperty()),
      },
      // Add this to handle navigation when pushing named routes
      onGenerateRoute: (settings) {
        // Handle any undefined routes
        return MaterialPageRoute(
          builder: (context) => const EmailLoginScreen(),
        );
      },
    );
  }
}