import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/event_state.dart';
import 'package:locomotive21/shared/services/event.dart';

class EventCubit extends Cubit<EventState> {
  final EventService _eventService = EventService();

  EventCubit() : super(EventInitial());

  Future<void> getEvents() async {
    emit(EventLoading());

    try {
      final events = await _eventService.getEvents();

      emit(EventSuccess(events));
    } catch (e) {
      emit(EventFailed(e.toString()));
    }
  }
}
