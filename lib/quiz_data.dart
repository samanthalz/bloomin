// lib/quiz_data.dart
// ─────────────────────────────────────────────────────────────────────────────
// Hard‑coded menstrual‑wellness quizzes
// ─────────────────────────────────────────────────────────────────────────────

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correct; // 0‑based index

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correct,
  });
}

class Quiz {
  final String title;
  final List<QuizQuestion> questions;

  const Quiz({required this.title, required this.questions});
}

/// 10 quizzes × 5 questions each
List<Quiz> quizList = [
  // 1 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Menstrual Basics',
    questions: [
      QuizQuestion(
        question: 'What is the average length of a menstrual cycle?',
        options: ['14 days', '21–35 days', '40–50 days', '60+ days'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Day 1 of the cycle begins with…',
        options: ['Ovulation', 'Menstruation', 'Luteal phase', 'Implantation'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Which organ sheds its lining during menstruation?',
        options: ['Ovary', 'Uterus', 'Cervix', 'Vagina'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'A normal period lasts about…',
        options: ['1 day', '3–7 days', '10 days', '2 weeks'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Primary component of menstrual blood is…',
        options: ['Urine', 'Digestive fluids', 'Endometrial tissue', 'Sweat'],
        correct: 2,
      ),
    ],
  ),

  // 2 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Hormones & Phases',
    questions: [
      QuizQuestion(
        question: 'Which hormone peaks just before ovulation?',
        options: ['LH', 'Progesterone', 'Insulin', 'Cortisol'],
        correct: 0,
      ),
      QuizQuestion(
        question: 'The luteal phase is dominated by…',
        options: ['Estrogen', 'Progesterone', 'FSH', 'Adrenaline'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Ovulation typically occurs around day…',
        options: ['7', '14', '21', '28'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'FSH stands for…',
        options: [
          'Follicle Stimulating Hormone',
          'Female Safety Hormone',
          'Fetal Support Hormone',
          'Follicle Secure Helper'
        ],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Drop in progesterone triggers…',
        options: ['Pregnancy', 'Menstruation', 'Ovulation', 'Breast milk'],
        correct: 1,
      ),
    ],
  ),

  // 3 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Period Symptoms & PMS',
    questions: [
      QuizQuestion(
        question: 'PMS stands for…',
        options: [
          'Post‑Menstrual Syndrome',
          'Pre‑Menstrual Syndrome',
          'Peri‑Menopausal Stage',
          'Painful Menstrual Situation'
        ],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Which vitamin is often used to ease PMS symptoms?',
        options: ['Vitamin A', 'Vitamin B6', 'Vitamin K', 'Vitamin B12'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Primary dysmenorrhea means…',
        options: [
          'Painful periods with no underlying disease',
          'Periods after childbirth',
          'Bleeding between periods',
          'Irregular cycles due to PCOS'
        ],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Which activity can reduce menstrual cramps?',
        options: ['Marathon run', 'Gentle yoga', 'Deep‑fried snacks', 'Smoking'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Prostaglandins cause…',
        options: ['Uterine contractions', 'Hair growth', 'Bone loss', 'Eye color'],
        correct: 0,
      ),
    ],
  ),

  // 4 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Period Hygiene',
    questions: [
      QuizQuestion(
        question: 'How often should a pad be changed?',
        options: ['Every 2–4 h', 'Every 12 h', 'Once a day', 'Never'],
        correct: 0,
      ),
      QuizQuestion(
        question: 'TSS stands for…',
        options: [
          'Toxic Shock Syndrome',
          'Total Stress Score',
          'Tissue Shedding Stage',
          'Tampon Safety Standard'
        ],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Which is a reusable menstrual product?',
        options: ['Tampon', 'Menstrual cup', 'Disposable pad', 'Pantyliner'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Best disposal of used pads:',
        options: [
          'Flush in toilet',
          'Wrap & bin with lid',
          'Burn outdoors',
          'Throw in street'
        ],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Menstrual cups are usually made of…',
        options: ['Glass', 'Silicone', 'Plastic', 'Latex paint'],
        correct: 1,
      ),
    ],
  ),

  // 5 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Nutrition & Diet',
    questions: [
      QuizQuestion(
        question: 'Which mineral helps reduce cramps?',
        options: ['Magnesium', 'Sodium', 'Chloride', 'Lead'],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Which food is rich in iron?',
        options: ['Chips', 'Spinach', 'Candy', 'Soda'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Best drink for bloating?',
        options: ['Sugary soda', 'Warm water', 'Energy drink', 'Strong coffee'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'High sugar intake can…',
        options: ['Improve mood', 'Worsen PMS', 'Stop bleeding', 'Cause pregnancy'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Omega‑3 fatty acids can…',
        options: ['Reduce inflammation', 'Increase cramps', 'Cause TSS', 'Stop ovulation'],
        correct: 0,
      ),
    ],
  ),

  // 6 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Exercise & Cycle',
    questions: [
      QuizQuestion(
        question: 'Best low‑impact exercise during cramps:',
        options: ['Box jumps', 'Child’s pose yoga', 'Sprint', 'Deadlift PR'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Exercise can ______ period pain.',
        options: ['Increase', 'Reduce', 'Cause', 'Have no effect'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'High‑intensity workouts are ideal in…',
        options: ['Menstrual phase', 'Follicular/ovulation', 'Luteal phase', 'Never'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Staying hydrated during exercise prevents…',
        options: ['Cramps', 'Sweating', 'Breathing', 'Hair loss'],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Gentle stretching can…',
        options: ['Worsen cramps', 'Relieve tension', 'Break bones', 'Stop bleeding'],
        correct: 1,
      ),
    ],
  ),

  // 7 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Cycle Tracking',
    questions: [
      QuizQuestion(
        question: 'Tracking helps predict…',
        options: ['Weather', 'Fertile window', 'Lottery numbers', 'Phone battery'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Basal body temperature ______ at ovulation.',
        options: ['Drops', 'Spikes', 'Disappears', 'Remains same'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Cervical mucus is egg‑white like when…',
        options: ['Not fertile', 'Fertile', 'Pregnant', 'Menopausal'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Which app feature is useful?',
        options: [
          'Cycle reminders',
          'Random alarms',
          'Spam emails',
          'None of these'
        ],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Best time to log symptoms?',
        options: ['Yearly', 'Daily', 'Never', 'When sick'],
        correct: 1,
      ),
    ],
  ),

  // 8 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Myths & Facts',
    questions: [
      QuizQuestion(
        question: 'Swimming on your period is…',
        options: ['Unsafe', 'Safe with protection', 'Illegal', 'Impossible'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'You can get pregnant on your period:',
        options: ['Never', 'Sometimes', 'Always', 'Only at night'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Drinking cold water stops periods:',
        options: ['True', 'False', 'Sometimes', 'Only in winter'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'PMS is “all in the mind”:',
        options: ['True', 'False', 'Maybe', 'Only for teens'],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Menstrual blood is…',
        options: ['Dirty/toxic', 'Normal body fluid', 'Poisonous', 'Blue'],
        correct: 1,
      ),
    ],
  ),

  // 9 ─────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Disorders & Conditions',
    questions: [
      QuizQuestion(
        question: 'PCOS stands for…',
        options: [
          'Polycystic Ovary Syndrome',
          'Post‑Cycle Ovarian Stage',
          'Painful Cyst On Skin',
          'Pre‑Cycle Oxidation'
        ],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Endometriosis tissue grows…',
        options: [
          'Only inside uterus',
          'Outside uterus',
          'In bladder',
          'In lungs'
        ],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Amenorrhea means…',
        options: ['No periods', 'Heavy bleeding', 'Light flow', 'Painful flow'],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Menorrhagia is…',
        options: [
          'Light bleeding',
          'Heavy/prolonged bleeding',
          'No bleeding',
          'Spotting'
        ],
        correct: 1,
      ),
      QuizQuestion(
        question: 'Primary care for severe cramps is usually…',
        options: ['NSAIDs', 'Antibiotics', 'Insulin', 'Chemotherapy'],
        correct: 0,
      ),
    ],
  ),

  // 10 ────────────────────────────────────────────────────────────────────────
  Quiz(
    title: 'Emotional Well‑being',
    questions: [
      QuizQuestion(
        question: 'Which hormone is linked to mood swings?',
        options: ['Progesterone', 'Melatonin', 'Insulin', 'Testosterone'],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Mindfulness can help reduce…',
        options: ['PMS anxiety', 'Bone density', 'Skin color', 'Foot size'],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Regular sleep affects…',
        options: [
          'PMS emotional symptoms',
          'Menstrual color',
          'Finger length',
          'Eye color'
        ],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Which practice helps stress?',
        options: [
          'Deep breathing',
          'Junk food',
          'Caffeine overload',
          'Screen time at 3 AM'
        ],
        correct: 0,
      ),
      QuizQuestion(
        question: 'Support groups can provide…',
        options: ['Isolation', 'Guidance & empathy', 'Pain', 'Confusion'],
        correct: 1,
      ),
    ],
  ),
];
