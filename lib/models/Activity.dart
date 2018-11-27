import 'dart:math';

class Activity {

  Activity(this._message, this._pageId) {
    _creationDate = DateTime.now().millisecondsSinceEpoch;
    _activityCompleted = false;
  }

  final int _pageId;
  get pageId => _pageId;

  String _message;
  get message => _message;

  bool _activityCompleted;
  get activityCompleted => _activityCompleted;
  set activityCompleted(bool activityCompleted) => _activityCompleted = activityCompleted;

  //not in local, so always have to convert to local for displaying
  int _creationDate;
  get creationDate => _creationDate;
}
class ActivityFactory {
  static List<Activity> createActivity(List<Activity> activities, int pageId) {
    var activity = Activity("Do 10 pushups", pageId);
    activity.activityCompleted = Random().nextBool();
    activities.add(activity);
    return activities;
  }
}