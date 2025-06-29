import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_statemanagements/screens/movie_screens/upcoming_movies_screen.dart';
import 'package:mvvm_statemanagements/service/init_getit.dart';
import 'package:mvvm_statemanagements/service/navigation_service.dart';
import 'package:mvvm_statemanagements/view_models/movies/upcoming/upcoming_movies_bloc.dart';
import 'package:mvvm_statemanagements/widgets/my_error_widget.dart';

class UpcomingMoviesLoadScreen extends StatelessWidget {
  const UpcomingMoviesLoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesBloc = getIt<UpcomingMoviesBloc>();
    final navigationService = getIt<NavigationService>();

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<UpcomingMoviesBloc, UpcomingMoviesState>(
            bloc: moviesBloc..add(FetchUpcomingMoviesEvent()),
            listener: (context, state) {
              if (state is UpcomingMoviesLoadedState) {
                navigationService.navigateReplace(const UpcomingMoviesScreen());
              } else if (state is UpcomingMoviesErrorState) {
                navigationService.showSnackbar(state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<UpcomingMoviesBloc, UpcomingMoviesState>(
          bloc: moviesBloc..add(FetchUpcomingMoviesEvent()),
          builder: (context, state) {
            if (state is UpcomingMoviesLoadedState) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Loading..."),
                    SizedBox(height: 20),
                    CircularProgressIndicator.adaptive(),
                  ],
                ),
              );
            } else if (state is UpcomingMoviesErrorState) {
              return MyErrorWidget(
                errorText: state.message,
                retryFunction: () {
                  moviesBloc.add(FetchUpcomingMoviesEvent());
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
