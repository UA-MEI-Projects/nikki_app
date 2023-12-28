import 'package:flutter/cupertino.dart';

class NikkiTitle extends StatelessWidget{
  final String content;

  const NikkiTitle({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );
  }

}