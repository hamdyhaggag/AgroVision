import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/cache_helper.dart';
import '../../Data/model/login_request_body.dart';
import '../../Data/model/user_model.dart';
import '../../Data/repos/login_repo.dart';
import '../auth cubit/auth_cubit.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(const LoginState.initial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void emitLoginStates(
      LoginRequestBody loginRequestBody, BuildContext context) async {
    emit(const LoginState.loading());
    final response = await _loginRepo.login(loginRequestBody);
    response.when(success: (loginResponse) async {
      final user = User(
        id: loginResponse.id,
        name: loginResponse.name,
        email: loginResponse.email,
      );

      context.read<AuthCubit>().setUser(user);
      await CacheHelper.saveData(key: 'token', value: loginResponse.token);
      await CacheHelper.saveData(key: 'userId', value: loginResponse.id);
      await CacheHelper.ensureInitialized();
      CacheHelper.saveData(key: 'isLoggedIn', value: true);

      if (kDebugMode) {
        print('🔵 RAW NAME: ${loginResponse.name}');
      }

      await CacheHelper.saveData(
        key: 'userName',
        value: loginResponse.name,
      );

      final savedName = CacheHelper.getString(key: 'userName');
      if (kDebugMode) {
        print('🆗 IMMEDIATE CHECK: $savedName');
      }

      emit(LoginState.success(loginResponse));
    }, failure: (error) {
      emit(LoginState.error(error: error.apiErrorModel.message ?? ''));
    });
  }

  void logout() async {
    await CacheHelper.ensureInitialized();
    await CacheHelper.removeData(key: 'userName');
    if (kDebugMode) {
      print('🚪 LOGGED OUT - Cleared userName');
    }
  }
}
