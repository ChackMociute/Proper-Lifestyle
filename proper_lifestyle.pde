//------------------------------------------------------------------------------
//GLOBAL VARIABLES, SETTINGS AND SETUP
//------------------------------------------------------------------------------

final int SCALE = 4;
final int WIDTH = 120*SCALE;
final int HEIGHT = 200*SCALE;
final int SCREENS = 6;

color titleColor, backgroundColor, boxColor1, boxColor2;
int screen, pop_up, recipe_index, tip_index, exercise_index, item_index, text_entry_mode;
boolean hold, text_entry, meal_dropdown;
float calories, day_calories, spent_money, budget, temp_budget, temp_spent_money, timer;
String text, exercise, item_name, item_price;
ArrayList<ShoppingItem> shopping_items;
ArrayList<Meal> recipes;
Meal recipe, meal;

void settings() {
  size(WIDTH, HEIGHT);
}


void setup() {
  screen = 0;
  pop_up = 0;
  text_entry_mode = 0;
  hold = false;
  text_entry = false;
  meal_dropdown = false;
  text = "";
  recipe_index = 0;
  tip_index = 0;
  exercise_index = 0;
  item_index = 0;
  exercise = "";
  item_name = "";
  item_price = "";
  timer = 0;
  shopping_items = new ArrayList<ShoppingItem>();
  recipes = new ArrayList<Meal>();
  meal = new Meal("");
  calories = 478;
  day_calories = 2586;
  budget = 30;
  spent_money = 12.5;
  titleColor = color(#2FD12A);
  backgroundColor = color(#FFA2A2);
  boxColor1 = color(#A4FFA1);
  boxColor2 = color(#FFDEDE);

  create_recipes(recipes);
}


//------------------------------------------------------------------------------
//UTILITY FUNCTIONS
//------------------------------------------------------------------------------


void load_screen(int x) {
  switch(x) {
  case 0:
    home();
    break;
  case 1:
    recipes();
    break;
  case 2:
    exercises();
    break;
  case 3:
    shopping();
    break;
  case 4:
    tips();
    break;
  case 5:
    stats();
    break;
  }
}


void options() {
  stroke(0);
  strokeWeight(4);
  fill(titleColor);
  rect(0, 0, 0.1*HEIGHT, 0.1*HEIGHT, 8);

  strokeWeight(0);
  fill(0);

  for (int i = 0; i < 3; i++) {
    rect(0.01*HEIGHT, 0.025*HEIGHT + i*0.02*HEIGHT, 0.08*HEIGHT, 0.01*HEIGHT, 8);
  }
}

void title(String title, float scale) {
  stroke(0);
  strokeWeight(4);
  fill(titleColor);
  rect(0.1*HEIGHT, 0, WIDTH - 0.1*HEIGHT, 0.1*HEIGHT, 8);

  fill(0);
  textSize(HEIGHT*scale);
  textAlign(LEFT);
  text(title, 0.11*HEIGHT, 0.08*HEIGHT);
}

String screen(int x) {
  switch(x) {
  case 0:
    return "Home";
  case 1:
    return "Recipes";
  case 2:
    return "Exercises";
  case 3:
    return "Shopping list";
  case 4:
    return "Helpful tips";
  case 5:
    return "Personal stats";
  default:
    return "";
  }
}

void dropdown() {
  for (int i = 0; i < SCREENS; i++) {
    stroke(0);
    strokeWeight(4);
    fill(boxColor1);

    rect(0, 0.1*HEIGHT + i*0.1*HEIGHT, 0.75*WIDTH, 0.1*HEIGHT, 8);

    textSize(HEIGHT*0.06);
    textAlign(CENTER);
    fill(0);
    text(screen(i), 0.375*WIDTH, 0.18*HEIGHT + i*0.1*HEIGHT);
  }
}

boolean hover(float x1, float x2, float y1, float y2) {
  if (mouseX >= x1 & mouseX <= x2 & mouseY >= y1 & mouseY <= y2) 
    return true;
  else 
  return false;
}

void dropdown_hover() {
  if (hover(0, 0.1*HEIGHT, 0, 0.1*HEIGHT)) {
    hold = true;
    dropdown();
  }

  if (hover(0, 0.75*WIDTH, 0.1*HEIGHT, 0.1*(SCREENS+1)*HEIGHT) & hold) {
    hold = true;
    dropdown();
  }

  if (!hover(0, 0.1*HEIGHT, 0, 0.1*HEIGHT) & !hover(0, 0.75*WIDTH, 0.1*HEIGHT, 0.1*(SCREENS+1)*HEIGHT))
    hold = false;
}

int change_screen(int screen) {
  if (mousePressed & hold) {
    for (int i = 0; i < SCREENS; i++) {
      if (mouseY >= 0.1*HEIGHT + i*0.1*HEIGHT & mouseY < 0.1*HEIGHT + (i+1)*0.1*HEIGHT) {
        pop_up = 0;
        text_entry = false;
        meal_dropdown = false;
        text_entry_mode = 0;
        timer = millis();
        text = "";
        item_name = "";
        item_price = "";
        meal = new Meal("");
        return i;
      }
    }
    return screen;
  } else
    return screen;
}

void pop_up(int screen, int pop_up) {
  switch(screen) {
  case 0:
    if (pop_up == 1) calorie_pop_up();
    else if (pop_up == 2) micronutrient_pop_up();
    else if (pop_up == 3) budget_pop_up();
    break;
  case 1:
    if (pop_up == 1) recipe_pop_up();
    break;
  case 2:
    if (pop_up == 1) exercise_pop_up();
    break;
  case 3:
    if (pop_up == 1) add_item_pop_up();
    else if (pop_up == 2) add_price_pop_up();
    break;
  }
}

void exit_button(float x, float y) {
  if (screen == 3)
    timer = 0;

  stroke(0);
  strokeWeight(3);

  if (hover(x - 0.1*WIDTH, x, y, y + 0.1*WIDTH) & !hold)
    fill(255, 0, 0);
  else
    fill(192);

  rect(x - 0.1*WIDTH, y, 0.1*WIDTH, 0.1*WIDTH, 8);

  strokeWeight(4);
  fill(0);
  line(x - 0.075*WIDTH, y + 0.025*WIDTH, x - 0.025*WIDTH, y + 0.075*WIDTH);
  line(x - 0.075*WIDTH, y + 0.075*WIDTH, x - 0.025*WIDTH, y + 0.025*WIDTH);

  if (hover(x - 0.1*WIDTH, x, y, y + 0.1*WIDTH) & !hold & mousePressed) {
    pop_up = 0;
    text_entry = false;
    meal_dropdown = false;
    text_entry_mode = 0;
    timer = millis();
    text = "";
    item_name = "";
    item_price = "";
    meal = new Meal("");
  }
}

void number_entry() {
  if (text_entry) {
    if (keyPressed) {
      if (key == BACKSPACE) {
        char[] temp;
        temp = text.toCharArray();

        text = "";
        for (int i = 0; i < temp.length-1; i++) {
          text += temp[i];
        }
      } else if (textWidth(text + key) < 0.3*WIDTH & 
        (key == '0' | key == '1' | key == '2' | key == '3' | key == '4' |
        key == '5' | key == '6' | key == '7' | key == '8' | key == '9'))
        text += key;
    }
  }
}

void decimal_entry() {
  if (text_entry) {
    if (keyPressed) {
      if (key == BACKSPACE) {
        char[] temp;
        temp = text.toCharArray();

        text = "";
        for (int i = 0; i < temp.length-1; i++) {
          text += temp[i];
        }
      } else if (float(text + key) < 1000 & textWidth(text + key) < 0.2*WIDTH & 
        (key == '-' | key == '0' | key == '1' | key == '2' | key == '3' | key == '4' |
        key == '5' | key == '6' | key == '7' | key == '8' | key == '9' | key == '.'))
        text += key;
    }
  }
}

void alphanumeric_entry() {
  if (text_entry) {
    if (keyPressed) {
      if (key == BACKSPACE) {
        char[] temp;
        temp = text.toCharArray();

        text = "";
        for (int i = 0; i < temp.length-1; i++) {
          text += temp[i];
        }
      } else if (textWidth(text + key) < 0.35*WIDTH)
        text += key;
    }
  }
}

void keyPressed() {
  switch(text_entry_mode) {
  case 1:
    number_entry();
    break;
  case 2:
    decimal_entry();
    break;
  case 3:
    alphanumeric_entry();
    break;
  }
}

String text_entry_box(int color_, int select_color, float x1, float x2, float y1, float y2) {
  textSize(0.03*HEIGHT);
  textAlign(LEFT);

  if (hover(x1, x2, y1, y2) & !hold & !text_entry & mousePressed) {
    text = "";
    text_entry = true;
  } else if (!hover(x1, x2, y1, y2) & mousePressed) {
    text_entry = false;
  }

  fill(color_);

  if (text_entry) 
    fill(select_color);

  rect(x1, y1, x2-x1, y2-y1, 8);

  boolean done = done_button(x1 + 9*(x2-x1)/10, x2, y1, y2);

  if (text_entry) {
    if ((keyPressed & key == ENTER) | done) {
      String temp_text = text;
      text = "";
      return temp_text;
    }
  }

  fill(0);

  text(text, x1+0.02*WIDTH, y1 + (y2 - y1)/2 + 0.011*HEIGHT);

  return "";
}

void meal_dropdown(float x1, float x2, float y1, float y2) {
  for (int i = 0; i < recipes.size(); i++) {
    stroke(0);
    strokeWeight(3);
    fill(255);

    if (hover(x1, x2, y2 + i*(y2-y1), y2 + (i+1)*(y2-y1))) {
      fill(235);
      if (mousePressed) {
        fill(0, 255, 0);
        meal = recipes.get(i);
        delay(150);
      }
    }

    rect(x1, y2 + i*(y2-y1), x2-x1, y2-y1, 8);

    textSize(0.9*(y2-y1));
    textAlign(LEFT);
    fill(0);
    text(recipes.get(i).name, x1 + 0.015*WIDTH, y2 - 0.005*HEIGHT + (i+1)*(y2-y1));
  }
}

int meal_dropdown(int color_, int select_color, float x1, float x2, float y1, float y2) {
  textSize(0.03*HEIGHT);
  textAlign(LEFT);

  if ((hover(x1, x2, y1, y2) & !hold & mousePressed) | meal_dropdown) {
    meal_dropdown(x1, x2, y1, y2);
    meal_dropdown = true;
  }

  if (!hover(x1, x2, y1, y2) & mousePressed) {
    if ((meal_dropdown & !hover(x1, x2, y2, y2 + recipes.size()*(y2-y1))) | !meal_dropdown) {
      meal_dropdown = false;
      meal = new Meal("");
    }
  }

  if (hover(x1, x2 - (x2-x1)/10, y1, y2) & !hold & mousePressed)
    meal = new Meal("");

  if (meal.name != "")
    meal_dropdown = false;

  fill(color_);

  if (meal_dropdown | (meal.name != "")) 
    fill(select_color);

  rect(x1, y1, x2-x1, y2-y1, 8);

  boolean done = done_button(x1 + 9*(x2-x1)/10, x2, y1, y2);

  if ((meal.name != "")) {
    if ((keyPressed & key == ENTER) | done) {
      delay(150);
      int temp = int(meal.calories);
      meal = new Meal("");
      return temp;
    }
  }

  fill(0);
  textSize(0.9*(y2-y1));
  text(meal.name, x1 + 0.015*WIDTH, y2 - 0.005*HEIGHT);

  return 0;
}

boolean button_base(float x1, float x2, float y1, float y2, color color1, color color2) {
  stroke(0);
  strokeWeight(3);

  if (hover(x1, x2, y1, y2) & !hold)
    fill(color1);
  else
    fill(color2);

  rect(x1, y1, x2-x1, y2-y1, 8);

  if (hover(x1, x2, y1, y2) & !hold & mousePressed)
    return true;
  else
    return false;
}

boolean done_button(float x1, float x2, float y1, float y2) {
  boolean value = button_base(x1, x2, y1, y2, color(0, 255, 0), color(0, 127, 0));

  strokeWeight(3.5);
  fill(0);
  line(x1 + (x2 - x1)/5, y1 + 2*(y2-y1)/5, x1 + (x2 - x1)/2, y1 + 4*(y2-y1)/5);
  line(x1 + (x2 - x1)/2, y1 + 4*(y2-y1)/5, x1 + 4*(x2 - x1)/5, y1 + (y2-y1)/5);

  return value;
}

boolean add_button(float x1, float x2, float y1, float y2) {
  boolean value = button_base(x1, x2, y1, y2, 192, 235);

  strokeWeight(2);
  fill(0);
  line(x1 + (x2 - x1)/5, y1 + 7*(y2-y1)/10, x1 + (x2 - x1)/2, y1 + 3*(y2-y1)/10);
  line(x1 + (x2 - x1)/2, y1 + 3*(y2-y1)/10, x1 + 4*(x2 - x1)/5, y1 + 7*(y2-y1)/10);

  return value;
}

boolean double_add_button(float x1, float x2, float y1, float y2) {
  boolean value = button_base(x1, x2, y1, y2, 192, 235);

  strokeWeight(2);
  fill(0);
  line(x1 + (x2 - x1)/5, y1 + 3*(y2-y1)/5, x1 + (x2 - x1)/2, y1 + (y2-y1)/5);
  line(x1 + (x2 - x1)/2, y1 + (y2-y1)/5, x1 + 4*(x2 - x1)/5, y1 + 3*(y2-y1)/5);
  line(x1 + (x2 - x1)/5, y1 + 4*(y2-y1)/5, x1 + (x2 - x1)/2, y1 + 2*(y2-y1)/5);
  line(x1 + (x2 - x1)/2, y1 + 2*(y2-y1)/5, x1 + 4*(x2 - x1)/5, y1 + 4*(y2-y1)/5);

  return value;
}

boolean remove_button(float x1, float x2, float y1, float y2) {
  boolean value = button_base(x1, x2, y1, y2, 192, 235);

  strokeWeight(2);
  fill(0);
  line(x1 + (x2 - x1)/5, y1 + 3*(y2-y1)/10, x1 + (x2 - x1)/2, y1 + 7*(y2-y1)/10);
  line(x1 + (x2 - x1)/2, y1 + 7*(y2-y1)/10, x1 + 4*(x2 - x1)/5, y1 + 3*(y2-y1)/10);

  return value;
}

boolean double_remove_button(float x1, float x2, float y1, float y2) {
  boolean value = button_base(x1, x2, y1, y2, 192, 235);

  strokeWeight(2);
  fill(0);
  line(x1 + (x2 - x1)/5, y1 + (y2-y1)/5, x1 + (x2 - x1)/2, y1 + 3*(y2-y1)/5);
  line(x1 + (x2 - x1)/2, y1 + 3*(y2-y1)/5, x1 + 4*(x2 - x1)/5, y1 + (y2-y1)/5);
  line(x1 + (x2 - x1)/5, y1 + 2*(y2-y1)/5, x1 + (x2 - x1)/2, y1 + 4*(y2-y1)/5);
  line(x1 + (x2 - x1)/2, y1 + 4*(y2-y1)/5, x1 + 4*(x2 - x1)/5, y1 + 2*(y2-y1)/5);

  return value;
}

boolean up_button(float x1, float x2, float y1, float y2) {
  boolean value = button_base(x1, x2, y1, y2, 192, 235);

  strokeWeight(4);
  fill(0);
  line(x1 + (x2 - x1)/5, y1 + 8*(y2-y1)/10, x1 + (x2 - x1)/2, y1 + 5*(y2-y1)/20);
  line(x1 + (x2 - x1)/2, y1 + 5*(y2-y1)/20, x1 + 4*(x2 - x1)/5, y1 + 8*(y2-y1)/10);

  return value;
}

boolean down_button(float x1, float x2, float y1, float y2) {
  boolean value = button_base(x1, x2, y1, y2, 192, 235);

  strokeWeight(4);
  fill(0);
  line(x1 + (x2 - x1)/5, y1 + 5*(y2-y1)/20, x1 + (x2 - x1)/2, y1 + 8*(y2-y1)/10);
  line(x1 + (x2 - x1)/2, y1 + 8*(y2-y1)/10, x1 + 4*(x2 - x1)/5, y1 + 5*(y2-y1)/20);

  return value;
}


//------------------------------------------------------------------------------
//POP UPS
//------------------------------------------------------------------------------


//-------------HOME-------------

void calorie_pop_up() {
  stroke(0);
  strokeWeight(3);
  fill(boxColor1);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.65*HEIGHT, 8);

  fill(boxColor2);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.1*WIDTH, 8);

  fill(0);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);
  text("Today's calories", 0.45*WIDTH, 0.345*HEIGHT);

  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("Consumed calories:", 0.08*WIDTH, 0.43*HEIGHT);
  text("Required calories:", 0.08*WIDTH, 0.47*HEIGHT);

  textAlign(RIGHT);
  text(nf(calories, 0, 0), 0.92*WIDTH, 0.43*HEIGHT);
  text(nf(day_calories, 0, 0), 0.92*WIDTH, 0.47*HEIGHT);

  textAlign(CENTER);
  text("Enter consumed calories", 0.5*WIDTH, 0.55*HEIGHT);
  text("Enter a meal", 0.5*WIDTH, 0.67*HEIGHT);
  text_entry_mode = 1;
  calories += int(text_entry_box(225, 255, 0.1*WIDTH, 0.9*WIDTH, 0.56*HEIGHT, 0.6*HEIGHT));

  calories += int(meal_dropdown(225, 255, 0.1*WIDTH, 0.9*WIDTH, 0.68*HEIGHT, 0.72*HEIGHT));

  exit_button(0.93*WIDTH, 0.3*HEIGHT);
}

void micronutrient_pop_up() {
  stroke(0);
  strokeWeight(3);
  fill(boxColor1);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.5*HEIGHT, 8);

  fill(boxColor2);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.1*WIDTH, 8);

  fill(0);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);
  text("Micronutrients", 0.45*WIDTH, 0.345*HEIGHT);

  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("Based on your recent meals you\nmay need these micronutrients:", 0.08*WIDTH, 0.4*HEIGHT);

  fill(boxColor2);
  rect(0.1*WIDTH, 0.48*HEIGHT, 0.8*WIDTH, 0.2*HEIGHT, 8);

  String[] micronutrients = {"Calcium", "Vitamin A", "Potassium"};
  int x = 0;

  for (String i : micronutrients) {
    fill(0);
    textSize(0.03*HEIGHT);

    if (pow(-1, x) > 0) {
      textAlign(LEFT);
      text(i, 0.11*WIDTH, 0.52*HEIGHT + floor(x/2)*0.04*HEIGHT);
    } else {
      textAlign(RIGHT);
      text(i, 0.88*WIDTH, 0.52*HEIGHT + floor(x/2)*0.04*HEIGHT);
    }

    x++;
  }

  fill(0);
  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("You should take supplements\nor prepare recommended meals.", 0.08*WIDTH, 0.72*HEIGHT);

  exit_button(0.93*WIDTH, 0.3*HEIGHT);
}

