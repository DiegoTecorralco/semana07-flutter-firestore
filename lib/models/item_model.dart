import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final DateTime? createdAt;
  const ItemModel({required this.id, required this.name, required this.description,
    required this.price, required this.stock, this.createdAt});

  factory ItemModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final rawPrice = data['price'];
    final rawStock = data['stock'];
    final rawDate = data['createdAt'];
    return ItemModel(
      id: doc.id,
      name: data['name'] is String ? data['name'] as String : 'Sin nombre',
      description: data['description'] is String ? data['description'] as String : '',
      price: rawPrice is num ? rawPrice.toDouble() : 0,
      stock: rawStock is num ? rawStock.toInt() : 0,
      createdAt: rawDate is Timestamp ? rawDate.toDate() : null,
    );
  }
}
