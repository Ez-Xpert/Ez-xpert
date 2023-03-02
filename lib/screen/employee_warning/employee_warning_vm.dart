import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';

class Employee_warningVM extends BaseViewModel {
  @override
  void onInit() {
    getKnowledge();
  }

  List knowledge = [];
  getKnowledge() async {
    showLoading();
    final response = await api.knowledgeRepo.getKnowledge();
    hideLoading();
    if (response.runtimeType == Response) {
      knowledge = response.data['result']['videos'] ?? [];
      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
  }
}
