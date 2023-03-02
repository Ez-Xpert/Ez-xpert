class UserSatistics {
  UserSatistics({
    this.totalHours,
    this.attendance,
    this.workingHours,
    this.mySalary,
    this.salaryReceived,
    this.news,
    this.totalLeave,
    this.takenLeave,
    this.dailyPerformance,
  });

  String? totalHours;
  int? attendance;
  String? workingHours;
  int? mySalary;
  int? salaryReceived;
  List<dynamic>? news;
  int? totalLeave;
  int? takenLeave;
  List<DailyPerformance>? dailyPerformance;

  factory UserSatistics.fromJson(Map<String, dynamic> json) => UserSatistics(
        totalHours: json["tot_hours"],
        attendance: json["attendance"],
        workingHours: json["working_hours"],
        mySalary: json["my_salary"],
        salaryReceived: json["salary_received"],
        news: List<dynamic>.from(json["news"].map((x) => x)),
        totalLeave: json["total_leave"],
        takenLeave: json["taken_leave"],
        dailyPerformance: List<DailyPerformance>.from(
            json["daily_performance"].map((x) => DailyPerformance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tot_hours": totalHours,
        "attendance": attendance,
        "working_hours": workingHours,
        "my_salary": mySalary,
        "salary_received": salaryReceived,
        "news": List<dynamic>.from(news?.map((x) => x) ?? []),
        "total_leave": totalLeave,
        "taken_leave": takenLeave,
        "daily_performance":
            List<dynamic>.from(dailyPerformance?.map((x) => x.toJson()) ?? []),
      };
}

class DailyPerformance {
  DailyPerformance({
    this.date,
    this.regularTime,
    this.overTime,
    this.emrgeTime,
  });

  String? date;
  int? regularTime;
  int? overTime;
  int? emrgeTime;

  factory DailyPerformance.fromJson(Map<String, dynamic> json) =>
      DailyPerformance(
        date: json["date"],
        regularTime: json["regular_time"],
        overTime: json["over_time"],
        emrgeTime: json["emrge_time"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "regular_time": regularTime,
        "over_time": overTime,
        "emrge_time": emrgeTime,
      };
}
