import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_requests_event.dart';
import 'my_requests_state.dart';
import '../../domain/usecases/get_my_requests.dart';

class MyRequestsBloc extends Bloc<MyRequestsEvent, MyRequestsState> {
  final GetMyRequests getMyRequests;

  MyRequestsBloc({required this.getMyRequests}) : super(MyRequestsInitial()) {
    on<FetchMyRequests>(_onFetchMyRequests);
  }

  Future<void> _onFetchMyRequests(
      FetchMyRequests event,
      Emitter<MyRequestsState> emit,
      ) async {
    emit(MyRequestsLoading());
    try {
      final requests = await getMyRequests();
      emit(MyRequestsLoaded(requests));
    } catch (e) {
      emit(MyRequestsError(e.toString()));
    }
  }
}
