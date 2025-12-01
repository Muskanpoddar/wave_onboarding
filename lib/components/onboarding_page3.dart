import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Color(0xFF8E24AA),
            Color(0xFF4A148C),
            Color(0xFF1A0D2E),
          ],
        ),
      ),
      child: const Stack(
        children: [
          Positioned.fill(
            child: ModelViewer(
              src: 'assets/page3.glb',
              alt: '3D asset 3',
              ar: false,
              autoRotate: false,
              disableZoom: true,
              animationName: 'Animation',
              autoPlay: true,
              interactionPrompt: InteractionPrompt.none,
            ),
          ),
          Positioned.fill(child: ColoredBox(color: Colors.transparent)),
        ],
      ),
    );
  }
}
