import 'dart:math';

import 'package:brain_training_app/patient/game/2048/const/colors.dart';
import 'package:flutter/material.dart';

class EmptyBoardWidget extends StatelessWidget {
  final int gridSize;
  const EmptyBoardWidget({super.key, this.gridSize = 4}); // Default to 4x4

  @override
  Widget build(BuildContext context) {
    final size = max(
        290.0,
        min((MediaQuery.of(context).size.shortestSide * 0.90).floorToDouble(),
            460.0));

    final sizePerTile = (size / gridSize).floorToDouble();
    final tileSize = sizePerTile - 12.0 - (12.0 / gridSize);
    final boardSize = sizePerTile * gridSize;

    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
          color: boardColor, borderRadius: BorderRadius.circular(6.0)),
      child: Stack(
        children: List.generate(gridSize * gridSize, (i) {
          var x = ((i + 1) / gridSize).ceil();
          var y = x - 1;
          var top = y * tileSize + (x * 12.0);
          var z = (i - (gridSize * y));
          var left = z * tileSize + ((z + 1) * 12.0);

          return Positioned(
            top: top,
            left: left,
            child: Container(
              width: tileSize,
              height: tileSize,
              decoration: BoxDecoration(
                  color: emptyTileColor,
                  borderRadius: BorderRadius.circular(6.0)),
            ),
          );
        }),
      ),
    );
  }
}
