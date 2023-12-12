import 'package:flutter/material.dart';

class NoEntryTakenWidget extends StatelessWidget {
  const NoEntryTakenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("You still don't have an entry for today!");
  }
}