import 'service_material.dart';

class Service {
  final int id;
  final String userId;
  final String userName;
  final String title;
  final String description;
  final String serviceType;
  final String location;
  final String locationType;
  final DateTime preferredStartDate;
  final DateTime preferredEndDate;
  final String preferredTime;
  final bool requiresMaterials;
  final String? materialsDescription;
  final double? budgetRange;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ServiceMaterial> materials;
  final int proposalCount;

  Service({
    required this.id,
    required this.userId,
    required this.userName,
    required this.title,
    required this.description,
    required this.serviceType,
    required this.location,
    required this.locationType,
    required this.preferredStartDate,
    required this.preferredEndDate,
    required this.preferredTime,
    required this.requiresMaterials,
    this.materialsDescription,
    this.budgetRange,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.materials,
    required this.proposalCount,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'] ?? 'Usuário',
      title: json['title'],
      description: json['description'],
      serviceType: json['serviceType'],
      location: json['location'],
      locationType: json['locationType'],
      preferredStartDate: DateTime.parse(json['preferredStartDate']),
      preferredEndDate: DateTime.parse(json['preferredEndDate']),
      preferredTime: json['preferredTime'],
      requiresMaterials: json['requiresMaterials'],
      materialsDescription: json['materialsDescription'],
      budgetRange: json['budgetRange']?.toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      materials: (json['materials'] as List<dynamic>?)
          ?.map((material) => ServiceMaterial.fromJson(material))
          .toList() ?? [],
      proposalCount: json['proposalCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'title': title,
      'description': description,
      'serviceType': serviceType,
      'location': location,
      'locationType': locationType,
      'preferredStartDate': preferredStartDate.toIso8601String(),
      'preferredEndDate': preferredEndDate.toIso8601String(),
      'preferredTime': preferredTime,
      'requiresMaterials': requiresMaterials,
      'materialsDescription': materialsDescription,
      'budgetRange': budgetRange,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'materials': materials.map((material) => material.toJson()).toList(),
      'proposalCount': proposalCount,
    };
  }
}

class CreateServiceRequest {
  final String title;
  final String description;
  final String serviceType;
  final String location;
  final String locationType;
  final DateTime preferredStartDate;
  final DateTime preferredEndDate;
  final String preferredTime;
  final bool requiresMaterials;
  final String? materialsDescription;
  final double? budgetRange;
  final List<ServiceMaterialRequest>? materials;

  CreateServiceRequest({
    required this.title,
    required this.description,
    required this.serviceType,
    required this.location,
    required this.locationType,
    required this.preferredStartDate,
    required this.preferredEndDate,
    required this.preferredTime,
    required this.requiresMaterials,
    this.materialsDescription,
    this.budgetRange,
    this.materials,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'serviceType': serviceType,
      'location': location,
      'locationType': locationType,
      'preferredStartDate': preferredStartDate.toIso8601String(),
      'preferredEndDate': preferredEndDate.toIso8601String(),
      'preferredTime': preferredTime,
      'requiresMaterials': requiresMaterials,
      'materialsDescription': materialsDescription,
      'budgetRange': budgetRange,
      'materials': materials?.map((material) => material.toJson()).toList(),
    };
  }
}

class ServiceMaterialRequest {
  final String name;
  final String? brand;
  final int quantity;
  final String unit;
  final double? estimatedPrice;
  final String? notes;

  ServiceMaterialRequest({
    required this.name,
    this.brand,
    required this.quantity,
    required this.unit,
    this.estimatedPrice,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'quantity': quantity,
      'unit': unit,
      'estimatedPrice': estimatedPrice,
      'notes': notes,
    };
  }
}
