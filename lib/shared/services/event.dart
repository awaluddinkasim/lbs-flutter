import 'package:locomotive21/models/event.dart';
import 'package:locomotive21/shared/utils/dio.dart';

class EventService {
  Future<List<Event>> getEvents() async {
    final result = await Request.get('/events');

    List<Event> events = [];

    for (var event in result['events']) {
      events.add(Event.fromJson(event));
    }

    print(events);

    return events;
  }
}
