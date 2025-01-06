import 'package:postgres/postgres.dart';
import 'package:windows_notification/notification_message.dart';
import 'package:windows_notification/windows_notification.dart';

Future<void> checkAndNotify() async {
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
        'SELECT * FROM public.control_cards WHERE status_id = 1',
      ),
    );

    final cards = result.map((row) => row.toColumnMap()).toList();

    for (final card in cards) {
      _showNotification(card);
      await conn.execute(
        Sql.named(
          'UPDATE public.control_cards SET status_id = 2 WHERE id = @card_id',
        ),
        parameters: {'card_id': card['id']},
      );
    }

    await conn.close();
  } catch (e) {
    print('Ошибка при отправке уведомлений: $e');
  }
}

void _showNotification(Map<String, dynamic> card) {
  final message = NotificationMessage.fromPluginTemplate(
    "Control Card Notification",
    "Новая карточка: ${card['card_number']}",
    '''
Описание: ${card['description']}
Дата начала: ${card['start_date']}
Дата окончания: ${card['end_date']}
Уровень задачи: ${card['task_level'] ?? 'Не указан'}
''',
  );

  WindowsNotification(applicationId: r"{YourAppID}")
      .showNotificationPluginTemplate(message);
}
