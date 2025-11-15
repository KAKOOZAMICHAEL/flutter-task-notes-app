import 'package:flutter/material.dart';
import '../models/task_item.dart';
import '../database/database_helper.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<TaskItem> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _dbHelper.getAllTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _loadTasks();
  }

  Future<void> _toggleTaskCompletion(TaskItem task) async {
    final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
    await _dbHelper.updateTask(updatedTask);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Notes Manager')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: const Text('My Tasks & Notes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
          SwitchListTile(title: const Text('Dark Mode'), value: widget.isDarkMode, onChanged: widget.onThemeToggle),
          const Divider(),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(child: Text('No tasks yet. Tap the + button to add one!', style: TextStyle(fontSize: 16)))
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(task.title, style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(task.description), const SizedBox(height: 4), Row(children: [Chip(label: Text(task.priority, style: const TextStyle(fontSize: 12)), backgroundColor: _getPriorityColor(task.priority)), if (task.isCompleted) const Chip(label: Text('Completed', style: TextStyle(fontSize: 12)), backgroundColor: Colors.green)])]),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: Icon(task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: task.isCompleted ? Colors.green : Colors.grey), onPressed: () => _toggleTaskCompletion(task)), IconButton(icon: const Icon(Icons.delete), color: Colors.red, onPressed: () => _deleteTask(task.id!))]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const FormScreen()));
          if (result == true) _loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade200;
      case 'medium':
        return Colors.orange.shade200;
      case 'low':
        return Colors.green.shade200;
      default:
        return Colors.grey.shade200;
    }
  }
}
