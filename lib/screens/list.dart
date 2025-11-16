import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_frontend/router.dart';
import 'package:todo_frontend/models/list_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ListItems> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<File> _getToDoListFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todo-list.json');
  }

  Future<void> _loadItems() async {
    List<ListItems> loadedItems = [];
    try {
      final file = await _getToDoListFile();

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final data = json.decode(content) as List;
          loadedItems = data.map((item) => ListItems.fromJson(item)).toList();
        }
      }
    } catch (e) {
      print("Error loading items from documents directory: ${e}");
    }

    if (mounted) {
      setState(() {
        _items = loadedItems;
      });
    }
  }

  Future<void> _deleteItem(int id) async {
    try {
      final file = await _getToDoListFile();
      if (!await file.exists()) return;

      final content = await file.readAsString();
      if (content.isEmpty) return;

      List<dynamic> itemList = jsonDecode(content);
      itemList.removeWhere((item) => item['id'] == id);

      await file.writeAsString(jsonEncode(itemList));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted!')),
        );
      }
      // Reload the list from the file to update the UI
      await _loadItems();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item: ${e}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: _loadItems,
            child: _items.isEmpty
                ? const Center(child: Text("No items yet. Add one!"))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ItemWidget(
                        id: item.id,
                        title: item.title,
                        description: item.description,
                        onDeletePressed: () => _deleteItem(item.id),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(RouterDestinations.add.url);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget(
      {super.key,
      required this.description,
      required this.title,
      required this.id,
      required this.onDeletePressed});

  final String description;
  final String title;
  final int id;
  final void Function() onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(title),
            subtitle: Text(description),
            isThreeLine: true,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onDeletePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Done'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
