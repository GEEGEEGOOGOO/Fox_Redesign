import 'package:flutter/material.dart';

// ============================================================================
// MAIN SCREEN - Decides between compact and wide layouts
// ============================================================================
class MiningScreenLayout extends StatelessWidget {
  const MiningScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF5D755F),
      appBar: const HeaderBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          // Layout mode switching: compact for phones, wide for tablets
          // For now, wide layout mirrors compact to preserve your design
          if (screenWidth < 600) {
            return MiningContent(screenWidth: screenWidth, isWideLayout: false);
          } else {
            return MiningContent(screenWidth: screenWidth, isWideLayout: true);
          }
        },
      ),
    );
  }
}

// ============================================================================
// HEADER BAR (AppBar) - Broken into smaller components
// ============================================================================
class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 70,
      toolbarHeight: 80,
      leading: const LeadingLogo(),
      title: const CoinBalance(),
      actions: const [NotificationBell()],
    );
  }
}

class LeadingLogo extends StatelessWidget {
  const LeadingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20.0),
      child: Image.asset(
        'asset/Three.png',
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
    );
  }
}

class CoinBalance extends StatelessWidget {
  const CoinBalance({super.key});

  // Helper for responsive typography
  double _s(BuildContext context, double baseSize) {
    return baseSize * MediaQuery.textScaleFactorOf(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'asset/appbar_icons/Vector-f.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          Text(
            "2,070.80 FOXC",
            style: TextStyle(
              color: Colors.white,
              fontSize: _s(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            "(51.77 €*)",
            style: TextStyle(
              color: Colors.white70,
              fontSize: _s(context, 14),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 20.0),
      child: SizedBox(
        width: 42,
        height: 42,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 5,
              left: 13,
              child: Image.asset(
                'asset/appbar_icons/Vector-26.png',
                width: 17,
                height: 17,
              ),
            ),
            Image.asset(
              'asset/appbar_icons/Vector-23.png',
              width: 42,
              height: 42,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// MINING CONTENT - Main container with background and all game elements
// ============================================================================
class MiningContent extends StatelessWidget {
  final double screenWidth;
  final bool isWideLayout;

  const MiningContent({
    super.key,
    required this.screenWidth,
    required this.isWideLayout,
  });

  // Calculate responsive sizes based on screen width
  double _responsive(double size) {
    final rawScale = screenWidth / 430;
    final scale = rawScale.clamp(0.7, 2.0);
    return size * scale;
  }

  double _responsiveIcon(double size) {
    final rawScale = screenWidth / 430;
    final iconScale = rawScale.clamp(0.8, 1.5);
    return size * iconScale;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF5D755F),
      ),
      child: Stack(
        children: [
          // Background layers
          const BackgroundCanvas(),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: _responsive(12)),

                // Main content area - uses Expanded to demonstrate Flex usage
                Expanded(
                  child: Stack(
                    children: [
                      // Central fox area
                      CentralFoxArea(
                        responsive: _responsive,
                      ),

                      // Boost icons around the fox
                      BoostArea(
                        responsiveIcon: _responsiveIcon,
                      ),

                      // Pickaxe in the center
                      PickaxeWidget(
                        responsive: _responsive,
                      ),

                      // Leaves row
                      LeavesRow(
                        responsive: _responsive,
                      ),

                      // Locks grid
                      LocksGrid(
                        responsive: _responsive,
                      ),

                      // Bottom bots with cat
                      BottomSection(
                        responsive: _responsive,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// BACKGROUND CANVAS
// ============================================================================
class BackgroundCanvas extends StatelessWidget {
  const BackgroundCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'asset/background/white_canvas.png',
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: const Alignment(0.0, -1.0),
          child: Image.asset('asset/background/vector.png'),
        ),
      ],
    );
  }
}

// ============================================================================
// CENTRAL FOX AREA - Main fox logo with background layers
// ============================================================================
class CentralFoxArea extends StatelessWidget {
  final double Function(double) responsive;

  const CentralFoxArea({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(0.0, -0.43),
          child: Image.asset(
            'asset/centre/Vector-2.png',
            width: responsive(220),
            height: responsive(220),
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: const Alignment(0.0, -0.45),
          child: Image.asset(
            'asset/centre/Vector-4.png',
            width: responsive(250),
            height: responsive(250),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BOOST AREA - All circular icons around the fox
// ============================================================================
class BoostArea extends StatelessWidget {
  final double Function(double) responsiveIcon;

  const BoostArea({
    super.key,
    required this.responsiveIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Paws (top center)
        Align(
          alignment: const Alignment(0.0, -0.78),
          child: Image.asset(
            'asset/paws.png',
            width: responsiveIcon(110),
            height: responsiveIcon(110),
            fit: BoxFit.contain,
          ),
        ),

        // Handshake (top left)
        Align(
          alignment: const Alignment(-0.85, -0.76),
          child: Image.asset(
            'asset/handshake.png',
            width: responsiveIcon(180),
            height: responsiveIcon(180),
            fit: BoxFit.contain,
          ),
        ),

        // Prize Cup (top right)
        Align(
          alignment: const Alignment(0.65, -0.66),
          child: Image.asset(
            'asset/prize_cup.png',
            width: responsiveIcon(85),
            height: responsiveIcon(85),
            fit: BoxFit.contain,
          ),
        ),

        // Wallet (middle left)
        Align(
          alignment: const Alignment(-0.90, -0.43),
          child: Image.asset(
            'asset/wallet.png',
            width: responsiveIcon(85),
            height: responsiveIcon(85),
            fit: BoxFit.contain,
          ),
        ),

        // Power (middle right)
        Align(
          alignment: const Alignment(0.90, -0.43),
          child: Image.asset(
            'asset/power.png',
            width: responsiveIcon(85),
            height: responsiveIcon(85),
            fit: BoxFit.contain,
          ),
        ),

        // Boost 20% (lower left)
        Align(
          alignment: const Alignment(-0.65, -0.20),
          child: Image.asset(
            'asset/boost_20.png',
            width: responsiveIcon(90),
            height: responsiveIcon(90),
            fit: BoxFit.contain,
          ),
        ),

        // Boost 30% (lower right)
        Align(
          alignment: const Alignment(0.65, -0.20),
          child: Image.asset(
            'asset/boost_30.png',
            width: responsiveIcon(78),
            height: responsiveIcon(78),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PICKAXE WIDGET - The pickaxe in the center
// ============================================================================
class PickaxeWidget extends StatelessWidget {
  final double Function(double) responsive;

  const PickaxeWidget({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.0, -0.01),
      child: Image.asset(
        'asset/pickaxe.png',
        width: responsive(120),
        height: responsive(120),
        fit: BoxFit.contain,
      ),
    );
  }
}

// ============================================================================
// LEAVES ROW - Three leaves at the bottom (preserves exact positions)
// ============================================================================
class LeavesRow extends StatelessWidget {
  final double Function(double) responsive;

  const LeavesRow({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(-0.9, 0.30),
          child: Image.asset(
            'asset/Leaf.png',
            width: responsive(90),
            height: responsive(90),
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: const Alignment(0.0, 0.30),
          child: Image.asset(
            'asset/Leaf.png',
            width: responsive(90),
            height: responsive(90),
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: const Alignment(0.9, 0.30),
          child: Image.asset(
            'asset/Leaf.png',
            width: responsive(90),
            height: responsive(90),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// LOCKS GRID - Four lock icons (preserves exact positions)
// ============================================================================
class LocksGrid extends StatelessWidget {
  final double Function(double) responsive;

  const LocksGrid({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(-0.5, 0.18),
          child: Image.asset(
            'asset/Lock.png',
            width: responsive(105),
            height: responsive(105),
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: const Alignment(-0.5, 0.43),
          child: Image.asset(
            'asset/Lock.png',
            width: responsive(105),
            height: responsive(105),
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: const Alignment(0.5, 0.18),
          child: Image.asset(
            'asset/Lock.png',
            width: responsive(105),
            height: responsive(105),
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: const Alignment(0.5, 0.43),
          child: Image.asset(
            'asset/Lock.png',
            width: responsive(105),
            height: responsive(105),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// BOTTOM SECTION - Three bots with shadows and cat
// ============================================================================
class BottomSection extends StatelessWidget {
  final double Function(double) responsive;

  const BottomSection({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Center bot (Bot.png)
        BotWithShadow(
          shadowAsset: 'asset/bot_shadow.png',
          botAsset: 'asset/Bot.png',
          alignment: const Alignment(0.0, 1.14),
          shadowSize: responsive(200),
          botSize: responsive(200),
        ),

        // Left bot (Bott.png)
        BotWithShadow(
          shadowAsset: 'asset/bott_shadow.png',
          botAsset: 'asset/Bott.png',
          alignment: const Alignment(-1.07, 1.13),
          shadowSize: responsive(187),
          botSize: responsive(180),
        ),

        // Right bot (Bottt.png)
        BotWithShadow(
          shadowAsset: 'asset/Bottt_shadow.png',
          botAsset: 'asset/Bottt.png',
          alignment: const Alignment(1.06, 1.13),
          shadowSize: responsive(181),
          botSize: responsive(180),
        ),

        // Cat and its backgrounds
        CatWidget(responsive: responsive),
      ],
    );
  }
}

// ============================================================================
// BOT WITH SHADOW - Reusable component for bot + shadow
// ============================================================================
class BotWithShadow extends StatelessWidget {
  final String shadowAsset;
  final String botAsset;
  final Alignment alignment;
  final double shadowSize;
  final double botSize;

  const BotWithShadow({
    super.key,
    required this.shadowAsset,
    required this.botAsset,
    required this.alignment,
    required this.shadowSize,
    required this.botSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: alignment,
          child: Image.asset(
            shadowAsset,
            width: shadowSize,
            height: shadowSize,
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: alignment,
          child: Image.asset(
            botAsset,
            width: botSize,
            height: botSize,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// CAT WIDGET - Cat with its background layers
// ============================================================================
class CatWidget extends StatelessWidget {
  final double Function(double) responsive;

  const CatWidget({
    super.key,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const Alignment(1.035, 1.0),
          child: Image.asset(
            'asset/cat_bg.png',
            width: responsive(40),
            height: responsive(40),
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: const Alignment(0.9, 1.043),
          child: Image.asset(
            'asset/cat_bgg.png',
            width: responsive(50),
            height: responsive(50),
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: const Alignment(1.06, 1.043),
          child: Image.asset(
            'asset/Cat.png',
            width: responsive(180),
            height: responsive(185),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}