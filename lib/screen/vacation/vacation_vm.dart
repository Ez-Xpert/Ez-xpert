// import 'package:dio/dio.dart';
// import 'package:ez_xpert/base/base_view_model.dart';

// class VacationVM extends BaseViewModel {
//   @override
//   void onInit() {
//     getLeave();
//   }

//   List leave = [];
//   var leaveCount;
//   // var sellHour;
//   void getLeave() async {
//     showLoading();
//     final response = await api.leaveRepo.getLeaveData();
//     print(response.toString());
//     hideLoading();
//     if (response.runtimeType == Response) {
//       leave = response.data['result']['employee'] ?? [];
//       leaveCount = response.data['result']['leave_cnt'];

//       // sellHour = response.data['result']['sell_hour'];
//       notifyListeners();
//     } else {
//       changeState(ChangeState.serverError);
//     }
//   }
// }
