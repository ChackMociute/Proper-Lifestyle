public class Meal {
  String name, short_description, description;
  float price, calories, time;
  ShoppingItem[] ingredients;

  public Meal(String name) {
    this.name = name;
  }

  public Meal(String name, float calories, float time, String description) {
    this.name = name;
    this.calories = calories;
    this.time = time;
    short_description = description;
  }

  public void count_price() {
    price = 0;
    for (ShoppingItem i : ingredients) {
      price += i.price;
    }
  }

  public void add_ingredients(ArrayList<ShoppingItem> ingredients) {
    ShoppingItem[] temp = new ShoppingItem[ingredients.size()];
    int x = 0;
    for (ShoppingItem i : ingredients) {
      temp[x] = i;
      x++;
    }
    this.ingredients = temp;
  }
}

void create_recipes(ArrayList<Meal> recipes) {
  ArrayList<ShoppingItem> ingredients = new ArrayList<ShoppingItem>();

  recipes.add(new Meal("Salmon wok", 456, 45, "Asian style salmon"));
  recipes.get(0).description = "Description of the recipe, how to\nmake it and so on.";
  ingredients.add(new ShoppingItem("Salmon", 4));
  ingredients.add(new ShoppingItem("Wok", 3));
  ingredients.add(new ShoppingItem("Seasoning", 0.5));
  recipes.get(0).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(0).count_price();

  recipes.add(new Meal("Tzatziki dip", 318, 20, "Dip"));
  recipes.get(1).description = "A quick and delicious dip\n for vegetables. Cut cucumbers\ninto small pieces, then put them\non a paper towel to dry\nfor 10 minutes. Finely chop\ngarlic, and add it all to the\nsour cream.";
  ingredients.add(new ShoppingItem("Cucumber", 2));
  ingredients.add(new ShoppingItem("Sour cream", 1.5));
  ingredients.add(new ShoppingItem("Garlic", 0.5));
  recipes.get(1).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(1).count_price();

  recipes.add(new Meal("Poke bowl", 493, 30, "Raw salmon dish"));
  recipes.get(2).description = "Cut the salmon into bite-sized\ncubes. Boil the rice before letting\nit cool to room temperature.\nAdd the rice and salmon to\na bowl, before adding vegetables.";
  ingredients.add(new ShoppingItem("Salmon", 3));
  ingredients.add(new ShoppingItem("Green beans", 1));
  ingredients.add(new ShoppingItem("Rice", 0.5));
  ingredients.add(new ShoppingItem("Sesame oil", 0.5));
  recipes.get(2).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(2).count_price();

  recipes.add(new Meal("Protein bars", 287, 15, "Healthy treat"));
  recipes.get(3).description = "Coarsely chop nuts, chocolate, and\ncrush the bananas into a bowl.\nAdd the eggs, and mix it all\ntogether. Form the gloop into bars\nand put it in the oven.";
  ingredients.add(new ShoppingItem("Protein powder", 1));
  ingredients.add(new ShoppingItem("Nuts", 0.75));
  ingredients.add(new ShoppingItem("Chocolate", 0.75));
  ingredients.add(new ShoppingItem("Bananas", 0.75));
  ingredients.add(new ShoppingItem("Eggs", 0.5));
  recipes.get(3).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(3).count_price();

  recipes.add(new Meal("Chicken", 522, 30, "Roasted chicken thighs"));
  recipes.get(4).description = "Season the chicken generously\nbefore putting it in the oven.";
  ingredients.add(new ShoppingItem("Chicken thighs", 3));
  ingredients.add(new ShoppingItem("Potatoes", 1.5));
  ingredients.add(new ShoppingItem("Salt", 0.5));
  ingredients.add(new ShoppingItem("Pepper", 0.5));
  recipes.get(4).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(4).count_price();
}
