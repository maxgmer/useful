import 'package:useful_app/models/UserDataModel.dart';
import 'package:useful_app/models/SessionDataModel.dart';

class BaseBloc {
  final SessionDataModel sessionData = SessionDataModel();
  final UserDataModel userData = UserDataModel();

  BaseBloc();
}