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
      height: 200,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 20, left: 15),
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
        child: TableCalendar(
          availableCalendarFormats: const {
            CalendarFormat.week: 'Week',
            CalendarFormat.month: 'Month',
          },

          locale: 'uz_UZ',
          firstDay: DateTime(2000),
          lastDay: DateTime(2100),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: (day) {
            final cleanedDay = DateTime(day.year, day.month, day.day);
            return _events[cleanedDay] ?? [];
          },
          //onDaySelected: _onDaySelected,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              final daysOfWeek = [
                'Dush',
                'Sesh',
                'Chor',
                'Pav',
                'Jum',
                'Shan',
                'Yak'
              ];
              final isSunday = day.weekday == DateTime.sunday;
              return Center(
                child: Text(daysOfWeek[day.weekday - 1],
                    style: AppStyle.fontStyle.copyWith(
                      color: isSunday ? Colors.red : Colors.black,
                    )),
              );
            },
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          startingDayOfWeek: StartingDayOfWeek.monday,
        ));
  }
}
