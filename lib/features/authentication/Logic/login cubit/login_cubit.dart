import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/cache_helper.dart';
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
    final response = await _loginRepo.login(body);

    response.when(
      success: (data) async {
        await _persistUserData(data);
        _updateAuthState(context, data);
        emit(LoginState.success(data));
      },
      failure: (error) => emit(LoginState.error(
          error: error.apiErrorModel.message ?? 'Login failed')),
    );
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
