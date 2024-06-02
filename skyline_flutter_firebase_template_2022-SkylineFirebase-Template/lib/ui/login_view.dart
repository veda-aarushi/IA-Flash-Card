import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:skyline_template_app/viewmodels/login_viewmodel.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => locator<LoginViewModel>(),
      onModelReady: (viewModel) => viewModel.init(),

      builder: (context, viewModel, child) => Scaffold(
            // Change the background color
            backgroundColor: kColorSkylineDarkGrey,

            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(child: IconButton(icon: Icon(Icons.arrow_back,color: kColorSkylineWhite,), onPressed: ()=> viewModel.routeToHomeView()),alignment: Alignment.topLeft,),
                  SizedBox(
                    height: 140.0,
                  ),
                  Container(
                    child: Center(child: Text("!Bienvenido a la clase de español¡",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: kColorSkylineWhite, fontStyle: FontStyle.italic),)),
                  ),SizedBox(height: 10,),
                  Container(child: Image.asset('assets/logo3.png',width: 150,height: 150,),),

                  SizedBox(
                    height: 18.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        //Do something with the user input.
                        viewModel.setEmailAddress(value);
                      },
                      decoration: InputDecoration(filled: true,fillColor: kColorSkylineWhite,
                        hintText: 'Enter your email',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kColorOrange, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kColorOrange, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      textAlign: TextAlign.center,
                      obscureText: true,
                      onChanged: (value) {
                        //Do something with the user input.
                        viewModel.setPassword(value);
                      },
                      decoration: InputDecoration(filled: true,fillColor: kColorSkylineWhite,
                        hintText: 'Enter your password.',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kColorOrange, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color:kColorOrange, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: Material(
                      color: kColorOrange,
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () {
                          //Implement login functionality.
                          print('login pressed ' + viewModel.email + " " +
                          viewModel.password);
                          viewModel.loginUser();
                          print('login done ------------' + viewModel.errorMessage);
                          if (viewModel.errorMessage != "") {
                            _showDialog(context, viewModel);
                            //viewModel.errorMessage = "";
                          }
                        },
                        minWidth: 330.0,
                        height: 42.0,
                        child: Text(
                          'Log In',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: kColorSkylineWhite),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                    child: Material(
                      color: kColorOrange,
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      elevation: 5.0,
                      child: MaterialButton(
                        onPressed: () {
                          //Go to registration page
                          print('Register new user pressed ');
                          viewModel.routeToRegistrationView();
                          print(viewModel.email);
                          print(viewModel.password);
                          //viewModel.registerUser();
                        },
                        minWidth: 330.0,
                        height: 42.0,
                        child: Text(
                          'Register New User',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: kColorSkylineWhite),
                        ),
                      ),
                    ),
                    ),
                ],
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),
          ),
      );
  }

  void _showDialog(BuildContext context, LoginViewModel viewmodel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Alert!!"),
          content: new Text(" Login Error: ${viewmodel.errorMessage}"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                viewmodel.errorMessage = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
