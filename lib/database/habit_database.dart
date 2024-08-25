import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // SETUP

  // initialize the database
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    //await dir.create(recursive: true);
    //final path = dir.path;
    isar = await Isar.open([HabitSchema, AppSettingsSchema], 
    directory: dir.path);
  }

  //save first date of app launch (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.getAll();
    if(existingSettings == null){
      final settings = AppSettings()..firsLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //get first date of app launch(for heatmap)
  Future <DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.getAll([1]);
    if(settings.isNotEmpty){
      return settings.first?.firsLaunchDate;
    }
    return null;//if no settings are found
  }

  //CRUD-OPERATIONS

  //List of habits
  final List<Habit> currentHabits = [];

  //CREATE
Future<void> addHabit(String habitName) async {
  //create habits
  final newHabit = Habit()..name = 'habitName';

  //save habits to database
  await isar.writeTxn(() => isar.habits.put(newHabit)); //put is used to save data to the database

  //re read habits from database
  readHabits();
}
  //read habits from database
  Future<void> readHabits() async {
    //get all habits from database
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //give the fetched habits to the current habits list
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    //UI update
    notifyListeners();
  }

  //update habits
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //get habit by id
    final habit = await isar.habits.get(id);

    //update habit
    habit!.isCompleted = isCompleted;

    //update completion status in database
    if (habit!=null) {
      await isar.writeTxn(()async{
        if (isCompleted && !habit.completedDays.contains(DateTime.now())){
          final today = DateTime.now();
          habit.completedDays.add(
            DateTime(
              today.year, 
              today.month, 
              today.day,
              ),
          );
        }

        else {
          habit.completedDays.removeWhere(
            (date) => 
            date.year == DateTime.now().year && 
            date.month == DateTime.now().month && 
            date.day == DateTime.now().day,
            );
        }
        await isar.habits.put(habit);
      });
    }
    //reread habits from database
    readHabits();
  }

  //edit habits names
  Future<void> editHabitName(int id, String newName) async {
    //get habit by id
    final habit = await isar.habits.get(id);

    //update habit name
    habit!.name = newName;

    //update habit name in database
    await isar.writeTxn(() => isar.habits.put(habit));

    //reread habits from database
    readHabits();
  }

  //delete habits


}