import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import 'screens/home_screen.dart';
// import 'state/app_state.dart';
// import 'theme/app_theme.dart';

void main() {
  runApp(const SalesRepApp());
}

class SalesRepApp extends StatelessWidget {
  const SalesRepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState()..init(),
      child: MaterialApp(
        title: 'Field Sales',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const HomeScreen(),
      ),
    );
  }
}