void budget_pop_up() {
  stroke(0);
  strokeWeight(3);
  fill(boxColor1);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.5*HEIGHT, 8);

  fill(boxColor2);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.1*WIDTH, 8);

  fill(0);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);
  text("Weekly budget", 0.45*WIDTH, 0.345*HEIGHT);

  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("Current weekly budget:", 0.08*WIDTH, 0.4*HEIGHT);
  text("Money spent so far:", 0.08*WIDTH, 0.44*HEIGHT);
  text("Money left in the budget:", 0.08*WIDTH, 0.48*HEIGHT);

  textAlign(RIGHT);
  text(nf(budget, 0, 2), 0.92*WIDTH, 0.4*HEIGHT);
  text(nf(spent_money, 0, 2), 0.92*WIDTH, 0.44*HEIGHT);
  text(budget >= spent_money ? nf(budget - spent_money, 0, 2) : "0", 0.92*WIDTH, 0.48*HEIGHT);

  textAlign(LEFT);
  text("Adjust weekly budget", 0.11*WIDTH, 0.555*HEIGHT);

  fill(boxColor2);
  rect(0.1*WIDTH, 0.57*HEIGHT, 0.8*WIDTH, 0.05*HEIGHT, 8);

  fill(0);
  textAlign(LEFT);
  text(nf(temp_budget, 0, 2), 0.11*WIDTH, 0.605*HEIGHT);

  if (done_button(0.8*WIDTH, 0.9*WIDTH, 0.57*HEIGHT, 0.62*HEIGHT)) {
    budget = temp_budget;
    delay(150);
  }

  if (add_button(0.4*WIDTH, 0.5*WIDTH, 0.57*HEIGHT, 0.62*HEIGHT)) {
    temp_budget++;
    delay(150);
  }

  if (double_add_button(0.5*WIDTH, 0.6*WIDTH, 0.57*HEIGHT, 0.62*HEIGHT)) {
    temp_budget += 10;
    delay(200);
  }

  if (remove_button(0.6*WIDTH, 0.7*WIDTH, 0.57*HEIGHT, 0.62*HEIGHT)) {
    if (temp_budget - 1 >= 0)
      temp_budget--;
    else
      temp_budget = 0;
    delay(150);
  }

  if (double_remove_button(0.7*WIDTH, 0.8*WIDTH, 0.57*HEIGHT, 0.62*HEIGHT)) {
    if (temp_budget - 10 >= 0)
      temp_budget -= 10;
    else
      temp_budget = 0;
    delay(200);
  }


  fill(0);
  textAlign(LEFT);
  text("Money spent", 0.11*WIDTH, 0.715*HEIGHT);

  fill(boxColor2);
  strokeWeight(3);
  rect(0.1*WIDTH, 0.73*HEIGHT, 0.8*WIDTH, 0.05*HEIGHT, 8);

  fill(0);
  textAlign(LEFT);
  text(nf(temp_spent_money, 0, 2), 0.11*WIDTH, 0.765*HEIGHT);

  if (done_button(0.8*WIDTH, 0.9*WIDTH, 0.73*HEIGHT, 0.78*HEIGHT)) {
    spent_money += temp_spent_money;
    temp_spent_money = 0;
    delay(150);
  }

  if (add_button(0.4*WIDTH, 0.5*WIDTH, 0.73*HEIGHT, 0.78*HEIGHT)) {
    temp_spent_money += 0.5;
    delay(150);
  }

  if (double_add_button(0.5*WIDTH, 0.6*WIDTH, 0.73*HEIGHT, 0.78*HEIGHT)) {
    temp_spent_money += 5;
    delay(200);
  }

  if (remove_button(0.6*WIDTH, 0.7*WIDTH, 0.73*HEIGHT, 0.78*HEIGHT)) {
    if (temp_spent_money - 0.5 >= 0)
      temp_spent_money -= 0.5;
    else
      temp_spent_money = 0;
    delay(150);
  }

  if (double_remove_button(0.7*WIDTH, 0.8*WIDTH, 0.73*HEIGHT, 0.78*HEIGHT)) {
    if (temp_spent_money - 5 >= 0)
      temp_spent_money -= 5;
    else
      temp_spent_money = 0;
    delay(200);
  }

  exit_button(0.93*WIDTH, 0.3*HEIGHT);
}

