

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

  Activity.fromJson(Map<String, dynamic> json)
      : _activityCompleted = json['activityCompleted'],
        _difficulty = json['difficulty'],
        _pageId = json['pageId'],
        _message = json['message'];

  Map<String, dynamic> toJson() => {
    'pageId': _pageId,
    'difficulty': _difficulty,
    'message': _message,
    'activityCompleted': _activityCompleted
  };
}
class ActivityFactory {



  static List<Activity> addActivity(List<Activity> activities, int pageId, int difficulty) {
    var activity = Activity("Do 10 pushups!", pageId, difficulty);
    activities.add(activity);
    return activities;
  }
}