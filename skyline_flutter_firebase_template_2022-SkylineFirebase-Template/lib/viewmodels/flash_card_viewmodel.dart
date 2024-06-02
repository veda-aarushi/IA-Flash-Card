import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/model/FlashCard.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:faker/faker.dart';

class FlashCardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  List<String> lessonIds = [];
  String selectedLesson = "";
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
      flashcards = [];
      lessonIds = [];
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
    readMapsFromDB(selectedLesson);
    //refreshCardsFromDB();

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
    notifyListeners();
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

  readMapsFromDB(String currentLesson) {
    Map<String, String> pairMapRead = new Map<String, String>();
    Map<String, dynamic> dynamicPairMap = new Map<String, dynamic>();
    Map<String, String> valueMap = new Map<String, String>();
    lessonIds = [];
    FirebaseFirestore.instance
        .collection('flash_cards')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        lessonIds.add(doc.id);
        if (currentLesson.isEmpty) {
          currentLesson = doc.id;
        }
        print('Processing subcollection with id:' + doc.id);
        print('currentLesson id:' + currentLesson);
        if (currentLesson.isNotEmpty && doc.id == currentLesson) {
          selectedLesson = currentLesson;
          print('Found subcollection with id:' + doc.id);
          //pairMapRead = doc.data();
          pairMapRead = (doc.data() as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value?.toString()));
          dynamicPairMap = (doc.data() as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value));
          valueMap = (dynamicPairMap["sets"] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value?.toString()));

          //print(" --- end collection names pairMapRead length--- ${pairMapRead.length}");
          print(" --- end collection pairMapRead toString ---" +
              pairMapRead.toString());
          print(" --- end collection valueMap toString ---" +
              valueMap.toString());

          flashcards = [];
          valueMap.forEach((key, value) {
            print("key  ------  " + key);
            print("value  ------  " + value);

            flashcards.add(new Flashcard(key, value));
          });
          print(" --- Populated Flash cards --- ${flashcards.length}");
          refreshCardsFromDB();
        }
        print(" --- Lesson Ids  from db --- " +  lessonIds.toString());
      });
    });
  }
}