//-------------RECIPES-------------

void recipe_pop_up() {
  stroke(0);
  strokeWeight(3);
  fill(boxColor1);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.5*HEIGHT, 8);

  fill(boxColor2);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.1*WIDTH, 8);

  fill(0);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);
  text(recipe.name, 0.45*WIDTH, 0.345*HEIGHT);

  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("Description of the recipe, how to\nmake it and so on.", 0.08*WIDTH, 0.4*HEIGHT);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);

  float x1 = 0.49*WIDTH - textWidth("Add to shopping")/2, x2 = 0.51*WIDTH + textWidth("Add to shopping")/2;
  float y = 0.71*HEIGHT;

  if (hover(x1, x2, y, y + 0.05*HEIGHT) & !hold & mousePressed & timer == 0) {
    for (ShoppingItem i : recipe.ingredients) {
      shopping_items.add(i);
    }
    fill(0, 255, 0);
    timer = millis();
  } else if (millis() <= timer+150) {
    fill(0, 255, 0);
  } else if (hover(x1, x2, y, y + 0.05*HEIGHT) & !hold) {
    timer = 0;
    fill(225);
  } else {
    timer = 0;
    fill(boxColor2);
  }

  rect(x1, y, x2-x1, 0.05*HEIGHT, 8);

  fill(0);
  text("Add to shopping", 0.5*WIDTH, 0.75*HEIGHT);

  exit_button(0.93*WIDTH, 0.3*HEIGHT);
}

