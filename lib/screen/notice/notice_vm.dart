import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';

class NoticeVM extends BaseViewModel {
  @override
  void onInit() {
    getNotice();
  }

  List notice = [];
  void getNotice() async {
    showLoading();
    final response = await api.noticeRepo.getNotice();
    hideLoading();
    if (response.runtimeType == Response) {
      notice = response.data['result']['news'] ?? [];
      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
  }
}
