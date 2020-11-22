import 'dart:io';

import 'package:flutter/cupertino.dart';

import './models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatefulWidget {
  final Transaction t;
  TransactionCard(this.t);
  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS ? CupertinoNavigationBar(leading: GestureDetector(onTap:()=>Navigator.of(context).pop(),child: Icon(Icons.arrow_back_ios)),): null,
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: widget.t.image != null
              ? Image.file(
                  widget.t.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.t.title,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.t.amount.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  )),
            ),
          ],
        ), Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(DateFormat.yMMMd().format(widget.t.date),
              style: TextStyle(fontSize: 24, color: Colors.black87)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.t.comment,
              style: TextStyle(fontSize: 24, color: Colors.black87)),
        ),
      ],
    ))));
  }
}
