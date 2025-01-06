import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _users = [];
  String? _selectedUser;
  String? _taskLevel;
  final TextEditingController _cardNumberController = TextEditingController();
  DateTime? _startDate;
  final TextEditingController _descriptionController = TextEditingController();
  final List<DateTime> _endDates = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
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
        Sql('SELECT id, firstname, lastname FROM public.users WHERE role_id = 2'),
      );

      setState(() {
        _users = result.map((row) => row.toColumnMap()).toList();
      });

      await conn.close();
    } catch (e) {
      print('Ошибка загрузки пользователей: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addControlCard() async {
    if (!_formKey.currentState!.validate() ||
        _startDate == null ||
        _endDates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все поля и выберите даты.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

      // Преобразование списка дат в массив для PostgreSQL
      final endDatesArray =
          '{${_endDates.map((date) => date.toIso8601String()).join(',')}}';

      await conn.execute(
        Sql.named(
          'INSERT INTO public.control_cards (user_id, card_number, start_date, end_date, description, task_level_id, status_id) VALUES '
          '(@user_id, @card_number, @start_date, @end_date, @description, @task_level_id, 1)',
        ),
        parameters: {
          'user_id': _selectedUser,
          'card_number': _cardNumberController.text.trim(),
          'start_date': _startDate.toString(),
          'end_date': endDatesArray,
          'description': _descriptionController.text.trim(),
          'task_level_id': _taskLevel,
        },
      );

      await conn.close();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Контрольная карточка добавлена!'),
          backgroundColor: Colors.green,
        ),
      );

      // Очистка формы
      _formKey.currentState!.reset();
      setState(() {
        _selectedUser = null;
        _taskLevel = null;
        _startDate = null;
        _endDates.clear();
      });
      _cardNumberController.clear();
      _descriptionController.clear();
    } catch (e) {
      print('Ошибка добавления карточки: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  Future<void> _addEndDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _endDates.add(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Админская панель'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Выберите сотрудника',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                items: _users
                    .map(
                      (user) => DropdownMenuItem(
                        value: user['id'].toString(),
                        child: Text('${user['firstname']} ${user['lastname']}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUser = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Выберите сотрудника' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Номер карточки',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Введите номер карточки'
                    : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Дата начала'),
                subtitle: Text(
                  _startDate == null
                      ? 'Выберите дату'
                      : _startDate.toString().split(' ')[0],
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectStartDate(context),
              ),
              const SizedBox(height: 16),
              const Text(
                'Даты окончания',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: _endDates
                    .map((date) => ListTile(
                          title: Text(date.toString().split(' ')[0]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _endDates.remove(date);
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
              ElevatedButton(
                onPressed: () => _addEndDate(context),
                child: const Text('Добавить дату окончания'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Введите описание' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Уровень задачи',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(
                    value: "1",
                    child: Text('Muhim'),
                  ),
                  DropdownMenuItem(
                    value: "2",
                    child: Text('muhim emas'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _taskLevel = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Выберите уровень задачи' : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addControlCard,
                child: const Text('Добавить карточку'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
