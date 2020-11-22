import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:project_OS/main.dart';
import 'package:project_OS/models/transaction.dart';

// import 'package:provider/provider.dart';
class NewTransaction extends StatefulWidget {
  final Function addTx;
final List<Transaction> usertrasanction;
  NewTransaction(
    this.addTx,
    this.usertrasanction
  );

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  File _storedImage;
  void _selectImage(File pickedImage) {
    _storedImage = pickedImage;
  }

  Future _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    final File file = File(pickedFile.path);
    if (pickedFile == null) {
      return;
    }
    setState(() {
      _storedImage = file;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(file.path);
    final savedImage = await file.copy('${appDir.path}/$fileName');
    _selectImage(savedImage);
  }
   Future _pickpucture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    if (pickedFile == null) {
      return;
    }
    setState(() {
      _storedImage = file;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(file.path);
    final savedImage = await file.copy('${appDir.path}/$fileName');
    _selectImage(savedImage);
  }

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final commentController = TextEditingController();
  DateTime _selectDate;
  void submitData() {
    final enteredTitle = titleController.text;
    final commentData = commentController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectDate == null) {
      return;
    }

    widget.addTx(
        enteredTitle, enteredAmount, commentData, _selectDate, _storedImage);
        Navigator.pushReplacement(context,  MaterialPageRoute(
                    builder: (context) =>TabsScreen()),
          );
  }

  void _presentDatePicker() {
    Platform.isIOS
        ? CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime pickedDate) {
              setState(() {
                _selectDate = pickedDate;
              });
            },
            initialDateTime: DateTime(2020),
            maximumDate: DateTime.now())
        : showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now())
            .then((pickedDate) {
            if (pickedDate == null) {
              return;
            }
            setState(() {
              _selectDate = pickedDate;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => submitData(),
              // onChanged: (val) {
              //   titleInput = val;
              // },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
              // onChanged: (val) => amountInput = val,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'Comment', hintText: "Add a comment..."),
              controller: commentController,
              onSubmitted: (_) => submitData(),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  child: _storedImage != null
                      ? Image.file(
                          _storedImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Text(
                          'No Image Taken',
                          textAlign: TextAlign.center,
                        ),
                  alignment: Alignment.center,
                ),
              
                Column(
                  children: [
                   
                      FlatButton.icon(
                        icon: Icon(Icons.camera),
                        label: Text('Take Picture'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: _takePicture,
                      ),
                    
                    
               FlatButton.icon(
                    icon: Icon(Icons.camera_front),
                    label: Text('choose picture'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _pickpucture,
                  )
                  ],
                ),
              ],
            ),
            Platform.isIOS
                ? Column(
                    children: [
                      CupertinoDialogAction(
                        child: Text(_selectDate == null
                            ? 'choose date'
                            : DateFormat.yMMMd().format(_selectDate)),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              actions: <Widget>[
                                Container(
                                  height: 300,
                                  child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (DateTime pickedDate) {
                                        setState(() {
                                          _selectDate = pickedDate;
                                        });
                                      },
                                      initialDateTime: DateTime.now(),
                                      backgroundColor: Colors.white,
                                      maximumDate: DateTime.now()),
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: Text('Cancel'),
                                onPressed: () {
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text('Add Transaction'),
                        onPressed: submitData,
                      )
                    ],
                  )
                : Column(
                    children: [
                      FlatButton(
                        child: Text(
                          _selectDate == null
                              ? 'choose date'
                              : DateFormat.yMMMd().format(_selectDate),
                        ),
                        textColor: Colors.purple,
                        onPressed: _presentDatePicker,
                      ),
                      FlatButton(
                        child: Text('Add Transaction'),
                        textColor: Colors.purple,
                        onPressed: submitData,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
