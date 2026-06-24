
import 'package:health/health.dart';

class HealthService {
  // إنشاء نسخة مفردة (Singleton) من الـ package
  final Health _health = Health();

  // تحديد أنواع البيانات المطلوبة: الخطوات ونبضات القلب
  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
  ];

  // دالة طلب الصلاحيات من اليوزر أوتوماتيكياً
  // دالة طلب الصلاحيات من اليوزر أوتوماتيكياً
  Future<bool> requestPermissions() async {
    try {
      // 🚀 تم التعديل هنا لـ HealthDataAccess بدلاً من الـ enum القديم
      bool? hasPermissions = await _health.hasPermissions(_types, permissions: [
        HealthDataAccess.READ,
        HealthDataAccess.READ,
      ]);

      if (hasPermissions == false || hasPermissions == null) {
        // إذا لم يكن لديه صلاحية، نطلبها منه الآن
        return await _health.requestAuthorization(_types, permissions: [
          HealthDataAccess.READ,
          HealthDataAccess.READ,
        ]);
      }
      return true;
    } catch (e) {
      print("🔴 Health SDK Authorization Error: $e");
      return false;
    }
  }

  // 🏃‍♂️ جلب إجمالي خطوات اليوم الحالي (من الساعة 12 منتصف الليل حتى اللحظة الحالية)
  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      bool authorized = await requestPermissions();
      if (!authorized) return 0;

      // جلب مجموع الخطوات في هذه الفترة الزمنية
      int? steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e) {
      print("🔴 Error fetching steps from Health SDK: $e");
      return 0;
    }
  }

  // ❤️ جلب آخر قراءة مسجلة لنبضات القلب (خلال آخر 24 ساعة)
  Future<int> getLatestHeartRate() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    try {
      bool authorized = await requestPermissions();
      if (!authorized) return 72; // Fallback الافتراضي في حالة عدم وجود صلاحية

      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: yesterday,
        endTime: now,
      );
      if (healthData.isNotEmpty) {
        // 🚀 تم التعديل هنا لـ dateTo بدلاً من dateEndTime المتغيرة في التحديث الجديد
        healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

        // استخراج القيمة العددية لآخر نبض مسجل
        NumericHealthValue value = healthData.first.value as NumericHealthValue;
        return value.numericValue.toInt();
      }
      return 72; // قراءة افتراضية شيك لو السيرفر أو الجهاز معندوش نبضات مسجلة قريب
    } catch (e) {
      print("🔴 Error fetching heart rate from Health SDK: $e");
      return 72;
    }
  }
}