import 'package:dio/dio.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/authentication/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static const baseUrl = "https://squiggly-cheery-newton.ngrok-free.dev";

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
        onRequest: (options, handler) async {
          // ✅ متحطش token بس في login و signup
          final isAuthRequest =
              options.path.contains('/api/token/') ||
                  options.path.contains('/api/register/') ||
                  options.path.contains('/api/login/');
          if (!isAuthRequest) {
            final prefs = await SharedPreferences.getInstance();
            final token =
                prefs.getString('access_token') ?? LoginView.tempAccessToken;

            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },

        onError: (error, handler) async {
          print("🔴 INTERCEPTOR HIT: ${error.response?.statusCode}");
          print("🔴 CODE: ${error.response?.data?['code']}");

          if (error.response?.statusCode == 401) {
            final responseData = error.response?.data;

            if (responseData is Map &&
                responseData['code'] == 'not_authenticated') {
              print("🔴 NOT AUTHENTICATED → goTo Login");
              goTo(LoginView());
              return;
            }

            if (responseData is Map &&
                responseData['code'] == 'token_not_valid') {
              print("🟡 TOKEN EXPIRED → trying refresh");

              final isRefreshRequest = error.requestOptions.path
                  .contains('api/token/refresh/');
              if (isRefreshRequest) {
                print("🔴 REFRESH FAILED → goTo Login");
                goTo(LoginView());
                return;
              }

              final prefs = await SharedPreferences.getInstance();
              final refreshToken = prefs.getString('refresh_token') ??
                  LoginView.tempRefreshToken;
              print("🟡 REFRESH TOKEN: $refreshToken");

              if (refreshToken == null) {
                print("🔴 NO REFRESH TOKEN → goTo Login");
                goTo(LoginView());
                return;
              }

              try {
                print("🟡 CALLING REFRESH ENDPOINT...");
                final refreshResponse = await Dio(
                  BaseOptions(
                    baseUrl: baseUrl,
                    headers: {
                      "Content-Type": "application/json",
                      "ngrok-skip-browser-warning": "true",
                    },
                  ),
                ).post(
                  "/api/token/refresh/",
                  data: {"refresh": refreshToken},
                );

                print("✅ REFRESH SUCCESS: ${refreshResponse.data}");

                final newAccess = refreshResponse.data['access'];
                final newRefresh = refreshResponse.data['refresh'];

                if (prefs.getString('access_token') != null) {
                  await prefs.setString('access_token', newAccess);
                  await prefs.setString('refresh_token', newRefresh);
                } else {
                  LoginView.tempAccessToken = newAccess;
                  LoginView.tempRefreshToken = newRefresh;
                }

                error.requestOptions.headers['Authorization'] =
                'Bearer $newAccess';
                print("✅ RETRYING ORIGINAL REQUEST...");
                handler.resolve(await dio.fetch(error.requestOptions));
              } catch (e) {
                print("🔴 REFRESH EXCEPTION: $e");
                goTo(LoginView());
              }
              return;
            }
          }

          handler.next(error);
        },
      ),
    );

    return dio;
  }
}