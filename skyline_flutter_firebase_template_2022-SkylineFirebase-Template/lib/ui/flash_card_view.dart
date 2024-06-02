import 'package:flutter/material.dart';
import 'package:skyline_template_app/viewmodels/flash_card_viewmodel.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';


class FlashCardView extends StatelessWidget {
  List<cardState> questionCardStates = [];
  List<cardState> answerCardStates = [];
  List<FlipCard> questionCardWidgets = [];
  List<FlipCard> answerCardWidgets = [];
  Map<int, bool> questionCardVisibilityMap = Map();
  Map<int, bool> answerCardVisibilityMap = Map();
  bool isStartGame = false;
  String selectedLesson = "";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FlashCardViewModel>.reactive(
      viewModelBuilder: () => locator<FlashCardViewModel>(),
      disposeViewModel: false,
      onModelReady: (viewModel) => viewModel.init(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: kColorSkylineDarkGrey,
        body: Column(
          children: [
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
              height: 30,
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
                initialValue: viewModel.lessonIds.first,
                dropDownType: DropDownType.Button,
                hint: Text("Select Lesson"),
                onChanged: (String value) {
                          print(value?.toString());
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
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white12,
                gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                Colors.grey,
                Colors.blueGrey,
                ],
                ),
                border: Border.all(
                  color: Colors.black12,
                  width: 1
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              //color: kColorSkylineDarkGrey,
              child: buildQuestionsList(viewModel),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white12,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.grey,
                    Colors.blueGrey,
                  ],
                ) ,
                border: Border.all(
                  color: Colors.black12,
                  width:1
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              //color: kColorSkylineDarkGrey,
              child: buildAnswersListView(viewModel, isStartGame),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    viewModel.routeToMenuView();
                  },
                  style: ElevatedButton.styleFrom(primary: kColorOrange),
                  child: Text('Return to Menu page',
                      style: TextStyle(color: kColorSkylineWhite)),
                ),
                ElevatedButton(
                  onPressed: () {
                    isStartGame = true;
                    resetFlashCardsState();
                    viewModel.notifyListeners();
                  },
                  style: ElevatedButton.styleFrom(primary: kColorOrange),
                  child: Text('Start Game',
                      style: TextStyle(color: kColorSkylineWhite)),
                ),
                ElevatedButton(
                  onPressed: () {
                    isStartGame = false;
                    resetFlashCardsState();
                    viewModel.notifyListeners();
                  },
                  style: ElevatedButton.styleFrom(primary: kColorOrange),
                  child: Text('Learn lesson',
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

  ListView buildAnswersListView(FlashCardViewModel viewModel, bool visibile) {
    if (!visibile) {
      return null;
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        //List<Flashcard> localCardsList = viewModel.flashcards;
        final question = viewModel.answerCards[index].question ?? 'na';
        //final question =  '** Guess **';
        final answer = viewModel.answerCards[index].answer ?? 'na';
        int cardId = viewModel.answerCards[index].hashCode;
        cardState answerCardState = createCardState(index, answerCardStates);
        //answerCardStates.add(answerCardState);
        if (!answerCardVisibilityMap.containsKey(cardId)) {
          answerCardVisibilityMap[cardId] = true;
        }
        Visibility lineItem = buildAnsFlipCard(
            answerCardState, question, answer, viewModel, cardId, index);
        answerCardWidgets.add(lineItem.child);
        return lineItem;
      },
      itemCount: viewModel.answerCards.length,
    );
  }

  ListView buildQuestionsList(FlashCardViewModel viewModel) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final question = viewModel.questionCards[index].question ?? 'na';
        final answer = viewModel.questionCards[index].answer ?? 'na';
        int cardId = viewModel.questionCards[index].hashCode;
        cardState questionCardState =
            createCardState(index, questionCardStates);
        if (!questionCardVisibilityMap.containsKey(cardId)) {
          questionCardVisibilityMap[cardId] = true;
        }
        Visibility lineItem = buildQuestionFlipCard(
            question, answer, viewModel, cardId, questionCardState, index);
        questionCardWidgets.add(lineItem.child);
        print(lineItem.toStringShort());
        return lineItem;
      },
      itemCount: viewModel.questionCards.length,
    );
  }

  cardState createCardState(int index, List<cardState> cardStateList) {
    cardState questionCardState;
    if (cardStateList.isNotEmpty && cardStateList.length > index) {
      questionCardState = cardStateList[index];
    } else {
      questionCardState = new cardState();
      cardStateList.add(questionCardState);
    }
    return questionCardState;
  }

  Visibility buildAnsFlipCard(cardState answerCardState, String question,
      String answer, FlashCardViewModel viewModel, int cardId, int index) {
    FlipCard thisFlipCard = new FlipCard(
        key: answerCardState.myKey,
        onFlip: () => answerCardState.updateCardIsFlipped(),
        front: Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10, primary: Colors.white),
                child: Text(answer, style: TextStyle(color: Colors.indigo, fontSize:18)))),
        back: Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                child: Text(isStartGame ? answer : question, style: TextStyle(color: Colors.black, fontSize:18)))),
        onFlipDone: (status) {
          print("status  ------  $status");
          if (status) {
            viewModel.setSelectedAnswer(cardId, index);
            if (viewModel.selectedQuestionId == cardId) {
              print("^^^^^^^^^^^^^Correct answer selected");
              //viewModel.reShuffleCards();
              questionCardVisibilityMap[cardId] = false;
              answerCardVisibilityMap[cardId] = false;
              //rebuildAllChildren(context);
              resetFlashCardsState();
              viewModel.notifyListeners();
            }
          }
        });
    //answerCardState.myFlipCard = thisFlipCard;

    Visibility answerVisibility = Visibility(
        child: thisFlipCard, visible: answerCardVisibilityMap[cardId]);
    //answerCardState.myFlipCard = answerVisibility;
    return answerVisibility;
  }

  Visibility buildQuestionFlipCard(
      String question,
      String answer,
      FlashCardViewModel viewModel,
      int cardId,
      cardState cardState,
      int index) {
    FlipCard thisFlipCard = new FlipCard(
        key: cardState.myKey,
        onFlip: () => cardState.updateCardIsFlipped(),
        front: Container(
            child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: kColorSkylineWhite),
          child: Text(question, style: TextStyle(color: Colors.black, fontSize: 18)),
        )),
        back: Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: kColorSkylineWhite),
            child: Text(isStartGame ? question : answer,
                style: TextStyle(color: Colors.indigo,fontSize: 18)),
          ),
        ),
        onFlipDone: (status) {
          print("status  ------  $status");
          if (status) {
            viewModel.setSelectedQuestion(cardId, index);
          }
        });

    //return Visibility(child: thisFlipCard,
    //  visible: questionCardVisibilityMap[cardId]
    //);

    Visibility questionVisibility = Visibility(
        child: thisFlipCard, visible: questionCardVisibilityMap[cardId]);
    //cardState.myFlipCard = questionVisibility;
    return questionVisibility;
  }

  // Turns all the flash cards to the side of the questions
  void resetFlashCardsState() {
    questionCardStates
        .forEach((cardState cardState) => {cardState.resetCard()});
    answerCardStates.forEach((cardState cardState) => {cardState.resetCard()});
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }
}

class cardState {
  GlobalKey<FlipCardState> myKey = new GlobalKey<FlipCardState>();
  bool cardIsFlipped = false;
  //bool myVisibility = true;
  //Visibility myFlipCard;

  void updateCardIsFlipped() => cardIsFlipped = !cardIsFlipped;

  // void setVisibility (bool visible) {
  // myVisibility = visible;
  //myFlipCard.
  //}

  void resetCard() {
    if (cardIsFlipped) {
      myKey.currentState.toggleCard();
    }
  }
}
