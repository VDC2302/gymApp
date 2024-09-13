import 'package:gymApp/src/shared/shared.dart';
import 'package:gymApp/src/features/navigation/routes.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymApp/src/shared/utils/utils.dart';

class ProfileView extends HookWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(true);
    final errorMessage = useState<String?>(null);
    final profileData = useState<Map<String, dynamic>?>(null);

    useEffect(() {
      Future<void> getProfile() async {
        ApiService apiService = ApiService();
        try {
          final data = await apiService.getProfile();
          profileData.value = data;
        } catch (e) {
          errorMessage.value = 'Failed to load profile: $e';
        } finally {
          isLoading.value = false;
        }
      }
      getProfile();
      return null;
    });

    return Scaffold(
      backgroundColor: appColors.lightGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAppBar(),
          Expanded(
            child: isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.value != null
                ? Center(child: Text(errorMessage.value!, style: const TextStyle(color: Colors.red)))
                : profileData.value != null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProfilePicture(profileData.value!),
                _buildProfileDetails(profileData.value!),
                _buildLogoutButton(context),
              ],
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProfilePicture({}),
                _buildProfileDetails({}),
                _buildLogoutButton(context),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 122.dy,
      width: double.infinity,
      color: appColors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.dx),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YBox(27.dy),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgAsset(assetName: drawerIcon),
                Text(
                  'Profile',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgAsset(
                  assetName: drawerIcon,
                  color: Colors.transparent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture(Map<String, dynamic> data) {
    String? pictureName = data['profilePicture'];
    return Container(
      margin: EdgeInsets.only(top: 20.dy),
      height: 130.dy,
      width: 130.dy,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: appColors.white,
        image: DecorationImage(
          image: AssetImage('assets/pngs/$pictureName.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileDetails(Map<String, dynamic>? data) {
    final firstName = data?['firstName'] ?? 'Admin';
    final lastName = data?['lastName'] ?? 'N/A';
    final gender = data?['gender'] ?? 'N/A';
    final birthYear = data?['birthYear'] ?? 'N/A';
    final height = data?['height'] ?? 'N/A';
    final weight = data?['weight'] ?? 'N/A';
    final activity = data?['activity'] ?? 'N/A';

    return Container(
      padding: EdgeInsets.all(15.dx),
      width: double.infinity,
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'First Name: $firstName',
            style: GoogleFonts.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.grey33,
            ),
          ),
          SizedBox(height: 5.dy), // Add spacing
          Divider(color: appColors.grey.withOpacity(0.3)),
          SizedBox(height: 5.dy), // Add spacing
          Text(
            'Last Name:  $lastName',
            style: GoogleFonts.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.grey33,
            ),
          ),
          SizedBox(height: 5.dy), // Add spacing
          Divider(color: appColors.grey.withOpacity(0.3)),
          SizedBox(height: 5.dy), // Add spacing
          Text(
            'Gender: $gender',
            style: GoogleFonts.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.grey33,
            ),
          ),
          SizedBox(height: 5.dy),
          Divider(color: appColors.grey.withOpacity(0.3)),
          SizedBox(height: 5.dy), // Add spacing
          Text(
            'Birth Year: $birthYear',
            style: GoogleFonts.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.grey33,
            ),
          ),
          SizedBox(height: 5.dy),
          Divider(color: appColors.grey.withOpacity(0.3)),
          SizedBox(height: 5.dy), // Add spacing
          Text(
            'Height: $height cm',
            style: GoogleFonts.lato(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: appColors.grey33,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.dx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => _editTarget(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.yellow, // Set a different button color
              padding: EdgeInsets.symmetric(vertical: 15.dy, horizontal: 30.dx),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: appColors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _logout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.yellow, // Set the button color
              padding: EdgeInsets.symmetric(vertical: 15.dy, horizontal: 30.dx),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: appColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editTarget(BuildContext context) {
    Navigator.pushNamed(context, AuthRoutes.onboarding);
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await ApiService().logout();
              Navigator.pushNamedAndRemoveUntil(context, AuthRoutes.loginOrSignUp, (Route<dynamic> route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.yellow,
            ),
            child: Text(
              'Logout', style: TextStyle(color: appColors.white),
            ),
          ),
        ],
      ),
    );
  }
}