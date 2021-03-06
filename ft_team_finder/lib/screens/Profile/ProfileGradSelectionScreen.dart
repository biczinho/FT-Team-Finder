import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ft_team_finder/baseWidgets/baseLayout.dart';
import 'package:ft_team_finder/logic/ProfileBloc/ProfileBloc.dart';
import 'package:ft_team_finder/logic/ProfileBloc/ProfileEvent.dart';
import 'package:ft_team_finder/logic/ProfileBloc/ProfileState.dart';
import 'package:ft_team_finder/models/UserProfileData.dart';

import 'ProfileSkillSelectionScreen.dart';

// ignore: must_be_immutable
class GradScreen extends BaseLayout {
  GradScreen() {
    this.child = ProfileGradSelectionScreen();
  }

  @override
  set child(Widget _child) {
    super.child = _child;
  }
}

class ProfileGradSelectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileGradSelectionScreenState();
  }
}

class ProfileGradSelectionScreenState
    extends State<ProfileGradSelectionScreen> {
  UserProfileData user;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (_, state) {
      state is CurrentProfile
          ? this.user = state.profile
          : print("this shouldnt happen");
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Select your Grad:"),
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("BSI"),
                makeRadioButton(1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("TADS"), makeRadioButton(2)],
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(left: Radius.zero),
                  border: Border.all(color: Colors.black, width: 3)),
              width: 300,
              height: 250,
              child: YearPicker(
                  firstDate: DateTime(DateTime.now().year - 10, 1),
                  lastDate: DateTime(DateTime.now().year, 1),
                  initialDate: DateTime.now(),
                  selectedDate:
                      DateTime(user.yearOfEntry) ?? DateTime.now().year,
                  onChanged: (DateTime dateTime) {
                    // print("grads start year: $dateTime");
                    setState(() {
                      user.yearOfEntry = dateTime.year;
                    });
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  print("${this.user.gradID}, ${this.user.yearOfEntry}");
                  BlocProvider.of<ProfileBloc>(context)
                      .add(UpdateEvent(profile: this.user));
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return Scaffold(
                        body: SkillsScreen(), resizeToAvoidBottomInset: false);
                  }));
                },
                child: Icon(Icons.forward)),
          ]),
        ],
      );
    });
  }

  Widget makeRadioButton(int value) {
    return Radio(
      value: value,
      groupValue: user.gradID,
      onChanged: (int input) {
        setState(() {
          user.gradID = input;
        });
      },
    );
  }
}
