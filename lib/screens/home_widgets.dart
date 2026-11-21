import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors used on the Home screen. 
const homeInk = Color(0xFF111111); // main text
const homeGray = Color(0xFF6E6E6E); // small gray text
const homeBlue = Color(0xFF1E40D8); // active tab

/// A white rounded card with a very soft shadow.
BoxDecoration homeCardDecoration({double radius = 20}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: const [
      BoxShadow(
        color: Color(0x14000000), 
        blurRadius: 12,
        offset: Offset(0, 3),
      ),
    ],
  );
}

/// it shows a similar Material icon instead, so nothing breaks.
class AssetIcon extends StatelessWidget {
  const AssetIcon({
    super.key,
    required this.asset,
    required this.fallback,
    this.size = 24,
    this.color,
  });

  final String asset;
  final IconData fallback;
  final double size;

  /// If given, paints the icon in this color (good for one-color icons).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          Icon(fallback, size: size, color: color ?? Colors.black),
    );
  }
}

/// A section title on the left and a small gray text on the right
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: homeInk,
          ),
        ),
        Text(
          trailing,
          style: GoogleFonts.poppins(fontSize: 12, color: homeGray),
        ),
      ],
    );
  }
}


class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.background,
    required this.color,
  });

  final String label;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: GoogleFonts.poppins(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}

/// One blood sugar reading card.
class BloodSugarCard extends StatelessWidget {
  const BloodSugarCard({
    super.key,
    required this.value,
    required this.updated,
    required this.statusLabel,
    required this.statusBackground,
    required this.statusColor,
  });

  final String value;
  final String updated;
  final String statusLabel;
  final Color statusBackground;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: homeCardDecoration(),
      padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFA9F3EE), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: const AssetIcon(
              asset: 'assets/images/ic_glucose.png',
              fallback: Icons.water_drop_outlined,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest blood sugar',
                  style: GoogleFonts.poppins(fontSize: 12, color: homeGray),
                ),
                // "120", "mg/dL", on the same line.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: homeInk,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'mg/dL',
                      style: GoogleFonts.poppins(fontSize: 16, color: homeGray),
                    ),
                  ],
                ),
                Text(
                  updated,
                  style: GoogleFonts.poppins(fontSize: 12, color: homeInk),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13),
            child: StatusChip(
              label: statusLabel,
              background: statusBackground,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Next medication" card, with the Taken and Missed buttons.
class MedicationCard extends StatelessWidget {
  const MedicationCard({
    super.key,
    required this.name,
    required this.time,
    required this.onTaken,
    required this.onMissed,
  });

  final String name;
  final String time;
  final VoidCallback onTaken;
  final VoidCallback onMissed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: homeCardDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: const AssetIcon(
              asset: 'assets/images/ic_medication.png',
              fallback: Icons.medication_outlined,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next medication',
                  style: GoogleFonts.poppins(fontSize: 13, color: homeGray),
                ),
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: homeInk,
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.poppins(fontSize: 13, color: homeGray),
                ),
              ],
            ),
          ),
          _ActionChip(
            label: 'Taken',
            background: const Color(0xFFE3F6F8),
            color: const Color(0xFF0B7A75),
            onTap: onTaken,
          ),
          const SizedBox(width: 7),
          _ActionChip(
            label: 'Missed',
            background: const Color(0xFFFFDEDE),
            color: const Color(0xFFD32F2F),
            onTap: onMissed,
          ),
        ],
      ),
    );
  }
}

// A tappable pill (Taken / Missed).
class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.label,
    required this.background,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// One of the four shortcut cards
class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.title,
    required this.bottom,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  /// What is shown at the bottom of the card 
  final Widget bottom;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 105,
        padding: const EdgeInsets.all(16),
        decoration: homeCardDecoration(radius: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: homeInk,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: GoogleFonts.poppins(fontSize: 13, color: homeGray),
                  ),
              ],
            ),
            bottom,
          ],
        ),
      ),
    );
  }
}

/// The floating bar with four tabs at the bottom of the Home screen.
class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE3EDF5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tab(0, (c) => Icon(Icons.home_outlined, size: 28, color: c)),
          _tab(
            1,
            (c) => AssetIcon(
              asset: 'assets/images/ic_chart.png',
              fallback: Icons.bar_chart_rounded,
              size: 28,
              color: c,
            ),
          ),
          _tab(
            2,
            (c) => AssetIcon(
              asset: 'assets/images/ic_calendar.png',
              fallback: Icons.edit_calendar_outlined,
              size: 28,
              color: c,
            ),
          ),
          _tab(3, (c) => Icon(Icons.person_outline, size: 28, color: c)),
        ],
      ),
    );
  }

 
  Widget _tab(int index, Widget Function(Color color) icon) {
    final color = index == selectedIndex ? homeBlue : Colors.black;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onSelected(index),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Center(child: icon(color)),
      ),
    );
  }
}