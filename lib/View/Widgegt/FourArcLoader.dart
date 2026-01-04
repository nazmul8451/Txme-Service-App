import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../Utils/AppColors/app_colors.dart';

class FourArcLoader extends StatelessWidget {
  const FourArcLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildArc(0),
          _buildArc(1),
          _buildArc(2),
          _buildArc(3),
        ],
      ),
    );
  }

  Widget _buildArc(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Transform.rotate(
        angle: math.pi / 4 * (index * 0.5), // Apply a slight rotation to each arc
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            value: 0.75, // Creates a 3/4 circle arc
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.A7DFF.withOpacity(0.8)),
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
