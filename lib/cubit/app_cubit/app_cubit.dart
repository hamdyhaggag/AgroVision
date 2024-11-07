import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isLightMode = true;
  int _bottomNavIndex = 0;

  // Getter for the current bottom navigation index
  int get bottomNavIndex => _bottomNavIndex;

  // Method to change the bottom navigation index
  void changeBottomNavIndex(int index) {
    _bottomNavIndex = index;
    emit(BottomNavChangeState());
  }
}
