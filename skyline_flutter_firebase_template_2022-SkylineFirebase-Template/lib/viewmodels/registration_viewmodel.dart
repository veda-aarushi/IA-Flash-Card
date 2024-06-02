import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _firebaseAuth = FirebaseAuth.instance;
  String _email;
  String get email => _email;
  String _password;
  String get password => _password;

  Future init() async {
    print("Registration ViewModel init()");
    setState(ViewState.Busy);
    try {
   print('try registration statement');
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);

  }


  void setEmailAddress(String inputString) {
    _email = inputString;
  }

  void setPassword(String inputString) {
    _password = inputString;
  }

  void routeToTeacherView() {
    _navigationService.navigateTo(AddCardViewRoute);
  }

  void routeToHomeView() {
    _navigationService.navigateTo(HomeViewRoute);
  }

  void routeToLoginView() {
    _navigationService.navigateTo(LoginViewRoute);
  }

  void registerUser() {
    try {
      final newUser = _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (newUser != null) {
        print("Registration Success");
        //routeToTeacherView();
        // route to login view as the user is now registered
        routeToLoginView();
      }
    }
    catch (e) {
      print ('Registration Error: $e');
    }
  }

  RegistrationViewModel() {
    setState(ViewState.Busy);
    try {
      print("RegistrationViewModel Constructor Called()");
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);
  }
}
