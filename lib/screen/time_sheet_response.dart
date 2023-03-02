import 'dart:convert';

class TimeSheetResponse {
  String statuscode="";
  String sucess="";
  late Result result;
  String message="";

   TimeSheetResponse.fromJson(Map<String, dynamic> json){
      statuscode= json["statuscode"];
      sucess= json["sucess"];
      result= Result.fromJson(json["result"]);
      message= json["message"];

  }
}


class Result {
  late String empId;
  late DateTime startDate;
  late DateTime endDate;
  late int regularHours;
  late double overTimeHours;
  late int emergencyHours;
  late int soldHours;

   Result.fromJson(Map<String, dynamic> json) {
    empId= json["emp_id"];
    startDate= DateTime.parse(json["start_date"]);
    endDate= DateTime.parse(json["end_date"]);
    regularHours= json["regularHours"];
    overTimeHours=json["overTimeHours"].toDouble();
    emergencyHours=json["emergencyHours"];
    soldHours= json["soldHours"];
  }

}
