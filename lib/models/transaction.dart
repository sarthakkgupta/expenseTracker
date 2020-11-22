import 'dart:io';

import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final String comment;
  final DateTime date;
final File image;
  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.comment,
    @required this.date,
    @required this.image
  });
}
