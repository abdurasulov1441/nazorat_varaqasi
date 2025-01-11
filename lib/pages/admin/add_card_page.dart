import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';
import 'package:postgres/postgres.dart';

class AddCardPage extends StatelessWidget {
  const AddCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.foregroundColor,
            )),
        title: Text(
          'Nazorat varqasi qo\'shish',
          style: AppStyle.fontStyle.copyWith(fontSize: 20),
        ),
        backgroundColor: Colors.green,
      ),
      body: const AddCardForm(),
    );
  }
}

class AddCardForm extends StatefulWidget {
  const AddCardForm({super.key});

  @override
  State<AddCardForm> createState() => _AddCardFormState();
}

class _AddCardFormState extends State<AddCardForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _startDate;
  final List<DateTime> _endDates = [];
  String? _selectedUserId;
  String? _taskLevel;

  List<Map<String, dynamic>> _users = [];

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
        Sql.named(
          'SELECT id, firstname, lastname FROM public.users WHERE role_id != 1',
        ),
      );

      setState(() {
        _users = result.map((row) => row.toColumnMap()).toList();
      });

      await conn.close();
    } catch (e) {
      print('Ошибка загрузки сотрудников: $e');
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

      final endDatesArray =
          '{${_endDates.map((date) => date.toIso8601String()).join(',')}}';

      await conn.execute(
        Sql.named(
          'INSERT INTO public.control_cards (user_id, card_number, start_date, end_date, description, task_level_id, status_id) VALUES '
          '(@user_id, @card_number, @start_date, @end_date, @description, @task_level_id, 1)',
        ),
        parameters: {
          'user_id': _selectedUserId,
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
      setState(() {
        _selectedUserId = null;
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LottieBuilder.asset('assets/lotties/add_info.json'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text('Xodimni tanlang', style: AppStyle.fontStyle),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    dropdownColor: AppColors.foregroundColor,
                    borderRadius: BorderRadius.circular(10),
                    items: _users
                        .map(
                          (user) => DropdownMenuItem(
                            value: user['id'].toString(),
                            child: Text(
                              '${user['firstname']} ${user['lastname']}',
                              style: AppStyle.fontStyle,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUserId = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Xodimni tanlang' : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.foregroundColor,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: AppStyle.fontStyle,
                    controller: _cardNumberController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.foregroundColor)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: AppColors.foregroundColor,
                      labelText: 'Nazorat varaqasi raqami',
                      labelStyle: AppStyle.fontStyle,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nazorat varaqasi raqamini kiriting'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    iconColor: AppColors.foregroundColor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.foregroundColor),
                        borderRadius: BorderRadius.circular(10)),
                    title: const Text(
                      'Ijro boshlanish vaqti',
                      style: AppStyle.fontStyle,
                    ),
                    subtitle: Text(
                        _startDate == null
                            ? 'Sanasini tanlang'
                            : _startDate.toString().split(' ')[0],
                        style: AppStyle.fontStyle),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectStartDate(context),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tugash vaqti',
                    style: AppStyle.fontStyle,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: _endDates
                        .map((date) => ListTile(
                              title: Text(date.toString().split(' ')[0],
                                  style: AppStyle.fontStyle),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: AppColors.foregroundColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _endDates.remove(date);
                                  });
                                },
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.foregroundColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () => _addEndDate(context),
                      child: const Text(
                        'Ijro muddati tugash vaqti',
                        style: AppStyle.fontStyle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: AppStyle.fontStyle,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.foregroundColor,
                      labelText: 'Tasnif',
                      labelStyle: AppStyle.fontStyle,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Tasnif kiriting'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nazorat varaqasi qayerniki?',
                    style: AppStyle.fontStyle,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    dropdownColor: AppColors.foregroundColor,
                    items: const [
                      DropdownMenuItem(
                          value: "1",
                          child: Text(
                            'QBB',
                            style: AppStyle.fontStyle,
                          )),
                      DropdownMenuItem(
                          value: "2",
                          child: Text(
                            'MG',
                            style: AppStyle.fontStyle,
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _taskLevel = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Nazorat varaqasi qayerniki?' : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.foregroundColor,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          backgroundColor: AppColors.foregroundColor),
                      onPressed: _addControlCard,
                      child: const Text(
                        'Nazorat varaqasini qo\'shish',
                        style: AppStyle.fontStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
