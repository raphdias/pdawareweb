import 'package:example/patientDetails.dart';
import 'package:example/patient_details_page.dart';
import 'package:example/selection.dart';
import 'package:example/src/authentication.dart';
import 'package:example/src/widgets.dart';
import 'package:example/working_with_json.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cohort.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDAware Cohort'),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('assets/banner.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'July 1'),
          const IconAndDetail(Icons.location_city, 'Pawtucket, RI'),
          GestureDetector(
            onTap: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
              return GetData();
            }),);},
            child: IconAndDetail(Icons.foundation_rounded, 'My Details')
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Authentication(
              email: appState.email,
              loginState: appState.loginState,
              startLoginFlow: appState.startLoginFlow,
              verifyEmail: appState.verifyEmail,
              signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
              cancelRegistration: appState.cancelRegistration,
              registerAccount: appState.registerAccount,
              signOut: appState.signOut,
            ),
          ),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.deepPurple,
          ),
          const Header("What we'll be doing"),
          const Paragraph(
            'Beta launching a thoughtfully crafted way of maintaining track of Parkinson\'s disease symptoms!',
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.participants >= 2)
                  Paragraph('${appState.participants} people joining')
                else if (appState.participants == 1)
                  const Paragraph('1 person joining')
                else
                  const Paragraph('No one joining'),
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  YesNoSelection(
                    state: appState.participating,
                    onSelection: (attending) => appState.participating = attending,
                  ),
                  const Header('Discussion'),
                  Cohort(
                    addMessage: (message) =>
                        appState.addMessageToGuestBook(message),
                    messages: appState.cohortMessages,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}