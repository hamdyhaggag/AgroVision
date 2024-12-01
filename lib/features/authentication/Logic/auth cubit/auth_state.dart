part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class NextPageState extends AuthState {}

class ChangeDotState extends AuthState {}
