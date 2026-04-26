import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FoodScannerWidget extends StatelessWidget {
  const FoodScannerWidget({super.key});

  Future<void> _openCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (photo != null) {
      print("الصورة في: ${photo.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الأيقونة والنص
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xff1A2D6B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.crop_free,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Column(
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

          SizedBox(height: 12),

          Text(
            "Scan your food to calculate nutrition",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),

          SizedBox(height: 12),

          // الزرار
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openCamera(context),
              icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
              label: Text("Open Camera", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff1A2D6B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}