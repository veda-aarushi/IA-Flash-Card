import 'dart:async';

import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _firebaseAuth = FirebaseAuth.instance;
  String _email;
  String get email => _email;
  String _password;
  String get password => _password;
  String errorMessage = "";

  void setEmailAddress(String inputString) {
    _email = inputString;
  }

  void setPassword(String inputString) {
    _password = inputString;
  }

  void routeToTeacherView() {
    _navigationService.navigateTo(AddCardViewRoute);
  }

  void routeToRegistrationView() {
    _navigationService.navigateTo(RegistrationViewRoute);
  }

  void routeToFlashCardsView() {
    _navigationService.navigateTo(FlashCardViewRoute);
  }

  void routeToMenuView() {
    _navigationService.navigateTo(MenuViewRoute);
  }

  void routeToHomeView() {
    _navigationService.navigateTo(HomeViewRoute);
  }

  Future init() async {
    setState(ViewState.Busy);
    try {
      print("Login ViewModel init()");
      print('try login statement');
      setState(ViewState.Busy);
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);
  }


  void loginUser() {
    try {
      final newUser = _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        //print("INSIDE WHEN COMPLETE");
      }).onError((error, stackTrace) {
        print("ERROR IS ------------" + error.toString());
        errorMessage = error.toString();
        var runtimeType = error.runtimeType;

        print("ERROR  runtimeType IS ------------" + runtimeType.toString());
        return null;

      }).then((value) {
        if (value != null) {
          print("UID is " + value.user.uid);
          if (value.user.uid.isNotEmpty) {
            // routeToFlashCardsView();
            errorMessage = "";
            routeToMenuView();
          }
        }
      });
    }
    catch (e) {

    }
  }
}
