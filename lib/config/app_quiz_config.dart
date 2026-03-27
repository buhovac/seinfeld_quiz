import '../models/quiz_category.dart';
import 'quiz_config.dart';

const appQuizConfig = QuizConfig(
  appTitle: 'Python Quiz',
  masteryTitle: 'Python Master',
  beginnerTitle: 'Python beginner',
  quizSubjectName: 'Python',
  categories: [
    QuizCategory(
      id: 1,
      title: 'Basics',
      description: 'Syntax, variables, comments and expressions.',
    ),
    QuizCategory(
      id: 2,
      title: 'Data Structures',
      description: 'Lists, tuples, sets and dictionaries.',
    ),
    QuizCategory(
      id: 3,
      title: 'Control Flow',
      description: 'Conditions, loops and branching.',
    ),
    QuizCategory(
      id: 4,
      title: 'Functions & OOP',
      description: 'Functions, scope, classes and methods.',
    ),
    QuizCategory(
      id: 5,
      title: 'Advanced Python',
      description: 'Exceptions, decorators, iterators and deeper behavior.',
    ),
  ],
);