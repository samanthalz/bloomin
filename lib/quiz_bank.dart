// Hard‑coded quizzes on menstrual wellness
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correct;
  QuizQuestion(this.question, this.options, this.correct);
}

class Quiz {
  final String title;
  final List<QuizQuestion> questions;
  Quiz(this.title, this.questions);
}

final quizBank = <Quiz>[
  Quiz(
    'Basics of Menstruation',
    [
      QuizQuestion('How long is a typical menstrual cycle?',
          ['10–15 days', '21–35 days', '40–50 days', '60+ days'], 1),
      QuizQuestion('Average period length?',
          ['1–3 days', '3–7 days', '8–12 days', '14 days'], 1),
      QuizQuestion('Which hormone triggers ovulation?',
          ['Insulin', 'LH', 'Cortisol', 'Adrenaline'], 1),
      QuizQuestion('First day of bleeding marks the start of which phase?',
          ['Follicular', 'Luteal', 'Ovulation', 'Secretory'], 0),
      QuizQuestion('Normal blood loss per cycle is about…',
          ['< 20 ml', '30–80 ml', '> 120 ml', '200 ml'], 1),
    ],
  ),

  Quiz(
    'Period Symptoms & Care',
    [
      QuizQuestion('Primary dysmenorrhea means…', [
        'Painful periods without underlying disease',
        'Pain from fibroids',
        'Endometriosis‑related pain',
        'Infection‑related pain'
      ], 0),
      QuizQuestion('Which vitamin may reduce cramps?',
          ['Vitamin C', 'Vitamin D', 'Vitamin K', 'Vitamin B12'], 1),
      QuizQuestion('Best exercise during menstruation:',
          ['Intense HIIT', 'Gentle yoga', 'Marathon', 'No movement'], 1),
      QuizQuestion('PMS stands for…', [
        'Post‑menstrual syndrome',
        'Pre‑menstrual syndrome',
        'Pre‑menopausal stage',
        'Post‑menopausal stage'
      ], 1),
      QuizQuestion('Common craving before period:',
          ['Salty snacks', 'Celery', 'Grapefruit', 'Tofu'], 0),
    ],
  ),

  // ---------- 8 more quick quizzes ----------
  Quiz('Hormonal Overview', [
    QuizQuestion('Main hormone in the luteal phase?',
        ['Estrogen', 'Progesterone', 'Prolactin', 'Oxytocin'], 1),
    QuizQuestion('FSH stands for…',
        ['Follicle Stimulating Hormone', 'Fast Serum Hormone', 'Fetal Stage Hormone', 'Final Stage Hemoglobin'], 0),
    QuizQuestion('Estrogen peaks around…',
        ['Day 1', 'Ovulation', 'Mid‑luteal', 'Day 28'], 1),
    QuizQuestion('Progesterone prepares the uterus for…',
        ['Ovulation', 'Fertilized egg', 'Menstruation', 'Lactation'], 1),
    QuizQuestion('High prolactin mainly affects…',
        ['Breast milk production', 'Hair growth', 'Vision', 'Bone density'], 0),
  ]),
  Quiz('Hygiene Products', [
    QuizQuestion('Tampons must be changed every…',
        ['2–8 h', '12 h', '24 h', '48 h'], 0),
    QuizQuestion('TSS stands for…',
        ['Toxic Shock Syndrome', 'Total Stress Score', 'Tissue Shedding Stage', 'Tampon Safety Standard'], 0),
    QuizQuestion('A menstrual cup is made of…',
        ['Glass', 'Silicone', 'Latex only', 'Plastic'], 1),
    QuizQuestion('Reusable cloth pads can last up to…',
        ['1 cycle', '6 months', '2–5 years', '10 years'], 2),
    QuizQuestion('Best storage for clean pads:',
        ['Damp bag', 'Dry pouch', 'Plastic wrap', 'Direct sunlight'], 1),
  ]),
  Quiz('Nutrition & Cycle', [
    QuizQuestion('Iron‑rich food to take after period?',
        ['Spinach', 'Candy', 'Soda', 'Chips'], 0),
    QuizQuestion('Which drink helps bloating?',
        ['Carbonated soda', 'Water', 'Energy drink', 'Strong coffee'], 1),
    QuizQuestion('Magnesium may reduce…',
        ['Hair loss', 'Cramps', 'Fever', 'Snoring'], 1),
    QuizQuestion('High sugar intake can worsen…',
        ['PMS mood', 'Hair color', 'Foot size', 'Height'], 0),
    QuizQuestion('Which seed is good for hormonal balance?',
        ['Sunflower', 'Pumpkin', 'Both', 'None'], 2),
  ]),
  Quiz('Cycle Phases', [
    QuizQuestion('Ovulation usually occurs on day…',
        ['3', '7', '14', '28'], 2),
    QuizQuestion('Luteal phase length is typically…',
        ['1–3 days', '9–16 days', '30 days', 'Varies wildly'], 1),
    QuizQuestion('Follicular phase starts with…',
        ['Ovulation', 'Menstruation', 'Fertilization', 'Implantation'], 1),
    QuizQuestion('Endometrium thickens during…',
        ['Follicular', 'Menstruation', 'At all times', 'Never'], 0),
    QuizQuestion('If no pregnancy, progesterone…',
        ['Increases', 'Drops', 'Stays same', 'Converts to estrogen'], 1),
  ]),
  Quiz('Medical Terms', [
    QuizQuestion('Amenorrhea means…',
        ['Irregular bleeding', 'No periods', 'Heavy flow', 'Painful flow'], 1),
    QuizQuestion('Menorrhagia is…',
        ['Light flow', 'Heavy/prolonged bleeding', 'Short cycle', 'None'], 1),
    QuizQuestion('Endometriosis tissue grows…',
        ['Inside uterus only', 'Outside uterus', 'In ovaries only', 'In lungs'], 1),
    QuizQuestion('PCOS stands for…',
        ['Polycystic Ovary Syndrome', 'Post‑Cycle Ovary Strain', 'Pre‑Cycle Ovarian Stage', 'Prolonged Cyst Ovary'], 0),
    QuizQuestion('Primary care for severe cramps:',
        ['Ignore', 'NSAIDs', 'Antibiotics', 'Insulin'], 1),
  ]),
  Quiz('Myths & Facts', [
    QuizQuestion('Swimming on your period is…',
        ['Unsafe', 'Fine with protection', 'Forbidden', 'Impossible'], 1),
    QuizQuestion('You can get pregnant on your period:',
        ['Never', 'Sometimes', 'Always', 'Only at night'], 1),
    QuizQuestion('Drinking cold drinks stops bleeding:',
        ['True', 'False', 'Sometimes', 'Only with ice'], 1),
    QuizQuestion('PMS is “all in your head”:',
        ['Yes', 'No', 'Depends', 'Only in teens'], 1),
    QuizQuestion('Cycle syncing workouts means…',
        ['Same workout daily', 'Adapting exercise to phases', 'Stopping exercise', 'None'], 1),
  ]),
  Quiz('Exercise & Periods', [
    QuizQuestion('Best low‑impact exercise during cramps:',
        ['Pilates', 'Sprint', 'Deadlift PR', 'Box jumping'], 0),
    QuizQuestion('Exercise can … period pain.',
        ['Increase', 'Reduce', 'Stop', 'Have no effect'], 1),
    QuizQuestion('High‑intensity workouts are ideal in … phase:',
        ['Menstrual', 'Follicular/Ovulation', 'Luteal', 'Any'], 1),
    QuizQuestion('Yoga pose “Child\'s Pose” helps…',
        ['Cramps', 'Hunger', 'Insomnia', 'Back acne'], 0),
    QuizQuestion('Staying hydrated during exercise prevents…',
        ['Cramps', 'Sweating', 'Breathing', 'None'], 0),
  ]),
  Quiz('Emotional Health', [
    QuizQuestion('Hormone linked to mood swings:',
        ['Cortisol', 'Progesterone', 'Dopamine', 'Melatonin'], 1),
    QuizQuestion('Journaling can help track…',
        ['Weather', 'Cycle patterns', 'TV shows', 'Stock market'], 1),
    QuizQuestion('Regular sleep can reduce…',
        ['PMS emotional symptoms', 'Eye color', 'Height', 'Nail length'], 0),
    QuizQuestion('Mindful breathing activates…',
        ['Sympathetic NS', 'Parasympathetic NS', 'Digestive enzymes', 'Bone growth'], 1),
    QuizQuestion('Best self‑care before period:',
        ['Avoid water', 'Balanced diet & rest', 'Skip meals', 'Heavy alcohol'], 1),
  ]),
  Quiz('Tracking & Apps', [
    QuizQuestion('Cycle tracking helps to predict…',
        ['Work deadlines', 'Fertile window', 'Haircuts', 'Weather'], 1),
    QuizQuestion('Basal body temperature … at ovulation.',
        ['Drops', 'Spikes', 'Disappears', 'Stays same'], 1),
    QuizQuestion('Digital period apps can remind…',
        ['Birthdays', 'Next period date', 'Cooking', 'Passwords'], 1),
    QuizQuestion('Cervical mucus becomes … when fertile.',
        ['Dry', 'Egg‑white like', 'Thick & clumpy', 'Bloody'], 1),
    QuizQuestion('Best time to log symptoms:',
        ['Randomly', 'Daily', 'Yearly', 'Never'], 1),
  ]),
];
