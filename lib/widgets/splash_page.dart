import 'package:flutter/material.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';
import 'package:nikki_app/main.dart';
import 'package:nikki_app/utils/get_it_init.dart';

import '../screens/app_container.dart';
import 'nikki_title.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late TextEditingController textEditingController;
  bool insertUsernameScreen = false;
  bool usernameExists = false;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  registerUsername(String username) async {
    await getIt.get<UserRepository>().addUsername(username);
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const AppContainer()));
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<String>(
        future: getIt.get<UserRepository>().loadUsername(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.requireData != "") {
            usernameExists = true;
          }
          return Material(
            color: Color.fromRGBO(232, 100, 78, 0.8274509803921568),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    AnimatedSlide(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeIn,
                        offset:
                            insertUsernameScreen ? Offset(0, 0) : Offset(0, 4),
                        child: NikkiSplashScreenText()),
                    Spacer(),
                    AnimatedOpacity(
                      opacity: insertUsernameScreen ? 1.0 : 0.0,
                      curve: Curves.easeIn,
                      duration: Duration(milliseconds: 1500),
                      child: Container(
                        margin: EdgeInsets.all(
                            15.0), // Optional: to provide external spacing
                        padding: EdgeInsets.all(
                            15.0), // Optional: to provide internal spacing
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white70, // Border color
                              width: 1, // Border width
                            )),
                        child: Wrap(spacing: 20.0, children: [
                          NikkiSplashScreenTitle(
                              content: "Please insert your username:"),
                          TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: 'Your username...',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: TextStyle(
                                color: Colors
                                    .black), // Text color inside the TextField
                          ),
                        ]),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          if (insertUsernameScreen) {
                            registerUsername(textEditingController.text);
                          } else {
                            if (usernameExists) {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AppContainer()));

                            } else {
                              setState(() {
                                insertUsernameScreen = true;
                              });
                            }
                          }
                        },
                        child: NikkiSplashScreenButtonText(
                          content:
                              insertUsernameScreen ? "Submit" : "Continue...",
                        )),
                    Spacer()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
