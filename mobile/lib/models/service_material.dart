class ServiceMaterial {
  final int id;
  final String name;
  final String? brand;
  final int quantity;
  final String unit;
  final double? estimatedPrice;
  final String? notes;

  ServiceMaterial({
    required this.id,
    required this.name,
    this.brand,
    required this.quantity,
    required this.unit,
    this.estimatedPrice,
    this.notes,
  });

  factory ServiceMaterial.fromJson(Map<String, dynamic> json) {
    return ServiceMaterial(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      quantity: json['quantity'],
      unit: json['unit'],
      estimatedPrice: json['estimatedPrice']?.toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'quantity': quantity,
      'unit': unit,
      'estimatedPrice': estimatedPrice,
      'notes': notes,
    };
  }
}
