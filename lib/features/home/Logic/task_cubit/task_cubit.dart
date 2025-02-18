import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Ui/widgets/task_list_screen.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(const TaskState(tasks: []));

  void addTask(Task newTask) {
    final updatedTasks = List<Task>.from(state.tasks)..add(newTask);
    emit(state.copyWith(tasks: updatedTasks));
  }

  void toggleTaskCompletion(String taskId) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == taskId) {
        return Task(
          id: task.id,
          title: task.title,
          dueDate: task.dueDate,
          priority: task.priority,
          notes: task.notes,
          isCompleted: !task.isCompleted,
        );
      }
      return task;
    }).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }

  void deleteTask(String taskId) {
    final updatedTasks =
        state.tasks.where((task) => task.id != taskId).toList();
    emit(state.copyWith(tasks: updatedTasks));
  }
}

class TaskState extends Equatable {
  final List<Task> tasks;

  const TaskState({required this.tasks});

  TaskState copyWith({List<Task>? tasks}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object> get props => [tasks];
}
