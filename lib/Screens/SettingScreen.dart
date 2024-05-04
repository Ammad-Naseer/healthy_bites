// ignore_for_file: file_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthy_bites/Models/colors.dart';
import 'package:healthy_bites/Provider/theme_changer_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var nameValue = "";
  void getValue() async {
    var prefs = await SharedPreferences.getInstance();
    var getName = prefs.getString('myName');
    setState(() {
      nameValue = getName!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.green.shade50
          : Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.green.shade50
                      : Colors.black45,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: Row(
                      children: [
                        Text(
                          "Setting",
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? MyColors.darkGreen
                                  : Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage("assets/ammad.png"),
                          radius: 40,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Hello $nameValue",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? MyColors.darkGreen
                                    : Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            settingItem(Icons.print, "Print"),
            const SizedBox(
              height: 15,
            ),
            settingItem(Icons.share, "Share menu"),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                themeDialogBox();
              },
              child: settingItem(Icons.light_mode, "Theme"),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                rateAppDialogBox();
              },
              child: settingItem(Icons.star_rate_rounded, "Rate this app"),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                privacyPolicyDialogBox();
              },
              child: settingItem(Icons.policy, "Privacy Policy"),
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                feedbackDialogBox();
              },
              child: settingItem(Icons.feedback, "Feedback"),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingItem(IconData icon, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(Random().nextInt(0xffffffff))
                      .withAlpha(0xff)
                      .withOpacity(.4),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(icon),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }

  themeDialogBox() {
    final themeChanger = Provider.of<ThemeChanger>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10,
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.green.shade50
                : Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Change Theme",
                style: GoogleFonts.mukta(
                  textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? MyColors.darkGreen
                          : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                      title: const Text(
                        "Light Mode",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: ThemeMode.light,
                      groupValue: themeChanger.themeMode,
                      onChanged: (value) {
                        themeChanger.setTheme(value);
                        Navigator.pop(context);
                      }),
                  RadioListTile<ThemeMode>(
                      title: const Text("Dark Mode",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      value: ThemeMode.dark,
                      groupValue: themeChanger.themeMode,
                      onChanged: (value) {
                        themeChanger.setTheme(value);
                        Navigator.pop(context);
                      }),
                  RadioListTile<ThemeMode>(
                      title: const Text("System Mode",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      value: ThemeMode.system,
                      groupValue: themeChanger.themeMode,
                      onChanged: (value) {
                        themeChanger.setTheme(value);
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  feedbackDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.green.shade50
              : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Feedback",
            style: GoogleFonts.mukta(
              textStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? MyColors.darkGreen
                    : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.65,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We'd love to hear your thoughts!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Type your feedback here...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement feedback submission logic here
                Navigator.pop(context);
                // Optionally show a confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Feedback Submitted"),
                      content:
                          const Text("Thank you for your valuable feedback!"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  rateAppDialogBox() {
    double rating = 4;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.green.shade50
              : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Rate Our App",
            style: GoogleFonts.mukta(
              textStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? MyColors.darkGreen
                    : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "How would you rate our app?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) {
                    rating = value;
                  },
                ),
                const SizedBox(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Thank You"),
                      content: const Text("We appreciate your feedback!"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  privacyPolicyDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.green.shade50
              : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Privacy Policy",
            style: GoogleFonts.mukta(
              textStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? MyColors.darkGreen
                    : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.65,
            child: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Privacy Policy",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Add your privacy policy text here
                  Text(
                    "We take your privacy seriously. This Privacy Policy describes how we collect, use, and disclose information about you when you use our app.",
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Information We Collect",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  // Add more sections of your privacy policy as needed
                  Text(
                    "We may collect information about you directly from you, from third parties, and automatically through your use of our app.",
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Your Choices",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "You can control cookies and tracking tools. You may refuse to accept cookies by activating the appropriate setting on your browser or mobile device.",
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
