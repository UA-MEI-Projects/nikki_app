import 'package:flutter/material.dart';
import 'package:nikki_app/domain/repository/user_repository.dart';
import 'package:nikki_app/widgets/nikki_title.dart';

import '../db/nikki_shared_pref.dart';
import '../utils/get_it_init.dart';
import '../widgets/error_page.dart';
import '../widgets/loading_page.dart';

class SettingsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController textEditingController;

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

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color.fromRGBO(232, 100, 78, 0.8274509803921568),
      content: NikkiText(content: message),
    ));
  }

  Future<NikkiSharedPreferences> initPreferences() async {
    var preferences = NikkiSharedPreferences();
    await preferences.init();
    return preferences;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NikkiTitle(
          content: "Settings",
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: FutureBuilder<NikkiSharedPreferences>(
              future: initPreferences(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                } else if (snapshot.hasData && snapshot.data != null) {
                  var preferences = snapshot.requireData;
                  return Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30.0, bottom: 30.0),
                    child: Column(
                      children: [
                        OutlinedButton(onPressed: (){
                          getIt.get<UserRepository>().generateNewPrompt();
                          showSnackbar("New prompt generated");
                        }, child: NikkiSubTitle(content: "Generate a new Prompt")),
                        Divider(
                          height: 100.0,
                        ),
                        NikkiSubTitle(content: "Change your username"),
                        TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.orange, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.deepOrangeAccent, width: 2.0),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: 'Your new username...',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          style: TextStyle(
                              color:
                              Colors.black), // Text color inside the TextField
                        ),
                        TextButton(onPressed: (){
                          if(textEditingController.text.isNotEmpty){
                            preferences.setUsername(textEditingController.text);
                            showSnackbar("Username updated");
                          }
                        }, child: NikkiText(content: "Update",)),
                        Divider(
                          height: 100.0,
                        ),
                        Container(
                          margin: EdgeInsets.all(10), // Optional: to provide external spacing
                          padding: EdgeInsets.all(10), // Optional: to provide internal spacing
                          decoration: BoxDecoration(
                            color: Colors.white, // Choose the container's background color
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.deepOrangeAccent, // Border color
                              width: 1, // Border width
                            ), // Adjust for desired border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1), // Shadow color with opacity
                                spreadRadius: 5, // Spread radius
                                blurRadius: 7, // Blur radius
                                offset: Offset(0, 3), // Changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              NikkiSubTitle(content: "About"),
                              Image.asset(
                                "assets/ua_logo.png",
                                height: 100,
                              ),
                              NikkiText(content: "Nikki aims at helping people register their life as they lived it."),
                              NikkiText(content: "This project was developed for University of Aveiro's Masters program."),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }
                return ErrorPage(
                    content: "Something went wrong. Please try again later!");
              }),
        ),
      ),
    );
  }
}
