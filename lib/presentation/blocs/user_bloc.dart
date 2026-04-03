import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user_entity.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  static const int itemsPerPage = 6;

  UserBloc({required this.userRepository}) : super(const UserState.initial()) {
    on<FetchUsers>(_onFetchUsers);
    on<LoadMoreUsers>(_onLoadMoreUsers);
    on<SearchUsers>(_onSearchUsers);
  }

  FutureOr<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(const UserState.loading());
    try {
      final users = await userRepository.fetchUsers();
      if (users.isEmpty) {
        emit(const UserState.empty());
      } else {
        final displayed = users.take(itemsPerPage).toList();
        emit(UserState.success(
          allUsers: users,
          displayedUsers: displayed,
          hasReachedMax: displayed.length >= users.length,
          searchQuery: '',
        ));
      }
    } catch (e, stackTrace) {
      print('DEBUG: UserBloc Fetch Error: $e');
      print('DEBUG: StackTrace: $stackTrace');
      emit(UserState.error(message: e.toString()));
    }
  }

  FutureOr<void> _onLoadMoreUsers(LoadMoreUsers event, Emitter<UserState> emit) {
    if (state.hasReachedMax) return null;

    final filtered = _getFilteredUsers(state.allUsers, state.searchQuery);
    final currentLength = state.displayedUsers.length;
    final nextLength = currentLength + itemsPerPage;

    final nextDisplayed = filtered.take(nextLength).toList();

    emit(state.copyWith(
      displayedUsers: nextDisplayed,
      hasReachedMax: nextDisplayed.length >= filtered.length,
    ));
  }

  FutureOr<void> _onSearchUsers(SearchUsers event, Emitter<UserState> emit) {
    final filtered = _getFilteredUsers(state.allUsers, event.query);

    if (filtered.isEmpty) {
      emit(state.copyWith(
        status: UserStatus.empty,
        displayedUsers: const [],
        searchQuery: event.query,
        hasReachedMax: true,
      ));
    } else {
      final displayed = filtered.take(itemsPerPage).toList();
      emit(state.copyWith(
        status: UserStatus.success,
        displayedUsers: displayed,
        searchQuery: event.query,
        hasReachedMax: displayed.length >= filtered.length,
      ));
    }
  }

  List<UserEntity> _getFilteredUsers(List<UserEntity> allUsers, String query) {
    if (query.isEmpty) return allUsers;
    return allUsers.where((user) => user.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
