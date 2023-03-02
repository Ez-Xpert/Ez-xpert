import 'languages.dart';

class LanguageEn extends BaseLanguage {
  /// Login Page
  @override
  String get log_text1 => 'Login';
  @override
  String get log_text2 => 'Email';
  @override
  String get log_text3 => 'Password';

  /// Bottom Navigation Bar
  @override
  String get bn_text1 => 'Home';
  @override
  String get bn_text2 => 'Time Sheet';
  @override
  String get bn_text3 => 'Check In/Check Out';
  @override
  String get bn_text4 => 'Vacation';
  @override
  String get bn_text5 => 'Tool Request';

  ///home
  @override
  String home_text1 = 'Daily Bench mark for service and install';
  @override
  String get home_text2 => 'Service Daily goal ';
  @override
  String get home_text22 => '(Technician)';
  @override
  String get home_text3 => 'Service Daily goal ';
  @override
  String get home_text33 => '(Technician + Apprentice)';
  @override
  String get home_text4 => 'Install Daily goal ';
  @override
  String get home_text44 => '(Technician + Apprentice)';
  @override
  String get home_text5 => 'Install Daily Goal ';
  @override
  String get home_text55 => '(Technician+ Technician)';
  @override
  String get home_text6 => 'Potential opportunity with Electrika';
  @override
  String get home_text7 => 'Number of Days Worked';
  @override
  String get home_text8 => 'Number of Hours Worked';
  @override
  String get home_text9 => 'Number of Potential Work days missed';
  @override
  String get home_text10 => 'Number of Potential work hours missed';

  ///time sheet screen
  @override
  String get time_text1 => 'Start date';
  @override
  String get time_text2 => 'End Date';
  @override
  String get time_text3 => 'Search';
  @override
  String get time_text4 => 'Regular Hours';
  @override
  String get time_text5 => 'Overtime Hours';
  @override
  String get time_text6 => 'Emergency Hours';
  @override
  String get time_text7 => 'Are you Efficient (Yes/No)';
  @override
  String get time_text8 => 'Efficiency';
  @override
  String get time_text9 => 'What is You Bonus ?';

  ///inout
  @override
  String get inout_text1 => 'Emergency Start';
  @override
  String get inout_text18 => 'Emergency Stop';
  @override
  String get inout_text2 => 'Sold hours';
  @override
  String get inout_text3 => 'Total Working Hours';
  @override
  String get inout_text4 => 'Calculate Efficiency';
  @override
  String get inout_text5 => 'Close';
  @override
  String get inout_text6 => 'Save';
  @override
  String get inout_text7 => 'Sold Hours';
  @override
  String get inout_text8 => 'Daily Report';
  @override
  String get inout_text9 => 'Emergency Report';
  @override
  String get inout_text10 => 'Date';
  @override
  String get inout_text11 => 'Working time';
  @override
  String get inout_text12 => 'Regular Hours';
  @override
  String get inout_text13 => 'OT Hours';
  @override
  String get inout_text14 => 'Emergency Hours';
  @override
  String get inout_text15 => 'Sold hours';
  @override
  String get inout_text16 => 'Time';
  @override
  String get inout_text17 => 'Working Hours';

  @override
  String get inout_text19 => 'Check in time';
  @override
  String get inout_text20 => 'Check Out time';

  //// leave
  @override
  String get leave_text1 => 'Vacation Days';
  @override
  String get leave_text2 => 'Personal Days';
  @override
  String get leave_text3 => 'Unpaid Leave Unlimited';
  @override
  String get leave_text4 => 'Vacation Leave';
  @override
  String get leave_text5 => 'Total Days';
  @override
  String get leave_text6 => 'Leave Request';
  @override
  String get leave_text7 => 'Start Date';
  @override
  String get leave_text8 => 'End Date';
  @override
  String get leave_text9 => 'Leave type';
  @override
  String get leave_text10 => 'Reason';
  @override
  String get leave_text11 => 'Close ';
  @override
  String get leave_text12 => 'Save';

  /// tool
  String get tool_text1 => 'Tool Request';
  @override
  String get tool_text2 => 'Tool';
  @override
  String get tool_text3 => 'Start Date';
  @override
  String get tool_text4 => 'End Date';
  @override
  String get tool_text5 => 'Reason';
  @override
  String get tool_text6 => 'Approved';
  @override
  String get tool_text7 => 'Requested';
  @override
  String get tool_text8 => 'Rejected';
  @override
  String get tool_text9 => 'Returned';
  @override
  String get tool_text10 => 'Not Returned';

  @override
  String get tool_text11 => 'Approved';

  /// dr
  @override
  String get dr_text1 => 'On call Schedule';
  @override
  String get dr_text2 => 'Company Alert';
  @override
  String get dr_text3 => 'Notice';
  @override
  String get dr_text4 => 'Knowledge Base';
  @override
  String get dr_text5 => 'Account Delete';
  @override
  String get dr_text6 => 'Logout';
  @override
  // TODO: implement dr_text12
  String get dr_text12 => 'Employee warning';

  @override
  String get dr_text7 => 'Keyword';
  @override
  String get dr_text8 => 'Are you sure you want to logout?';
  @override
  String get dr_text9 => 'Are you sure you want to delete the account?';
  @override
  String get dr_text10 => 'Yes';
  @override
  String get dr_text11 => 'No';

  /// pro
  @override
  String get pro_text1 => 'Name';
  @override
  String get pro_text2 => 'Date of Birth';
  @override
  String get pro_text3 => 'E-mail';
  @override
  String get pro_text4 => 'Mobile';
  @override
  String get pro_text5 => 'Driving License';
  @override
  String get pro_text6 => 'Trade license';
  @override
  String get pro_text7 => 'Update';
  @override
  String get pro_text8 => 'Select Date';
  @override
  String get pro_text9 => 'Cancel';
  @override
  String get pro_text10 => 'Ok';

  //employee_warning
  @override
  String get employee_warning1 => 'Warning';
  @override
  String get employee_warning2 => 'Previous Meeting Date';
  @override
  String get employee_warning3 => 'Other Reasons';
  @override
  String get employee_warning4 => 'Detail of Action';
  @override
  String get employee_warning5 => 'Corrective measures';
}
