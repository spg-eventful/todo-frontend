import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_frontend/models/list_items.dart';

import '../router.dart';

class AddNewListEntryScreen extends StatefulWidget {
  const AddNewListEntryScreen({super.key});

  @override
  State<AddNewListEntryScreen> createState() => _AddNewListEntryState();
}

class _AddNewListEntryState extends State<AddNewListEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<bool> _saveToDoEntry() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/todo-list.json');

      List<Map<String, dynamic>> itemList = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          itemList = List<Map<String, dynamic>>.from(jsonDecode(content));
        }
      }

      final newItem = ListItems(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      itemList.add(newItem.toJson());

      await file.writeAsString(jsonEncode(itemList));

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New entry saved locally!')),
        );
      }

      _titleController.clear();
      _descriptionController.clear();
      return true;
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save entry: $e')),
        );
      }
      return false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new entry"),),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Enter ToDo title',
                        border: OutlineInputBorder(),
                        label: Text("Title"),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder(),
                        label: Text("Description"),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          final wasSaved = await _saveToDoEntry();
                          if (wasSaved && context.mounted) {
                            context.go(RouterDestinations.list.url);
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
