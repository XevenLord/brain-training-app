import 'package:brain_training_app/utils/app_constant.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models/tile.dart';

part 'board.g.dart';

@JsonSerializable(explicitToJson: true, anyMap: true)
class Board {
  //Current score on the board
  final int score;
  //Best score so far
  final int best;
  //Current list of tiles shown on the board
  final List<Tile> tiles;
  //Whether the game is over or not
  final bool over;
  //Whether the game is won or not
  final bool won;
  //Keeps the previous round board state used for the undo functionality
  final Board? undo;

  DateTime? startTime;

  DateTime? endTime;

  Level? level;

  Board(this.score, this.best, this.tiles,
      {this.over = false,
      this.won = false,
      this.undo,
      this.startTime,
      this.endTime,
      this.level = Level.Easy});

  //Create a model for a new game.
  Board.newGame(this.best, this.tiles)
      : score = 0,
        over = false,
        won = false,
        undo = null,
        startTime = DateTime.now(),
        endTime = null,
        level = Level.Easy;

  //Create an immutable copy of the board
  Board copyWith(
          {int? score,
          int? best,
          List<Tile>? tiles,
          bool? over,
          bool? won,
          Board? undo,
          DateTime? startTime,
          DateTime? endTime,
          Level? level}) =>
      Board(score ?? this.score, best ?? this.best, tiles ?? this.tiles,
          over: over ?? this.over,
          won: won ?? this.won,
          undo: undo ?? this.undo,
          startTime: startTime ?? this.startTime,
          endTime: endTime ?? this.endTime,
          level: level ?? this.level);

  //Create a Board from json data
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  //Generate json data from the Board
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}
