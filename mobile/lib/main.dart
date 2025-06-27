import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:locapro/core/providers/providers.dart';
import 'package:locapro/features/auth/presentation/screens/email_login_screen.dart';
import 'package:locapro/features/auth/presentation/screens/signup_screen.dart';
import 'package:locapro/features/proprietaire/presentation/screens/property_details_screen.dart';
import 'package:locapro/features/settings/presentation/screens/settings_screen.dart';
import 'core/services/token_service.dart' hide tokenServiceProvider;
import 'core/providers/user_provider.dart';
import 'features/proprietaire/data/providers/property_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/verification_screen.dart';
import 'features/proprietaire/presentation/screens/proprietaire_dashboard_screen.dart';
import 'features/proprietaire/presentation/screens/proprietaire_statistics_screen.dart';
import 'features/proprietaire/presentation/screens/property_form_screen.dart';
import 'features/proprietaire/presentation/screens/property_details_screen.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        tokenServiceProvider.overrideWithValue(TokenService(const FlutterSecureStorage(), storage: null)),
        httpClientProvider.overrideWithValue(http.Client()),
        propertyProvider.overrideWith((ref) => PropertyProvider(
          tokenService: ref.watch(tokenServiceProvider),
          client: ref.watch(httpClientProvider),
        )),
      ],
      child: MaterialApp(
      title: 'LocaPro',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              // Get user role from Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (userSnapshot.hasData && userSnapshot.data != null) {
                    final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                    final userRole = userData['role'] as String?;
                    
                    if (userRole == 'proprietaire') {
                                        return const HomeScreen();

                    }
                  }
                                        return const ProprietaireDashboardScreen();

                },
              );
            }
            return const EmailLoginScreen();
          },
        ),

        '/home': (context) => const HomeScreen(),
        '/proprietaire/dashboard': (context) => const ProprietaireDashboardScreen(),
        '/proprietaire/statistics': (context) => const ProprietaireStatisticsScreen() as Widget,
        '/proprietaire/property/form': (context) => const PropertyFormScreen(),
                '/setting': (context) => const SettingsScreen(),
                                '/signup': (context) => const SignUpScreen(),


        '/property/details': (context) => PropertyDetailsScreen(property: PropertyDetailsScreen.getMockProperty()),

   
      }
      ),
    );
  }
}