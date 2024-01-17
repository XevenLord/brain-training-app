// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map json) => Board(
      json['score'] as int,
      json['best'] as int,
      (json['tiles'] as List<dynamic>)
          .map((e) => Tile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      over: json['over'] as bool? ?? false,
      won: json['won'] as bool? ?? false,
      undo: json['undo'] == null
          ? null
          : Board.fromJson(Map<String, dynamic>.from(json['undo'] as Map)),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      duration: json['duration'] == null
          ? null
          : Duration(seconds: json['duration'] as int),
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'score': instance.score,
      'best': instance.best,
      'tiles': instance.tiles.map((e) => e.toJson()).toList(),
      'over': instance.over,
      'won': instance.won,
      'undo': instance.undo?.toJson(),
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'duration': instance.duration?.inSeconds,
    };
