import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class CatalogRepository {
  CatalogRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _db;
  CollectionReference<Map<String, dynamic>> get _items => _db.collection('items');

  Stream<List<ItemModel>> getCatalogStream() => _items
      .orderBy('name').limit(50).snapshots(includeMetadataChanges: true)
      .map((snapshot) => snapshot.docs.map(ItemModel.fromFirestore).toList());

  Stream<QuerySnapshot<Map<String, dynamic>>> getCatalogSnapshots() =>
      _items.orderBy('name').limit(50).snapshots(includeMetadataChanges: true);

  Future<void> addItem({required String name, required String description,
    required double price, required int stock}) async {
    await _items.add({'name': name, 'description': description,
      'price': price, 'stock': stock, 'createdAt': FieldValue.serverTimestamp()});
  }
  Future<void> updateItem(String id, {required String name,
    required String description, required double price, required int stock}) =>
    _items.doc(id).update({'name': name, 'description': description,
      'price': price, 'stock': stock});
  Future<void> deleteItem(String id) => _items.doc(id).delete();
}
