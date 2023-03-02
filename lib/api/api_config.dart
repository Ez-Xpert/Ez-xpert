class ApiConfig {
  //static const baseUrl = "http://159.223.142.128/User/";
  static const baseUrl = "https://ez-xpert.ca/api/";

  //Updated All Api
  static const login = "login";
  static const getProfile = "user";
  static const logout = "logout";
  static const account_delete = "remove-user";
  static const updateProfile = "profile-update";
  static const getLeave = "leave";
  static const addLeave = "add-leave";
  static const gettools = "tool-list";
  static const requestTool = "tool-request";
  static const tool_request_list = "tool-request-list";
  static const getnotice = "notice";
  static const getKnowledge = "knowledge";
  static const getCallSchedule = "on-call-schedule";
  static const getHours = "time-sheet";
  static const attendanceInOut = "add-attendance";
  static const emerAttendanceInOut = "emergency-attendance";
  static const getattendance = "attendance-list";
  static const calcEffecience = "efficiency-calculation";
  static const addSellHour = "add-sell-hours";
  static const getDash = "dashboard";
  static const updateToken = "update-token";
   static const checkVersion  ='settings';
  //static const attendanceInOut = "User/api/auth/attendance_clk_in";

  //static const attendanceInOut = "User/api/auth/attendance_clk_in";
  //static const emerAttendanceInOut = "User/api/auth/emerge_clk";
  static const getattend = "User/api/auth/attendance";

  /* static const calcEffecience = "User/api/auth/efficiency_cal";
  static const addSellHour = "User/api/auth/add_sell_hour";*/
  //Pending Api

  static const signup = "User/api/register";
  static const getUserData = "User/api/auth/get_user_satistics";
  static const getPayRoll = "User/api/auth/payroll";
  //static const getattendance = "User/api/auth/attendance_details";

  //static const attendanceInOut = "User/api/auth/attendance_clk_in";
  // static const emerAttendanceInOut = "User/api/auth/emerge_clk";

  /*static const getDash = "User/api/auth/appdashboard";*/
  static const DEFAULT_LANGUAGE = 'en';

  //static const gettools = "User/api/auth/tool_lst";
  //static const requestTool = "User/api/auth/tool_request";
  //static const getLeave = "User/api/auth/leave";
  // static const getnotice = "User/api/auth/notice";
  //static const addLeave = "User/api/auth/add_leave";
  // static const getKnowledge = "User/api/auth/knowledge";
  //static const updateProfile = "User/api/auth/profile_update";
  //static const account_delete = "User/api/auth/remove_user_account";
}
