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

  recipes.add(new Meal("Salmon wok", 456, 45, "Japanese style salmon"));
  ingredients.add(new ShoppingItem("Salmon", 4));
  ingredients.add(new ShoppingItem("Wok", 3));
  ingredients.add(new ShoppingItem("Seasoning", 0.5));
  recipes.get(0).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(0).count_price();

  recipes.add(new Meal("Tzatziki dip", 318, 20, "Idk what this is"));
  ingredients.add(new ShoppingItem("Tzatziki", 2));
  ingredients.add(new ShoppingItem("Sour cream", 1.5));
  ingredients.add(new ShoppingItem("Chilli powder", 0.5));
  recipes.get(1).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(1).count_price();

  recipes.add(new Meal("Poke bowl", 493, 30, "Pokemon?"));
  ingredients.add(new ShoppingItem("Pokemon", 3));
  ingredients.add(new ShoppingItem("Bowl", 1.5));
  ingredients.add(new ShoppingItem("Rice", 0.5));
  recipes.get(2).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(2).count_price();

  recipes.add(new Meal("Protein bars", 287, 15, "Healthy treat"));
  ingredients.add(new ShoppingItem("Protein powder", 1));
  ingredients.add(new ShoppingItem("Nuts", 0.75));
  ingredients.add(new ShoppingItem("Chocolate", 0.75));
  recipes.get(3).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(3).count_price();

  recipes.add(new Meal("Chicken", 522, 30, "Simple roasted chicken"));
  ingredients.add(new ShoppingItem("Chicken", 3));
  ingredients.add(new ShoppingItem("Potatoes", 1.5));
  ingredients.add(new ShoppingItem("Seasoning", 0.5));
  recipes.get(4).add_ingredients(ingredients);
  ingredients.clear();
  recipes.get(4).count_price();
}
