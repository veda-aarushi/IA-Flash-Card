import 'package:flutter/material.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:skyline_template_app/viewmodels/cards_admin_viewmodel.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => locator<HomeViewModel>(),
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: kColorSkylineDarkGrey,
        body: Column(
          children: [
            Container(
              child: Center(
                  child: Text(
                "Card Admin Page",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: kColorSkylineWhite),
              )),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Image.asset('assets/logo3.png',width: 150,height: 150,),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.routeToAddCardsView();
              },
              style: ElevatedButton.styleFrom(
                primary: kColorOrange,
              ),
              child: Text(
                "Add Flash cards",
                style: TextStyle(color: kColorSkylineWhite),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.routeToEditCardsView();
              },
              style: ElevatedButton.styleFrom(
                primary: kColorOrange,
              ),
              child: Text(
                "Edit Flash cards",
                style: TextStyle(color: kColorSkylineWhite),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.routeToMenuView();
              },
              style: ElevatedButton.styleFrom(
                primary: kColorOrange,
              ),
              child: Text(
                "Return to Menu",
                style: TextStyle(color: kColorSkylineWhite),
              ),
            )
          ],
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
