import 'package:agro_vision/core/themes/app_colors.dart';
import 'package:agro_vision/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../Logic/task_cubit/task_cubit.dart';

class Task {
  final String id;
  final String title;
  final DateTime dueDate;
  final String priority;
  final String notes;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.notes,
    this.isCompleted = false,
  });
}

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task newTask) {
    _tasks.add(newTask);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Task Manager', isHome: false, actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () => showSearch(
            context: context,
            delegate: TaskSearchDelegate(),
          ),
        )
      ]),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state.tasks.isEmpty) {
            return _buildEmptyState();
          }
          final groupedTasks = _groupTasksByDate(state.tasks);
          return _buildTaskList(groupedTasks, context);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 24),
          Text('No Tasks Found',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 12),
          Text('Tap the + button to create a new task',
              style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Map<String, List<Task>> _groupTasksByDate(List<Task> tasks) {
    Map<String, List<Task>> groupedTasks = {};
    for (var task in tasks) {
      final dateKey = DateFormat('yyyy-MM-dd').format(task.dueDate);
      groupedTasks.putIfAbsent(dateKey, () => []).add(task);
    }
    return groupedTasks;
  }

  Widget _buildTaskList(
      Map<String, List<Task>> groupedTasks, BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...groupedTasks.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  DateFormat('EEEE, MMM d').format(DateTime.parse(entry.key)),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ...entry.value.map((task) => _buildTaskItem(task, context)),
              const SizedBox(height: 16),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTaskItem(Task task, BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_forever, color: Colors.white),
      ),
      onDismissed: (direction) {
        context.read<TaskCubit>().deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted "${task.title}"'),
            backgroundColor: Colors.red,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTaskDetails(context, task),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildPriorityIndicator(task.priority),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          )),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('h:mm a').format(task.dueDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  activeColor: AppColors.primaryColor,
                  onChanged: (value) =>
                      context.read<TaskCubit>().toggleTaskCompletion(task.id),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = Colors.red;
        break;
      case 'Medium':
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }
    return Container(
      width: 6,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  void _showTaskDetails(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Text(task.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 16),
              _buildDetailItem(Icons.calendar_month_rounded,
                  DateFormat('EEEE, MMM d, y').format(task.dueDate)),
              _buildDetailItem(Icons.flag_rounded, task.priority),
              if (task.notes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Notes',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    )),
                const SizedBox(height: 8),
                Text(task.notes, style: TextStyle(color: Colors.grey[700])),
              ],
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 16),
          Text(text, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}

class TaskSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final tasks = BlocProvider.of<TaskCubit>(context).state.tasks;
    final results = tasks
        .where((task) => task.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(DateFormat('MMM d, y').format(task.dueDate)),
          onTap: () => close(context, task),
        );
      },
    );
  }
}
