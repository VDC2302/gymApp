import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/shared/theme/app_theme.dart';
import 'package:gymApp/src/shared/utils/utils.dart';

class ProfileView extends HookWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final switchVal = useState<bool>(false);
    final isLoading = useState(true);
    final errorMessage = useState<String?>(null);
    final profileData = useState<Map<String, dynamic>?>(null);

    useEffect((){
      Future<void> getProfile() async{
        ApiService apiService = ApiService();
        try{
          final data = await apiService.getProfile();
          profileData.value = data;
        }catch(e){
          errorMessage.value = 'Failed to load profile: $e';
        }finally{
          isLoading.value = false;
        }
      }
      getProfile();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: appColors.lightGrey,
      body: Column(
        children: [
          _buildAppBar(),
          isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.value != null
              ? Center(child: Text(errorMessage.value!, style: const TextStyle(color: Colors.red)))
              : profileData.value != null
              ? Column(
                children:[
                  _buildProfileContainer(profileData.value!),
                  _buildLogoutButton(context),
                ],
              )
              : const Center(child: Text('Profile data not available')),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.dx),
      child: ElevatedButton(
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
    );
  }

  void _logout(BuildContext context) {

    // Perform logout actions here, such as clearing user data, redirecting to login screen, etc.
    // For demonstration, we'll just show a dialog
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
            onPressed: () async{
              Navigator.of(context).pop(); // Close the dialog
              await ApiService().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.yellow,
            ),
            child: const Text(
                'Logout',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContainer(Map<String, dynamic> data) {
    return Container(
      height: 100.dy,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.dx, vertical: 10.dx),
      padding: EdgeInsets.symmetric(horizontal: 15.dx),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          children: [
            Container(
              height: 42.dy,
              width: 42.dy,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appColors.grey,
              ),
            ),
            XBox(8.dx),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data['firstName']} ${data['lastName']}',
                  style: GoogleFonts.lato(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: appColors.grey33,
                  ),
                ),
                Text(
                  '${data['gender']}',
                  style: GoogleFonts.lato(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: appColors.grey.withOpacity(.5),
                  ),
                ),
                Text(
                  '01/01/2002',
                  style: GoogleFonts.lato(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: appColors.grey.withOpacity(.5),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStartAlignedText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 13.dy).copyWith(left: 25.dx),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
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
}

class SettingsTile extends StatelessWidget {
  final String title, leadingIcon;
  final Widget? trailingIcon;
  final VoidCallback? onTap;
  const SettingsTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    this.trailingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 15.dx).copyWith(bottom: 15.dy),
      height: 79.dy,
      child: ListTile(
        onTap: onTap,
        leading: SvgAsset(assetName: leadingIcon),
        titleAlignment: ListTileTitleAlignment.center,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.dx),
        tileColor: appColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.dy)
              .copyWith(left: leadingIcon == watchIcon ? 0 : 10.dx),
          child: AppText(
            isStartAligned: true,
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailingIcon != null
            ? trailingIcon!
            : SvgAsset(assetName: arrowRight),
      ),
    );
  }


}
