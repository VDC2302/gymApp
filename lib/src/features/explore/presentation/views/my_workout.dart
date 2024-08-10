import 'package:flutter/cupertino.dart';
import 'package:gymApp/src/features/explore/presentation/views/lesson_view.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymApp/src/shared/api/api_service.dart';

class MyWorkout extends StatefulWidget {
  const MyWorkout({super.key});

  @override
  _MyWorkoutState createState() => _MyWorkoutState();
}

class _MyWorkoutState extends State<MyWorkout>{
  ApiService apiService = ApiService();
  List<Map<String, dynamic>> workouts = [];
  List<Map<String, dynamic>> filteredWorkouts = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool isSearching = false;
  bool hasMore = true;
  int currentPage = 0;
  final int pageSize = 5;
  String selectedType = 'ONLINE';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWorkouts();
    _searchController.addListener(_filterWorkouts);
  }

  Future<void> _getWorkouts({String? searchQuery}) async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      try {
        await Future.delayed(const Duration(milliseconds: 500));

        final queryParams = searchQuery != null ? '?title.contains=$searchQuery' : '';
        final response = await apiService.getUserTrainingProgram(currentPage, selectedType, queryParams);
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
      workouts.clear(); // Clear current workouts
      filteredWorkouts.clear(); // Clear filtered workouts
      currentPage = 0; // Reset page
      hasMore = true; // Reset hasMore
      isSearching = false;
      _searchController.clear();
      _getWorkouts(); // Fetch new data
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
                    _buildtypeButton('Online', 'ONLINE'),
                    _buildtypeButton('Offline', 'OFFLINE'),
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
                  const Center(child: Text('No registered workouts'))
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
                      return Column(
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
                              workout: workout, // Pass the workout map here
                            ),
                          ),
                          if (index < filteredWorkouts.length - 1) YBox(15.dy),
                        ],
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

  Widget _buildtypeButton(String text, String type) {
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
    required String? startTime,
    required Map<String, dynamic> workout, // Pass the workout map here
  }) {
    return InkWell(
      onTap: () {
        if (type == 'ONLINE') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonView(workout: workout),
            ),
          );
        }
      },
      child: Padding(
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
      ),
    );
  }
}
