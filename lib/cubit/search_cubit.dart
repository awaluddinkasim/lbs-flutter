import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/search_state.dart';
import 'package:locomotive21/shared/services/event.dart';

class SearchCubit extends Cubit<SearchState> {
  final _eventService = EventService();

  SearchCubit() : super(SearchInitial());

  void resetSearch() {
    emit(SearchInitial());
  }

  Future<void> search(String keyword) async {
    emit(SearchLoading());
    try {
      final events = await _eventService.searchEvents(keyword);

      emit(SearchSuccess(events));
    } catch (e) {
      emit(SearchFailed(e.toString()));
    }
  }
}
