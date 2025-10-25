class CartItem {
  final String id; // product id
  final String name;
  final double price;
  final String image; // أول صورة تكفي للعرض
  final int qty;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.qty,
  });

  CartItem copyWith({int? qty}) => CartItem(
    id: id,
    name: name,
    price: price,
    image: image,
    qty: qty ?? this.qty,
  );

  double get lineTotal => price * qty;

  factory CartItem.fromJson(Map<String, dynamic> j) => CartItem(
    id: j['id'] as String,
    name: j['name'] as String,
    price: (j['price'] as num).toDouble(),
    image: (j['image'] ?? '') as String,
    qty: (j['qty'] as num).toInt(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'image': image,
    'qty': qty,
  };
}
