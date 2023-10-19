import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stable/constant.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class CourseCriteria {
  final String terrain;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String discipline;

  CourseCriteria({
    required this.terrain,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.discipline,
  });
}

class CourseForm extends StatefulWidget {
  const CourseForm({Key? key}) : super(key: key);

  @override
  _CourseFormState createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Duration? duration;

  final List<String> terrainOptions = ['Carrière', 'Manège'];
  final List<String> disciplineOptions = ['Dressage', 'Saut d\'obstacle', 'Endurance'];
  String? selectedTerrain;
  String? selectedDiscipline;

  void showSuccessNotification() {
    Get.snackbar(
      'Enregistrement réussi',
      'Les données ont été enregistrées avec succès.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void showErrorNotification(String error) {
    Get.snackbar(
      'Erreur d\'enregistrement',
      error,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void calculateDuration() {
    if (selectedDate != null && startTime != null && endTime != null) {
      final start = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,
          startTime!.hour, startTime!.minute);
      final end = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day,
          endTime!.hour, endTime!.minute);

      setState(() {
        duration = end.difference(start);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programmer un cours')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(selectedDate != null
                  ? 'Date: ${selectedDate!.toLocal()}'
                  : 'Sélectionnez la date'),
              trailing: const Icon(Icons.date_range),
              onTap: () async {
                final DateTime? selected = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (selected != null && selected != selectedDate) {
                  setState(() {
                    selectedDate = selected;
                  });
                }
              },
            ),
            ListTile(
              title: Text(startTime != null
                  ? 'Heure de début: ${startTime!.format(context)}'
                  : 'Sélectionnez l\'heure de début'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? selected = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selected != null && selected != startTime) {
                  setState(() {
                    startTime = selected;
                    calculateDuration();
                  });
                }
              },
            ),
            ListTile(
              title: Text(endTime != null
                  ? 'Heure de fin: ${endTime!.format(context)}'
                  : 'Sélectionnez l\'heure de fin'),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final TimeOfDay? selected = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selected != null && selected != endTime) {
                  setState(() {
                    endTime = selected;
                    calculateDuration();
                  });
                }
              },
            ),
            ListTile(
              title: Text(duration != null
                  ? 'Durée: ${duration!.inHours}h ${duration!.inMinutes.remainder(60)}m'
                  : 'La durée sera calculée automatiquement'),
              trailing: const Icon(Icons.timer),
            ),
            DropdownButtonFormField<String>(
              value: selectedTerrain,
              items: terrainOptions.map((terrain) {
                return DropdownMenuItem<String>(
                  value: terrain,
                  child: Text(terrain),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedTerrain = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'Terrain'),
            ),
            DropdownButtonFormField<String>(
              value: selectedDiscipline,
              items: disciplineOptions.map((discipline) {
                return DropdownMenuItem<String>(
                  value: discipline,
                  child: Text(discipline),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedDiscipline = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'Discipline'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDate != null &&
                    startTime != null &&
                    endTime != null &&
                    duration != null &&
                    selectedTerrain != null &&
                    selectedDiscipline != null) {

                  final criteria = CourseCriteria(
                    terrain: selectedTerrain!,
                    date: selectedDate!,
                    startTime: DateTime(
                        selectedDate!.year, selectedDate!.month, selectedDate!.day,
                        startTime!.hour, startTime!.minute),
                    endTime: DateTime(
                        selectedDate!.year, selectedDate!.month, selectedDate!.day,
                        endTime!.hour, endTime!.minute),
                    discipline: selectedDiscipline!,
                  );

                  bool result = await saveData(criteria);
                  if (result) {
                    showSuccessNotification();
                  } else {
                    showErrorNotification('Erreur lors de l\'enregistrement.');
                  }
                } else {
                  showErrorNotification('Veuillez remplir tous les champs obligatoires.');
                }
              },
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> saveData(CourseCriteria criteria) async {
    try {
      var db = mdb.Db(MONGO_URL);
      await db.open();

      var collection = db.collection('cours');
      await collection.insert({
        'terrain': criteria.terrain,
        'date': criteria.date.toIso8601String(),
        'startTime': criteria.startTime.toIso8601String(),
        'endTime': criteria.endTime.toIso8601String(),
        'discipline': criteria.discipline,
      });

      await db.close();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
