import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:intl/intl.dart';

import 'lesson_view.dart';

class ExploreWorkouts extends StatefulWidget {
  const ExploreWorkouts({super.key});

  @override
  _ExploreWorkoutsState createState() => _ExploreWorkoutsState();
}

class _ExploreWorkoutsState extends State<ExploreWorkouts> {
  ApiService apiService = ApiService();
  List<Map<String, dynamic>> workouts = [];
  List<Map<String, dynamic>> filteredWorkouts = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool isSearching = false;
  bool hasMore = true;
  bool isAdmin = false;
  int currentPage = 0;
  final int pageSize = 5;
  String selectedType = 'ONLINE';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWorkouts();
    _searchController.addListener(_filterWorkouts);
    _checkIfAdmin();
  }

  Future<void> _checkIfAdmin() async {
    try {
      final result = await apiService.checkTarget();
      setState(() {
        isAdmin = result == 'admin';
      });
    } catch (e) {
      print('Failed to check admin status: $e');
    }
  }

  Future<void> _getWorkouts({String? searchQuery}) async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      try {
        await Future.delayed(const Duration(milliseconds: 500));

        final queryParams = searchQuery != null ? '?title.contains=$searchQuery' : '';
        final response = isAdmin
            ? await apiService.adminGetAllTrainingProgram(currentPage, selectedType, queryParams)
            : await apiService.getAllTrainingProgram(currentPage, selectedType, queryParams);
        setState(() {
          workouts.addAll(List<Map<String, dynamic>>.from(response['content']));
          _filterWorkouts(); // Filter the workouts based on the search query
          isLoading = false;
          isLoadingMore = false;
          currentPage++;
          hasMore = currentPage < response['totalPages'];
        });
      } catch (e) {
        print('Failed to load workouts: $e');
        setState(() {
          isLoading = false;
          isLoadingMore = false;
        });
      }
    }
  }

  void _onTypeSelected(String type) {
    setState(() {
      selectedType = type;
      workouts.clear();
      filteredWorkouts.clear();
      currentPage = 0;
      hasMore = true;
      isSearching = false;
      _searchController.clear();
      _getWorkouts();
    });
  }

  void _filterWorkouts() {
    final query = _searchController.text;
    setState(() {
      filteredWorkouts = workouts.where((workout) {
        final title = workout['title'];
        return title.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.lightGrey,
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () => _showAddWorkoutDialog(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null, // Hide the button if not an admin
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !isLoadingMore && hasMore) {
            _getWorkouts();
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.dx),
            child: Column(
              children: [
                // Toggle search bar visibility
                if (isSearching)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.dy),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by title...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black), // Change border color when focused
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              isSearching = false;
                              _searchController.clear();
                              _filterWorkouts();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTypeButton('Online', 'ONLINE'),
                    _buildTypeButton('Offline', 'OFFLINE'),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isSearching) {
                            _searchController.clear(); // Clear the search text
                            _filterWorkouts(); // Update the workouts list
                          }
                          isSearching = !isSearching;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: isSearching ? Colors.black : const Color(0xffE5E5E5),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15.0),
                      ),
                      child: isSearching
                          ? Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                          : const Icon(CupertinoIcons.search, color: Colors.black,),
                    ),
                  ],
                ),
                if (filteredWorkouts.isEmpty && !isLoading)
                  const Center(child: Text('No workouts available'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredWorkouts.length + (hasMore && isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredWorkouts.length) {
                        // Show loading indicator if there are more items to load
                        return const Center(child: CircularProgressIndicator());
                      }
                      final workout = filteredWorkouts[index];
                      return GestureDetector(
                        onTap: () {
                          _showWorkoutDetails(
                              workout['title'],
                              workout['type'],
                              workout['description'],
                              workout['startDate'],
                              workout['startTime'],
                              workout['id']
                          );
                        },
                        child: Column(
                          children: [
                            SparkleContainer(
                              height: 148.dy,
                              isBgWhite: index % 3 == 1,
                              decoration: BoxDecoration(
                                color: index % 3 == 0
                                    ? appColors.black
                                    : index % 3 == 1
                                    ? appColors.white
                                    : appColors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: workoutContent(
                                topText: workout['title'].toUpperCase(),
                                description: workout['description'],
                                type: workout['type'],
                                startDate: workout['startDate'],
                                startTime: workout['startTime'],
                                isBgWhite: index % 3 == 1,
                              ),
                            ),
                            if (index < filteredWorkouts.length - 1) YBox(15.dy),
                          ],
                        ),
                      );
                    },
                  ),
                if (isLoadingMore && filteredWorkouts.isEmpty)
                  const Center(child: CircularProgressIndicator()),
                YBox(30.dy),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String text, String type) {
    bool isSelected = selectedType == type;
    return ElevatedButton(
      onPressed: () => _onTypeSelected(type),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? appColors.white : appColors.black,
        backgroundColor: isSelected ? appColors.black : appColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(10.dx),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget workoutContent({
    bool isBgWhite = false,
    required String? topText,
    required String? type,
    required String? description,
    required String? startDate,
    required String? startTime
  }) {
    return Padding(
      padding: EdgeInsets.all(10.dx).copyWith(bottom: 30.dy),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: '$topText\n',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: !isBgWhite ? appColors.white : null,
                  ),
                  children: [
                    TextSpan(
                      text: type == 'OFFLINE' ? '$type\n$startDate\n$startTime' : '$type',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: !isBgWhite ? appColors.white : null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 200.dx, // Adjust the width as needed
                child: Text(
                  '$description',
                  maxLines: type == 'OFFLINE' ? 1 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.roboto(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: !isBgWhite ? const Color(0xffD9D9D9) : null,
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgAsset(
                    assetName: trophyIcon,
                    height: 13.5.dy,
                  ),
                ],
              ),
              SvgPicture.asset(quickBurst),
            ],
          ),
        ],
      ),
    );
  }

  void _showWorkoutDetails(
      String? title,
      String? type,
      String? description,
      String? startDate,
      String? startTime,
      int id) {
    if (isAdmin) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return EditWorkoutForm(
            workout: {
              'title': title,
              'type': type,
              'description': description,
              'startDate': startDate,
              'startTime': startTime,
              'id': id,
            },
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title ?? '',
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type: $type',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.dy),
                Text(
                  type == 'OFFLINE' ? 'Start Date: $startDate' : '',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.dy),
                Text(
                  'Start Time: $startTime',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.dy),
                Text(
                  'Description: $description',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await apiService.userRegisterProgram(id);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully registered for the program!')),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to register: $e')),
                    );
                  }
                },
                child: Text(
                  'Register',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _showAddWorkoutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddWorkoutForm();
      },
    );
  }
}

