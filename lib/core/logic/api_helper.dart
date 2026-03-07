import 'package:dio/dio.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static const baseUrl = "https://squiggly-cheery-newton.ngrok-free.dev/";

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        // ✅ بيبعت الـ access token تلقائياً مع كل request
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token =
              prefs.getString('access_token') ?? LoginView.tempAccessToken;

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },

        // ✅ بيمسك الـ 401 ويعمل token refresh تلقائي
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refresh_token') ??
                LoginView.tempRefreshToken;

            if (refreshToken == null) {
              goTo(LoginView());
              return;
            }

            try {
              final resp = await Dio(
                BaseOptions(
                  baseUrl: baseUrl,
                  headers: {"Content-Type": "application/json"},
                ),
              ).post("api/token/refresh/", data: {"refresh": refreshToken});

              final newAccess = resp.data['access'];
              final newRefresh = resp.data['refresh'];

              // احفظ الـ tokens الجدد
              if (prefs.getString('access_token') != null) {
                await prefs.setString('access_token', newAccess);
                await prefs.setString('refresh_token', newRefresh);
              } else {
                LoginView.tempAccessToken = newAccess;
                LoginView.tempRefreshToken = newRefresh;
              }

              error.requestOptions.headers['Authorization'] =
              'Bearer $newAccess';
              handler.resolve(await dio.fetch(error.requestOptions));
            } catch (e) {
              goTo(LoginView());
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );

    return dio;
  }
}