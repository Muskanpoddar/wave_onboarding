import 'package:flutter/material.dart';
import '../components/onboarding_page1.dart';
import '../components/onboarding_page2.dart';

import '../widgets/pagination_dots.dart';
import '../widgets/wave_edge.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  late final AnimationController _clock;
  late final AnimationController _fade;

  double _page = 0;
  double _lastPage = 0;
  int _dir = 0;
  int _stickyDir = 0;
  bool _active = false;

  final List<Widget> _pages = const [OnboardingPage1(), OnboardingPage2()];

  final List<Color> _leftEdge = const [
    Color(0xFF0D47A1),
    Color(0xFF263238),
    Color(0xFF4A148C),
  ];

  final List<Color> _rightEdge = const [
    Color(0xFF003C8F),
    Color(0xFF102027),
    Color(0xFF1A0D2E),
  ];

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    final v = _pageController.page ?? 0.0;
    final delta = v - _lastPage;

    if (delta.abs() > 0.0006) {
      _dir = delta > 0 ? 1 : -1;
      if (delta.abs() > 0.006) _stickyDir = _dir;
    }

    _page = v;

    final d = (_page - _page.round()).abs();
    final nowActive = d > 0.001;

    if (nowActive && !_active) {
      _active = true;
      _fade.forward();
    } else if (!nowActive && _active) {
      _active = false;
      _fade.reverse();
    }

    _lastPage = v;
    setState(() {});
  }

  double get _intensity {
    final d = (_page - _page.round()).abs();
    return Curves.easeOutCubic.transform((d * 1.05).clamp(0.0, 1.0)) * 1.05;
  }

  double get _alpha {
    final d = (_page - _page.round()).abs();
    final v = Curves.easeOutCubic.transform((d * 2.2).clamp(0.0, 1.0));
    return v * _fade.value;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _clock.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ip = _page.floor().clamp(0, _pages.length - 1);
    final np = _page.ceil().clamp(0, _pages.length - 1);
    final show = _alpha > 0.01 && (_stickyDir != 0 || _dir != 0);
    final dir = _stickyDir != 0 ? _stickyDir : _dir;
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final phaseBias = _page;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (context, i) {
              final activeHere = show && (i == ip || i == np);
              final side = dir > 0
                  ? (i == ip ? WaveSide.right : WaveSide.left)
                  : (i == ip ? WaveSide.left : WaveSide.right);
              final edgeColor = side == WaveSide.left
                  ? _leftEdge[i]
                  : _rightEdge[i];
              final innerColor = Color.alphaBlend(
                edgeColor.withOpacity(0.35),
                Colors.white.withOpacity(0.1),
              );

              return Stack(
                children: [
                  _pages[i],
                  if (activeHere)
                    Positioned.fill(
                      child: IgnorePointer(
                        ignoring: true,
                        child: Opacity(
                          opacity: _alpha,
                          child: EdgeWave(
                            time: _clock,
                            intensity: _intensity,
                            side: side,
                            edgeColor: edgeColor,
                            innerColor: innerColor,
                            devicePixelRatio: dpr,
                            phaseBias: phaseBias,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PaginationDots(
              count: _pages.length,
              currentIndex: _page.round(),
              onDotTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
