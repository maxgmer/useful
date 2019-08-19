

class Activity {

  Activity(this._message, this._pageId, this._difficulty) {
    _creationDate = DateTime.now().millisecondsSinceEpoch;
    _activityCompleted = false;

    if (_difficulty != easyDifficulty &&
    _difficulty != mediumDifficulty &&
    _difficulty != hardDifficulty &&
    _difficulty != crazyDifficulty) throw "Such activity difficulty does not exist";
  }

  final int _difficulty;
  get difficulty => _difficulty;

  static const easyDifficulty = 1;
  static const mediumDifficulty = 2;
  static const hardDifficulty = 3;
  static const crazyDifficulty = 4;

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