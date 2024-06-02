import 'package:flutter/material.dart';
import 'package:skyline_template_app/model/FlashCard.dart';
import 'package:skyline_template_app/viewmodels/edit_card_viewmodel.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';


class EditCardView extends StatelessWidget {
  List<DynamicWidget> questionCardWidgets = [];
  List<String> AnswerList = [];
  List<String> QuestionList = [];
  bool isStartGame = false;
  String selectedLesson = "";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditCardViewModel>.reactive(
      viewModelBuilder: () => locator<EditCardViewModel>(),
      disposeViewModel: false,
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: kColorSkylineDarkGrey,
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              child: Center(
                  child: Text(
                    "Flash card Page",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black),
                  )),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 200,
              //color: kColorSkylineDarkGrey,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.black,
                ),
                color: kColorSkylineDarkGrey,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.grey,
                    Colors.black12,
                  ],
                ),
              ),
              child: DropDown<String>(
                items: viewModel.lessonIds,
                initialValue: viewModel.selectedLesson,
                dropDownType: DropDownType.Button,
                hint: Text("Select Lesson"),
                onChanged: (String value) {
                  viewModel.readMapsFromDB(value);
                },
                icon: Icon(
                  Icons.expand_more,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 750,
              decoration: BoxDecoration(
                color: kColorSkylineDarkGrey,
                /*gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.red,
                  ],
                ),*/
                border: Border.all(
                    color: Colors.black12,
                    width: 5
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              //color: kColorSkylineDarkGrey,
              child: buildTextFieldList(viewModel),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    submitData(viewModel);
                  },
                  style: ElevatedButton.styleFrom(primary: kColorOrange),
                  child: Text('Update data',
                      style: TextStyle(color: kColorSkylineWhite)),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.routeToHomeView();
                  },
                  style: ElevatedButton.styleFrom(primary: kColorOrange),
                  child: Text('Cancel and return',
                      style: TextStyle(color: kColorSkylineWhite)),
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

  ListView buildTextFieldList(EditCardViewModel viewModel) {
    questionCardWidgets = [];
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        DynamicWidget currentWidget = new DynamicWidget();
        currentWidget.question_controller.text = viewModel.flashcards[index].question;
        currentWidget.answer_controller.text = viewModel.flashcards[index].answer;
        Container lineItem = new Container( child: currentWidget);
        questionCardWidgets.add(lineItem.child);
        print(lineItem.toStringShort());
        return lineItem;
      },
      itemCount: viewModel.flashcards.length,
    );
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  submitData( EditCardViewModel viewModel) {
    //print('inside submit data ${floatingButtomPressed}');
    /*if(floatingButtomPressed ) {
      floatingButtomPressed = false;
      return;
    }*/
    QuestionList = [];
    AnswerList = [];
    questionCardWidgets
        .forEach((widget) => QuestionList.add(widget.question_controller.text));
    questionCardWidgets
        .forEach((widget) => AnswerList.add(widget.answer_controller.text));
    if (viewModel != null) {
      viewModel.addCards(QuestionList, AnswerList);
    }
    //setState(() {});
    //print(QuestionList.length);
  }

}

class DynamicWidget extends StatelessWidget {
  TextEditingController question_controller = new TextEditingController();
  TextEditingController answer_controller = new TextEditingController();
  String _temp = "";

  @override
  Widget build(BuildContext context) {
    print('Inside build of dynamic widget');

    return new Container(
//      margin: new EdgeInsets.all(8.0),
      child: ListBody(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width:190,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: new TextFormField(
                  controller: question_controller,
                  decoration: const InputDecoration(
                      labelText: 'Question', border: OutlineInputBorder()),
                ),
              ),
              Container(
                width: 190,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: new TextFormField(
                  controller: answer_controller,
                  decoration: const InputDecoration(
                      labelText: 'Answer', border: OutlineInputBorder()),
                  //keyboardType: TextInputType.number,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
