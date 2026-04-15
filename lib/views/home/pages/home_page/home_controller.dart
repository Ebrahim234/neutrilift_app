import 'dart:async';
import 'package:dio/dio.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../details.dart';

class HomeController {
  final dio = ApiHelper.createDio();
  StreamSubscription<StepCount>? stepCountStream;

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print("TOKEN: $token");

    try {
      final response = await dio.get(
        "/",
        options: Options(
          followRedirects: false,
          // ✅ شيل validateStatus أو خليها تعدي 401 للـ interceptor
          validateStatus: (status) => status == 302 || status == 200,
        ),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE DATA: ${response.data}");

      if (response.statusCode == 302) {
        goTo(DetailsView());
      }

    } on DioException catch (e) {
      print("ERROR STATUS: ${e.response?.statusCode}");
      print("ERROR DATA: ${e.response?.data}");
    }
  }

  Future<bool> requestPermission() async {
    final statuses = await [
      Permission.activityRecognition,
      Permission.sensors,
    ].request();
    return statuses[Permission.activityRecognition]?.isGranted ?? false;
  }

  void startStepCounting({
    required Function(int steps) onStep,
    required Function() onError,
  }) {
    stepCountStream = Pedometer.stepCountStream.listen(
          (event) => onStep(event.steps),
      onError: (_) => onError(),
      cancelOnError: false,
    );
  }

  void dispose() {
    stepCountStream?.cancel();
  }
}