import 'package:clean_arch_reso/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:clean_arch_reso/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NumberTriviaBloc(
        getConcreteNumberTrivia: sl(),
        getRandomNumberTrivia: sl(),
        inputConverter: sl(),
      ),
      child: MaterialApp(
          title: 'Number Trivia',
          theme: ThemeData(
              primaryColor: Colors.green[800], primarySwatch: Colors.green),
          home: NumberTriviaPage()),
    );
  }
}
