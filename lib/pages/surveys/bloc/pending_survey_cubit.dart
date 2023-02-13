import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:project_care_app/common/api_client/data_state.dart';
import 'package:project_care_app/common/event/event_bus_mixin.dart';
import 'package:project_care_app/pages/surveys/bloc/pending_survey_state.dart';
import 'package:project_care_app/pages/widgets/content_widget.dart';
import 'package:project_care_app/repositories/data_repository.dart';

import '../help/even_bus_event.dart';

@injectable
class PendingSurveyCubit extends Cubit<PendingSurveyState> with EventBusMixin {
  PendingSurveyCubit(this._dataRepository) : super(PendingSurveyState()) {
    listenEvent<InComingSurveyEvent>((_) => refresh());
    listenEvent<UpdatedSurveyEvent>((_) => _updateSurveys());
  }

  final DataRepository _dataRepository;
  bool _updating = false;

  Future<void> loadData() async {
    emit(state.copyWith(status: DataSourceStatus.loading));
    await _fetchData();
  }

  Future<void> _fetchData({bool updateStatus = true}) async {
    try {
      final result = await _dataRepository.getPendingSurveys();
      if (result.isSuccess()) {
        emit(state.copyWith(
          surveys: result.data,
          status: updateStatus
              ? ((result.data ?? []).isEmpty ? DataSourceStatus.empty : DataSourceStatus.success)
              : null,
        ));
      } else {
        emit(state.copyWith(status: DataSourceStatus.failed, surveys: []));
      }
    } catch (e) {
      emit(state.copyWith(status: DataSourceStatus.failed, surveys: []));
    }
  }

  Future<void> refresh() async {
    if (state.status == DataSourceStatus.refreshing) {
      return;
    }
    emit(state.copyWith(status: DataSourceStatus.refreshing));
    await _fetchData();
  }

  Future<void> _updateSurveys() async {
    if (_updating) {
      return;
    }
    _updating = true;
    await _fetchData(updateStatus: false);
    _updating = false;
  }
}
