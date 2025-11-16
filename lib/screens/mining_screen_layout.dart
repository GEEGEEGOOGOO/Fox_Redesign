import 'package:flutter/material.dart';
import 'dart:math' as math;

// This approach mimics how game engines handle responsive design:
// 1. Define a fixed aspect ratio "game area"
// 2. Letterbox/pillarbox when needed
// 3. Anchor UI elements to edges
// 4. Scale everything proportionally within the game area

class MiningScreenLayout extends StatefulWidget {
  const MiningScreenLayout({super.key});

  @override
  State<MiningScreenLayout> createState() => _MiningScreenLayoutState();
}

class _MiningScreenLayoutState extends State<MiningScreenLayout> {
  bool passiveBoost1Used = false;
  bool passiveBoost2Used = false;
  int referralBonus = 0;
  int passivePremiumPct = 0;
  int nodulePremiumPct = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF5D755F),
      appBar: const HeaderBar(),
      body: SafeArea(
        top: false, // ✅ FIXED: Remove green padding beneath app bar
        bottom: false, // ✅ FIXED: Remove bottom padding to anchor elements to screen bottom
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Define target aspect ratio for the "game area"
            const targetAspectRatio = 9 / 16; // Portrait game aspect

            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final screenAspect = screenWidth / screenHeight;

            // Calculate game area dimensions (with letterboxing if needed)
            double gameWidth;
            double gameHeight;
            double offsetX = 0;
            double offsetY = 0;

            if (screenAspect > targetAspectRatio) {
              // Screen is wider - add pillarbox (vertical bars on sides)
              gameHeight = screenHeight;
              gameWidth = gameHeight * targetAspectRatio;
              offsetX = (screenWidth - gameWidth) / 2;
            } else {
              // Screen is taller or matches - add letterbox (horizontal bars top/bottom)
              gameWidth = screenWidth;
              gameHeight = gameWidth / targetAspectRatio;
              offsetY = (screenHeight - gameHeight) / 2;
            }

            // Scale factor based on screen width (reference: 393px)
            final scale = screenWidth / 393;

            // Get status bar + app bar height for top positioning
            final mediaQuery = MediaQuery.of(context);
            final statusBarHeight = mediaQuery.padding.top;
            final appBarHeight = kToolbarHeight;
            final totalTopHeight = statusBarHeight + appBarHeight;

            return Stack(
              clipBehavior: Clip.none, // ✅ CRITICAL: Allow elements to overflow Stack bounds
              children: [
                // Background (full screen)
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFF5D755F),
                    child: Image.asset(
                      'asset/background/white_canvas.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // All elements now render at screen level for consistent positioning
                ..._buildTopSection(screenWidth, screenHeight, scale, totalTopHeight),
                ..._buildCentralSection(screenWidth, screenHeight, scale),
                ..._buildScreenBottomSection(screenWidth, screenHeight, scale),
              ],
            );
          },
        ),
      ),
    );
  }

  // Top section - vector background and boost capsule
  List<Widget> _buildTopSection(double screenWidth, double screenHeight, double scale, double totalTopHeight) {
    final vectorTopOffset = totalTopHeight - (115 * scale);
    final boostTopOffset = totalTopHeight + (-40 * scale);

    return [
      // Top vector decoration - positioned beneath app bar
      Positioned(
        top: vectorTopOffset,
        left: 0,
        right: 0,
        child: Image.asset(
          'asset/background/vector.png',
          fit: BoxFit.contain,
        ),
      ),

      // Boost capsule - anchored to top
      Positioned(
        left: 20 * scale,
        right: 20 * scale,
        top: boostTopOffset,
        child: BoostStatusCapsule(
          passiveBoost1Used: passiveBoost1Used,
          passiveBoost2Used: passiveBoost2Used,
          referralBonus: referralBonus,
          passivePremiumPct: passivePremiumPct,
          nodulePremiumPct: nodulePremiumPct,
          scale: scale,
        ),
      ),
    ];
  }

  // Central section - fox and circular icons
  List<Widget> _buildCentralSection(double screenWidth, double screenHeight, double scale) {
    final foxSize = 220.0 * scale;
    final foxCenterX = screenWidth / 2;
    // Position fox at a fixed distance from top instead of percentage
    final foxCenterY = 300 * scale; // Fixed pixel distance from top

    return [
      // Central fox circle
      Positioned(
        left: foxCenterX - foxSize / 2,
        top: foxCenterY - foxSize / 2,
        width: foxSize,
        height: foxSize * 1.34,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'asset/centre/Vector-2.png',
              width: foxSize * 0.88,
              height: foxSize * 0.88,
              fit: BoxFit.contain,
            ),
            Image.asset(
              'asset/centre/Vector-4.png',
              width: foxSize * 1.05,
              height: foxSize * 1.05,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),

      // Icons positioned around fox using polar coordinates
      ..._buildCircularIcons(foxCenterX, foxCenterY, foxSize, scale),
    ];
  }

  // Circular icons around fox
  List<Widget> _buildCircularIcons(double centerX, double centerY, double foxSize, double scale) {
    final radius = foxSize / 2;

    return [
      // Top paw
      _polarIcon(centerX, centerY, radius * 0.9, -90, 85 * scale, 'asset/paws.png'),

      // Handshake (top-left)
      _polarIcon(centerX, centerY, radius * 1.05, -145, 150 * scale, 'asset/handshake.png'),

      // Trophy (top-right)
      _polarIcon(centerX, centerY, radius * 1.0, -35, 70 * scale, 'asset/prize_cup.png'),

      // Wallet (left)
      _polarIcon(centerX, centerY, radius * 1.2, 176, 75 * scale, 'asset/wallet.png'),

      // Power (right)
      _polarIcon(centerX, centerY, radius * 1.2, 4, 52 * scale, 'asset/power.png'),

      // Boost 20%
      _polarIcon(centerX, centerY, radius * 1.4, 130, 90 * scale, 'asset/boost_20.png'),

      // Boost 30%
      _polarIcon(centerX, centerY, radius * 1.4, 50, 78 * scale, 'asset/boost_30.png'),

      // Pickaxe
      Positioned(
        left: centerX - (100 * scale) / 2,
        top: centerY + foxSize * 0.47,
        width: 100 * scale,
        height: 100 * scale,
        child: Image.asset('asset/pickaxe.png', fit: BoxFit.contain),
      ),

    ];
  }

  // Helper to position icons using polar coordinates
  Widget _polarIcon(double centerX, double centerY, double radius, double angleDeg, double size, String asset) {
    final angleRad = angleDeg * math.pi / 180;
    final x = centerX + radius * math.cos(angleRad) - size / 2;
    final y = centerY + radius * math.sin(angleRad) - size / 2;

    return Positioned(
      left: x,
      top: y,
      width: size,
      height: size,
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }

  // Bottom section that anchors to the ACTUAL screen bottom (not game area)
  List<Widget> _buildScreenBottomSection(double screenWidth, double screenHeight, double scale) {
    final leafSize = 70 * scale;
    final lockSize = 85 * scale;
    final botSize = 145 * scale;

    // Fixed pixel distances from actual screen bottom
    final leavesBottomOffset = 230 * scale;
    final locksRow1BottomOffset = 260 * scale;
    final locksRow2BottomOffset = 180 * scale;
    final botsBottomOffset = -15 * scale;
    final catBottomOffset = 30 * scale;

    return [
      // Leaves row
      Positioned(
        left: screenWidth * 0.16 - leafSize / 2,
        bottom: leavesBottomOffset,
        width: leafSize,
        height: leafSize,
        child: Image.asset('asset/Leaf.png', fit: BoxFit.contain),
      ),
      Positioned(
        left: screenWidth * 0.5 - leafSize / 2,
        bottom: leavesBottomOffset,
        width: leafSize,
        height: leafSize,
        child: Image.asset('asset/Leaf.png', fit: BoxFit.contain),
      ),
      Positioned(
        left: screenWidth * 0.84 - leafSize / 2,
        bottom: leavesBottomOffset,
        width: leafSize,
        height: leafSize,
        child: Image.asset('asset/Leaf.png', fit: BoxFit.contain),
      ),

      // Lower locks grid
      Positioned(
        left: screenWidth * 0.33 - lockSize / 2,
        bottom: locksRow1BottomOffset,
        width: lockSize,
        height: lockSize,
        child: Image.asset('asset/Lock.png', fit: BoxFit.contain),
      ),
      Positioned(
        left: screenWidth * 0.67 - lockSize / 2,
        bottom: locksRow1BottomOffset,
        width: lockSize,
        height: lockSize,
        child: Image.asset('asset/Lock.png', fit: BoxFit.contain),
      ),
      Positioned(
        left: screenWidth * 0.33 - lockSize / 2,
        bottom: locksRow2BottomOffset,
        width: lockSize,
        height: lockSize,
        child: Image.asset('asset/Lock.png', fit: BoxFit.contain),
      ),
      Positioned(
        left: screenWidth * 0.67 - lockSize / 2,
        bottom: locksRow2BottomOffset,
        width: lockSize,
        height: lockSize,
        child: Image.asset('asset/Lock.png', fit: BoxFit.contain),
      ),

      // Bots - anchored to screen bottom
      // Center bot
      Positioned(
        left: screenWidth / 2 - botSize * 0.610,
        bottom: -3 * scale,
        width: botSize * 1.18,
        height: botSize * 1.15,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset('asset/bot_shadow.png', fit: BoxFit.contain),
          ],
        ),
      ),

      Positioned(
        left: screenWidth / 2 - botSize * 0.612,
        bottom: botsBottomOffset,
        width: botSize * 1.2,
        height: botSize * 1.2,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset('asset/Bot.png', fit: BoxFit.contain),
          ],
        ),
      ),

      // Left bot
      Positioned(
        left: -7 * scale,
        bottom: -45 * scale,
        width: botSize * 1.14,
        height: botSize * 1.14 ,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              bottom: 5 * scale,
              child: Image.asset('asset/bott_shadow.png', fit: BoxFit.contain),
            ),
            Positioned.fill(
              child: Image.asset('asset/Bott.png', fit: BoxFit.contain),
            ),
          ],
        ),
      ),

      Positioned(
        right: 230 * scale,
        bottom: -10 * scale,
        width: botSize * 1.2,
        height: botSize * 1.2,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset('asset/Bott_shadow.png', fit: BoxFit.contain),
          ],
        ),
      ),

      Positioned(
        right: 238 * scale,
        bottom: -16 * scale,
        width: botSize * 1.12,
        height: botSize * 1.12,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset('asset/Bott.png', fit: BoxFit.contain),
          ],
        ),
      ),

      // Right bot
      Positioned(
        right: -8 * scale,
        bottom: -10 * scale,
        width: botSize * 1.2,
        height: botSize * 1.2,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset('asset/Bottt_shadow.png', fit: BoxFit.contain),
          ],
        ),
      ),

      Positioned(
        right: -7 * scale,
        bottom: botsBottomOffset,
        width: botSize * 1.17,
        height: botSize * 1.17,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset('asset/Bottt.png', fit: BoxFit.contain),
          ],
        ),
      ),

      // Cat - anchored to bottom-right
      Positioned(
        right: botSize * 0.18,
        bottom: -1,
        child: Image.asset(
          'asset/cat_bgg.png',
          width: botSize * 0.16,
          height: botSize * 0.16,
        ),
      ),
      Positioned(
        right: -4 * scale,
        bottom: -16 * scale,
        width: botSize * 0.95,
        height: botSize * 0.95,
        child: Stack(
          children: [
            Image.asset('asset/Cat.png', fit: BoxFit.contain),
          ],
        ),
      ),
    ];
  }
}

// AppBar
class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
        child: Image.asset(
          'asset/Three.png',
          width: 36,
          height: 36,
          fit: BoxFit.contain,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'asset/appbar_icons/Vector-f.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 6),
              const Text(
                "2 070,80 FOXC",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                "(51,77 €*)",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0, top: 8.0),
          child: SizedBox(
            width: 36,
            height: 36,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 4,
                  left: 10,
                  child: Image.asset(
                    'asset/appbar_icons/Vector-26.png',
                    width: 14,
                    height: 14,
                  ),
                ),
                Image.asset(
                  'asset/appbar_icons/Vector-23.png',
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BoostStatusCapsule extends StatelessWidget {
  final bool passiveBoost1Used;
  final bool passiveBoost2Used;
  final int referralBonus;
  final int passivePremiumPct;
  final int nodulePremiumPct;
  final double scale;

  const BoostStatusCapsule({
    super.key,
    required this.passiveBoost1Used,
    required this.passiveBoost2Used,
    required this.referralBonus,
    required this.passivePremiumPct,
    required this.nodulePremiumPct,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8 * scale,
        horizontal: 12 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24 * scale),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              'Boost : +0% ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13 * scale,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Boost : +0% ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13 * scale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
