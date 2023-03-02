import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';

class CallScheduleVM extends BaseViewModel {
  @override
  void onInit() {
    getSchedule();
  }

  List schedules = [];
  getSchedule() async {
    showLoading();
    final response = await api.callScheduleRepo.getCallSchedule();
    hideLoading();
    if (response.runtimeType == Response) {
      schedules = response.data['result']['tasks'] ?? [];
      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
  }
}
