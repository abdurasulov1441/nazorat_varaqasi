import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
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
          'SELECT c.end_date, c.card_number, u.firstname, u.lastname, c.description, c.task_level_id, c.status_id '
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
        print('_events: $_events'); // Отладочный вывод
      });

      await conn.close();
    } catch (e) {
      print('Ошибка загрузки данных: $e');
    }
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
      appBar: AppBar(
        title: const Text('Календарь задач'),
        backgroundColor: Colors.red,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 600,
            height: 400,
            child: TableCalendar(
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
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedEvents.isEmpty
                ? const Center(
                    child: Text(
                      'На выбранную дату задач нет.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = _selectedEvents[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        color: AppColors.foregroundColor,
                        child: ListTile(
                          title: Text(
                            'Карточка №${event['card_number']}',
                            style: AppStyle.fontStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ответственный: ${event['firstname']} ${event['lastname']}',
                                style: AppStyle.fontStyle,
                              ),
                              Text(
                                'Описание: ${event['description']}',
                                style: AppStyle.fontStyle,
                              ),
                              Text(
                                'Уровень задачи: ${event['task_level_id'] == 1 ? "QBB" : "MG"}',
                                style: AppStyle.fontStyle,
                              ),
                              Text(
                                'Статус: ${event['status_id'] == 1 ? "Активная" : "В процессе"}',
                                style: AppStyle.fontStyle,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
