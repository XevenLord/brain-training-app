import 'package:brain_training_app/admin/patients/domain/entity/inspirational_mssg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InspirationalMessageCard extends StatelessWidget {
  final InspirationalMessage message;

  const InspirationalMessageCard({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.imgUrl != null)
            Image.network(message.imgUrl!, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(
            message.sender ?? 'Unknown Sender',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            message.message ?? 'No message',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            message.createdAt != null
                ? DateFormat.yMMMd().format(message.createdAt!)
                : 'Unknown Date',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }
}
