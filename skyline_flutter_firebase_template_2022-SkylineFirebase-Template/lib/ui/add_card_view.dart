import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skyline_template_app/viewmodels/add_card_viewmodel.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:stacked/stacked.dart';


class AddCardView extends StatefulWidget {
  @override
  _genTeacherViewState createState() => _genTeacherViewState();
}

class _genTeacherViewState extends State<AddCardView> {
  List<dynamicWidget> dynamicList = [];
  List<String> AnswerList = [];
  List<String> QuestionList = [];
  String lessonId = "";
  TextEditingController lesson_controller = new TextEditingController();
  AddCardViewModel parentViewModel;
  bool floatingButtomPressed = false;

  @override
  Widget build(BuildContext context) {

    Widget dynamicTextField = new Flexible(
      flex: 2,
      child: new ListView.builder(
        itemCount: dynamicList.length,
        itemBuilder: (_, index) => dynamicList[index],
      ),
    );

    Widget lessonTextField = new Container(
      width: 200,
      //alignment:Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(25, 75, 25,25),
      child: new TextFormField(
        controller: lesson_controller,
        decoration: const InputDecoration(
            labelText: 'Add Lesson', border: OutlineInputBorder()),
      ),
    );

    Widget submitButton = new Container(
        color:kColorOrange,
        child: new RaisedButton(
          color: kColorOrange,
        onPressed: submitData,
        child: new Padding(
          padding: new EdgeInsets.all(16.0),
          child: new Text('Submit Data',style: TextStyle(color: kColorSkylineWhite)),
        ),
      ),
    );

    Widget result = new Flexible(
        flex: 1,
        child: new Card(
          child: ListView.builder(
            itemCount: QuestionList.length,
            itemBuilder: (_, index) {
              return new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      //margin: new EdgeInsets.all(left: 10.0),
                      width: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.white70,
                      ),
                      child: new Text(
                          "${index + 1} : ${QuestionList[index]}   ${AnswerList[index]}",
                          style: TextStyle(fontSize: 25)),

                    ),
                    new Divider()
                  ],
                ),
              );
            },
          ),
        ));

    return ViewModelBuilder<AddCardViewModel>.reactive(
        viewModelBuilder: () => locator<AddCardViewModel>(),
        disposeViewModel: false,
        onModelReady: (viewModel) => init(viewModel),
        builder: (context, viewModel, child) => Scaffold(
              body: new Container(
                child: new Column(children: <Widget>[
                  QuestionList.length == 0 ? lessonTextField : new Container(),
                  QuestionList.length == 0 ? dynamicTextField : result,
                  //QuestionList.length == 0 ? lessonTextField : new Container(),
                  QuestionList.length == 0 ? submitButton : new Container(),
                ]),
              ),
              floatingActionButton: new FloatingActionButton(
                  onPressed:  addDynamic, child: new Icon(Icons.add)),
            ));
  }

  init(AddCardViewModel viewModel) {
    viewModel.init();
    parentViewModel = viewModel;
  }

  submitData() {
    print('inside submit data ${floatingButtomPressed}');
    QuestionList = [];
    AnswerList = [];
    dynamicList
        .forEach((widget) => QuestionList.add(widget.question_controller.text));
    dynamicList
        .forEach((widget) => AnswerList.add(widget.answer_controller.text));
    lessonId = lesson_controller.text;

    if (parentViewModel != null) {
      parentViewModel.addCards(QuestionList, AnswerList, lessonId);
    }
    setState(() {});
    //print(QuestionList.length);
  }

  addDynamic() {
    print('Inside add dynamic');
    floatingButtomPressed = true;
    //parentViewModel = inputViewModel;
    if (QuestionList.length != 0) {
      Icon floatingIcon = new Icon(Icons.add);

      QuestionList = [];
      AnswerList = [];
      dynamicList = [];
      lesson_controller.text = "";
    }
    print('Before set state');
    setState(() {});
    print('After set state');
    if (dynamicList.length >= 10) {
      return;
    }
    //print('length of dynamicList before adding is ${dynamicList.length}');
    dynamicList.add(new dynamicWidget());
    //print('length of dynamicList after adding is ${dynamicList.length}');

  }

}

class dynamicWidget extends StatelessWidget {
  TextEditingController question_controller = new TextEditingController();
  TextEditingController answer_controller = new TextEditingController();
  String _temp = "";

  @override
  Widget build(BuildContext context) {
    print('Inside build of dynamic widget');
    return Container(
//      margin: new EdgeInsets.all(8.0),
      child: ListBody(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: new TextFormField(
                  controller: question_controller,
                  decoration: const InputDecoration(
                      labelText: 'Question', border: OutlineInputBorder()),
                ),
              ),
              Container(
                width: 100,
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

  void printTextFieldValue() {
    print("------------value--------- ${_temp}");
  }

  TextFormField buildTextField(int index) {
    return TextFormField(
      controller: question_controller,
      onChanged: (v) => _temp = v,
      decoration: InputDecoration(hintText: 'Enter your friend\'s name'),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
