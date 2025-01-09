import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';

class AdminCalendarPage extends StatefulWidget {
  const AdminCalendarPage({super.key});

  @override
  State<AdminCalendarPage> createState() => _AdminCalendarPageState();
}

class _AdminCalendarPageState extends State<AdminCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  List<Map<String, dynamic>> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEventsFromDatabase();
  }

  Future<void> _loadEventsFromDatabase() async {
    try {
      final conn = await Connection.open(
        Endpoint(
          host: '10.100.9.145',
          database: 'abdulaziz',
          username: 'postgres',
          password: 'fizmasoft7998872',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );

      final result = await conn.execute(
        Sql.named(
          'SELECT c.end_date, c.card_number, u.firstname, u.lastname, c.description, c.task_level_id, c.status_id,c.start_date '
          'FROM public.control_cards c '
          'LEFT JOIN public.users u ON c.user_id = u.id '
          'WHERE c.status_id != 3',
        ),
      );

      final data = result.map((row) => row.toColumnMap()).toList();

      Map<DateTime, List<Map<String, dynamic>>> events = {};
      for (var item in data) {
        if (item['end_date'] is List) {
          for (var date in item['end_date']) {
            final cleanedDate = date is DateTime
                ? DateTime(date.year, date.month, date.day)
                : DateTime.parse(date.toString()).toUtc();

            if (!events.containsKey(cleanedDate)) {
              events[cleanedDate] = [];
            }
            events[cleanedDate]?.add(item);
          }
        }
      }

      setState(() {
        _events = events;
      });

      await conn.close();
    } catch (e) {
      print('Ошибка загрузки данных: $e');
    }
  }

  String _formatDate(dynamic date) {
    if (date is String) {
      return DateTime.parse(date)
          .toLocal()
          .toString()
          .split(' ')[0]
          .replaceAll('-', '.');
    } else if (date is DateTime) {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
    return '';
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      final normalizedSelectedDay = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      );

      _selectedDay = normalizedSelectedDay;
      _focusedDay = focusedDay;

      _selectedEvents = _events[normalizedSelectedDay] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'Sana bo\'yicha nazorat varaqalari',
          style: AppStyle.fontStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.red,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 10),
            decoration: BoxDecoration(
                color: AppColors.foregroundColor,
                borderRadius: BorderRadius.circular(10)),
            width: 400,
            height: 400,
            child: TableCalendar(
              availableCalendarFormats: const {
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
              onDaySelected: _onDaySelected,
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
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _selectedEvents.isEmpty
                ? Center(
                    child: Text(
                      'Tanlangan sanaga nazorat varaqalari yo\'q',
                      style: AppStyle.fontStyle.copyWith(color: Colors.grey),
                    ),
                  )
                : SpGrid(
                    width: MediaQuery.of(context).size.width,
                    spacing: 16,
                    children: _selectedEvents.map((event) {
                      return SpGridItem(
                        xs: 12,
                        sm: 6,
                        md: 4,
                        lg: 6,
                        child: Card(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          color: AppColors.foregroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: (() {
                                          switch (event['status_id']) {
                                            case 1:
                                            case 2:
                                              return Colors.green;
                                            case 3:
                                              return Colors.blue;
                                            case 4:
                                              return Colors.orange;
                                            case 5:
                                              return Colors.red;
                                            default:
                                              return Colors.grey;
                                          }
                                        })(),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Nazorat varaqasi №${event['card_number']}',
                                        style: AppStyle.fontStyle.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      event['task_level_id'] == 1
                                          ? "QBB"
                                          : "MG",
                                      style: AppStyle.fontStyle,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatDate(event['start_date']),
                                          style: AppStyle.fontStyle
                                              .copyWith(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_right_alt,
                                      color: AppColors.headerColor,
                                      size: 30,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (event['end_date'] is List &&
                                            event['end_date'].length > 1) ...[
                                          for (var date in event['end_date'])
                                            Text(
                                              _formatDate(date),
                                              style: AppStyle.fontStyle,
                                            ),
                                        ] else
                                          Text(
                                            _formatDate(
                                              event['end_date'] is List
                                                  ? event['end_date'][0]
                                                  : event['end_date'],
                                            ),
                                            style: AppStyle.fontStyle
                                                .copyWith(fontSize: 20),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Javobgar: ${event['firstname']} ${event['lastname']}',
                                  style: AppStyle.fontStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Tasnif: ${event['description']}',
                                  style: AppStyle.fontStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
