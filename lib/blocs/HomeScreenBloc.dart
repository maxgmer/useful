import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:useful_app/models/UserDataModel.dart';
import 'package:useful_app/models/SessionDataModel.dart';

class HomeScreenBloc {
  final SessionDataModel _sessionData = new SessionDataModel();
  final UserDataModel _userData = new UserDataModel();

  HomeScreenBloc() {

  }

  //read only for view, so we expose only Streams from these controllers
  final BehaviorSubject<int> _healthLvl = new BehaviorSubject<int>();
  final BehaviorSubject<int> _wealthLvl = new BehaviorSubject<int>();
  final BehaviorSubject<int> _loveLvl = new BehaviorSubject<int>();
  final BehaviorSubject<int> _happinessLvl = new BehaviorSubject<int>();

  Stream<int> get healthLvl => _healthLvl.stream;
  Stream<int> get wealthLvl => _wealthLvl.stream;
  Stream<int> get loveLvl => _loveLvl.stream;
  Stream<int> get happinessLvl => _happinessLvl.stream;



  final BehaviorSubject<int> _pageId = new BehaviorSubject<int>();

  Stream<int> get pageId => _pageId.stream;



  void dispose() {
    _healthLvl.close();
    _wealthLvl.close();
    _loveLvl.close();
    _happinessLvl.close();

    _pageId.close();
  }
}