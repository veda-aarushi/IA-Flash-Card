import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:skyline_template_app/model/FlashCard.dart';

class EditCardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  //List<Teacher> teachers = [];
  List<String> lessonIds = [];
  String selectedLesson = "";
  List<Flashcard> flashcards = [];
  List<Flashcard> questionCards = [];
  List<Flashcard> answerCards = [];
  bool pageLoaded = false;

  Future init() async {
    print("Edit Cards ViewModel init()");
    setState(ViewState.Busy);
    try {
     fetchCardsFromDB();
      pageLoaded = true;
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);
  }

  List fetchCardsFromDB() {
    if (!pageLoaded == true)
    flashcards = [];
    lessonIds = [];
    readMapsFromDB(selectedLesson);
    //refreshCardsFromDB();
    //notifyListeners();
    return flashcards;
  }

  void addTeacher() {
    //var faker = new Faker();//this package generates fictitious info...
    //Teacher teacher = new Teacher(uid: 'xxx', firstName: faker.person.firstName(), lastName: faker.person.lastName(), nickName: 'Cool Teacher ', email: faker.internet.email() );
    //teachers.add(teacher);
    print('Adding teacher.firstName as a new teacher');
    loadFlashCardsFromDB();
    notifyListeners();
  }

  void setValue(int index) {
    //var faker = new Faker();//this package generates fictitious info...
    //Teacher teacher = new Teacher(uid: 'xxx', firstName: faker.person.firstName(), lastName: faker.person.lastName(), nickName: 'Cool Teacher ', email: faker.internet.email() );
    //teachers.add(teacher);
    print('setting value in setValue ${index}');
  }

  void routeToHomeView() {
    _navigationService.navigateTo(HomeViewRoute);
  }

  void loadFlashCardsFromDB() {
    print("inside load flashcards and Saving");

       FirebaseFirestore.instance
        .collection('flash_cards')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(" --- start collection names--- ");
        print('Found subcollection with id:' + doc.id);
        //print(doc["answer"]);
        //collections.forEach(collection => {
        //console.log('Found subcollection with id:', collection.id);
        //});
        print(" --- end collection names--- ");
      });
    });
  }



  void addCards(
      List<String> questionList, List<String> answerList) {
    print('inside Add cards to db ***************');
    Map<String, String> pairMap = new Map<String, String>();
    for (var i = 0; i < questionList.length; i++) {
      pairMap[questionList[i]] = answerList[i];
    }

    //FirebaseFirestore.instance.collection("flash_cards").document("deck1").setData(exercise.toMap());
    if (selectedLesson.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("flash_cards").doc(selectedLesson).set(
          {"sets": pairMap}, SetOptions(merge: true));
    }

    readMapsFromDB(selectedLesson);
    print ('Updated DB');
    notifyListeners();
  }

  void readMapsFromDB(String currentLesson) {
    Map<String, String> pairMapRead = new Map<String, String>();
    Map<String, dynamic> dynamicPairMap = new Map<String, dynamic>();
    Map<String, String> valueMap = new Map<String, String>();
    lessonIds = [];
    print("Started reading cards from DB");
    FirebaseFirestore.instance
        .collection('flash_cards')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print ('Adding ${doc.id} to the list ${lessonIds.length}');
        lessonIds.add(doc.id);
        if (currentLesson.isEmpty || currentLesson == "toBeSet") {
          currentLesson = doc.id;
        }
        //print('Processing subcollection with id:' + doc.id);
        print('currentLesson id:' + currentLesson);
        if (currentLesson.isNotEmpty && doc.id == currentLesson) {

          selectedLesson = currentLesson;
          print('Setting the selected lesson id:' + selectedLesson);


          //print('Found subcollection with id:' + doc.id);
          //pairMapRead = doc.data();
          pairMapRead = (doc.data() as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value?.toString()));
          dynamicPairMap = (doc.data() as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value));
          valueMap = (dynamicPairMap["sets"] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value?.toString()));

          //print(" --- end collection names pairMapRead length--- ${pairMapRead.length}");
          //print(" --- end collection pairMapRead toString ---" +
          //    pairMapRead.toString());
          //print(" --- end collection valueMap toString ---" +
          //    valueMap.toString());

          flashcards = [];
          valueMap.forEach((key, value) {
            //print("key  ------  " + key);
            //print("value  ------  " + value);

            flashcards.add(new Flashcard(key, value));
          });
          //print(" --- Populated Flash cards --- ${flashcards.length}");
          //refreshCardsFromDB();
        }
        //print(" --- Lesson Ids  from db --- " +  lessonIds.toString());
      });
      notifyListeners();
    });
  }
}
