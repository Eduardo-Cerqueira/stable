
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:stable/components/json.dart';

class CourseCriteria {
  final String terrain;
  final DateTime date;
  final Duration duration;
  final String discipline;

  CourseCriteria({
    required this.terrain,
    required this.date,
    required this.duration,
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
  TimeOfDay? selectedTime;
  final TextEditingController durationController = TextEditingController();

  List<String> terrainOptions = ['Carrière', 'Manège'];
  List<String> disciplineOptions = ['Dressage', 'Saut d\'obstacle', 'Endurance'];
  String? selectedTerrain;
  String? selectedDiscipline;

  JsonDataManager jsonDataManager = JsonDataManager('cours.json');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programmer un cours')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                selectedDate != null
                    ? 'Date: ${selectedDate!.toLocal()}'
                    : 'Sélectionnez la date',
              ),
              trailing: const Icon(Icons.date_range),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (selectedDate != null) {
                  setState(() {
                    this.selectedDate = selectedDate;
                  });
                }
              },
            ),
            ListTile(
              title: Text(
                selectedTime != null
                    ? 'Heure: ${selectedTime!.hour}:${selectedTime!.minute}'
                    : 'Sélectionnez l\'heure',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  setState(() {
                    this.selectedTime = selectedTime;
                  });
                }
              },
            ),
            TextFormField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Durée (minutes)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la durée';
                }
                return null;
              },
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
              decoration: InputDecoration(labelText: 'Terrain'),
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
              decoration: InputDecoration(labelText: 'Discipline'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDate != null &&
                    selectedTime != null &&
                    durationController.text.isNotEmpty &&
                    selectedTerrain != null &&
                    selectedDiscipline != null) {

                  // Vérifiez si la durée est un nombre valide
                  try {
                    final durationMinutes = int.parse(durationController.text);
                    if (durationMinutes <= 0) {
                      showErrorNotification('La durée doit être supérieure à zéro.');
                      return;
                    }
                  } catch (e) {
                    showErrorNotification('La durée doit être un nombre valide.');
                    return;
                  }

                  // Vérifiez si la date est dans le futur
                  if (selectedDate!.isBefore(DateTime.now())) {
                    showErrorNotification('La date doit être dans le futur.');
                    return;
                  }

                  final criteria = CourseCriteria(
                    terrain: selectedTerrain ?? '',
                    date: selectedDate!,
                    duration: Duration(minutes: int.parse(durationController.text)),
                    discipline: selectedDiscipline ?? '',
                  );

                  if (await saveData(criteria)) {
                    showSuccessNotification();
                    Get.back();
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
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/cours.json');

      // Chargez les données JSON actuelles
      final currentData = await jsonDataManager.loadData(file);

      // Ajoutez les nouvelles données
      currentData['cours'] ??= [];
      currentData['cours'].add({
        'terrain': criteria.terrain,
        'date': criteria.date.toIso8601String(),
        'duration_minutes': criteria.duration.inMinutes,
        'discipline': criteria.discipline,
      });

      // Sauvegardez les données mises à jour dans le fichier JSON
      await jsonDataManager.saveData(file, currentData);

      // Indiquez que l'enregistrement a réussi
      showSuccessNotification(); // Affichez la notification de succès ici
      return true;
    } catch (error) {
      // Affichez un message d'erreur explicatif en fonction de l'erreur
      print('Erreur lors de l\'enregistrement : $error');
      // Indiquez que l'enregistrement a échoué
      showErrorNotification('Erreur lors de l\'enregistrement.');
      return false;
    }
  }
}
