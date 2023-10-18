import 'dart:convert';
import 'dart:io';

class JsonDataManager {
  final String filePath;

  JsonDataManager(this.filePath);

  Future<Map<String, dynamic>> loadData(File file) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final jsonContent = await file.readAsString();
        final jsonData = json.decode(jsonContent);
        print('Données chargées avec succès: $jsonData');
        return jsonData;
      }
    } catch (error) {
      print('Erreur lors du chargement des données: $error');
    }
    return {};
  }

  Future<void> saveData(File file, Map<String, dynamic> data) async {
    try {
      final jsonContent = json.encode(data);
      await file.writeAsString(jsonContent);
      print('Données enregistrées avec succès: $jsonContent');
      print('Chemin du fichier JSON : ${file.path}');
    } catch (error) {
      print('Erreur lors de l\'enregistrement des données: $error');
    }
  }
}
