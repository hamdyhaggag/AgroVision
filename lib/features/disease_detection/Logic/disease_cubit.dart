import 'package:flutter_bloc/flutter_bloc.dart';

import 'disease_state.dart';

class DiseaseCubit extends Cubit<DiseaseState> {
  DiseaseCubit() : super(DiseaseInitial());
}
