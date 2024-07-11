import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:locomotive21/cubit/search_state.dart';
import 'package:locomotive21/shared/services/event.dart';

FlutterSecureStorage storage = const FlutterSecureStorage();

class SearchCubit extends Cubit<SearchState> {
  final _eventService = EventService();

  SearchCubit() : super(SearchInitial());

  void resetSearch() {
    emit(SearchInitial());
  }

  Future<void> search(String keyword) async {
    emit(SearchLoading());
    try {
      final token = await storage.read(key: 'token');

      final events = await _eventService.searchEvents(keyword, token: token!);

      emit(SearchSuccess(events));
    } catch (e) {
      emit(SearchFailed(e.toString()));
    }
  }
}
