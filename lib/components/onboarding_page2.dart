import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF37474F),
            Color(0xFF263238),
            Color(0xFF102027),
          ],
        ),
      ),
      child: Stack(
        children: const [
          Positioned.fill(
            child: ModelViewer(
              src: 'assets/page2.glb',
              alt: '3D asset 2',
              ar: false,
              autoRotate: false,
              disableZoom: true,
              animationName: 'Stand',
              autoPlay: true,
              interactionPrompt: InteractionPrompt.none,
              cameraOrbit: "180deg 90deg 6m",
            ),
          ),
          Positioned.fill(child: ColoredBox(color: Colors.transparent)),
        ],
      ),
    );
  }
}
