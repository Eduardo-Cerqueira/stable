import 'constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class PartyActions {
  static Future<void> bringItemToParty(String soireeName, String itemToBring, String userID) async {
    final Db db = await Db.create(MONGO_URL);
    await db.open();
    var partyCollection = db.collection('soirees_evenements');
    var userCollection = db.collection('users');
    var user = await userCollection.findOne(where.id(ObjectId.parse(userID)));

    Map<String, dynamic>? party = await partyCollection.findOne(where.eq('name', soireeName));

    if (party != null) {
      List<dynamic> items = party['items'] ?? <dynamic>[];

      if (user != null) {
        String userName = user['name'];
        Map<String, dynamic> itemToAdd = {
          'name': userName,
          'item': itemToBring,
        };

        // Recherchez si l'utilisateur a déjà ajouté un item et mettez à jour ou ajoutez l'entrée
        bool userAlreadyAddedItem = false;
        for (int i = 0; i < items.length; i++) {
          if (items[i] is Map && items[i]['name'] == userName) {
            // Remplacez l'entrée existante avec la nouvelle valeur
            items[i] = itemToAdd;
            userAlreadyAddedItem = true;
            break;
          }
        }

        if (!userAlreadyAddedItem) {
          // Ajoutez la nouvelle entrée
          items.add(itemToAdd);
        }

        // Mettez à jour le champ 'items' dans la base de données
        await partyCollection.update(where.eq('name', soireeName), modify.set('items', items));
        print('Élément ajouté à la soirée $soireeName : $itemToBring');
      }
    }

    await db.close();
  }
}
