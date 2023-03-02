import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';

class HomeVM extends BaseViewModel {
  @override
  void onInit() {
    getData();
  }

  Map? data;
  getData() async {
    changeState(ChangeState.clone);
    showLoading();
    final response = await api.userRepo.getUserData();
    if (response.runtimeType == Response) {
      data = response.data['result'];
      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
    hideLoading();
    changeState(ChangeState.page);
  }
}
