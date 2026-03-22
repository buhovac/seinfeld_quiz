import '../models/quiz_category.dart';
import 'quiz_config.dart';

const appQuizConfig = QuizConfig(
  appTitle: 'Seinfeld Quiz',
  masteryTitle: 'Fan Master Seinfeld',
  beginnerTitle: 'baby Seinfeld fan',
  quizSubjectName: 'Seinfeld',
  categories: [
    QuizCategory(
      id: 1,
      title: 'Characters',
      description: 'Jerry, George, Elaine, Kramer and the wider cast.',
    ),
    QuizCategory(
      id: 2,
      title: 'Episodes',
      description: 'Classic episodes, plots and memorable moments.',
    ),
    QuizCategory(
      id: 3,
      title: 'Quotes',
      description: 'Iconic lines and catchphrases.',
    ),
    QuizCategory(
      id: 4,
      title: 'Relationships',
      description: 'Dating disasters and social chaos.',
    ),
    QuizCategory(
      id: 5,
      title: 'Jobs & Life',
      description: 'Work, schemes and day-to-day nonsense.',
    ),
    QuizCategory(
      id: 6,
      title: 'Places & Objects',
      description: 'Monk’s, apartments and legendary objects.',
    ),
    QuizCategory(
      id: 7,
      title: 'Ultimate',
      description: 'Hardcore fan questions.',
    ),
  ],
);