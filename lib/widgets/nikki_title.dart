import 'package:flutter/material.dart';

class NikkiTitle extends StatelessWidget {
  final String content;

  const NikkiTitle({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content,
        style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.deepOrangeAccent,
            shadows: [Shadow(color: Colors.grey, blurRadius: 5.0)]));
  }
}

class NikkiSubTitle extends StatelessWidget {
  final String content;

  const NikkiSubTitle({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content,
        style: TextStyle(
          fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
            shadows: [Shadow(color: Colors.black54, blurRadius: 5.0)]));
  }
}

class NikkiText extends StatelessWidget {
  final String content;

  const NikkiText({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontWeight: FontWeight.w600,
          fontSize: 15.0)
      );
  }
}

class NikkiSplashScreenText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        "Welcome to Nikki",
        style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
            color: Colors.white,
            shadows: [Shadow(color: Colors.white, blurRadius: 5.0)]),
      ),
      Text("Your app for registering moments of your life.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.white,
              shadows: [Shadow(color: Colors.grey, blurRadius: 5.0)])
          )
    ]);
  }
}

class NikkiSplashScreenTitle extends StatelessWidget{
  final String content;

  const NikkiSplashScreenTitle({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.deepOrangeAccent,
          shadows: [Shadow(color: Colors.grey, blurRadius: 5.0)]));
  }
}

class NikkiSplashScreenButtonText extends StatelessWidget {
  final String content;

  const NikkiSplashScreenButtonText({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
        content,
        style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.deepOrange,
            shadows: [Shadow(color: Colors.black54, blurRadius: 5.0)])
    );
  }
}

