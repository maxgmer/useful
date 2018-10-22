class Event {

  Event(this._message) {
    _creationDate = DateTime.now().millisecondsSinceEpoch;
  }

  String _message;
  get message => _message;

  bool _eventCompleted;
  get eventCompleted => _eventCompleted;
  set eventCompleted (bool isCompleted) => _eventCompleted = eventCompleted;

  int _creationDate;
  get creationDate => _creationDate;
}
class EventFactory {
  static List<Event> createEvent(List<Event> events, int pageId) {
    events.add(Event("Do 10 pushups: $pageId"));
    return events;
  }
}