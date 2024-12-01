import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_service.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final ApiService _apiService;

  LogoutCubit(this._apiService) : super(const LogoutState.initial());

  Future<void> logout() async {
    emit(const LogoutState.loading());
    try {
      await _apiService.logout();
      emit(const LogoutState.success());
    } catch (e) {
      emit(LogoutState.error(error: e.toString()));
    }
  }
}
