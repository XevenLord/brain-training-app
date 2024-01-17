import 'dart:math';
import 'package:brain_training_app/patient/game/2048/services/tzfe_service.dart';
import 'package:brain_training_app/patient/game/2048/tzfe_vmodel.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/tile.dart';
import '../models/board.dart';

import 'next_direction.dart';
import 'round.dart';

class BoardManager extends StateNotifier<Board> {
  // We will use this list to retrieve the right index when user swipes up/down
  // which will allow us to reuse most of the logic.
  List<int> verticalOrder;
  final int gridSize; // New variable for grid size
  List<int> valueList = [2];
  int benchmark = 200;
  DateTime? endTime = DateTime.now();

  final StateNotifierProviderRef ref;
  BoardManager(this.ref, this.gridSize)
      : verticalOrder = List.generate(gridSize * gridSize, (index) {
          int row = index % gridSize;
          int col = index ~/ gridSize;
          return gridSize * (gridSize - 1 - row) + col;
        }),
        super(Board.newGame(0, [], gridSize)) {
    load();
  }

  void load() async {
    //Access the box and get the first item at index 0
    //which will always be just one item of the Board model
    //and here we don't need to call fromJson function of the board model
    //in order to construct the Board model
    //instead the adapter we added earlier will do that automatically.
    var box = await Hive.openBox<Board>('boardBox');
    //If there is no save locally it will start a new game.
    state = box.get(0) ?? _newGame();
  }

  // Create New Game state.
  Board _newGame() {
    return Board.newGame(state.best + state.score, [random([])], gridSize);
  }

  // Start New Game
  // Can add service here to save the score to the database
  void newGame() {
    valueList = [2];
    benchmark = 200;
    state = _newGame();
  }

  // Check whether the indexes are in the same row or column in the board.
  bool _inRange(index, nextIndex) {
    int row = index ~/ gridSize;
    int nextRow = nextIndex ~/ gridSize;
    int col = index % gridSize;
    int nextCol = nextIndex % gridSize;

    return (row == nextRow) || (col == nextCol);
  }

  Tile _calculate(Tile tile, List<Tile> tiles, direction) {
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;
    // Get the first index from the left in the row
    // Example: for left swipe that can be: 0, 4, 8, 12
    // for right swipe that can be: 3, 7, 11, 15
    // depending which row in the column in the board we need
    // let's say the title.index = 6 (which is the 3rd tile from the left and 2nd from right side, in the second row)
    // ceil means it will ALWAYS round up to the next largest integer
    // NOTE: don't confuse ceil it with floor or round as even if the value is 2.1 output would be 3.
    // ((6 + 1) / 4) = 1.75
    // Ceil(1.75) = 2
    // If it's ascending: 2 * 4 – 4 = 4, which is the first index from the left side in the second row
    // If it's descending: 2 * 4 – 1 = 7, which is the last index from the left side and first index from the right side in the second row
    // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
    int index = vert ? verticalOrder[tile.index] : tile.index;
    int nextIndex =
        ((index + 1) / gridSize).ceil() * gridSize - (asc ? gridSize : 1);

    // If the list of the new tiles to be rendered is not empty get the last tile
    // and if that tile is in the same row as the curren tile set the next index for the current tile to be after the last tile
    if (tiles.isNotEmpty) {
      var last = tiles.last;
      // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
      var lastIndex = last.nextIndex ?? last.index;
      lastIndex = vert ? verticalOrder[lastIndex] : lastIndex;
      if (_inRange(index, lastIndex)) {
        // If the order is ascending set the tile after the last processed tile
        // If the order is descending set the tile before the last processed tile
        nextIndex = lastIndex + (asc ? 1 : -1);
      }
    }

    // Return immutable copy of the current tile with the new next index
    // which can either be the top left index in the row or the last tile nextIndex/index + 1
    return tile.copyWith(
        nextIndex: vert ? verticalOrder.indexOf(nextIndex) : nextIndex);
  }

  //Move the tile in the direction
  bool move(SwipeDirection direction) {
    bool asc =
        direction == SwipeDirection.left || direction == SwipeDirection.up;
    bool vert =
        direction == SwipeDirection.up || direction == SwipeDirection.down;
    // Sort the list of tiles by index.
    // If user swipes vertically use the verticalOrder list to retrieve the up/down index
    state.tiles.sort(((a, b) =>
        (asc ? 1 : -1) *
        (vert
            ? verticalOrder[a.index].compareTo(verticalOrder[b.index])
            : a.index.compareTo(b.index))));

    List<Tile> tiles = [];

    for (int i = 0, l = state.tiles.length; i < l; i++) {
      var tile = state.tiles[i];

      // Calculate nextIndex for current tile.
      tile = _calculate(tile, tiles, direction);
      tiles.add(tile);

      if (i + 1 < l) {
        var next = state.tiles[i + 1];
        // Assign current tile nextIndex or index to the next tile if its allowed to be moved.
        if (tile.value == next.value) {
          // If user swipes vertically use the verticalOrder list to retrieve the up/down index else use the existing index
          var index = vert ? verticalOrder[tile.index] : tile.index,
              nextIndex = vert ? verticalOrder[next.index] : next.index;
          if (_inRange(index, nextIndex)) {
            tiles.add(next.copyWith(nextIndex: tile.nextIndex));
            // Skip next iteration if next tile was already assigned nextIndex.
            i += 1;
            continue;
          }
        }
      }
    }

    // Assign immutable copy of the new board state and trigger rebuild.
    state = state.copyWith(tiles: tiles, undo: state);
    return true;
  }

