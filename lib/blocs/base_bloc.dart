import 'package:useful_app/models/user_data_model.dart';
import 'package:useful_app/models/session_data_model.dart';

class BaseBloc {
  final SessionDataModel sessionData = SessionDataModel();
  final UserDataModel userData = UserDataModel();

  BaseBloc();
}