import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymApp/src/features/explore/presentation/views/nutrition.dart';
import 'package:intl/intl.dart';
import 'package:gymApp/src/shared/api/api_service.dart';

import '../../../../shared/shared.dart';

class NutritionForm extends StatefulWidget {
  final VoidCallback? onSubmit;

  const NutritionForm({super.key, this.onSubmit});

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
        ApiService apiService = ApiService();
        await apiService.postUserTodayMeals(requestData);
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
        title: const Text('Add Food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Date and Time Fields
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                    labelText: 'Date',
                    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
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
                decoration: const InputDecoration(
                    labelText: 'Time',
                    labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)
                ),
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
              // Food Entries List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _foodEntries.length,
                itemBuilder: (context, index) {
                  final entry = _foodEntries[index];
                  return Column(
                    key: UniqueKey(),
                    children: [
                      TextFormField(
                        controller: entry["foodNameController"],
                        decoration: InputDecoration(
                            labelText: 'Food Name',
                            labelStyle: TextStyle(color: appColors.black, fontWeight: FontWeight.w700)),
                        onSaved: (value) {
                          entry["foodNameController"].text = value ?? '';
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: entry["valueController"],
                              decoration: const InputDecoration(
                                  labelText: 'Value',
                                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
                              keyboardType: TextInputType.number,
                              onSaved: (value) {
                                entry["valueController"].text = value ?? '0.0';
                              },
                            ),
                          ),
                          const SizedBox(width: 1),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: entry["unit"],
                              items: ["g", "ml"].map((unit) {
                                return DropdownMenuItem<String>(
                                  value: unit,
                                  child: Center(
                                    child: Text(unit,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  entry["unit"] = value ?? "g";
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: IconButton(
                        onPressed: _addFoodEntry,
                        icon: SvgPicture.asset(addIcon, width: 30, height: 30),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Submit'),
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}