  // Generates tiles at random place on the board
  Tile random(List<int> indexes) {
    var rng = Random();
    int i;
    do {
      i = rng.nextInt(gridSize * gridSize);
    } while (indexes.contains(i));
    return Tile(const Uuid().v4(), valueList[rng.nextInt(valueList.length)], i);
  }

  //Merge tiles
  void merge() {
    List<Tile> tiles = [];
    var tilesMoved = false;
    List<int> indexes = [];
    var score = state.score;

    for (int i = 0, l = state.tiles.length; i < l; i++) {
      var tile = state.tiles[i];

      var value = tile.value, merged = false;

      if (i + 1 < l) {
        //sum the number of the two tiles with same index and mark the tile as merged and skip the next iteration.
        var next = state.tiles[i + 1];
        if (tile.nextIndex == next.nextIndex ||
            tile.index == next.nextIndex && tile.nextIndex == null) {
          value = tile.value + next.value;
          merged = true;
          score += tile.value;
          i += 1;
        }
      }

      if (merged || tile.nextIndex != null && tile.index != tile.nextIndex) {
        tilesMoved = true;
      }

      tiles.add(tile.copyWith(
          index: tile.nextIndex ?? tile.index,
          nextIndex: null,
          value: value,
          merged: merged));
      indexes.add(tiles.last.index);
    }

    //If tiles got moved then generate a new tile at random position of the available positions on the board.
    if (tilesMoved) {
      tiles.add(random(indexes));
    }
    state = state.copyWith(score: score, tiles: tiles);
  }

  //Finish round, win or loose the game.
  void _endRound() {
    var gameOver = state.tiles.length == gridSize * gridSize;
    var gameWon = state.tiles.any((tile) => tile.value == 2048);
    List<Tile> tiles = [];

    //If there is no more empty place on the board
    if (state.tiles.length == gridSize * gridSize) {
      state.tiles.sort(((a, b) => a.index.compareTo(b.index)));

      for (int i = 0, l = state.tiles.length; i < l; i++) {
        var tile = state.tiles[i];

        //If there is a tile with 2048 then the game is won.
        if (tile.value == 2048) {
          gameWon = true;
          valueList = [2];
          benchmark = 200;
          // submitScore(state.score, gameWon,
          //     getDuration(state.startTime!, DateTime.now()));
        }

        var x = (i - (((i + 1) / gridSize).ceil() * gridSize - gridSize));

        if (x > 0 && i - 1 >= 0) {
          //If tile can be merged with left tile then game is not lost.
          var left = state.tiles[i - 1];
          if (tile.value == left.value) {
            gameOver = false;
          }
        }

        if (x < gridSize - 1 && i + 1 < l) {
          //If tile can be merged with right tile then game is not lost.
          var right = state.tiles[i + 1];
          if (tile.value == right.value) {
            gameOver = false;
          }
        }

        if (i - gridSize >= 0) {
          //If tile can be merged with above tile then game is not lost.
          var top = state.tiles[i - gridSize];
          if (tile.value == top.value) {
            gameOver = false;
          }
        }

        if (i + gridSize < l) {
          //If tile can be merged with the bellow tile then game is not lost.
          var bottom = state.tiles[i + gridSize];
          if (tile.value == bottom.value) {
            gameOver = false;
          }
        }
        //Set the tile merged: false
        tiles.add(tile.copyWith(merged: false));
      }
    } else {
      //There is still a place on the board to add a tile so the game is not lost.
      gameOver = false;
      for (var tile in state.tiles) {
        //If there is a tile with 2048 then the game is won.
        if (tile.value == 2048) {
          gameWon = true;
        }
        //Set the tile merged: false
        tiles.add(tile.copyWith(merged: false));
      }
    }

    if (gameOver) {
      endTime = DateTime.now();
      // submitScore(
      //     state.score, gameWon, getDuration(state.startTime!, endTime!));
    }

    state = state.copyWith(
        tiles: tiles, won: gameWon, over: gameOver, endTime: endTime);
  }

  // void submitScore(int score, bool status, Duration duration) async {
  //   await TZFEService.submitScore(score, status ? 'win' : 'lose', duration);
  // }

  // Duration getDuration(DateTime startTime, DateTime endTime) {
  //   Duration duration = endTime.difference(startTime);
  //   return duration;
  // }

  //Mark the merged as false after the merge animation is complete.
  bool endRound() {
    //End round.
    _endRound();
    ref.read(roundManager.notifier).end();

    //If player moved too fast before the current animation/transition finished, start the move for the next direction
    var nextDirection = ref.read(nextDirectionManager);
    if (nextDirection != null) {
      move(nextDirection);
      ref.read(nextDirectionManager.notifier).clear();
      return true;
    }
    return false;
  }

  //undo one round only
  void undo() {
    if (state.undo != null) {
      state = state.copyWith(
          score: state.undo!.score,
          best: state.undo!.best,
          tiles: state.undo!.tiles);
    }
  }

  //Move the tiles using the arrow keys on the keyboard.
  bool onKey(RawKeyEvent event) {
    SwipeDirection? direction;
    if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      direction = SwipeDirection.right;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      direction = SwipeDirection.left;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      direction = SwipeDirection.up;
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      direction = SwipeDirection.down;
    }

    if (direction != null) {
      move(direction);
      return true;
    }
    return false;
  }

  void save() async {
    //Here we don't need to call toJson function of the board model
    //in order to convert the data to json
    //instead the adapter we added earlier will do that automatically.
    var box = await Hive.openBox<Board>('boardBox');
    try {
      box.putAt(0, state);
    } catch (e) {
      box.add(state);
    }
  }
}

dynamic boardManager = StateNotifierProvider<BoardManager, Board>((ref) {
  return BoardManager(
      ref, Get.find<TZFEViewModel>().gridSize); // For a 3x3 board
});