class AddWorkoutForm extends StatefulWidget {
  @override
  _AddWorkoutFormState createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedType = 'ONLINE';
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();

  final ApiService apiService = ApiService();

  bool get isOnline => selectedType == 'ONLINE';

  Future<void> _submitWorkout() async {
    try {
      await apiService.adminPostWorkout(
        titleController.text,
        descriptionController.text,
        selectedType,
        startDateController.text,
        startTimeController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout added successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add workout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedType,
            onChanged: (String? newValue) {
              setState(() {
                selectedType = newValue!;
              });
            },
            items: <String>['ONLINE', 'OFFLINE']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Type',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: startDateController,
            decoration: InputDecoration(
              labelText: 'Start Date',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              enabled: !isOnline, // Disable the field if online
              fillColor: isOnline ? Colors.grey[300] : null, // Grey out the field if online
              filled: isOnline,
            ),
            onTap: isOnline
                ? null // Prevent interaction if online
                : () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                startDateController.text = formattedDate;
              }
            },
            readOnly: isOnline, // Make the field read-only if online
          ),
          SizedBox(height: 10),
          TextField(
            controller: startTimeController,
            decoration: InputDecoration(
              labelText: 'Start Time',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              enabled: !isOnline, // Disable the field if online
              fillColor: isOnline ? Colors.grey[300] : null, // Grey out the field if online
              filled: isOnline,
            ),
            onTap: isOnline
                ? null // Prevent interaction if online
                : () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                final now = DateTime.now();
                final formattedTime = DateFormat('HH:mm:ss').format(
                  DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute),
                );
                startTimeController.text = formattedTime;
              }
            },
            readOnly: isOnline, // Make the field read-only if online
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _submitWorkout,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                ),
                child: const Text('Add Workout'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the form or dialog
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditWorkoutForm extends StatefulWidget {
  final Map<String, dynamic> workout;

  const EditWorkoutForm({required this.workout, Key? key}) : super(key: key);

  @override
  _EditWorkoutFormState createState() => _EditWorkoutFormState();
}

class _EditWorkoutFormState extends State<EditWorkoutForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedType = 'ONLINE';
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the current workout details
    final workout = widget.workout;
    titleController.text = workout['title'] ?? '';
    descriptionController.text = workout['description'] ?? '';
    selectedType = workout['type'] ?? 'ONLINE';
    startDateController.text = workout['startDate'] ?? '';
    startTimeController.text = workout['startTime'] ?? '';
  }

  bool get isOnline => selectedType == 'ONLINE';

  Future<void> _submitWorkout() async {
    try {
      await apiService.adminUpdateWorkout(
        widget.workout['id'], // Pass the workout ID for updating
        titleController.text,
        descriptionController.text,
        selectedType,
        startDateController.text,
        startTimeController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workout updated successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update workout')),
      );
    }
  }

  void _navigateToLessonView() {
    print('');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonView(workout: widget.workout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedType,
            onChanged: (String? newValue) {
              setState(() {
                selectedType = newValue!;
              });
            },
            items: <String>['ONLINE', 'OFFLINE']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Type',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: startDateController,
            decoration: InputDecoration(
              labelText: 'Start Date',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              enabled: !isOnline,
              fillColor: isOnline ? Colors.grey[300] : null,
              filled: isOnline,
            ),
            onTap: isOnline
                ? null
                : () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                startDateController.text = formattedDate;
              }
            },
            readOnly: isOnline,
          ),
          SizedBox(height: 10),
          TextField(
            controller: startTimeController,
            decoration: InputDecoration(
              labelText: 'Start Time',
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              enabled: !isOnline,
              fillColor: isOnline ? Colors.grey[300] : null,
              filled: isOnline,
            ),
            onTap: isOnline
                ? null
                : () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                final now = DateTime.now();
                final formattedTime = DateFormat('HH:mm:ss').format(
                  DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute),
                );
                startTimeController.text = formattedTime;
              }
            },
            readOnly: isOnline,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _submitWorkout,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                ),
                child: const Text('Update'),
              ),
              ElevatedButton(
                onPressed: _navigateToLessonView,
                child: Text('View Lesson'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the form or dialog
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red,
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}