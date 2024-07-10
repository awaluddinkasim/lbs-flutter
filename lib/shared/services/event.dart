import 'package:locomotive21/models/event.dart';
import 'package:locomotive21/shared/utils/dio.dart';

class EventService {
  Future<List<Event>> getEvents() async {
    final result = await Request.get('/events');

    List<Event> events = [];

    for (var event in result['events']) {
      events.add(Event.fromJson(event));
    }

    return events;
  }

  Future<List<Event>> searchEvents(String keyword) async {
    final result = await Request.get('/events/search?keyword=$keyword');

    List<Event> events = [];

    for (var event in result['events']) {
      events.add(Event.fromJson(event));
    }

    return events;
  }
}
