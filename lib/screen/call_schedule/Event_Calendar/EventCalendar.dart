library event_calendar;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../base/base_page.dart';
import '../call_schedule_vm.dart';
import 'package:http/http.dart' as http;

import '../../../api/api_config.dart';

part 'color-picker.dart';

part 'timezone-picker.dart';

List<Color> _colorCollection = <Color>[];
List<String> _colorNames = <String>[];
int _selectedColorIndex = 0;
int _selectedTimeZoneIndex = 0;
List<String> _timeZoneCollection = <String>[];
DataSource? _events;
late Meeting _selectedAppointment;
DateTime? _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';

//ignore: must_be_immutable
class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  EventCalendarState createState() => EventCalendarState();
}

class EventCalendarState extends State<EventCalendar>
    with BasePage<CallScheduleVM> {
  //EventCalendarState();

  final CalendarView _calendarView = CalendarView.month;
  List<String>? eventNameCollection;
  List<Meeting>? appointments = <Meeting>[];

  int? user_id;
  List leaveList = [];
  var user_name;
  var dateT;

  List demo = [
    {"dateTime": "19-07-2022", "title": 'hgjfhgjh', "notes": 'hghhfddsgf'},
    {"dateTime": "20-07-2022", "title": 'hgjfhgjh', "notes": 'hghhfddsgf'},
    {"dateTime": "21-07-2022", "title": 'hgjfhgjh', "notes": 'hghhfddsgf'},
  ];

  late DataSource dataSource;
  CalendarDataSource? _calendarDataSource;

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getInt("user_id");
      user_name = prefs.getString("user_name");

      getAllTask();
    });
  }

  getAllTask() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    print("token::::::=>" + token.toString());

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.baseUrl + ApiConfig.getCallSchedule));
    request.headers.addAll(headers);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        leaveList = result['data'];
        //appointments = getMeetingDetails(leaveList);
        _events = DataSource(appointments!);
      });
      // print("user result-->"+result['result']['tasks'].toString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    getUserId();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [],
        title: const Text(
          "On Call Schedule",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins400',
          ),
        ),
        elevation: .4,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: _events != null
          ? Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: getEventCalendar(_calendarView))
          : const Center(),
    );
  }

  SfCalendar getEventCalendar(
    CalendarView _calendarView,
  ) {
    return SfCalendar(
      view: _calendarView,
      dataSource: leaveList == null ? _getDataSource2() : _getDataSource(),
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        agendaViewHeight: 150,
        showAgenda: true,
        agendaStyle: AgendaStyle(
          backgroundColor: Colors.white30,
          appointmentTextStyle: TextStyle(
              fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black),
          dateTextStyle: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.black),
          dayTextStyle: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black),
        ),
      ),
    );
  }

  _DataSource _getDataSource() {
    final List<Appointment> appointments = <Appointment>[];
    for (var i = 0; i < leaveList.length; i++) {
      _startDate = DateTime.parse(leaveList[i]['schedules_date']);
      leaveList[i]['type'] == "office"
          ? appointments.add(Appointment(
              startTime: _startDate!.add(const Duration(hours: 0)),
              endTime: _startDate!.add(const Duration(hours: 0)),
              subject: leaveList[i]['title'],
              notes: leaveList[i]['notes'],
              color: Colors.green))
          : appointments.add(Appointment(
              startTime: _startDate!.add(const Duration(hours: 0)),
              endTime: _startDate!.add(const Duration(hours: 0)),
              subject: leaveList[i]['title'],
              notes: leaveList[i]['notes'],
              color: Colors.red));
    }
    return _DataSource(appointments);
  }

  _DataSource _getDataSource2() {
    final List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now().add(const Duration(hours: 4)),
      endTime: DateTime.now().add(const Duration(hours: 5)),
      subject: 'Meeting',
      color: Colors.red,
    ));
    return _DataSource(appointments);
  }

  @override
  CallScheduleVM create() {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  void initialise(BuildContext context) {
    // TODO: implement initialise
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source) {
    appointments = source;
  }
}

class Meeting {
  Meeting({
    this.id = 1,
    this.projId = 1,
    required this.title,
    this.ratio = 0,
    required this.notes,
    this.updated,
    required this.dateTime,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  int projId;
  String title;
  int ratio;
  String notes;
  dynamic updated;
  DateTime dateTime;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
}

class DateUtil {
  static const DATE_FORMAT = 'dd-MM-yyyy';
  String formattedDate(DateTime dateTime) {
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}
