import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'monitoring_state.dart';

class MonitoringCubit extends Cubit<MonitoringState> {
  MonitoringCubit() : super(MonitoringInitial());
}
