import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker_app/models/weight_entry.dart';

class WeightEntryScreen extends StatefulWidget {
  @override
  _WeightEntryScreenState createState() => _WeightEntryScreenState();
}

class _WeightEntryScreenState extends State<WeightEntryScreen> {
  final TextEditingController _weightController = TextEditingController();
  late DateTime _selectedDate;
  final TextEditingController _noteController = TextEditingController();

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _selectedDate.toString(); // Update the text field with selected date
      });
    });
    print('...');
  }

  final TextEditingController _dateController = TextEditingController();

  void _submitForm(BuildContext context) {
    final weight = double.parse(_weightController.text);
    final date = _selectedDate.toString();
    final note = _noteController.text;

    // Create a new WeightEntry object
    final weightEntry = WeightEntry(
      id: DateTime.now().toString(),
      weight: weight,
      date: date,
      note: note,
    );

    // Add the weight entry to Firestore
    FirebaseFirestore.instance
        .collection('weightEntries')
        .doc(weightEntry.id)
         .set(weightEntry.toMap())
        .then((value) => Navigator.pop(context))
        .catchError((error) => print('Failed to add weight entry: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Weight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight',
              ),
            ),
            TextField(
              controller: _noteController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Note',
              ),
            ),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: const Text('Save'),
            ),
          ],
        ),
     ),
);
}
}


