import 'package:flutter_bloc/flutter_bloc.dart';

import 'monitoring_state.dart';

class MonitoringCubit extends Cubit<MonitoringState> {
  MonitoringCubit() : super(MonitoringInitial());
}
