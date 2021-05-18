public class Exercise {
  String name, short_description, description, setsreps;
  float calories, time;

  public Exercise(String name, float calories, float time, String setsreps, String description) {
    this.name = name;
    this.calories = calories;
    this.time = time;
    this.setsreps = setsreps;
    short_description = description;
  }
}

void create_exercises(ArrayList<Exercise> exercises) {
  exercises.add(new Exercise("Lounges", 200, 20, "20x4", "Lower body workout"));
  exercises.get(0).description = "From a standing position, take \na big step forwards with \none leg such that the your knee \nalmost touches the ground.";
  
  exercises.add(new Exercise("Squats", 250, 20, "25x5", "Lower body workout"));
  exercises.get(1).description = "Stand with your feet\npointing forwards, then make a\nsitting motion until your knees\nare at 90°, then stand\nback up again.";
  
  exercises.add(new Exercise("Pushups", 300, 15, "10x4", "Upper body workout"));
  exercises.get(2).description = "Start by lying on your\nstomach, then place your thumbs\nat your shoulders. Push your body\nup with your arms slowly, then\nback down again without touching\n the ground with your chest.";
  
  exercises.add(new Exercise("Pullups", 350, 15, "8x3", "Arm workout"));
  exercises.get(3).description = "Grab the bar at shoulder width,\nthen proceed to lift yourself\nto chin height using only your\narms and back. An elastic band\ncan be used if the\nexercise is hard.";
  
  exercises.add(new Exercise("HIIT run", 300, 15, "10x5", "Cardio"));
  exercises.get(4).description = "From a slow run, take intervals\nof 1 minute where you run as\nfast as you can, with 1 minute\nbreaks.";
  
  exercises.add(new Exercise("Box jumps", 350, 25, "20x4", "Lower body workout"));
  exercises.get(5).description = "From a squatting position,\njump on top of the box,\nthen jump back down again.";
  
  exercises.add(new Exercise("Sit-ups", 200, 20, "30x5", "Core workout"));
  exercises.get(6).description = "Laying flat on your back\nwith your legs in a 90°angle,\nslowly lift your upper body\ntowards your legs while flexing\nyour stomach.";
}