//-------------EXERCISES-------------

void exercise_pop_up() {
  stroke(0);
  strokeWeight(3);
  fill(boxColor1);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.5*HEIGHT, 8);

  fill(boxColor2);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.1*WIDTH, 8);

  fill(0);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);
  text(exercise, 0.45*WIDTH, 0.345*HEIGHT);

  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  //Only works for lounges as of now for practical reasons
  text("From a standing position, take \na big step forwards with \none leg such that the your knee \nalmost touches the ground.", 0.08*WIDTH, 0.4*HEIGHT);

  exit_button(0.93*WIDTH, 0.3*HEIGHT);
}

//-------------SHOPPING-------------

void add_item_pop_up() {
  stroke(0);
  strokeWeight(3);
  fill(boxColor1);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.25*HEIGHT, 8);

  fill(boxColor2);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.1*WIDTH, 8);

  fill(0);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);
  text("Add to shopping list", 0.45*WIDTH, 0.345*HEIGHT);

  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("Enter the name of the item", 0.11*WIDTH, 0.42*HEIGHT);

  item_name = text_entry_box(225, 255, 0.1*WIDTH, 0.9*WIDTH, 0.45*HEIGHT, 0.5*HEIGHT);

  exit_button(0.93*WIDTH, 0.3*HEIGHT);
}

