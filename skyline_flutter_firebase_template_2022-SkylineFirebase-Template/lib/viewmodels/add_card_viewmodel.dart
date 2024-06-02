import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/model/Teacher.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:faker/faker.dart';

class AddCardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  List<Teacher> teachers = [];
  bool pageLoaded = false;

  Future init() async {
    print("Teacher ViewModel init()");
    setState(ViewState.Busy);
    try {
      _generateTeacherList(5);
      pageLoaded = true;
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);
  }

  List _generateTeacherList(int teacherCount) {
    if (!pageLoaded == true)
      for (int i = 0; i < teacherCount; i++) {
        var faker = new Faker(); //this package generates fictitious info...
        Teacher teacher = new Teacher(
            uid: 'xxx$i',
            firstName: faker.person.firstName(),
            lastName: faker.person.lastName(),
            nickName: 'Cool Teacher $i',
            email: faker.internet.email());
        teachers.add(teacher);
      }
    /*teachers.forEach((element) {
      print('${element.firstName}, ${element.lastName}');
    });*/
    return teachers;
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

    //void SaveNestedData() {

    FirebaseFirestore.instance.collection("flash_cards").doc("deck1").set({
      "name": "lesson1",
      "sets": [
        {"question": "question1", "answer": "answer1"},
        {"question": "question2", "answer": "answer2"},
        {"question": "question3", "answer": "answer3"}
      ]
    });

    /*FirebaseFirestore.instance.collection("flash_cards").add({
      "name": "lesson1",
      "sets": [
        {"question": "question1", "answer": "answer1"},
        {"question": "question2", "answer": "answer2"},
        {"question": "question3", "answer": "answer3"}]
    });*/
    //}

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

  /*void addCards(
      List<String> questionList, List<String> answerList, String lessonId) {
      print('inside Add cards to db ***************');
    Map<String, String> qaMap = new Map<String, String>();
    Map<String, Map<String, String>> listQAMap = new Map<String, Map<String, String>>();
      for (var i = 0; i < questionList.length; i++) {
      //print ( "questionList[i]                 ---------------------------------------" + questionList[i]);
      //print ( "answerList[i]                 ---------------------------------------" + answerList[i]);
      //qaMap[questionList[i]] = answerList[i];
      qaMap["question"] = questionList[i];
      qaMap["answer"]= answerList[i];
      qaMap["id"]= Object.hash(questionList[i].hashCode, answerList[i].hashCode).toString();
      listQAMap.set(qaMap);
      qaMap = new Map<String, String>();
    }

    print ('pairMap                 --------------------------------------- ${qaMap.length}');
    //FirebaseFirestore.instance.collection("flash_cards").document("deck1").setData(exercise.toMap());
    FirebaseFirestore.instance
       .collection("flash_cards").doc(lessonId).set({"sets": listQAMap}, SetOptions(merge: true));

    print ('updated DB');

    Map<String, String> pairMapRead = new Map<String, String>();
    FirebaseFirestore.instance
        .collection('flash_cards')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(" --- start collection names--- ");
        print('Found subcollection with id:' + doc.id);
        if (doc.id == "Lesson1" || doc.id == "Lesson2" || doc.id == "Lesson3") {
          //pairMapRead = doc.data();
          pairMapRead = (doc.data() as Map<String, dynamic>).map(
                  (key, value) => MapEntry(key, value?.toString()));
          //collections.forEach(collection => {
          //console.log('Found subcollection with id:', collection.id);
          //});
          print(" --- end collection names pairMapRead length--- ${pairMapRead.length}");
          print(" --- end collection pairMapRead toString ---" + pairMapRead.toString());
        }
        print(" --- end collection names--- ");
      });
    });
  }*/



  void addCards(
      List<String> questionList, List<String> answerList, String lessonId) {
    print('inside Add cards to db ***************');
    Map<String, String> pairMap = new Map<String, String>();
    for (var i = 0; i < questionList.length; i++) {
      pairMap[questionList[i]] = answerList[i];
    }

    //FirebaseFirestore.instance.collection("flash_cards").document("deck1").setData(exercise.toMap());
    FirebaseFirestore.instance
        .collection("flash_cards").doc(lessonId).set({"sets": pairMap}, SetOptions(merge: true));

    print ('Updated DB');
  }
}
