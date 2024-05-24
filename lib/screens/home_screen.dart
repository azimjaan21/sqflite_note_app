import 'package:flutter/material.dart';
import 'package:sqflite_note_app_tutorial/database/tasks_database.dart';
import 'package:sqflite_note_app_tutorial/models/task.dart';
import 'package:sqflite_note_app_tutorial/screens/add_task_screen.dart';
import 'package:sqflite_note_app_tutorial/widgets/task_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List<Task> tasks = [];

  Future<void> getAllTasks() async {
    setState(() => isLoading = true);

    tasks = await TasksDatabase.instance.readAllTasks();

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  @override
  void dispose() {
    TasksDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks List'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildTasksList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddTaskScreen(),
            ),
          );

          getAllTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTasksList() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddTaskScreen(
                    task: task,
                  ),
                ),
              );

              getAllTasks();
            },
            child: TaskListTile(task: task));
      },
    );
  }
}
