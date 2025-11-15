import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task_item.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'Low';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;
    final task = TaskItem(title: _titleController.text.trim(), priority: _priority, description: _descriptionController.text.trim());
    await DatabaseHelper.instance.insertTask(task);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _priority, items: const [DropdownMenuItem(value: 'Low', child: Text('Low')), DropdownMenuItem(value: 'Medium', child: Text('Medium')), DropdownMenuItem(value: 'High', child: Text('High'))], onChanged: (v) => setState(() => _priority = v ?? 'Low'), decoration: const InputDecoration(labelText: 'Priority')),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveTask, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
