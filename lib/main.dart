import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() => runApp(CalendarPickerIntegration());

class VisibleDatesDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarPickerIntegration(),
    );
  }
}

class CalendarPickerIntegration extends StatefulWidget {
  @override
  CalendarPickerIntegrationState createState() => CalendarPickerIntegrationState();
}

class CalendarPickerIntegrationState extends State<CalendarPickerIntegration> {
    CalendarController _calendarController;
    DateRangePickerController _dateRangePickerController;

    @override
    void initState() {
      _calendarController = CalendarController();
      _dateRangePickerController = DateRangePickerController();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: SfDateRangePicker(
                    controller: _dateRangePickerController,
                    showNavigationArrow: true,
                    allowViewNavigation: false,
                    monthViewSettings: DateRangePickerMonthViewSettings(
                        numberOfWeeksInView: 1),
                    onSelectionChanged: selectionChanged,
                  ),
                ),
                Expanded(
                  child: SfCalendar(
                    headerHeight: 0,
                    controller: _calendarController,
                    viewHeaderHeight: 0,
                    dataSource: _getCalendarDataSource(),
                    onViewChanged: viewChanged,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _calendarController.displayDate = args.value;
    });
  }

  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    DateTime today = DateTime.now();
    appointments.add(Appointment(
      startTime:DateTime(today.year,today.month,today.day,9,0,0),
      endTime: DateTime(today.year,today.month,today.day,10,0,0),
      subject: 'Meeting',
      color: Colors.pinkAccent,
    ));
    appointments.add(Appointment(
      startTime:DateTime(today.year,today.month,today.day+1,9,0,0),
      endTime: DateTime(today.year,today.month,today.day+1,10,0,0),
      subject: 'Retrospective',
      color: Colors.blue,
    ));

    return _AppointmentDataSource(appointments);
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _dateRangePickerController.selectedDate =
      viewChangedDetails.visibleDates[0];
      _dateRangePickerController.displayDate =
      viewChangedDetails.visibleDates[0];
    });
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