void add_price_pop_up() {
  stroke(0);
  strokeWeight(3);
  fill(boxColor1);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.25*HEIGHT, 8);

  fill(boxColor2);
  rect(0.07*WIDTH, 0.3*HEIGHT, 0.86*WIDTH, 0.1*WIDTH, 8);

  fill(0);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);
  text("Add to shopping list", 0.45*WIDTH, 0.345*HEIGHT);

  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("Enter the price of the item", 0.11*WIDTH, 0.42*HEIGHT);

  item_price = text_entry_box(225, 255, 0.1*WIDTH, 0.9*WIDTH, 0.45*HEIGHT, 0.5*HEIGHT);

  exit_button(0.93*WIDTH, 0.3*HEIGHT);
}


//------------------------------------------------------------------------------
//SCREEN FUNCTIONS
//------------------------------------------------------------------------------


//-------------HOME-------------

void calories() {
  stroke(0);
  strokeWeight(4);
  fill(boxColor2);

  rect(0.1*WIDTH, 0.25*HEIGHT, 0.8*WIDTH, 0.1*HEIGHT, 8);

  fill(0);
  textSize(0.04*HEIGHT);
  textAlign(LEFT);
  text("Today's calories", 0.1*WIDTH, 0.23*HEIGHT);

  fill(128, 0, 255);
  rect(0.1*WIDTH, 0.25*HEIGHT, 0.8*WIDTH * (calories <= day_calories ? calories/day_calories : 1), 0.1*HEIGHT, 8);

  fill(0);
  textSize(0.025*HEIGHT);
  textAlign(RIGHT);
  text(nf(calories, 0, 0) + "/" + nf(day_calories, 0, 0), 0.88*WIDTH, 0.31*HEIGHT);


  textSize(0.04*HEIGHT);
  textAlign(CENTER);

  float x1 = 0.5*WIDTH - textWidth("Edit calories")/2, x2 = 0.5*WIDTH + textWidth("Edit calories")/2;
  float y = 0.455*HEIGHT;

  text("Edit calories", 0.5*WIDTH, 0.45*HEIGHT);
  line(x1, y, x2, y);

  if (hover(x1, x2, y - 0.04*HEIGHT, y) & !hold & mousePressed & pop_up == 0) {
    pop_up = 1;
  }

  x1 = 0.5*WIDTH - textWidth("Micronutrients")/2;
  x2 = 0.5*WIDTH + textWidth("Micronutrients")/2;
  y = 0.555*HEIGHT;

  text("Micronutrients", 0.5*WIDTH, 0.55*HEIGHT);
  line(x1, 0.555*HEIGHT, x2, 0.555*HEIGHT);

  if (hover(x1, x2, y - 0.04*HEIGHT, y) & !hold & mousePressed & pop_up == 0) {
    pop_up = 2;
  }
}

