import 'dart:math';

class Activity {

  Activity(this._message, this._pageId, this._difficulty) {
    _creationDate = DateTime.now().millisecondsSinceEpoch;
    _activityCompleted = false;

    if (_difficulty != EASY_DIFFICULTY &&
    _difficulty != MEDIUM_DIFFICULTY &&
    _difficulty != HARD_DIFFICULTY &&
    _difficulty != CRAZY_DIFFICULTY) throw "Such activity difficulty does not exist";
  }

  final int _difficulty;
  get difficulty => _difficulty;

  static const EASY_DIFFICULTY = 1;
  static const MEDIUM_DIFFICULTY = 2;
  static const HARD_DIFFICULTY = 3;
  static const CRAZY_DIFFICULTY = 4;

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
    var activity = Activity("Do 10 pushups!", pageId, Random().nextInt(4) + 1);
    activity.activityCompleted = Random().nextBool();
    activities.add(activity);
    var activity1 = Activity("Do 200 pullups!", pageId, Random().nextInt(4) + 1);
    activity.activityCompleted = Random().nextBool();
    activities.add(activity1);
    var activity2 = Activity("Find a hobby which you would be ready to follow your whole life.", pageId, Random().nextInt(4) + 1);
    activity.activityCompleted = Random().nextBool();
    activities.add(activity2);
    var activity3 = Activity("Go to a place of your interest, where there is interaction with people.", pageId, Random().nextInt(4) + 1);
    activity.activityCompleted = Random().nextBool();
    activities.add(activity3);
    return activities;
  }
}