// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:skyline_template_app/core/utilities/route_names.dart';
import 'package:skyline_template_app/model/Menu.dart';
import 'package:skyline_template_app/viewmodels/base_viewmodel.dart';
import 'package:skyline_template_app/core/enums/view_state.dart';
import 'package:skyline_template_app/core/services/navigation_service.dart';
import 'package:skyline_template_app/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuViewModel extends BaseViewModel {
  final  _navigationService = locator<NavigationService>();
  List<Menu> menuOptions = [];
  bool pageLoaded = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  Future init() async {
    print("Teacher ViewModel init()");
    setState(ViewState.Busy);
    try {
      _generateTeacherList(3);
      pageLoaded = true;
    } catch (e) {
      setState(ViewState.Error);
    }
    setState(ViewState.Idle);

  }

  List _generateTeacherList(int teacherCount) {
    if (!pageLoaded == true) {
      CollectionReference menuItemslist = FirebaseFirestore.instance.collection('menu_items');

      print("----------------getting from fireBase-------------------------");
      loadMenuFromDB();
      print("----------------Done getting from fireBase-------------------------");
      Menu currentItem;
      for (int i = 0; i < teacherCount; i++) {
        currentItem = new Menu(uid: 'xxx$i', menuItem: 'menu$i');
        menuOptions.add(currentItem);
      }

      currentItem = new Menu(uid: '4', menuItem: 'Memory Game');
      menuOptions.add(currentItem);

      currentItem = new Menu(uid: '5', menuItem: 'Teachers Page');
      menuOptions.add(currentItem);

      menuOptions.forEach((element) {
        print('${element.uid}, ${element.menuItem}');
      });
    }
    return menuOptions;
  }

  void loadMenuFromDB() {
    FirebaseFirestore.instance
        .collection('menu_items')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(" --- start fields--- ");
        print(doc["id"]);
        print(doc["menu_item"]);
        print(" --- end fields--- ");
      });
    });
  }
  /* void addTeacher(){
    var faker = new Faker();//this package generates fictitious info...
    Teacher teacher = new Teacher(uid: 'xxx', firstName: faker.person.firstName(), lastName: faker.person.lastName(), nickName: 'Cool Teacher ', email: faker.internet.email() );
    menuOptions.add(teacher);
    print('Adding ${teacher.firstName} as a new teacher');
    notifyListeners();
  }*/

  void routeToHomeView(){
    _navigationService.navigateTo(HomeViewRoute);
  }

  void routeToLoginPage() {
    _navigationService.navigateTo(LoginViewRoute);
  }

  void signOut ( ) {
    print ('signing out current user ') ;
    _firebaseAuth.signOut();
    routeToLoginPage();
  }
  void routeToMemGame(){
    _navigationService.navigateTo(FlashCardViewRoute);
  }

  void routeTeachersPage(){
    _navigationService.navigateTo(AddCardViewRoute);
  }

}