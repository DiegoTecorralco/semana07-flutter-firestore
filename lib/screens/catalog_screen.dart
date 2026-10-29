
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/item_model.dart';
import '../repositories/catalog_repository.dart';
import '../widgets/item_form.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final CatalogRepository repo = CatalogRepository();

  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  void initState() {
    super.initState();
    stream = repo.getCatalogSnapshots();
  }

  // Mostrar mensajes al usuario
  void message(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }

  // Abrir formulario para agregar o editar
  Future<void> openForm([ItemModel? item]) async {
    await showDialog<void>(
      context: context,
      builder: (_) => ItemForm(
        repository: repo,
        item: item,
      ),
    );
  }

  // Eliminar producto
  Future<void> remove(ItemModel item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Eliminar ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (ok != true) {
      return;
    }

    try {
      await repo.deleteItem(item.id);
      message('Producto eliminado correctamente');
    } catch (_) {
      message(
        'No se pudo eliminar. Revisa la conexión o los permisos.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo en tiempo real'),
        centerTitle: true,
      ),

      // Botón para agregar productos
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),

      // Escuchar cambios de Firestore
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {

          // ESTADO ERROR
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 50,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Error al cargar los productos.',
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Revisa Firestore y los permisos.',
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        stream = repo.getCatalogSnapshots();
                      });
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // ESTADO LOADING
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // OBTENER PRODUCTOS
          final data = snapshot.data!;

          final items = data.docs
              .map(ItemModel.fromFirestore)
              .toList();

          return Column(
            children: [

              // ESTADO DE SINCRONIZACIÓN
              MaterialBanner(
                content: Text(
                  data.metadata.isFromCache
                      ? 'Datos de caché: pueden no estar actualizados'
                      : 'Datos sincronizados con Firestore',
                ),
                leading: Icon(
                  data.metadata.isFromCache
                      ? Icons.cloud_off
                      : Icons.cloud_done,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            data.metadata.isFromCache
                                ? 'Mostrando datos locales'
                                : 'Conectado con Firestore',
                          ),
                        ),
                      );
                    },
                    child: const Text('ESTADO'),
                  ),
                ],
              ),

              // ESTADO EMPTY
              if (items.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No hay productos. Agrega el primero.',
                    ),
                  ),
                )
              else

                // ESTADO SUCCESS
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                            '${item.description}\n'
                            'Stock: ${item.stock} · '
                            'Precio: \$${item.price.toStringAsFixed(2)}',
                          ),
                          isThreeLine: true,

                          // BOTONES EDITAR Y ELIMINAR
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar',
                                icon: const Icon(Icons.edit),
                                onPressed: () => openForm(item),
                              ),
                              IconButton(
                                tooltip: 'Eliminar',
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                                onPressed: () => remove(item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
