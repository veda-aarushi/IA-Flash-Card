import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/model/FlashCard.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:faker/faker.dart';

class FlashCardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  List<Flashcard> flashcards = [];
  List<Flashcard> questionCards = [];
  List<Flashcard> answerCards = [];

  bool pageLoaded = false;
  int selectedQuestionId = null;
  int selectedAnswerId = null;
  int selectedQuestionIndex = null;
  int selectedAnswerIndex = null;

  Future init() async {
    //print("FlashCard ViewModel init()");
    setState(ViewState.Busy);
    try {
      print('Before Generate flash cards list');
      _generateFlashCardsList(5);
      print('After Generate flash cards list');
      pageLoaded = true;
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);
  }

  List _generateFlashCardsList(int teacherCount) {
    if (!pageLoaded == true)
      //for (int i =0; i < teacherCount; i++){
      var faker = new Faker(); //this package generates fictitious info...
    //flashcards = new List<Flashcard> ();
    /*flashcards = [
      Flashcard(question: "Spanish: Hola", answer: "English: Hello"),
      Flashcard(question: "Spanish: Por favor", answer: "English: Please"),
      Flashcard(question: "Spanish: Gracias", answer: "English: Thank You"),
      Flashcard(question: "Spanish: Lo siento", answer: "English: Sorry"),
      Flashcard(
          question: "Spanish: Salud",
          answer: "English: Bless you (after someone sneezes)")
      // Flashcard(question: faker.lorem.sentence(), answer: faker.lorem.word())
    ];*/
    //flashcards.forEach((element) {print('${element.question}, ${element.answer}');});

    refreshCardsFromDB();

    return flashcards;
  }

  void refreshCardsFromDB() {
    if (questionCards.isNotEmpty) {
      questionCards.clear();
    }
    if (answerCards.isNotEmpty) {
      answerCards.clear();
    }

    questionCards.addAll(flashcards);
    answerCards.addAll(flashcards);
    reShuffleCards();
  }

  void reShuffleCards() {
    questionCards.shuffle();
    answerCards.shuffle();
  }

  void routeToMenuView() {
    _navigationService.navigateTo(MenuViewRoute);
  }

  void setSelectedQuestion(int id, int index) {
    print("setting selected question id ----$id");
    selectedQuestionId = id;
    selectedQuestionIndex = index;
  }

  void setSelectedAnswer(int id, int index) {
    print("setting selected answer id ----$id");
    selectedAnswerId = id;
    selectedAnswerIndex = index;
  }
}
