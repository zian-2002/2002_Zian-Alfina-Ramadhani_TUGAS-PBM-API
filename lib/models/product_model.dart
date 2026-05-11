class ProductModel {
  final int? id;
  final String name;
  final int price;
  final String description;
  final String? githubUrl;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    this.githubUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'] is int
          ? json['price']
          : (double.tryParse(json['price'].toString())?.toInt() ?? 0),
      description: json['description'] ?? '',
      githubUrl: json['github_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      if (githubUrl != null) 'github_url': githubUrl,
    };
  }
}
