import 'package:flutter/material.dart';
import 'package:skyline_template_app/viewmodels/menu_viewmodel.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:skyline_template_app/locator.dart';

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MenuViewModel>.reactive(
      viewModelBuilder: () => locator<MenuViewModel>(),
      disposeViewModel: false,
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: kColorSkylineDarkGrey,
        body: Column(
          children: [
            Container(
              child: Center(
                  child: Text(
                    " ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: kColorOrange),
                  )),
            ),
            SizedBox(
              height: 50,
            ),
            /*Container(
              width: 300,
              height: 500,
              //color: kColorOrange,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final id = viewModel.menuOptions[index].uid ?? 'na';
                  final menuOption = viewModel.menuOptions[index].menuItem ?? 'na';
                  //final email = viewModel.menuOptions[index].email ?? 'na';
                  return ListTile(tileColor: index%2 ==0 ? kColorDarkGreyButton : kColorSkylineDarkGrey,
                    title: Text('$id $menuOption'),
                    //subtitle: Text(email),
                  );
                },
                itemCount: viewModel.menuOptions.length,
              ),
            ),*/
            Container(
              child: Center(child: Text("Flash Cards Menu",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: kColorSkylineWhite),)),
            ),SizedBox(height: 10,),
            Container(child: Image.asset('assets/logo3.png', width: 150, height: 150,),),
            Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    //viewModel.addTeacher();
                    viewModel.routeToMemGame();
                  },style: ElevatedButton.styleFrom(
                  primary:kColorOrange,),
                  child: Text('Play Memory Game',style: TextStyle(color: kColorSkylineWhite)),
                ),SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: () {
                    viewModel.routeToHomeView();
                  },style: ElevatedButton.styleFrom(
                    primary: kColorOrange),
                  child: Text(' Cards Admin Menu ',style: TextStyle(color: kColorSkylineWhite)),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.signOut();
                  },style: ElevatedButton.styleFrom(
                    primary: kColorOrange),
                  child: Text('   Sign out   ',style: TextStyle(color: kColorSkylineWhite)),
                ),
              ],
            ),
          ],
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
