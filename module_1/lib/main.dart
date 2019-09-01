import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _questions = const [
    {
      'questionText': 'What\'s your favorit color?',
      'answers': [
        {'text': 'Black', 'score': 10},
        {'text': 'Red', 'score': 5},
        {'text': 'Green', 'score': '3'},
        {'text': 'White', 'score': 1}
      ]
    },
    {
      'questionText': 'What\'s your favorit animel?',
      'answers': [
        {'text': 'Rabbit', 'score': 1},
        {'text': 'Snake', 'score': 2},
        {'text': 'Elephent', 'score': 3},
        {'text': 'Lion', 'score': 4}
      ]
    },
    {
      'questionText': 'What\'s your favorit animel?',
      'answers': [
        {'text': 'Rabbit', 'score': 1},
        {'text': 'Snake', 'score': 2},
        {'text': 'Elephent', 'score': 3},
        {'text': 'Lion', 'score': 4}
      ]
    },
  ];

  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answrQuestion(int score) {
    _totalScore += score;
    setState(() {
      _questionIndex += 1;
    });

    if (_questionIndex < _questions.length) {
      print('we have more question');
    } else {
      print('we have no more question');
    }
    print(_questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answrQuestion,
                questionIndex: _questionIndex,
                questions: _questions,
              )
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
