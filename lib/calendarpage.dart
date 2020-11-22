import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import './models/transaction.dart';

class CalendarPage extends StatefulWidget {

  final List<Transaction> transactions;
  CalendarPage(this.transactions);
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  double expenditureinlast30days = 0,
      expenditureinlastweek = 0,
      averageexpenditureinaday = 0;

  external bool isBefore(DateTime other);
  Widget widgetlist(String s, double i) {
    return Card(
      child: Container(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              s,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              i.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  double calculatemonthly(transactions) {
    setState(() {
      expenditureinlast30days = 0;
    });
    for (int i = 0; i < transactions.length; i++) {
      setState(() {
        if (transactions[i].date.compareTo(DateTime.now()) < 30.0)
          expenditureinlast30days =
              expenditureinlast30days + transactions[i].amount;
      });
    }
    return expenditureinlast30days;
  }

  double calculateweekly(transactions) {
    setState(() {
      expenditureinlastweek = 0;
    });
    for (int i = 0; i < transactions.length; i++) {
      setState(() {
        if (transactions[i].date.compareTo(DateTime.now()) < 7.0)
          expenditureinlastweek =
              expenditureinlastweek + transactions[i].amount;
      });
    }
    return expenditureinlastweek;
  }

  double averageexpenditure(transactions) {
    double totalamount = 0;
    DateTime d = DateTime.now();
    for (int i = 0; i < transactions.length; i++) {
      setState(() {
        if (transactions[i].date.compareTo(d) < 0) d = transactions[i].date;
        totalamount = totalamount + transactions[i].amount;
      });
    }
    setState(() {
      averageexpenditureinaday =
          totalamount / (DateTime.now().difference(d).inDays.toInt() + 1);
    });
    return averageexpenditureinaday;
  }

  @override
  Widget build(BuildContext context) {
    final bodyy = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          widgetlist("average expenditure per day:",
              averageexpenditure(widget.transactions)),
          widgetlist("expenditure in Last 30 days :",
              calculatemonthly(widget.transactions)),
          widgetlist(
              "expenditure in a week :", calculateweekly(widget.transactions))
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: SafeArea(child: bodyy),
            navigationBar: CupertinoNavigationBar(
              middle: Text('App'),
            ),
          )
        : Scaffold(
            appBar: Platform.isIOS
                ? Container()
                : AppBar(
                    // Here we take the value from the CalendarPage object that was created by
                    // the App.build method, and use it to set our appbar title.
                    title: Text('Personal Expense'),
                  ),
            body: SafeArea(child: bodyy),
          );
  }
}
