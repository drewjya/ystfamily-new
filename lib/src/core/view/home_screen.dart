// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ystfamily/src/core/config/color.dart';
import 'package:ystfamily/src/core/routes/router.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({
    super.key,
    required this.child,
  });
  final Widget child;

  int getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.contains(HomePageRoute.routeName)) {
      return 0;
    }
    if (location.contains(HistoryPageRoute.routeName)) {
      return 1;
    }

    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currIndex = getCurrentIndex(context);
    return Container(
      color: VColor.appbarBackground,
      child: Scaffold(
        appBar: currIndex == 0
            ? AppBar(
                elevation: 0,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                backgroundColor: VColor.appbarBackground,
                foregroundColor: VColor.darkBrown,
                centerTitle: true,
                title: const TitleWidget(),
                actions: [
                  IconButton(
                    onPressed: () {
                      const NotificationPageRoute().push(context);
                    },
                    icon: const Icon(
                      Icons.notifications,
                    ),
                  ),
                ],
              )
            : AppBar(
                centerTitle: true,
                title: Text(
                  currIndex == 1 ? "Riwayat" : "Profil",
                ),
                backgroundColor: VColor.appbarBackground,
                surfaceTintColor: Colors.transparent,
              ),
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: VColor.primaryBackground,
          currentIndex: currIndex,
          onTap: (value) {
            switch (value) {
              case 0:
                const HomePageRoute().go(context);
                break;
              case 1:
                const HistoryPageRoute().go(context);
                break;
              case 2:
                const ProfilePageRoute().go(context);
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currIndex == 0 ? VColor.primaryTextColor : null,
                  ),
                  child: Icon(
                    Icons.home_filled,
                    color: currIndex == 0 ? VColor.primaryBackground : null,
                  ),
                ),
                label: "Beranda"),
            BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currIndex == 1 ? VColor.primaryTextColor : null,
                  ),
                  child: Icon(
                    Icons.calendar_month,
                    color: currIndex == 1 ? VColor.primaryBackground : null,
                  ),
                ),
                label: "Riwayat"),
            BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currIndex == 2 ? VColor.primaryTextColor : null,
                  ),
                  child: Icon(
                    Icons.person,
                    color: currIndex == 2 ? VColor.primaryBackground : null,
                  ),
                ),
                label: "Profil"),
          ],
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "YANG SHEN TANG",
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        Text(
          "FAMILY REFLEXOLOGY",
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
