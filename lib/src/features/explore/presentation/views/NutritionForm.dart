import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gymApp/src/shared/api/api_service.dart';

class NutritionForm extends StatefulWidget {
  @override
  _NutritionFormState createState() => _NutritionFormState();
}

class _NutritionFormState extends State<NutritionForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final List<Map<String, dynamic>> _foodEntries = [
    {
      "foodNameController": TextEditingController(),
      "valueController": TextEditingController(),
      "unit": "g"
    },
  ];

  void _addFoodEntry() {
    setState(() {
      _foodEntries.add({
        "foodNameController": TextEditingController(),
        "valueController": TextEditingController(),
        "unit": "g"
      });
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final date = _dateController.text;
      final time = _timeController.text;

      final nutritionList = _foodEntries.map((entry) {
        return {
          "foodName": entry["foodNameController"].text,
          "value": double.parse(entry["valueController"].text),
          "unit": entry["unit"],
        };
      }).toList();

      final requestData = {
        "nutritionList": nutritionList,
        "createdDate": date,
        "createdTime": time,
      };

      // Call the API
      try {
        print(requestData);
        ApiService apiService = ApiService();
        await apiService.postUserMeals(requestData);
        Navigator.pop(context, requestData);
      } catch (error) {
        // Handle errors
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post meals: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  return null;
                },
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final dateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    setState(() {
                      _timeController.text = DateFormat('HH:mm:ss').format(dateTime);
                    });
                  }
                },
              ),
              ..._foodEntries.map((entry) {
                int index = _foodEntries.indexOf(entry);
                return Column(
                  key: UniqueKey(),
                  children: [
                    TextFormField(
                      controller: entry["foodNameController"],
                      decoration: InputDecoration(labelText: 'Food Name'),
                      onSaved: (value) {
                        entry["foodNameController"].text = value ?? '';
                      },
                    ),
                    TextFormField(
                      controller: entry["valueController"],
                      decoration: InputDecoration(labelText: 'Value'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        entry["valueController"].text = value ?? '0.0';
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: entry["unit"],
                      items: ["g", "ml"].map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          entry["unit"] = value ?? "g";
                        });
                      },
                    ),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: _addFoodEntry,
                child: const Text('Add Food'),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}