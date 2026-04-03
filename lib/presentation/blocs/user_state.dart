import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum UserStatus { initial, loading, success, error, empty }

class UserState extends Equatable {
  final UserStatus status;
  final List<UserEntity> allUsers;
  final List<UserEntity> displayedUsers;
  final String? error;
  final bool hasReachedMax;
  final String searchQuery;

  const UserState({
    required this.status,
    this.allUsers = const [],
    this.displayedUsers = const [],
    this.error,
    this.hasReachedMax = false,
    this.searchQuery = '',
  });

  const UserState.initial()
      : status = UserStatus.initial,
        allUsers = const [],
        displayedUsers = const [],
        error = null,
        hasReachedMax = false,
        searchQuery = '';

  const UserState.loading()
      : status = UserStatus.loading,
        allUsers = const [],
        displayedUsers = const [],
        error = null,
        hasReachedMax = false,
        searchQuery = '';

  const UserState.success({
    required List<UserEntity> allUsers,
    required List<UserEntity> displayedUsers,
    required bool hasReachedMax,
    required String searchQuery,
  })  : status = UserStatus.success,
        allUsers = allUsers,
        displayedUsers = displayedUsers,
        error = null,
        hasReachedMax = hasReachedMax,
        searchQuery = searchQuery;

  const UserState.error({required String message, List<UserEntity> cachedUsers = const []})
      : status = UserStatus.error,
        allUsers = cachedUsers,
        displayedUsers = cachedUsers,
        error = message,
        hasReachedMax = true,
        searchQuery = '';

  const UserState.empty()
      : status = UserStatus.empty,
        allUsers = const [],
        displayedUsers = const [],
        error = null,
        hasReachedMax = true,
        searchQuery = '';

  UserState copyWith({
    UserStatus? status,
    List<UserEntity>? allUsers,
    List<UserEntity>? displayedUsers,
    String? error,
    bool? hasReachedMax,
    String? searchQuery,
  }) {
    return UserState(
      status: status ?? this.status,
      allUsers: allUsers ?? this.allUsers,
      displayedUsers: displayedUsers ?? this.displayedUsers,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, allUsers, displayedUsers, error, hasReachedMax, searchQuery];
}
