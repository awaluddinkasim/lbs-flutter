import 'package:locomotive21/models/event.dart';
import 'package:locomotive21/shared/utils/dio.dart';

class EventService {
  Future<List<Event>> getEvents({required String token}) async {
    final result = await Request.get('/events', headers: {
      'Authorization': 'Bearer $token',
    });

    List<Event> events = [];

    for (var event in result['events']) {
      events.add(Event.fromJson(event));
    }

    return events;
  }

  Future<List<Event>> searchEvents(String keyword, {required String token}) async {
    final result = await Request.get('/events/search?keyword=$keyword', headers: {
      'Authorization': 'Bearer $token',
    });

    List<Event> events = [];

    for (var event in result['events']) {
      events.add(Event.fromJson(event));
    }

    return events;
  }
}
