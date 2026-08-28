import 'package:flutter/material.dart';
import 'package:fuelmetrics/screens/auth/login.dart';
import 'package:provider/provider.dart';
import 'services/connectivity_service.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => AppState()..init()),
      ],
      child: MaterialApp(
        title: 'Fuelmetrics',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const LoginScreen(),
      ),
    );
  }
}
