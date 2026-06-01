import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neutrilift/models/routine_model.dart';

class LoadPresetSheet extends StatelessWidget {
  final List<RoutineModel> routines;
  final ValueChanged<RoutineModel> onLoad;

  const LoadPresetSheet({
    super.key,
    required this.routines,
    required this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Load Preset',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Choose a saved workout preset to load',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 16.h),

            if (routines.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: Text(
                    'No routines saved yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              )
            else
              ...routines.map(
                    (r) => Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: const Color(0xffE5E7EB)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        r.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
    FilledButton(
    onPressed: () {
    Navigator.pop(context);
    onLoad(r);
    },
    style: FilledButton.styleFrom(
    backgroundColor: const Color(0xff173272),
    minimumSize: Size(80.w, 38.h),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.r),
    ),
    padding: EdgeInsets.symmetric(
    horizontal: 20.w,
    vertical: 10.h,
    ),
    ),
    child: const Text('Load'),
    ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 4.h),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xffE5E7EB)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}