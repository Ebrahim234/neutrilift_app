import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'counter_widget.dart';

class WeekCalorieCard extends StatefulWidget {
  final int weekNumber;
  final TextEditingController calorieController;
  final bool showCopyButton;
  final int maxApply;
  final void Function(int applyCount) onApply;

  const WeekCalorieCard({
    super.key,
    required this.weekNumber,
    required this.calorieController,
    required this.showCopyButton,
    required this.maxApply,
    required this.onApply,
  });

  @override
  State<WeekCalorieCard> createState() => _WeekCalorieCardState();
}

class _WeekCalorieCardState extends State<WeekCalorieCard> {
  bool _isExpanded = false;
  int _applyToCount = 1;

  @override
  void initState() {
    super.initState();
    _applyToCount = widget.maxApply > 0 ? widget.maxApply : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Main row ─────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                // week label — بيظهر دايماً
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Week ${widget.weekNumber}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      'Enter calorie target',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // ✅ copy + input + kcal في Row واحد
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.showCopyButton)
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isExpanded = !_isExpanded),
                        child: Container(
                          margin: EdgeInsetsDirectional.only(end: 8.w),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _isExpanded
                                ? const Color(0xff173272)
                                : const Color(0xffF3F4F6),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.copy_rounded,
                            size: 18.sp,
                            color: _isExpanded
                                ? Colors.white
                                : const Color(0xff173272),
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 80.w,
                      height: 40.h,
                      child: TextField(
                        controller: widget.calorieController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 8.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide:
                            const BorderSide(color: Color(0xffE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide:
                            const BorderSide(color: Color(0xffE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide:
                            const BorderSide(color: Color(0xff173272)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'kcal',
                      style:
                      TextStyle(color: Colors.grey, fontSize: 13.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Expanded section — تحت الـ main row مباشرةً ──────
          if (_isExpanded && widget.showCopyButton) ...[
            Divider(height: 1, color: Colors.grey.shade100),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: widget.calorieController,
                    builder: (_, value, __) => Text(
                      'Apply ${value.text} kcal to next:',
                      style: TextStyle(
                        color: const Color(0xff173272),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      CounterWidget(
                        value: _applyToCount,
                        min: 1,
                        max: widget.maxApply,
                        onChanged: (v) =>
                            setState(() => _applyToCount = v),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Weeks',
                        style: TextStyle(
                            fontSize: 13.sp, color: Colors.grey),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          widget.onApply(_applyToCount);
                          setState(() => _isExpanded = false);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xff173272),
                          minimumSize: Size(80.w, 38.h), // ✅ width + height صريحين
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

