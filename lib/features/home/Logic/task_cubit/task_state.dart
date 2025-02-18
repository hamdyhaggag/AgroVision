import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
sealed class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {
  @override
  List<Object?> get props => [];
}
