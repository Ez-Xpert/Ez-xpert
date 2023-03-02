import 'package:ez_xpert/base/base_page.dart';
import 'package:ez_xpert/screen/call_schedule/call_schedule_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class CallSchedule extends StatefulWidget {
  const CallSchedule({Key? key}) : super(key: key);

  @override
  _CallScheduleState createState() => _CallScheduleState();
}

class _CallScheduleState extends State<CallSchedule>
    with BasePage<CallScheduleVM> {
  @override
  Widget build(BuildContext context) {
    return builder(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            const Icon(Icons.person),
            Center(child: Text("  ${provider!.prefs.user?.name ?? "user"}  "))
          ],
          title: const Text("On Call Schedule"),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: CalendarCarousel<Event>(
            customGridViewPhysics: const NeverScrollableScrollPhysics(),
            onDayPressed: (DateTime date, List<Event> events) {
              // this.setState(() => _currentDate = date);
            },
            // daysHaveCircularBorder: false,
            todayButtonColor: Colors.transparent,
            todayTextStyle: const TextStyle(color: Colors.black),
            weekendTextStyle: const TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.grey,
            customDayBuilder: (
              bool isSelectable,
              int index,
              bool isSelectedDay,
              bool isToday,
              bool isPrevMonthDay,
              TextStyle textStyle,
              bool isNextMonthDay,
              bool isThisMonthDay,
              DateTime day,
            ) {
              if (provider!.schedules.where((element) {
                return DateTime.parse(element['dateTime']).day == day.day &&
                    DateTime.parse(element['dateTime']).month == day.month &&
                    DateTime.parse(element['dateTime']).year == day.year;
              }).isNotEmpty) {
                final ele = provider!.schedules.where((element) {
                  return DateTime.parse(element['dateTime']).day == day.day &&
                      DateTime.parse(element['dateTime']).month == day.month &&
                      DateTime.parse(element['dateTime']).year == day.year;
                }).first;
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.5),
                      shape: BoxShape.circle),
                  child: InkWell(
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Center(child: Text(' Schedule')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                "${ele['title']}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${ele['notes']}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            // TextButton(
                            //   onPressed: () => Navigator.pop(context, 'Cancel'),
                            //   child: const Text('Cancel'),
                            // ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Center(child: Text(day.day.toString())),
                  ),
                );
              } else {
                return null;
              }
              // if (provider.schedules
              //     .firstWhere((element) => element['dateTime'])
              //     .toString()
              //     .contains(day.toString().substring(0, 9))) {}
              // return null;
              // if (day.day == 15) {
              //   return const Center(
              //     child: Icon(Icons.local_airport),
              //   );
              // } else {
              //   return null;
              // }
            },
            weekFormat: false,
            // markedDatesMap: _markedDateMap,
            height: 420.0,
            // selectedDateTime: _currentDate,
            // daysHaveCircularBorder: true,
          ),
        ),
      ),
    );
  }

  @override
  CallScheduleVM create() => CallScheduleVM();

  @override
  void initialise(BuildContext context) {}
}
