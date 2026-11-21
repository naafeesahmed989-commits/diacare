import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0; // 0 = Home, 1, 2, 3 = the other tabs

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFDFF3FC), Color(0xFFFBFEFF)],
                  ),
                ),
              ),
            ),

            // The pages. IndexedStack shows one and keeps the others alive,
            // so the Home page keeps its scroll position when you come back.
            Positioned.fill(
              child: IndexedStack(
                index: _tab,
                children: const [
                  _HomeTab(),
                  _ComingSoon(name: 'Insights'), 
                  _ComingSoon(name: 'Schedule'),
                  _ComingSoon(name: 'Profile'), 
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: math.max(28.0, bottomInset + 8),
              child: HomeBottomNav(
                selectedIndex: _tab,
                onSelected: (index) => setState(() => _tab = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// What the other three tabs show until we build them.
class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$name (coming soon)',
        style: GoogleFonts.poppins(fontSize: 16, color: homeGray),
      ),
    );
  }
}


class _HomeTab extends StatelessWidget {
  const _HomeTab();

  // The buttons are not connected yet. They show a short message.
  void _soon(BuildContext context, String what) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$what is coming soon'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        math.max(62.0, topInset + 14),
        16,
        100 + bottomInset,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/avatar.png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  // If the photo is not in the project yet, show a gray circle.
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    color: const Color(0xFFD9D9D9),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: homeGray,
                      ),
                    ),
                    Text(
                      'Nafisa Ahmed', 
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: homeInk,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _soon(context, 'Notifications'),
                child: const Icon(
                  Icons.notifications_none,
                  size: 28,
                  color: homeInk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Section 1: blood sugar readings.
          const SectionHeader(
            title: 'Blood sugar readings',
            trailing: '2 recent entries',
          ),
          const SizedBox(height: 6),
          
          const BloodSugarCard(
            value: '120',
            updated: 'Last update: Today: 8:30 AM',
            statusLabel: 'Normal',
            statusBackground: Color(0xFFD6F5C2),
            statusColor: Color(0xFF3A7D1E),
          ),
          const SizedBox(height: 9),
          const BloodSugarCard(
            value: '120',
            updated: 'Last update: Today: 8:30 AM',
            statusLabel: 'Low',
            statusBackground: Color(0xFFFFE0E0),
            statusColor: Color(0xFFD32F2F),
          ),
          const SizedBox(height: 23),

          // Section 2: next medication.
          const SectionHeader(
            title: 'Next medication',
            trailing: 'Today · 9 PM',
          ),
          const SizedBox(height: 10),
          MedicationCard(
            name: 'Insulin',
            time: 'Today · 9 PM',
            onTaken: () => _soon(context, 'Marking as taken'),
            onMissed: () => _soon(context, 'Marking as missed'),
          ),
          const SizedBox(height: 6),

          // Section 3: quick actions
          const SectionHeader(
            title: 'Quick actions',
            trailing: '4 shortcuts',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  title: 'Add Reading',
                  subtitle: 'Blood Pressure',
                  onTap: () => _soon(context, 'Add Reading'),
                  bottom: Row(
                    children: [
                      const AssetIcon(
                        asset: 'assets/images/ic_glucose.png',
                        fallback: Icons.water_drop_outlined,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F1F1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: QuickActionCard(
                  title: 'Reminders',
                  subtitle: 'Check status',
                  onTap: () => _soon(context, 'Reminders'),
                  bottom: const AssetIcon(
                    asset: 'assets/images/ic_chart.png',
                    fallback: Icons.bar_chart_rounded,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  title: 'Food Guide',
                  subtitle: 'Healthy Habits',
                  onTap: () => _soon(context, 'Food Guide'),
                  bottom: const AssetIcon(
                    asset: 'assets/images/ic_food.png',
                    fallback: Icons.restaurant_outlined,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: QuickActionCard(
                  title: 'Your History',
                  onTap: () => _soon(context, 'Your History'),
                  bottom: const AssetIcon(
                    asset: 'assets/images/ic_chart.png',
                    fallback: Icons.bar_chart_rounded,
                    size: 26,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}