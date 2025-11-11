import 'package:flutter/material.dart';

enum MishiTab { sala, comedor, voz, dormitorio }

class MishiBottomNavBar extends StatelessWidget {
  final MishiTab currentTab;
  final Function(MishiTab) onTabChanged;

  const MishiBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavButton(
            icon: Icons.home,
            label: 'Sala',
            isSelected: currentTab == MishiTab.sala,
            onTap: () => onTabChanged(MishiTab.sala),
          ),
          _NavButton(
            icon: Icons.restaurant,
            label: 'Comedor',
            isSelected: currentTab == MishiTab.comedor,
            onTap: () => onTabChanged(MishiTab.comedor),
          ),
          _NavButton(
            icon: Icons.mic,
            label: 'Voz',
            isSelected: currentTab == MishiTab.voz,
            onTap: () => onTabChanged(MishiTab.voz),
            isCenter: true,
          ),
          _NavButton(
            icon: Icons.bedtime,
            label: 'Dormitorio',
            isSelected: currentTab == MishiTab.dormitorio,
            onTap: () => onTabChanged(MishiTab.dormitorio),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCenter;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isCenter
                  ? const Color(0xFFFF6B35)
                  : const Color(0xFFFFB6C1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isCenter
                      ? const Color(0xFFFF6B35)
                      : const Color(0xFF999999)),
              size: isCenter ? 32 : 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isCenter
                        ? const Color(0xFFFF6B35)
                        : const Color(0xFF999999)),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}