void budget() {
  stroke(0);
  strokeWeight(4);
  fill(boxColor2);

  rect(0.1*WIDTH, 0.7*HEIGHT, 0.8*WIDTH, 0.1*HEIGHT, 8);

  fill(0);
  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("Weekly budget: ", 0.12*WIDTH, 0.765*HEIGHT);

  fill(0);
  textSize(0.025*HEIGHT);
  textAlign(RIGHT);
  text((budget >= spent_money ? nf(budget - spent_money, 0, 2) : "0") + " left", 0.88*WIDTH, 0.765*HEIGHT);

  textSize(0.04*HEIGHT);
  textAlign(CENTER);

  float x1 = 0.5*WIDTH - textWidth("Adjust weekly budget")/2, x2 = 0.5*WIDTH + textWidth("Adjust weekly budget")/2;
  float y = 0.905*HEIGHT;

  text("Adjust weekly budget", 0.5*WIDTH, 0.9*HEIGHT);
  line(x1, y, x2, y);

  if (hover(x1, x2, y - 0.04*HEIGHT, y) & !hold & mousePressed & pop_up == 0) {
    pop_up = 3;
    temp_budget = budget;
    temp_spent_money = 0;
  }
}

//-------------RECIPES-------------

void recipe_list() {
  if (recipe_index != 0) {
    if (up_button(0.45*WIDTH, 0.55*WIDTH, 0.15*HEIGHT, 0.15*HEIGHT + 0.1*WIDTH)) {
      recipe_index--;
      pop_up = 0;
      delay(150);
    }
  }

  if (recipes.size() - 2*recipe_index - 2 > 0) {
    if (down_button(0.45*WIDTH, 0.55*WIDTH, 0.85*HEIGHT, 0.85*HEIGHT + 0.1*WIDTH)) {
      recipe_index++;
      pop_up = 0;
      delay(150);
    }
  }

  String time;

  for (int i = 0; i < (recipes.size() - 2*recipe_index >= 2 ? 2 : 1); i++) {
    stroke(0);
    strokeWeight(4);
    fill(boxColor1);

    rect(0.1*WIDTH, 0.25*HEIGHT + i*0.3*HEIGHT, 0.8*WIDTH, 0.25*HEIGHT, 8);

    fill(boxColor2);

    rect(0.1*WIDTH, 0.25*HEIGHT + i*0.3*HEIGHT, 0.4*WIDTH, 0.06*HEIGHT, 8);
    rect(0.15*WIDTH, 0.43*HEIGHT + i*0.3*HEIGHT, 0.7*WIDTH, 0.045*HEIGHT, 8);

    if (hover(0.5*WIDTH, 0.6*WIDTH, 0.25*HEIGHT + i*0.3*HEIGHT, 0.31*HEIGHT + i*0.3*HEIGHT))
      fill(215);

    rect(0.5*WIDTH, 0.25*HEIGHT + i*0.3*HEIGHT, 0.1*WIDTH, 0.06*HEIGHT, 8);

    line(0.52*WIDTH, 0.28*HEIGHT + i*0.3*HEIGHT, 0.58*WIDTH, 0.28*HEIGHT + i*0.3*HEIGHT);
    line(0.55*WIDTH, 0.26*HEIGHT + i*0.3*HEIGHT, 0.55*WIDTH, 0.3*HEIGHT + i*0.3*HEIGHT);

    if (hover(0.5*WIDTH, 0.6*WIDTH, 0.25*HEIGHT + i*0.3*HEIGHT, 0.31*HEIGHT + i*0.3*HEIGHT) & mousePressed & !hold) {
      pop_up = 1;
      recipe = recipes.get(i + recipe_index*2);
    }

    fill(0);
    textSize(0.04*HEIGHT);
    textSize(textWidth(recipes.get(i + recipe_index*2).name)/float(int(0.4*WIDTH)) > 0.9 ?
      0.036*HEIGHT*float(int(0.4*WIDTH))/textWidth(recipes.get(i + recipe_index*2).name) : 0.04*HEIGHT);
    textAlign(LEFT);
    text(recipes.get(i + recipe_index*2).name, 0.11*WIDTH, 0.295*HEIGHT + i*0.3*HEIGHT);

    textSize(0.03*HEIGHT);
    text("Calories: " + nf(recipes.get(i + recipe_index*2).calories, 0, 0), 0.11*WIDTH, 0.35*HEIGHT + i*0.3*HEIGHT);
    text("Cost: " + nf(recipes.get(i + recipe_index*2).price, 0, 1), 0.11*WIDTH, 0.4*HEIGHT + i*0.3*HEIGHT);

    textSize(textWidth(recipes.get(i + recipe_index*2).short_description)/float(int(0.7*WIDTH)) > 0.9 ?
      0.027*HEIGHT*float(int(0.7*WIDTH))/textWidth(recipes.get(i + recipe_index*2).short_description) : 0.03*HEIGHT);
    text(recipes.get(i + recipe_index*2).short_description, 0.16*WIDTH, 0.463*HEIGHT + i*0.3*HEIGHT);

    time = "Time " + nf(recipes.get(i + recipe_index*2).time, 0, 0);

    textSize(0.03*HEIGHT);
    textSize(textWidth(time)/float(int(0.2*WIDTH)) > 0.9 ?
      0.027*HEIGHT*float(int(0.2*WIDTH))/textWidth(time) : 0.03*HEIGHT);
    textAlign(RIGHT);
    text(time, 0.88*WIDTH, 0.295*HEIGHT + i*0.3*HEIGHT);

    fill(boxColor2);
    strokeWeight(2);
    circle(0.65*WIDTH, 0.285*HEIGHT + i*0.3*HEIGHT, 0.03*HEIGHT);
    line(0.65*WIDTH, 0.285*HEIGHT + i*0.3*HEIGHT, 0.65*WIDTH, 0.275*HEIGHT + i*0.3*HEIGHT);
    line(0.65*WIDTH, 0.285*HEIGHT + i*0.3*HEIGHT, 0.662*WIDTH, 0.285*HEIGHT + i*0.3*HEIGHT);
  }
}

//-------------EXERCISES-------------

