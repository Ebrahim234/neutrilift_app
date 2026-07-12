import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'profile/profile_view.dart';
import 'preferences/preferences_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold, color: const Color(0xff111827)),
                  ),
                  IconButton(
                    onPressed: () {
                      // لدالة الـ Logout لاحقاً
                    },
                    icon: Icon(Icons.logout, color: const Color(0xff173272), size: 28.sp),
                  )
                ],
              ),
              SizedBox(height: 24.h),

              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'Edit personal info',
                subtitle: 'Update your profile',
                onTap: () => goTo(const ProfileView()),
              ),
              SizedBox(height: 16.h),

              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: 'App preferences',
                subtitle: 'Units and reminders settings',
                onTap: () => goTo(const PreferencesView()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(color: const Color(0xff173272), borderRadius: BorderRadius.circular(12.r)),
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xff111827))),
                  SizedBox(height: 4.h),
                  Text(subtitle, style: TextStyle(fontSize: 13.sp, color: Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18.sp),
          ],
        ),
      ),
    );
  }
}