import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skyline_template_app/model/FlashCard.dart';
import 'package:skyline_template_app/viewmodels/flash_card_viewmodel.dart';
import 'package:skyline_template_app/core/utilities/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlashCardView extends StatelessWidget {
  List<cardState> questionCardStates = [];
  List<cardState> answerCardStates = [];
  List<FlipCard> questionCardWidgets = [];
  List<FlipCard> answerCardWidgets = [];
  Map<int, bool> questionCardVisibilityMap = Map();
  Map<int, bool> answerCardVisibilityMap = Map();

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
              height: 25,
            ),
            Container(
              width: 200,
              color: kColorSkylineDarkGrey,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final question =
                      viewModel.questionCards[index].question ?? 'na';
                  final answer = viewModel.questionCards[index].answer ?? 'na';
                  int cardId = viewModel.questionCards[index].hashCode;
                  cardState questionCardState = createCardState(index,
                      questionCardStates);
                  if (!questionCardVisibilityMap.containsKey(cardId))
                  {
                    questionCardVisibilityMap[cardId] = true;
                  }
                  Visibility lineItem = buildQuestionFlipCard(
                      question, answer, viewModel, cardId, questionCardState, index);
                  questionCardWidgets.add(lineItem.child);
                  print(lineItem.toStringShort());
                  return lineItem;
                },
                itemCount: viewModel.questionCards.length,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: 200,
              color: kColorSkylineDarkGrey,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  //List<Flashcard> localCardsList = viewModel.flashcards;
                  final question =
                      viewModel.answerCards[index].question ?? 'na';
                  //final question =  '** Guess **';
                  final answer = viewModel.answerCards[index].answer ?? 'na';
                  int cardId = viewModel.answerCards[index].hashCode;
                  cardState answerCardState =
                  createCardState(index, answerCardStates);
                  //answerCardStates.add(answerCardState);
                  if (!answerCardVisibilityMap.containsKey(cardId))
                  {
                    answerCardVisibilityMap[cardId] = true;
                  }
                  Visibility lineItem = buildAnsFlipCard(answerCardState,
                      question, answer, viewModel, cardId, index);
                  answerCardWidgets.add(lineItem.child);
                  return lineItem;
                },
                itemCount: viewModel.answerCards.length,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    viewModel.routeToMenuView();
                  },
                  style: ElevatedButton.styleFrom(primary: kColorOrange),
                  child:
                  Text('Return to Menu page', style: TextStyle(color: kColorSkylineWhite)),
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

  cardState createCardState(int index, List<cardState> cardStateList) {
    cardState questionCardState;
    if (cardStateList.isNotEmpty &&
        cardStateList.length > index) {
      questionCardState = cardStateList[index];
    }
    else {
      questionCardState = new cardState();
      cardStateList.add(questionCardState);
    }
    return questionCardState;
  }

  Visibility buildAnsFlipCard(cardState answerCardState, String question,
      String answer, FlashCardViewModel viewModel, int cardId, int index) {
    FlipCard thisFlipCard =    new FlipCard(
        key: answerCardState.myKey,
        onFlip: () => answerCardState.updateCardIsFlipped(),
        front: Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 10,
                    primary: Colors.white),
                child: Text(question,
                    style: TextStyle(color: Colors.black)))),
        back: Container(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey),
                child: Text(answer,
                    style: TextStyle(color: kColorLightOrange)))),
        onFlipDone: (status) {
          print("status  ------  $status");
          if (status) {
            viewModel.setSelectedAnswer(cardId, index);
            if (viewModel.selectedQuestionId == cardId) {
              print("^^^^^^^^^^^^^Correct answer selected");
              //viewModel.reShuffleCards();
              //questionCardStates[viewModel.selectedQuestionIndex].setVisibility(false);
              //answerCardStates[viewModel.selectedAnswerIndex].setVisibility(false);
              questionCardVisibilityMap[cardId] = false;
              answerCardVisibilityMap[cardId] = false;
              //rebuildAllChildren(context);
              resetFlashCardsState();
              viewModel.notifyListeners();
            }

          }
        });
    //answerCardState.myFlipCard = thisFlipCard;

    Visibility answerVisibility = Visibility(child: thisFlipCard,
        visible: answerCardVisibilityMap[cardId]
    );
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
    FlipCard thisFlipCard =  new FlipCard(
        key: cardState.myKey,
        onFlip: () => cardState.updateCardIsFlipped(),
        front: Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: kColorSkylineWhite),
              child: Text(question, style: TextStyle(color: Colors.black)),
            )),
        back: Container(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: kColorSkylineWhite),
            child: Text(answer, style: TextStyle(color: kColorLightOrange)),
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

    Visibility questionVisibility = Visibility(child: thisFlipCard,
        visible: questionCardVisibilityMap[cardId]
    );
    //cardState.myFlipCard = questionVisibility;
    return questionVisibility;
  }

  // Turns all the flash cards to the side of the questions
  void resetFlashCardsState() {
    questionCardStates.forEach((cardState cardState) => {
      cardState.resetCard()
    });
    answerCardStates.forEach((cardState cardState) => {
      cardState.resetCard()
    });
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
