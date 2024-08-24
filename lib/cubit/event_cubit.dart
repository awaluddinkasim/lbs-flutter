import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:locomotive21/cubit/event_state.dart';
import 'package:locomotive21/shared/services/event.dart';

FlutterSecureStorage storage = const FlutterSecureStorage();

class EventCubit extends Cubit<EventState> {
  final EventService _eventService = EventService();

  EventCubit() : super(EventInitial());

  Future<void> getEvents() async {
    emit(EventLoading());

    try {
      final token = await storage.read(key: 'token');

      final events = await _eventService.getEvents(token: token!);

      emit(EventSuccess(events));
    } catch (e) {
      print(e);
      emit(EventFailed(e.toString()));
    }
  }
}
