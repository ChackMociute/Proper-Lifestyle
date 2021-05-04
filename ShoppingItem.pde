public class ShoppingItem {
  String name;
  float price;
  int quantity = 1;
  
  public ShoppingItem (String name, float price) {
    this.name = name;
    this.price = price;
  }
  
  void add_one () {
    quantity++;
  }
  
  void subtract_one () {
    if (quantity > 1)
      quantity--;
  }
  
  float get_total_price () {
    return price * quantity;
  }
}
