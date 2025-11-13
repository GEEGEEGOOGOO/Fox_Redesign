import 'package:flutter/material.dart';
import '../components/boost_status_capsule.dart';

double deviceAdjustScale(double w, double h) {
  final ratio = h / w;

  if (ratio > 2.0) return 0.92; // Tall phones (iPhone Pro Max)
  if (ratio < 1.7) return 1.10; // Tablets or wider screens
  return 1.0; // Default
}

enum LayoutSize { small, medium, large }

LayoutSize getLayoutSize(double w) {
  if (w < 380) return LayoutSize.small; // iPhone SE, old Androids
  if (w < 500) return LayoutSize.medium; // most modern phones
  return LayoutSize.large; // tablets, foldables
}

// Responsive refactor of original MiningScreenLayout
// - Uses a single Stack that sizes itself to the screen (LayoutBuilder)
// - Positions and sizes children using percentages (so they scale proportionally)
// - Removes hard-coded Alignment constants and fixed widths/heights
// - Keeps API of existing assets intact (just replace assets paths if needed)

class MiningScreenLayout extends StatefulWidget {
  const MiningScreenLayout({super.key});

  @override
  State<MiningScreenLayout> createState() => _MiningScreenLayoutState();
}

class _MiningScreenLayoutState extends State<MiningScreenLayout> {
  // UI-only state (kept from original)
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // We'll use the full available width/height to compute % positions
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            final layout = getLayoutSize(w);
            final foxScale = deviceAdjustScale(w, h);

            // BaseScale helps scale fonts/icons in a way that behaves nicely
            final baseScale = (w / 430).clamp(0.7, 2.0);

