import 'package:flutter/material.dart';
import 'package:sidekick/dto/release.dto.dart';

void showDeleteDialog(
  BuildContext context, {
  ReleaseDto item,
  @required Function onDelete,
}) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (context) {
      // return object of type Dialog
      return AlertDialog(
        title: const Text("Are you sure you want to remove?"),
        content: Text('This will remove ${item.name} cache from your system.'),
        buttonPadding: const EdgeInsets.all(15),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Confirm"),
            onPressed: () async {
              Navigator.of(context).pop();
              onDelete();
            },
          ),
        ],
      );
    },
  );
}
