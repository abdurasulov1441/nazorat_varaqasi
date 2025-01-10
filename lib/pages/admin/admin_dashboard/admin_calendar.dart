import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminCalendar extends StatelessWidget {
  const AdminCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 515,
      height: 250,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 10, left: 15),
      decoration: BoxDecoration(
          color: AppColors.foregroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: AdminDashboardCalendar(),
    );
  }
}

class AdminDashboardCalendar extends StatefulWidget {
  const AdminDashboardCalendar({super.key});

  @override
  State<AdminDashboardCalendar> createState() => _AdminDashboardCalendarState();
}

CalendarFormat _calendarFormat = CalendarFormat.month;
DateTime _focusedDay = DateTime.now();
DateTime? _selectedDay;
Map<DateTime, List<Map<String, dynamic>>> _events = {};
List<Map<String, dynamic>> _selectedEvents = [];

class _AdminDashboardCalendarState extends State<AdminDashboardCalendar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.only(top: 10, left: 10),
        decoration: BoxDecoration(
            color: AppColors.foregroundColor,
            borderRadius: BorderRadius.circular(10)),
        width: 100,
        height: 100,
        child: SimpleCalendarPage());
  }
}

class SimpleCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<DateTime?> _selectedDate = [DateTime.now()];

    return Center(
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.single,
          selectedDayHighlightColor: Colors.orange,
          firstDayOfWeek: 1,
        ),
        value: _selectedDate,
        onValueChanged: (dates) {
          print('Выбрана дата: ${dates.first}');
        },
      ),
    );
  }
}
