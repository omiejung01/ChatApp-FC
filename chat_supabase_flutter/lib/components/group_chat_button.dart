import 'package:flutter/material.dart';

// at most 4 icons

class GroupChatButton extends StatelessWidget {
  final double iconSize = 50.0;
  final List<Color> iconColors = const [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
  ];
  final double overlapOffset = 20.0;

  GroupChatButton();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0, // Adds a shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners for the card
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keep the column compact
          children: [
            const SizedBox(height: 15.0),
            // The core of our cascade effect
            SizedBox(
              width: (iconColors.length * iconSize) -
                  ((iconColors.length - 1) * overlapOffset), // Calculate total width
              height: iconSize, // Height is just the icon size
              child: Stack(
                children: _buildCascadeIcons(),
              ),
            ),
            const SizedBox(height: 15.0),
            Text('...',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCascadeIcons() {
    List<Widget> icons = [];
    for (int i = 0; i < iconColors.length; i++) {
      icons.add(
        Positioned(
          left: i * overlapOffset, // Position each icon to create the cascade
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColors[i],
              border: Border.all(
                color: Colors.white, // Add a white border for better separation
                width: 2.0,
              ),
            ),
            child: Icon(
              Icons.star, // You can change this icon or remove it for just circles
              color: Colors.white,
              size: iconSize * 0.6, // Adjust icon size within the circle
            ),
          ),
        ),
      );
    }
    return icons;
  }

// ProfileIcon
}

/*
class GroupChatButton extends StatelessWidget {
  final double iconSize = 50.0;
  final List<Color> iconColors = const [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
  ];
  final double overlapOffset = 20.0;

  GroupChatButton();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0, // Adds a shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners for the card
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Keep the column compact
          children: [
            const SizedBox(height: 15.0),
            // The core of our cascade effect
            SizedBox(
              width: (iconColors.length * iconSize) -
                  ((iconColors.length - 1) * overlapOffset), // Calculate total width
              height: iconSize, // Height is just the icon size
              child: Stack(
                children: _buildCascadeIcons(),
              ),
            ),
            const SizedBox(height: 15.0),
            Text('...',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCascadeIcons() {
    List<Widget> icons = [];
    for (int i = 0; i < iconColors.length; i++) {
      icons.add(
        Positioned(
          left: i * overlapOffset, // Position each icon to create the cascade
          child: Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColors[i],
              border: Border.all(
                color: Colors.white, // Add a white border for better separation
                width: 2.0,
              ),
            ),
            child: Icon(
              Icons.star, // You can change this icon or remove it for just circles
              color: Colors.white,
              size: iconSize * 0.6, // Adjust icon size within the circle
            ),
          ),
        ),
      );
    }
    return icons;
  }



// ProfileIcon
}
*/

