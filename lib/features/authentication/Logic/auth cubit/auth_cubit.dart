import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/helpers/cache_helper.dart';
import '../../Data/model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  User? _currentUser;
  int currentIndex = 0;
  late PageController pageController;

  User? get currentUser => _currentUser;

  static AuthCubit get(context) => BlocProvider.of(context);

  AuthCubit() : super(AuthInitial()) {
    pageController = PageController();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    await CacheHelper.ensureInitialized();
    final userId = CacheHelper.getInteger(key: 'userId');
    if (userId != 0) {
      _currentUser = User(
        id: userId,
        name: CacheHelper.getString(key: 'userName'),
        email: CacheHelper.getString(key: 'email'),
      );
      emit(UserUpdatedState(_currentUser!));
    }
  }

  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(ChangeDotState());
  }

  void setUser(User user) {
    _currentUser = user;
    emit(UserUpdatedState(user));
  }

  void clearUser() {
    _currentUser = null;
    emit(UserClearedState());
  }

  void nextPage() {
    currentIndex++;
    pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );
    emit(NextPageState());
  }
}
