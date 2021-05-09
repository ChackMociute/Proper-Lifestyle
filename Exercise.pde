public class Exercise {
  String name, short_description, description;
  float calories, time;

  public Exercise(String name, float calories, float time, String description) {
    this.name = name;
    this.calories = calories;
    this.time = time;
    short_description = description;
  }
}

void create_exercises(ArrayList<Exercise> exercises) {
  exercises.add(new Exercise("Lounges", 200, 20, "Leg workout"));
  exercises.get(0).description = "From a standing position, take \na big step forwards with \none leg such that the your knee \nalmost touches the ground.";
  
  exercises.add(new Exercise("Squats", 250, 20, "Leg workout"));
  exercises.get(1).description = "Description of the exercise\nAn animation too maybe";
  
  exercises.add(new Exercise("Push-ups", 300, 15, "Arm workout"));
  exercises.get(2).description = "Description of the exercise\nAn animation too maybe";
  
  exercises.add(new Exercise("Pull_ups", 350, 15, "Arm workout"));
  exercises.get(3).description = "Description of the exercise\nAn animation too maybe";
  
  exercises.add(new Exercise("HIIT run", 300, 15, "Cardio"));
  exercises.get(4).description = "Description of the exercise\nAn animation too maybe";
  
  exercises.add(new Exercise("Box jumps", 350, 25, "Legs and cardio"));
  exercises.get(5).description = "Description of the exercise\nAn animation too maybe";
  
  exercises.add(new Exercise("Bear claw", 200, 20, "Claw workout"));
  exercises.get(6).description = "Description of the exercise\nAn animation too maybe";
}
