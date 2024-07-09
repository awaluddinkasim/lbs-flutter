import 'package:equatable/equatable.dart';
import 'package:locomotive21/models/event.dart';

class EventState extends Equatable {
  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventSuccess extends EventState {
  final List<Event> events;

  EventSuccess(this.events);
}

class EventFailed extends EventState {
  final String message;

  EventFailed(this.message);
}
