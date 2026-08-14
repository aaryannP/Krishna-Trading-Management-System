import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/registration_screen.dart';
import 'features/auth/screens/ban_48hr_screen.dart';
import 'features/auth/screens/freeze_24hr_screen.dart';
import 'features/dashboard/screens/welcome_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KtmsApp());
}

class KtmsApp extends StatelessWidget {
  const KtmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Krishna Trading ERP',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkMode,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/ban-48hr': (context) => const Ban48HrScreen(),
          '/freeze-24hr': (context) => const Freeze24HrScreen(),
          '/welcome': (context) => const WelcomeDashboard(),
        },
      ),
    );
  }
}
