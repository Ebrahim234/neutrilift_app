import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/logic/api_helper.dart';
import '../../../../core/logic/helper_method.dart';
import '../../../../core/ui/app_image.dart';

class ExerciseDetailSheet extends StatefulWidget {
  final int exerciseId;
  const ExerciseDetailSheet({super.key, required this.exerciseId});

  @override
  State<ExerciseDetailSheet> createState() => _ExerciseDetailSheetState();
}

class _ExerciseDetailSheetState extends State<ExerciseDetailSheet> {
  final Dio dio = ApiHelper.createDio();
  bool isLoading = true;
  Map<String, dynamic>? exerciseData;

  @override
  void initState() {
    super.initState();
    _fetchExerciseDetails();
  }

  Future<void> _fetchExerciseDetails() async {
    try {
      final response = await dio.get('/api/exercises/${widget.exerciseId}/');
      if (response.statusCode == 200) {
        setState(() {
          exerciseData = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("🔴 FETCH ERROR => $e");
      showMsg('Failed to load exercise details', isError: true);
    }
  }

  Future<void> _playVideo(String urlString) async {
    String fixedUrl = urlString.trim();
    if (fixedUrl.isEmpty) {
      showMsg("No video available", isError: true);
      return;
    }

    // إضافة الـ Protocol تلقائياً إن لم يوجد
    if (!fixedUrl.toLowerCase().startsWith("http")) {
      fixedUrl = "https://$fixedUrl";
    }

    final Uri uri = Uri.parse(fixedUrl);
    print("🎬 VIDEO URL => $uri");

    try {
      // 🚀 الاستراتيجية الأولى: التشغيل الافتراضي للنظام (يفتح تطبيق اليوتيوب إن وجد)
      bool launched = await launchUrl(uri, mode: LaunchMode.platformDefault);

      if (!launched) {
        // الاستراتيجية الثانية: الإجبار كـ تطبيق خارجي
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      if (launched) {
        // إذا نجح الفتح، نغلق الـ BottomSheet بعد تأخير بسيط لتأمين الـ Context
        if (mounted) Navigator.pop(context);
      } else {
        // الاستراتيجية الثالثة (خطة الطوارئ): الفتح داخل الأبليكيشن كـ WebView
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      print("🔴 VIDEO ERROR => $e");
      // الـ Fallback الأخير لو رفض النظام الخروج تماماً
      try {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
        if (mounted) Navigator.pop(context);
      } catch (innerError) {
        showMsg("Error opening video", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. شاشة التحميل (Loading State)
    if (isLoading) {
      return Container(
        height: 400.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // 2. شاشة الخطأ (Error State)
    if (exerciseData == null) {
      return Container(
        height: 200.h,
        color: Colors.white,
        child: const Center(child: Text("Failed to load details")),
      );
    }

    // 3. استخراج البيانات وفك الهيكلة
    String name = exerciseData!['name'] ?? 'Unknown';
    String muscle = (exerciseData!['muscles'] as List).isNotEmpty
        ? exerciseData!['muscles'][0]['muscle']
        : 'General';
    List<String> instructions = (exerciseData!['description'] ?? '').split('\n');

    String rawImageUrl = exerciseData!['image'] ?? '';
    String fullImageUrl = rawImageUrl.startsWith('http')
        ? rawImageUrl
        : '${ApiHelper.baseUrl}$rawImageUrl';

    String videoLink = exerciseData!['video_link'] ?? '';

    // 4. عرض الواجهة الرئيسية بعد التصفية
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================
          // HEADER (الاسم والزرار)
          // ======================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xff0D1B2A)),
                  ),
                  Text(
                    muscle,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.grey),
                style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ======================
          // IMAGE + PLAY BUTTON
          // ======================
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppImage(
                  image: fullImageUrl,
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200.h,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 65),
                  onPressed: () => _playVideo(videoLink),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // ======================
          // INSTRUCTIONS
          // ======================
          Text(
            "Instructions",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          ...instructions.map((inst) {
            if (inst.trim().isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ", style: TextStyle(fontSize: 16.sp, color: Colors.black)),
                  Expanded(
                    child: Text(
                      inst.trim(),
                      style: TextStyle(fontSize: 14.sp, color: const Color(0xff0D1B2A)),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}