import 'package:flutter/material.dart';
import 'package:neutrilift/core/ui/app_image.dart';
import 'package:neutrilift/views/logging/view.dart';
import 'home_page/view.dart';

import 'package:neutrilift/views/plan/create_plan/create_plan_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _NewHomeViewState();
}

class _NewHomeViewState extends State<HomeView> {
  final list = [
    _Model(icon: "home.svg", view: const HomePageView(), label: "Home"),
    _Model(icon: "plans.svg", view: CreatePlanView(), label: "Plans"),
    _Model(icon: "log.svg", view: const LoggingView(), label: "Log"),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(color: Color(0xffD9D9D9)),
        child: BottomNavigationBar(
          onTap: (value) {
            currentIndex = value;
            setState(() {});
          },
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: List.generate(
            list.length,
                (index) => BottomNavigationBarItem(
              label: "",
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppImage(
                    image: list[index].icon,
                    color: currentIndex == index ? const Color(0xff0D1F49) : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    list[index].label,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: currentIndex == index
                          ? const Color(0xff0D1F49)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: list[currentIndex].view,
    );
  }
}

class _Model {
  final String icon;
  final Widget view;
  final String label;

  _Model({required this.icon, required this.view, required this.label});
}