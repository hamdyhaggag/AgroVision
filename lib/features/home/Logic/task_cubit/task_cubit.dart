import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/helpers/cache_helper.dart';
import '../../../../models/task_model.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(const TaskState(tasks: [])) {
    _loadTasksFromCache();
  }

  Future<void> _loadTasksFromCache() async {
    final tasksJson = CacheHelper.getString(key: 'tasks');
    if (tasksJson.isNotEmpty) {
      try {
        final tasksList = jsonDecode(tasksJson) as List<dynamic>;
        final tasks = tasksList.map((map) => Task.fromMap(map)).toList();
        emit(state.copyWith(tasks: tasks));
      } catch (e) {
        emit(state.copyWith(tasks: const []));
      }
    }
  }

  Future<void> _saveTasksToCache(List<Task> tasks) async {
    final tasksJson = jsonEncode(tasks.map((task) => task.toMap()).toList());
    await CacheHelper.saveData(key: 'tasks', value: tasksJson);
  }

  void addTask(Task newTask) {
    final updatedTasks = List<Task>.from(state.tasks)..add(newTask);
    emit(state.copyWith(tasks: updatedTasks));
    _saveTasksToCache(updatedTasks);
  }

  void toggleTaskCompletion(String taskId) {
    final updatedTasks = state.tasks.map((task) {
      return task.id == taskId
          ? task.copyWith(isCompleted: !task.isCompleted)
          : task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));
    _saveTasksToCache(updatedTasks);
  }

  void deleteTask(String taskId) {
    final updatedTasks =
        state.tasks.where((task) => task.id != taskId).toList();
    emit(state.copyWith(tasks: updatedTasks));
    _saveTasksToCache(updatedTasks);
  }
}

class TaskState extends Equatable {
  final List<Task> tasks;

  const TaskState({required this.tasks});

  TaskState copyWith({List<Task>? tasks}) {
    return TaskState(tasks: tasks ?? this.tasks);
  }

  @override
  List<Object> get props => [tasks];
}
