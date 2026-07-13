import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:neutrilift/core/logic/api_helper.dart';
import 'package:neutrilift/core/logic/helper_method.dart';
import 'package:neutrilift/views/home/pages/home_page/barcode_feature/scanner_details.dart';

class FoodScannerWidget extends StatefulWidget {
  const FoodScannerWidget({super.key});

  @override
  State<FoodScannerWidget> createState() => _FoodScannerWidgetState();
}

class _FoodScannerWidgetState extends State<FoodScannerWidget> {
  final Dio dio = ApiHelper.createDio();
  bool isLoading = false;


  Future<void> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isEmpty) return;

      String barcodeScanRes = result.rawContent;

      setState(() => isLoading = true);

      final response = await dio.get('/api/scanner/?barcode=$barcodeScanRes');

      if (response.statusCode == 200) {
        final data = response.data;
        print("✅ Nutrition Data: $data");
        goTo(ScannerDetailsView(nutritionData: data), canPop: true);
      }
    } on DioException catch (e) {
      showMsg("Product not found or network error", isError: true);
      print("🔴 Dio Error: ${e.response?.data}");
    } catch (e) {
      showMsg("An unexpected error occurred", isError: true);
      print("🔴 Unexpected Error: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xff1A2D6B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.crop_free, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Food Scanner",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1A2D6B),
                    ),
                  ),
                  Text(
                    "AI-powered nutrition analysis",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Scan your food barcode to calculate nutrition",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _scanBarcode,
              icon: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: Text(isLoading ? "Scanning..." : "Scan Barcode", style: const TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1A2D6B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}