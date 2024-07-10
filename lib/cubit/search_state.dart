import 'package:equatable/equatable.dart';
import 'package:locomotive21/models/event.dart';

class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Event> events;
  const SearchSuccess(this.events);

  @override
  List<Object> get props => [events];
}

class SearchFailed extends SearchState {
  final String message;

  const SearchFailed(this.message);

  @override
  List<Object> get props => [message];
}
