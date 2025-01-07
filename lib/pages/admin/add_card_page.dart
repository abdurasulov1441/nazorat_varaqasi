import 'package:flutter/material.dart';

class AddCardPage extends StatelessWidget {
  const AddCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить карточку'),
        backgroundColor: Colors.red,
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


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: GlobalKey<FormState>(),
        child: ListView(
          children: [
          
            ElevatedButton(
              onPressed: () {
          
              },
              child: const Text('Добавить карточку'),
            ),
          ],
        ),
      ),
    );
  }
}
