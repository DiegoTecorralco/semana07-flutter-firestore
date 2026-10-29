import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../repositories/catalog_repository.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key, required this.repository, this.item});
  final CatalogRepository repository;
  final ItemModel? item;
  @override
  State<ItemForm> createState() => _ItemFormState();
}
class _ItemFormState extends State<ItemForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController name, description, price, stock;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    final item = widget.item;
    name = TextEditingController(text: item?.name ?? '');
    description = TextEditingController(text: item?.description ?? '');
    price = TextEditingController(text: item?.price.toString() ?? '');
    stock = TextEditingController(text: item?.stock.toString() ?? '');
  }
  @override
  void dispose() { name.dispose(); description.dispose(); price.dispose(); stock.dispose(); super.dispose(); }
  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);
    try {
      final p = double.parse(price.text.trim()); final s = int.parse(stock.text.trim());
      if (widget.item == null) {
        await widget.repository.addItem(name: name.text.trim(), description: description.text.trim(), price: p, stock: s);
      } else {
        await widget.repository.updateItem(widget.item!.id, name: name.text.trim(), description: description.text.trim(), price: p, stock: s);
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo guardar. Revisa la conexión y permisos.')));
    } finally { if (mounted) setState(() => saving = false); }
  }
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.item == null ? 'Nuevo producto' : 'Editar producto'),
    content: SizedBox(width: 360, child: Form(key: formKey, child: SingleChildScrollView(child: Column(
      mainAxisSize: MainAxisSize.min, children: [
        TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Nombre'),
          validator: (v) => v == null || v.trim().isEmpty ? 'Escribe un nombre' : null),
        TextFormField(controller: description, decoration: const InputDecoration(labelText: 'Descripción')),
        TextFormField(controller: price, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Precio'),
          validator: (v) { final n = double.tryParse(v?.trim() ?? ''); return n == null || !n.isFinite || n < 0 ? 'Precio válido mayor o igual a 0' : null; }),
        TextFormField(controller: stock, keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Existencias'),
          validator: (v) { final n = int.tryParse(v?.trim() ?? ''); return n == null || n < 0 ? 'Número entero mayor o igual a 0' : null; }),
      ])))),
    actions: [TextButton(onPressed: saving ? null : () => Navigator.pop(context), child: const Text('Cancelar')),
      FilledButton(onPressed: saving ? null : save, child: Text(saving ? 'Guardando...' : 'Guardar'))],
  );
}
