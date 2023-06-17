import 'package:cloud_firestore/cloud_firestore.dart';

class TicTacToeService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateGameBoard(
      {required String gameId,
      required String gameBoard,
      required String nextPlayer}) async {
    await firestore
        .collection('tic_tac_toe')
        .doc(gameId)
        .update({'gameBoard': gameBoard, 'nextPlayer': nextPlayer});
  }
}
