import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';
import 'database/habit_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize the database
await HabitDatabase.initialize();
await HabitDatabase().saveFirstLaunchDate();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), 
      child: MainApp(),
      ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      //theme: darkMode,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
