import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CarProApp());
}

class CarProApp extends StatelessWidget {
  const CarProApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (_, theme, __) {
        return MaterialApp(
          title: 'CarPro',
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          theme: ThemeData(
            useMaterial3: false,
            primaryColor: theme.primary,
            scaffoldBackgroundColor: theme.bg,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1A2332),
              elevation: 0,
              systemOverlayStyle: const SystemUiOverlayStyle((
                statusBarColor: Colors.white,
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
          ),
        );
      },
    );
  }
}
