import 'package:flutter/material.dart';

import 'nikki_title.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    required this.content,
    super.key,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(content)),
    );
  }
}

class NoEntryTakenWidget extends StatelessWidget {
  const NoEntryTakenWidget({
    super.key,
    required this.takeEntry
  });

  final void Function() takeEntry;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        NikkiText(content:"You still don't have an entry for today!"),
        ElevatedButton(
          onPressed: () {
            takeEntry();
          },
          child: const NikkiText(content:"NIKKI"),
        ),
      ],
    );
  }
}

class NoSharedEntriesWidget extends StatelessWidget {
  const NoSharedEntriesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const NikkiText(content:"You still don't have any shared entries!");
  }
}

class NoDiaryEntriesWidget extends StatelessWidget {
  const NoDiaryEntriesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const NikkiText(content:"You still don't have any entries!");
  }
}

class NoPromptWidget extends StatelessWidget{
  const NoPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const NikkiText(content:"Could not load prompt");
  }

}