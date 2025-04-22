import 'package:agro_vision/core/helpers/cache_helper.dart';
import 'package:agro_vision/core/theme/theme_cubit/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeCubitState> {
  ThemeCubit() : super(ThemeCubitInitial());

  void getCurrentTheme() {
    bool isDark = CacheHelper.getBool("isDark");
    if (isDark) {
      emit(DarkThemeState());
    } else {
      emit(LightThemeState());
    }
  }

  void toggleTheme() {
    CacheHelper.setBool("isDark", !CacheHelper.getBool("isDark"));
    getCurrentTheme();
  }
}
