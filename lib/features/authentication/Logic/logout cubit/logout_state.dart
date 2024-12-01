import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_state.freezed.dart';

@freezed
class LogoutState with _$LogoutState {
  const factory LogoutState.initial() = LogoutInitial;
  const factory LogoutState.loading() = LogoutLoading;
  const factory LogoutState.success() = LogoutSuccess;
  const factory LogoutState.error({required String error}) = LogoutError;
}
