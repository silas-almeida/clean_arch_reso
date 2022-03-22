import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControlls extends StatefulWidget {
  const TriviaControlls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControlls> createState() => _TriviaControllsState();
}

class _TriviaControllsState extends State<TriviaControlls> {
  final controller = TextEditingController();
  String inputSTR = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputSTR = value;
          },
          onSubmitted: (_) {
            _addConcrete();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
              child: const Text('Search'),
              onPressed: _addConcrete,
            )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
              child: const Text('Get random trivia'),
              onPressed: _addRandom,
            ))
          ],
        )
      ],
    );
  }

  void _addConcrete() {
    controller.clear();
    context
        .read<NumberTriviaBloc>()
        .add(GetTriviaForConcreteNumber(numberString: inputSTR));
  }

  void _addRandom() {
    controller.clear();
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
  }
}