void exercise_list() {
  String[] exercises = {"Lounges", "Squats", "Push-ups", "Pull-ups", "HIIT run", "Box jumps", "Bear crawl"};

  if (exercise_index != 0) {
    if (up_button(0.45*WIDTH, 0.55*WIDTH, 0.12*HEIGHT, 0.12*HEIGHT + 0.1*WIDTH)) {
      exercise_index--;
      pop_up = 0;
      delay(150);
    }
  }

  if (exercises.length - 3*exercise_index - 3 > 0) {
    if (down_button(0.45*WIDTH, 0.55*WIDTH, 0.92*HEIGHT, 0.92*HEIGHT + 0.1*WIDTH)) {
      exercise_index++;
      pop_up = 0;
      delay(150);
    }
  }

  for (int i = 0; i < (exercises.length - 3*exercise_index > 3 ? 3 : exercises.length - 3*exercise_index); i++) {
    stroke(0);
    strokeWeight(4);
    fill(boxColor1);

    rect(0.1*WIDTH, 0.2*HEIGHT + i*0.25*HEIGHT, 0.8*WIDTH, 0.2*HEIGHT, 8);

    fill(boxColor2);

    rect(0.1*WIDTH, 0.2*HEIGHT + i*0.25*HEIGHT, 0.4*WIDTH, 0.06*HEIGHT, 8);
    if (hover(0.8*WIDTH, 0.9*WIDTH, 0.2*HEIGHT + i*0.25*HEIGHT, 0.26*HEIGHT + i*0.25*HEIGHT)) fill(127, 0, 255);
    else fill(127, 127, 255);
    rect(0.8*WIDTH, 0.2*HEIGHT + i*0.25*HEIGHT, 0.1*WIDTH, 0.06*HEIGHT, 8);

    fill(0);
    textSize(0.03*HEIGHT);
    textAlign(LEFT);
    text(exercises[i + 3*exercise_index], 0.12*WIDTH, 0.24*HEIGHT + i*0.25*HEIGHT);
    text("Description", 0.12*WIDTH, 0.3*HEIGHT + i*0.25*HEIGHT);
    text("Calories burnt: #", 0.12*WIDTH, 0.38*HEIGHT + i*0.25*HEIGHT);

    textSize(0.05*HEIGHT);
    textAlign(CENTER);
    text("?", 0.85*WIDTH, 0.25*HEIGHT + i*0.25*HEIGHT);

    textSize(0.03*HEIGHT);
    textAlign(RIGHT);
    text("Time: #", 0.88*WIDTH, 0.38*HEIGHT + i*0.25*HEIGHT);

    fill(boxColor2);
    strokeWeight(2);
    circle(0.88*WIDTH - textWidth("Time: #") - 0.03*HEIGHT, 0.37*HEIGHT + i*0.25*HEIGHT, 0.03*HEIGHT);
    line(0.88*WIDTH - textWidth("Time: #") - 0.03*HEIGHT, 0.37*HEIGHT + i*0.25*HEIGHT, 0.88*WIDTH - textWidth("Time: #") - 0.03*HEIGHT, 0.36*HEIGHT + i*0.25*HEIGHT);
    line(0.88*WIDTH - textWidth("Time: #") - 0.03*HEIGHT, 0.37*HEIGHT + i*0.25*HEIGHT, 0.88*WIDTH - textWidth("Time: #") - 0.0225*HEIGHT, 0.37*HEIGHT + i*0.25*HEIGHT);

    if (hover(0.8*WIDTH, 0.9*WIDTH, 0.2*HEIGHT + i*0.25*HEIGHT, 0.26*HEIGHT + i*0.25*HEIGHT) & !hold & mousePressed & pop_up == 0) {
      pop_up = 1;
      exercise = exercises[i + 3*exercise_index];
    }
  }
}

//-------------SHOPPING-------------

void shopping_list() {
  stroke(0);
  strokeWeight(4);
  fill(boxColor1);

  rect(0.1*WIDTH, 0.2*HEIGHT, 0.8*WIDTH, 0.6*HEIGHT, 8);

  fill(boxColor2);

  rect(0.5*WIDTH, 0.2*HEIGHT, 0.4*WIDTH, 0.075*HEIGHT, 8);

  fill(0);
  textSize(0.04*HEIGHT);
  textAlign(CENTER);
  text("Items:", 0.3*WIDTH, 0.25*HEIGHT);

  float x1 = 0.5*WIDTH - textWidth("Add to the list")/2, x2 = 0.5*WIDTH + textWidth("Add to the list")/2;
  float y = 0.905*HEIGHT;

  text("Add to the list", 0.5*WIDTH, 0.9*HEIGHT);
  line(x1, y, x2, y);

  if (item_index != 0) {
    if (up_button(0.4*WIDTH, 0.5*WIDTH, 0.8*HEIGHT - 0.1*WIDTH, 0.8*HEIGHT)) {
      item_index--;
      pop_up = 0;
      item_name = "";
      item_price = "";
      delay(150);
    }
  }

  if (shopping_items.size() - 9*item_index > 9) {
    if (down_button(0.5*WIDTH, 0.6*WIDTH, 0.8*HEIGHT - 0.1*WIDTH, 0.8*HEIGHT)) {
      item_index++;
      pop_up = 0;
      item_name = "";
      item_price = "";
      delay(150);
    }
  }

  if (hover(x1, x2, y - 0.04*HEIGHT, y) & !hold & mousePressed & pop_up == 0) {
    pop_up = 1;
    text_entry_mode = 3;
  }

  if (item_name != "" & pop_up != 0) {
    pop_up = 2;
    text_entry_mode = 2;
  }

  if (Float.isNaN(float(item_price)) | float(item_price) < 0) {
    item_price = "";
  } else if (item_price != "")
    pop_up = 0;

  if (item_name != "" & item_price != "") {
    shopping_items.add(new ShoppingItem(item_name, float(item_price)));
    item_name = "";
    item_price = "";
  }

  int x = 0;
  for (int i = 0 + 9*item_index; i < (shopping_items.size() - 9*item_index > 9 ? 9*(item_index + 1) : shopping_items.size()); i++) {
    fill(0);
    textSize(0.03*HEIGHT);
    textAlign(LEFT);
    String text = shopping_items.get(i).name.trim() + " (" + nf(shopping_items.get(i).price, 0, 2) + ")";
    text(text, 0.12*WIDTH, 0.32*HEIGHT + x*0.05*HEIGHT);
    text("x" + shopping_items.get(i).quantity, 0.13*WIDTH + textWidth(text), 0.32*HEIGHT + x*0.05*HEIGHT);

    if (add_button(0.76*WIDTH, 0.83*WIDTH, 0.29*HEIGHT + x*0.05*HEIGHT, 0.33*HEIGHT + x*0.05*HEIGHT) & pop_up == 0 & millis() > timer + 150) {
      shopping_items.get(i).add_one();
      delay(150);
    }

    if (remove_button(0.83*WIDTH, 0.8985*WIDTH, 0.29*HEIGHT + x*0.05*HEIGHT, 0.33*HEIGHT + x*0.05*HEIGHT) & pop_up == 0  & millis() > timer + 150) {
      if (shopping_items.get(i).quantity == 1)
        shopping_items.remove(i);
      else
        shopping_items.get(i).subtract_one();

      delay(150);
    }

    x++;
  }

  float price = 0;
  for (int i = 0; i < shopping_items.size(); i++)
    price += shopping_items.get(i).get_total_price();

  textSize(0.025*HEIGHT);
  textAlign(CENTER);
  text("Total price: " + nf(price, 0, 2), 0.7*WIDTH, 0.247*HEIGHT);
}

