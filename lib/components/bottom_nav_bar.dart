import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback onSearch;
  
  const BottomNavBar({
    super.key,
    required this.onSearch,
    required this.children
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: BottomNavBarPainter(
                color: Theme.of(context).colorScheme.secondary,
                borderColor: Theme.of(context).colorScheme.surface
              )
            )
          ),
      
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children
          ),
      
          Positioned(
            bottom: 10,
            child: SizedBox.square(
              dimension: 64,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8
                    )
                  ],
                  shape: BoxShape.circle
                ),
                child: IconButton.filled(
                  iconSize: 30,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed: onSearch,
                  icon: Icon(Icons.search)
                )
              )
            )
          )
        ]
      )
    );
  }
}

class BottomNavBarPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  BottomNavBarPainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final centerWidth = size.width / 2;
    final bumpRadius = 20.0;

    path.moveTo(0, 0);
    path.lineTo(centerWidth - bumpRadius - 48, 0);

    path.cubicTo(
      centerWidth - bumpRadius - 24,
      0,
      centerWidth - bumpRadius - 12,
      -bumpRadius,
      centerWidth,
      -bumpRadius,
    );

    path.cubicTo(
      centerWidth + bumpRadius + 12,
      -bumpRadius,
      centerWidth + bumpRadius + 24,
      0,
      centerWidth + bumpRadius + 48,
      0,
    );

    path.lineTo(size.width, 0);

    final borderPath = Path.from(path)..fillType;
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, Paint()..color = color);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
