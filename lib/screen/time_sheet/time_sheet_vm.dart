import 'package:dio/dio.dart';
import 'package:ez_xpert/base/base_view_model.dart';

class TimeSheetVM extends BaseViewModel {
  @override
  void onInit() {
    getPayroll();
  }

  List payroll = [];
  String basePay = "0";
  String incentive = "0";
  String tax = "0";
  String deduction = "0";
  String total = "0";
  void getPayroll() async {
    showLoading();
    final response = await api.payRollRepo.getPayRoll();
    hideLoading();
    if (response.runtimeType == Response) {
      payroll = response.data['result']['payouts'] ?? [];
      if (payroll.isNotEmpty) {
        basePay = payroll[0]['pay'].toString();
        incentive = payroll[0]['incentive'].toString();
        tax = payroll[0]['tax'].toString();
        deduction = payroll[0]['ded'].toString();
        total = payroll[0]['net'].toString();
      }
      notifyListeners();
    } else {
      changeState(ChangeState.serverError);
    }
  }
}