//-------------TIPS-------------

void tip_list() {
  String[] tips = {"Having trouble finding \nmotivation? Listen to \nsome energic music!", "Training is always \nbetter with friends", "Improvement takes time; \ndon't give up!", "Tip 4", "Tip 5", "Tip 6", "Tip 7", "Tips 8"};

  if (tip_index != 0) {
    if (up_button(0.45*WIDTH, 0.55*WIDTH, 0.12*HEIGHT, 0.12*HEIGHT + 0.1*WIDTH)) {
      tip_index--;
      delay(150);
    }
  }

  if (tips.length - 3*tip_index - 3 > 0) {
    if (down_button(0.45*WIDTH, 0.55*WIDTH, 0.92*HEIGHT, 0.92*HEIGHT + 0.1*WIDTH)) {
      tip_index++;
      delay(150);
    }
  }

  for (int i = 0; i < (tips.length - 3*tip_index > 3 ? 3 : tips.length - 3*tip_index); i++) {
    stroke(0);
    strokeWeight(4);
    fill(boxColor1);

    rect(0.1*WIDTH, 0.2*HEIGHT + i*0.25*HEIGHT, 0.8*WIDTH, 0.2*HEIGHT, 8);

    fill(0);
    textSize(0.03*HEIGHT);
    textAlign(LEFT);
    text(tips[i + 3*tip_index], 0.12*WIDTH, 0.24*HEIGHT + i*0.25*HEIGHT);
  }
}

//-------------STATS-------------

void personal_stats() {
  stroke(0);
  strokeWeight(4);
  fill(boxColor1);

  rect(0.1*WIDTH, 0.16*HEIGHT, 0.8*WIDTH, 0.08*HEIGHT, 8);
  rect(0.1*WIDTH, 0.29*HEIGHT, 0.8*WIDTH, 0.08*HEIGHT, 8);
  rect(0.1*WIDTH, 0.42*HEIGHT, 0.8*WIDTH, 0.08*HEIGHT, 8);
  rect(0.1*WIDTH, 0.55*HEIGHT, 0.8*WIDTH, 0.25*HEIGHT, 8);
  rect(0.1*WIDTH, 0.85*HEIGHT, 0.8*WIDTH, 0.08*HEIGHT, 8);

  fill(0);
  textSize(0.03*HEIGHT);
  textAlign(LEFT);
  text("# of days on calorie target: 27", 0.12*WIDTH, 0.21*HEIGHT);
  text("# kg gained/lost: 0.5", 0.12*WIDTH, 0.34*HEIGHT);
  text("# of weeks within budget: 2", 0.12*WIDTH, 0.47*HEIGHT);
  text("Last meal, calories: 350", 0.12*WIDTH, 0.9*HEIGHT);
  textAlign(CENTER);
  text("Graphs\n\n(temporarily imaginary)", 0.5*WIDTH, 0.6*HEIGHT);
}


//------------------------------------------------------------------------------
//SCREENS
//------------------------------------------------------------------------------


void home() {
  options();
  title("Home", 0.08);
  calories();
  budget();
  pop_up(screen, pop_up);
  dropdown_hover();
  screen = change_screen(screen);
}

void recipes() {
  options();
  title("Recipes", 0.08);
  recipe_list();
  pop_up(screen, pop_up);
  dropdown_hover();
  screen = change_screen(screen);
}

void exercises() {
  options();
  title("Exercises", 0.08);
  exercise_list();
  pop_up(screen, pop_up);
  dropdown_hover();
  screen = change_screen(screen);
}

void shopping() {
  options();
  title("Shopping List", 0.07);
  shopping_list();
  pop_up(screen, pop_up);
  dropdown_hover();
  screen = change_screen(screen);
}

void tips() {
  options();
  title("Helpful tips", 0.07);
  tip_list();
  dropdown_hover();
  screen = change_screen(screen);
}

void stats() {
  options();
  title("Personal stats", 0.07);
  personal_stats();
  dropdown_hover();
  screen = change_screen(screen);
}


//------------------------------------------------------------------------------
//MAIN LOOP
//------------------------------------------------------------------------------


void draw() {
  background(backgroundColor);
  load_screen(screen);
}
