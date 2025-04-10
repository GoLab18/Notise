import 'package:flutter/material.dart';

class BottomNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isSelected
      ? Theme.of(context).colorScheme.inversePrimary
      : Theme.of(context).colorScheme.primary;

    final Color labelColor = isSelected
      ? Theme.of(context).colorScheme.inversePrimary
      : Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: Theme.of(context).colorScheme.primary.withAlpha(64),
        highlightColor: Theme.of(context).colorScheme.primary.withAlpha(32),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
              ? Theme.of(context).colorScheme.primary.withAlpha(32)
              : Colors.transparent
          ),
          child: SizedBox.fromSize(
            size: Size(120, 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24.0
                  )
                ),
                AnimatedDefaultTextStyle(
                  curve: Curves.easeOut,
                  style: TextStyle(
                    fontSize: isSelected ? 14.0 : 12.0,
                    color: labelColor
                  ),
                  duration: const Duration(milliseconds: 100),
                  child: Text(label)
                )
              ]
            )
          )
        )
      )
    );
  }
}
