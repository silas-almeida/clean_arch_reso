import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(message: 'Start Searching!');
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Error) {
                    return MessageDisplay(message: state.errorMessage);
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: state.trivia,
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                    );
                  }
                },
              ),
              //TOP HALF
              const SizedBox(
                height: 20.0,
              ),
              //BOTTOM HALF
              const TriviaControlls()
            ],
          ),
        ),
      ),
    );
  }
}

