import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1E88E5),
            Color(0xFF0D47A1),
            Color(0xFF003C8F),
          ],
        ),
      ),
      child: const Stack(
        children: [
          Positioned.fill(
            child: ModelViewer(
              src: 'assets/page1.glb',
              alt: '3D asset 1',
              ar: false,
              autoRotate: false,
              disableZoom: true,
              animationName: 'avatar hod ur set02',
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
