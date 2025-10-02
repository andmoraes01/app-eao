class Proposal {
  final int id;
  final int serviceId;
  final String contractorId;
  final String contractorName;
  final String description;
  final double laborCost;
  final double? materialCost;
  final double totalCost;
  final DateTime estimatedStartDate;
  final DateTime estimatedEndDate;
  final String status;
  final String? notes;
  final int? rating;
  final String? evaluationComment;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProposalMaterial> materials;

  Proposal({
    required this.id,
    required this.serviceId,
    required this.contractorId,
    required this.contractorName,
    required this.description,
    required this.laborCost,
    this.materialCost,
    required this.totalCost,
    required this.estimatedStartDate,
    required this.estimatedEndDate,
    required this.status,
    this.notes,
    this.rating,
    this.evaluationComment,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.materials,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      id: json['id'],
      serviceId: json['serviceId'],
      contractorId: json['contractorId'],
      contractorName: json['contractorName'] ?? 'Prestador',
      description: json['description'],
      laborCost: json['laborCost'].toDouble(),
      materialCost: json['materialCost']?.toDouble(),
      totalCost: json['totalCost'].toDouble(),
      estimatedStartDate: DateTime.parse(json['estimatedStartDate']),
      estimatedEndDate: DateTime.parse(json['estimatedEndDate']),
      status: json['status'],
      notes: json['notes'],
      rating: json['rating'],
      evaluationComment: json['evaluationComment'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      materials: (json['materials'] as List<dynamic>?)
          ?.map((material) => ProposalMaterial.fromJson(material))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'contractorId': contractorId,
      'contractorName': contractorName,
      'description': description,
      'laborCost': laborCost,
      'materialCost': materialCost,
      'totalCost': totalCost,
      'estimatedStartDate': estimatedStartDate.toIso8601String(),
      'estimatedEndDate': estimatedEndDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'rating': rating,
      'evaluationComment': evaluationComment,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'materials': materials.map((material) => material.toJson()).toList(),
    };
  }
}

class CreateProposalRequest {
  final String description;
  final double laborCost;
  final double? materialCost;
  final DateTime estimatedStartDate;
  final DateTime estimatedEndDate;
  final String? notes;
  final List<ProposalMaterialRequest>? materials;

  CreateProposalRequest({
    required this.description,
    required this.laborCost,
    this.materialCost,
    required this.estimatedStartDate,
    required this.estimatedEndDate,
    this.notes,
    this.materials,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'laborCost': laborCost,
      'materialCost': materialCost,
      'estimatedStartDate': estimatedStartDate.toIso8601String(),
      'estimatedEndDate': estimatedEndDate.toIso8601String(),
      'notes': notes,
      'materials': materials?.map((material) => material.toJson()).toList(),
    };
  }
}

class ProposalMaterial {
  final int id;
  final String name;
  final String? brand;
  final int quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;
  final String? notes;

  ProposalMaterial({
    required this.id,
    required this.name,
    this.brand,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
    this.notes,
  });

  factory ProposalMaterial.fromJson(Map<String, dynamic> json) {
    return ProposalMaterial(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      quantity: json['quantity'],
      unit: json['unit'],
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
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
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'notes': notes,
    };
  }
}

class ProposalMaterialRequest {
  final String name;
  final String? brand;
  final int quantity;
  final String unit;
  final double unitPrice;
  final String? notes;

  ProposalMaterialRequest({
    required this.name,
    this.brand,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'quantity': quantity,
      'unit': unit,
      'unitPrice': unitPrice,
      'notes': notes,
    };
  }
}

class EvaluateProposalRequest {
  final int rating;
  final String? evaluationComment;

  EvaluateProposalRequest({
    required this.rating,
    this.evaluationComment,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'evaluationComment': evaluationComment,
    };
  }
}
