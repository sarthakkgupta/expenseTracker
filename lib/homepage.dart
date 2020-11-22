import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:project_OS/main.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';

class MyHomePage extends StatefulWidget {
  final List<Transaction> userTransactions;
  MyHomePage(this.userTransactions);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _addNewTransaction(String txTitle, double txAmount, String comment,
      DateTime chosenDate, File image) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      comment: comment,
      image: image,
      id: DateTime.now().toString(),
    );

    setState(() {
      widget.userTransactions.add(newTx);
    });
    Navigator.pop(context);
  }

  void _startAddNewTransaction(BuildContext ctx) {
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              actions: <Widget>[
                CupertinoActionSheetAction(
                  onPressed: () {},
                  child: NewTransaction(_addNewTransaction,userTransactions),
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('Cancel'),
                onPressed: () {
                 { Navigator.pop(context);}
                },
              ),
            ),
          )
        : showModalBottomSheet(
            context: ctx,
            builder: (_) {
              return GestureDetector(
                onTap: () {},
                child: NewTransaction(_addNewTransaction,userTransactions),
                behavior: HitTestBehavior.opaque,
              );
            },
          );
  }

  void _deleteTransaction(String id) {
    setState(() {
      widget.userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    const IconData add = const IconData(
      0xf2c7,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage,
    );
    final body = SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TransactionList(widget.userTransactions, _deleteTransaction),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: CupertinoNavigationBar(
              middle: Text('App'),
              trailing: GestureDetector(
                child: Icon(
                  add,
                ),
                onTap: () => {_startAddNewTransaction(context)}
              ),
            ),
          )
        : Scaffold(
            appBar: Platform.isIOS
                ? Container()
                : AppBar(
                    // Here we take the value from the MyHomePage object that was created by
                    // the App.build method, and use it to set our appbar title.
                    title: Text('Personal Expense'),
                  ),
            body: body,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
  }
}
