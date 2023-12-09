import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'data.dart';
import 'dart:async';

class FlipCardGame extends StatefulWidget {
  final Level _level;
  FlipCardGame(this._level);

  @override
  _FlipCardGameState createState() => _FlipCardGameState();
}

class _FlipCardGameState extends State<FlipCardGame> {
  int _previousIndex = -1;
  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  late Level _level;
  late Timer _timer;
  int _time = 5;
  late int _left;
  bool _isFinished = false;
  List<String>? _data;
  List<bool>? _cardFlips;
  List<GlobalKey<FlipCardState>>? _cardStateKeys;

  @override
  void initState() {
    super.initState();
    _level = widget._level;
    restart();
  }

  // void restart() async {
  //   await startTimer();
  //   _data = getSourceArray(_level) as List<String>;
  //   _cardFlips = getInitialItemState(_level);
  //   _cardStateKeys = getCardStateKeys(_level);
  //   _time = 5;
  //   _left = (_data.length ~/ 2);
  //   _isFinished = false;

  //   Future.delayed(const Duration(seconds: 6), () {
  //     setState(() {
  //       _start = true;
  //       _timer.cancel();
  //     });
  //   });
  // }

  Future<void> restart() async {
    await startTimer();
    _data = getSourceArray(_level) as List<String>;
    _cardFlips = getInitialItemState(_level);
    _cardStateKeys = getCardStateKeys(_level);
    _time = 6;
    _left = (_data!.length ~/ 2);
    _isFinished = false;

    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        _start = true;
        _timer.cancel();
      });
    });
  }

  Future<void> startTimer() async {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        _time = _time - 1;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null || _cardFlips == null || _cardStateKeys == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _isFinished
        ? Scaffold(
            body: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    restart();
                  });
                },
                child: Container(
                  height: 50,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    "Replay",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _time > 0
                          ? Text(
                              '$_time',
                              style: Theme.of(context).textTheme.headline3,
                            )
                          : Text(
                              'Left:$_left',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) => _start
                            ? FlipCard(
                                key: _cardStateKeys![index],
                                onFlip: () {
                                  if (!_flip) {
                                    _flip = true;
                                    _previousIndex = index;
                                  } else {
                                    _flip = false;
                                    if (_previousIndex != index) {
                                      if (_data?[_previousIndex] !=
                                          _data?[index]) {
                                        _wait = true;

                                        Future.delayed(
                                            const Duration(milliseconds: 1500),
                                            () {
                                          _cardStateKeys?[_previousIndex]
                                              .currentState
                                              ?.toggleCard();
                                          _previousIndex = index;
                                          _cardStateKeys?[_previousIndex]
                                              .currentState
                                              ?.toggleCard();

                                          Future.delayed(
                                              const Duration(milliseconds: 160),
                                              () {
                                            setState(() {
                                              _wait = false;
                                            });
                                          });
                                        });
                                      } else {
                                        _cardFlips![_previousIndex] = false;
                                        _cardFlips![index] = false;
                                        print(_cardFlips);

                                        setState(() {
                                          _left -= 1;
                                        });
                                        if (_cardFlips!
                                            .every((t) => t == false)) {
                                          print("Won");
                                          Future.delayed(
                                              const Duration(milliseconds: 160),
                                              () {
                                            setState(() {
                                              _isFinished = true;
                                              _start = false;
                                            });
                                          });
                                        }
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                flipOnTouch: _wait ? false : _cardFlips![index],
                                direction: FlipDirection.HORIZONTAL,
                                front: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 3,
                                          spreadRadius: 0.8,
                                          offset: Offset(2.0, 1),
                                        )
                                      ]),
                                  margin: EdgeInsets.all(4.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/images/animalspics/quest.png",
                                    ),
                                  ),
                                ),
                                back: getItem(index))
                            : getItem(index),
                        itemCount: _data!.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 3,
              spreadRadius: 0.8,
              offset: Offset(2.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.all(4.0),
      child: Image.asset(_data![index]),
    );
  }
}