            return Container(
              width: w,
              height: h,
              color: const Color(0xFF5D755F),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background layer (fills)
                  Positioned.fill(
                    child: Image.asset(
                      'asset/background/white_canvas.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Decorative top vector (keeps its intrinsic size but positioned relatively)
                  Positioned(
                    top: h * -0.1,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset('asset/background/vector.png'),
                    ),
                  ),

                  // Central circular fox area (centered at 28% from top)
                  ResponsivePositioned(
                    width: w * 0.57, // relative size
                    height: w * 0.57,
                    left: (w - w * 0.57) / 2,
                    top: h * 0.18,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'asset/centre/Vector-2.png',
                          fit: BoxFit.contain,
                          width: w * 0.50,
                          height: w * 0.50,
                        ),
                        Image.asset(
                          'asset/centre/Vector-4.png',
                          fit: BoxFit.contain,
                          width: w * 0.60 * foxScale,
                          height: w * 0.60 * foxScale,
                        ),
                      ],
                    ),
                  ),

                  // Boost icons around the fox using percent-based positions
                  // Top paw
                  RelativeImage(
                    asset: 'asset/paws.png',
                    centerX: 0.5,
                    centerY: 0.15,
                    size: w * 0.22,
                  ),

                  // Handshake (top-left)
                  RelativeImage(
                    asset: 'asset/handshake.png',
                    centerX: 0.28,
                    centerY: 0.18,
                    size: w * 0.38,
                  ),

                  // Prize cup (top-right)
                  RelativeImage(
                    asset: 'asset/prize_cup.png',
                    centerX: 0.75,
                    centerY: 0.19,
                    size: w * 0.18,
                  ),

                  // Wallet (mid-left)
                  RelativeImage(
                    asset: 'asset/wallet.png',
                    centerX: 0.16,
                    centerY: 0.28,
                    size: w * 0.195,
                  ),

                  // Power (mid-right)
                  RelativeImage(
                    asset: 'asset/power.png',
                    centerX: 0.85,
                    centerY: 0.28,
                    size: w * 0.135,
                  ),

                  // Boost 20% (lower-left)
                  RelativeImage(
                    asset: 'asset/boost_20.png',
                    centerX: 0.25,
                    centerY: 0.41,
                    size: w * 0.22,
                  ),

                  // Boost 30% (lower-right)
                  RelativeImage(
                    asset: 'asset/boost_30.png',
                    centerX: 0.75,
                    centerY: 0.41,
                    size: w * 0.195,
                  ),

                  // Pickaxe in center (slightly below fox)
                  RelativeImage(
                    asset: 'asset/pickaxe.png',
                    centerX: 0.5,
                    centerY: 0.47,
                    size: w * 0.28,
                  ),

                  // Leaves row (three leaves at bottom area)
                  RelativeImage(
                    asset: 'asset/Leaf.png',
                    centerX: 0.16,
                    centerY: 0.63,
                    size: w * 0.18,
                  ),
                  RelativeImage(
                    asset: 'asset/Leaf.png',
                    centerX: 0.5,
                    centerY: 0.63,
                    size: w * 0.18,
                  ),
                  RelativeImage(
                    asset: 'asset/Leaf.png',
                    centerX: 0.83,
                    centerY: 0.63,
                    size: w * 0.18,
                  ),

                  // Locks grid (2x2)
                  RelativeImage(
                    asset: 'asset/Lock.png',
                    centerX: 0.33,
                    centerY: 0.57,
                    size: w * 0.22,
                  ),
                  RelativeImage(
                    asset: 'asset/Lock.png',
                    centerX: 0.33,
                    centerY: 0.68,
                    size: w * 0.22,
                  ),
                  RelativeImage(
                    asset: 'asset/Lock.png',
                    centerX: 0.67,
                    centerY: 0.57,
                    size: w * 0.22,
                  ),
                  RelativeImage(
                    asset: 'asset/Lock.png',
                    centerX: 0.67,
                    centerY: 0.68,
                    size: w * 0.22,
                  ),

                  // Bottom bots and shadows
                  RelativeImage(
                    asset: 'asset/bot_shadow.png',
                    centerX: 0.5,
                    centerY: 0.949,
                    size: w * 0.42,
                  ),
                  RelativeImage(
                    asset: 'asset/Bot.png',
                    centerX: 0.5,
                    centerY: 0.949,
                    size: w * 0.42,
                  ),

                  RelativeImage(
                    asset: 'asset/bott_shadow.png',
                    centerX: 0.160,
                    centerY: 0.949,
                    size: w * 0.44,
                  ),
                  RelativeImage(
                    asset: 'asset/Bott.png',
                    centerX: 0.172,
                    centerY: 0.952,
                    size: w * 0.38,
                  ),

                  RelativeImage(
                    asset: 'asset/Bottt_shadow.png',
                    centerX: 0.83,
                    centerY: 0.95,
                    size: w * 0.39,
                  ),
                  RelativeImage(
                    asset: 'asset/Bottt.png',
                    centerX: 0.83,
                    centerY: 0.95,
                    size: w * 0.38,
                  ),

                  // Cat group (bottom-right)
                  RelativeImage(
                    asset: 'asset/cat_bg.png',
                    centerX: 0.967,
                    centerY: 0.988,
                    size: w * 0.07,
                  ),
                  RelativeImage(
                    asset: 'asset/cat_bgg.png',
                    centerX: 0.9,
                    centerY: 0.99,
                    size: w * 0.06,
                  ),
                  RelativeImage(
                    asset: 'asset/Cat.png',
                    centerX: 0.83,
                    centerY: 0.93,
                    size: w * 0.36,
                  ),

                  // Boost status capsule (overlay near top middle). Keep it above other elements.
                  Positioned(
                    left: w * 0.06,
                    right: w * 0.06,
                    top: h * 0.02,
                    child: BoostStatusCapsule(
                      passiveBoost1Used: passiveBoost1Used,
                      passiveBoost2Used: passiveBoost2Used,
                      referralBonus: referralBonus,
                      passivePremiumPct: passivePremiumPct,
                      nodulePremiumPct: nodulePremiumPct,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------- Helper widgets ----------------------

/// Simple widget that lets us place an image by centerX/centerY as percentages and a size (square)
class RelativeImage extends StatelessWidget {
  final String asset;
  final double centerX; // 0..1
  final double centerY; // 0..1
  final double size;

  const RelativeImage({
    super.key,
    required this.asset,
    required this.centerX,
    required this.centerY,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;

          final left = (w * centerX) - (size / 2);
          final top = (h * centerY) - (size / 2);

          return Stack(
            children: [
              Positioned(
                left: left,
                top: top,
                width: size,
                height: size,
                child: Image.asset(asset, fit: BoxFit.contain),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Positions a child by absolute left/top and fixed w/h — used for center circle
class ResponsivePositioned extends StatelessWidget {
  final double left;
  final double top;
  final double width;
  final double height;
  final Widget child;

  const ResponsivePositioned({
    super.key,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: child,
    );
  }
}

// ---------------------- UI pieces kept from original ----------------------
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
            "2 070,80 FOXC",
            style: TextStyle(
              color: Colors.white,
              fontSize: _s(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            "(51,77 €*)",
            style: TextStyle(color: Colors.white, fontSize: _s(context, 16)),
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

// A minimal placeholder for BoostStatusCapsule so this file compiles independently.
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Boost : +0% ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
