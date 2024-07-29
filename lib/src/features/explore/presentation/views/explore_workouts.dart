import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/shared/shared.dart';

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
  int currentPage = 0;
  final int pageSize = 5;
  bool hasMore = true;
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
        final response = await apiService.getAllTrainingProgram(currentPage, selectedType, queryParams);
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
      _getWorkouts(); // Fetch new data
    });
  }

  void _filterWorkouts() {
    final query = _searchController.text;
    setState(() {
      filteredWorkouts = workouts.where((workout) {
        final title = workout['title'].toLowerCase();
        return title.contains(query.toLowerCase());
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
                      child: Text(
                        isSearching ? 'Cancel' : 'Search',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    _buildLevelButton('Online', 'ONLINE'),
                    _buildLevelButton('Offline', 'OFFLINE'),
                  ],
                ),
                YBox(20.dy),
                if (filteredWorkouts.isEmpty && !isLoading)
                  const Center(child: Text('No workouts available'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredWorkouts.length + (hasMore && !isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == filteredWorkouts.length) {
                        // Show loading indicator if there are more items to load
                        print('length: $filteredWorkouts.length');
                        return const Center(child: CircularProgressIndicator());
                      }
                      final workout = filteredWorkouts[index];
                      return Column(
                        children: [
                          SparkleContainer(
                            height: 148.dy,
                            isBgWhite: index % 3 == 1,
                            decoration: BoxDecoration(
                              color: index % 3 == 0 ? appColors.black : index % 3 == 1 ? appColors.white : appColors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: workoutContContent(
                              topText: workout['title'].toUpperCase(),
                              bottomText: workout['description'],
                              type: workout['type'],
                              isBgWhite: index % 3 == 1,
                            ),
                          ),
                          if (index < filteredWorkouts.length - 1) YBox(15.dy),
                        ],
                      );
                    },
                  ),
                if (isLoadingMore)
                  const Center(child: CircularProgressIndicator()),
                YBox(30.dy),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(String text, String type) {
    bool isSelected = selectedType == type;
    return ElevatedButton(
      onPressed: () => _onTypeSelected(type),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? appColors.white : appColors.black, backgroundColor: isSelected ? appColors.black : appColors.white,
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

  Widget workoutContContent({
    bool isBgWhite = false,
    required String? topText,
    required String? type,
    required String? bottomText,
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
                      text: type ?? 'TYPE',
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
                width: 150.dx, // Adjust the width as needed
                child: Text(
                  '$bottomText',
                  maxLines: 3,
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
}