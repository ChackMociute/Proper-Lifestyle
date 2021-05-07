public class Meal {
  String name, short_description, description;
  float price, calories, time;
  int[] ingredients;

  public Meal (String name, float price, float calories, float time, String description) {
    this.name = name;
    this.price = price;
    this.calories = calories;
    this.time = time;
    short_description = description;
  }
}


void create_recipes(ArrayList<Meal> recipes) {
  recipes.add(new Meal("Chicken", 5, 522, 30, "Simple roasted chicken"));
}
