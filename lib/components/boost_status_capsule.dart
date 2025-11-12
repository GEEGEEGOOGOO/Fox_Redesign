// lib/components/boost_status_capsule.dart
import 'package:flutter/material.dart';

class BoostStatusCapsule extends StatelessWidget {
  final bool passiveBoost1Used;
  final bool passiveBoost2Used;
  final int referralBonus;
  final int passivePremiumPct;
  final int nodulePremiumPct;

  const BoostStatusCapsule({
    super.key,
    required this.passiveBoost1Used,
    required this.passiveBoost2Used,
    required this.referralBonus,
    required this.passivePremiumPct,
    required this.nodulePremiumPct,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total boosts
    int totalPassiveBoost = referralBonus + passivePremiumPct;
    int totalNoduleBoost = referralBonus + nodulePremiumPct;

    // Add ad boosts if active
    if (passiveBoost1Used) totalPassiveBoost += 20;
    if (passiveBoost2Used) totalPassiveBoost += 30;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.23),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Passive Mining Boost
          _buildBoostIndicator(
            icon: Icons.schedule,
            label: 'Boost',
            value: '+$totalPassiveBoost%',
            isActive: totalPassiveBoost > 0,
          ),

          const SizedBox(width: 16),

          // Separator
          Container(width: 1, height: 24, color: Colors.white.withOpacity(0.3)),

          const SizedBox(width: 16),

          // Nodule Boost
          _buildBoostIndicator(
            icon: Icons.flash_on,
            label: 'Boost',
            value: '+$totalNoduleBoost%',
            isActive: totalNoduleBoost > 0,
          ),
        ],
      ),
    );
  }

  Widget _buildBoostIndicator({
    required IconData icon,
    required String label,
    required String value,
    required bool isActive,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? Colors.white : Colors.white60, size: 20),
        const SizedBox(width: 6),
        Text(
          '$label : $value',
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white60,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
