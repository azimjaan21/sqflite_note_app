import 'package:flutter/foundation.dart' show immutable;

const String tasksTable = 'tasks';

class TasksFields {
  static final List<String> values = [
    id,
    title,
    description,
    startDate,
    isCompleted,
  ];

  // Column names for task tables
  static const id = 'id';
  static const title = 'title';
  static const description = 'description';
  static const startDate = 'startDate';
  static const isCompleted = 'isCompleted';
}

@immutable
class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime startDate;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.isCompleted,
  });

  Task copy({
    int? id,
    String? title,
    String? description,
    DateTime? startDate,
    bool? isCompleted,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      TasksFields.id: id,
      TasksFields.title: title,
      TasksFields.description: description,
      TasksFields.startDate: startDate.toIso8601String(),
      TasksFields.isCompleted: isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map[TasksFields.id] != null ? map[TasksFields.id] as int : null,
      title: map[TasksFields.title] as String,
      description: map[TasksFields.description] as String,
      startDate: DateTime.parse(map[TasksFields.startDate] as String),
      isCompleted: map[TasksFields.isCompleted] == 1,
    );
  }
}
