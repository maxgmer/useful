class Activity {

  Activity(this._message) {
    _creationDate = DateTime.now().millisecondsSinceEpoch;
  }

  String _message;
  get message => _message;

  bool _activityCompleted;
  get activityCompleted => _activityCompleted;
  set activityCompleted (bool activityCompleted) => _activityCompleted = activityCompleted;

  //not in local, so always have to convert to local for displaying
  int _creationDate;
  get creationDate => _creationDate;
}
class ActivityFactory {
  static List<Activity> createActivity(List<Activity> activities, int pageId) {
    activities.add(Activity("Do 10 pushups: $pageId"));
    return activities;
  }
}