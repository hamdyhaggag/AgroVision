import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/cache_helper.dart';
import '../../../home/Logic/home_cubit/home_cubit.dart';
import '../../Data/model/login_request_body.dart';
import '../../Data/model/user_model.dart';
import '../../Data/repos/login_repo.dart';
import '../auth cubit/auth_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginCubit(this._loginRepo) : super(const LoginState.initial());

  Future<void> emitLoginStates(
      LoginRequestBody body, BuildContext context) async {
    emit(const LoginState.loading());
    final result = await _loginRepo.login(body);

    result.when(
      success: (loginResponse) async {
        await _persistUserData(loginResponse);
        _updateAuthState(context, loginResponse);
        unawaited(_handleSensorData(context));
        emit(LoginState.success(loginResponse));
      },
      failure: (error) {
        final errorMessage =
            error.apiErrorModel.message ?? 'Invalid username or password';
        emit(LoginState.error(error: errorMessage));
      },
    );
  }

  Future<void> _handleSensorData(BuildContext context) async {
    try {
      final sensorData = await _fetchSensorData();
      context.read<HomeCubit>().updateSensorData(sensorData);
    } catch (e) {
      context.read<HomeCubit>().handleSensorError(e.toString());
    }
  }

  Future<Map<String, dynamic>> _fetchSensorData() async {
    throw Exception('Sensor server offline');
  }

  Future<void> _persistUserData(dynamic responseData) async {
    await Future.wait([
      CacheHelper.saveData(key: 'userId', value: responseData.id),
      CacheHelper.saveData(key: 'userName', value: responseData.name),
      CacheHelper.saveData(key: 'email', value: responseData.email),
      CacheHelper.saveData(key: 'token', value: responseData.token),
      CacheHelper.saveData(key: 'isLoggedIn', value: true),
    ]);
  }

  void _updateAuthState(BuildContext context, dynamic responseData) {
    context.read<AuthCubit>().setUser(User(
          id: responseData.id,
          name: responseData.name,
          email: responseData.email,
        ));
  }

  Future<void> logout(BuildContext context) async {
    await Future.wait([
      CacheHelper.removeData(key: 'userId'),
      CacheHelper.removeData(key: 'userName'),
      CacheHelper.removeData(key: 'email'),
      CacheHelper.removeData(key: 'token'),
      CacheHelper.saveData(key: 'isLoggedIn', value: false),
    ]);

    context.read<AuthCubit>().clearUser();
    _clearControllers();
  }

  void _clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}
