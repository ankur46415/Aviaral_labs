import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/user_bloc.dart';
import '../blocs/user_event.dart';
import '../blocs/user_state.dart';
import '../widgets/user_card.dart';
import '../widgets/search_field.dart';
import '../widgets/state_widgets.dart';
import 'user_detail_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<UserBloc>().add(const FetchUsers());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<UserBloc>().add(const LoadMoreUsers());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Directory'),
        actions: [
          IconButton(
            onPressed: () => context.read<UserBloc>().add(const FetchUsers(isRefresh: true)),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchField(
              hintText: 'Search users by name...',
              onChanged: (query) {
                context.read<UserBloc>().add(SearchUsers(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                switch (state.status) {
                  case UserStatus.initial:
                    return const SizedBox.shrink();
                  case UserStatus.loading:
                    return const LoadingStateWidget();
                  case UserStatus.error:
                    return ErrorStateWidget(
                      message: state.error ?? 'Unknown error',
                      onRetry: () => context.read<UserBloc>().add(const FetchUsers()),
                    );
                  case UserStatus.empty:
                    return const EmptyStateWidget();
                  case UserStatus.success:
                    if (state.displayedUsers.isEmpty) {
                      return const EmptyStateWidget();
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                      itemCount: state.hasReachedMax
                          ? state.displayedUsers.length
                          : state.displayedUsers.length + 1,
                      itemBuilder: (context, index) {
                        if (index >= state.displayedUsers.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final user = state.displayedUsers[index];
                        return UserCard(
                          user: user,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailPage(user: user),
                              ),
                            );
                          },
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
