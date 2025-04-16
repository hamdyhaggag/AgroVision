part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class ChangeDotState extends AuthState {}

class NextPageState extends AuthState {}

class UserUpdatedState extends AuthState {
  final User user;
  UserUpdatedState(this.user);
}

class UserClearedState extends AuthState {}
