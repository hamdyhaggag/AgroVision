import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final DateTime dueDate;
  final String priority;
  final String notes;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.notes,
    this.isCompleted = false,
  });

  Task copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    String? priority,
    String? notes,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      title: map['title'] as String,
      dueDate: DateTime.parse(map['dueDate'] as String),
      priority: map['priority'] as String,
      notes: map['notes'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  @override
  List<Object> get props => [id, title, dueDate, priority, notes, isCompleted];
}
