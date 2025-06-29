import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mvvm_statemanagements/models/movies_genre.dart';

class TestingScreen extends StatelessWidget {
  const TestingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Texting Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final genre1 = MoviesGenre(id: 1, name: 'Action');
            final genre2 = MoviesGenre(id: 1, name: 'Action');
            log("Is genre1 is equal to genre1 ${genre1 == genre1}");
            log("Is genre2 is equal to genre2 ${genre2 == genre2}");
            log("Is genre1 is equal to genre2 ${genre1 == genre2}");
          },
          child: Text('press me'),
        ),
      ),
    );
  }
}
