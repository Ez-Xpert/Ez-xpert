import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';
import 'package:ez_xpert/model/tool_model.dart';

class ToolRequestVM extends BaseViewModel {
  @override
  void onInit() {
    getTools();
  }

  List<ToolModel>? tools;
  List requests = [];
  void getTools() async {
    showLoading();
    final response = await api.toolRepo.getTools();
    if (response.runtimeType == Response) {
      List toolList = response.data['result']['tools'] as List;
      tools = toolList.map((e) => ToolModel.fromJson(e)).toList();
      var tempList = response.data['result']['toolrequest'] ?? [];
      requests = tempList;
      notifyListeners();
      hideLoading();
    } else {
      hideLoading();
      changeState(ChangeState.serverError);
    }
    // hideLoading();
    // print(response);
  }
}
