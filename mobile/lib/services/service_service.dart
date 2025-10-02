import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/service.dart';
import '../models/service_material.dart';
import '../models/proposal.dart';
import 'token_storage.dart';

class ServiceService {
  // Determinar URL base baseado na plataforma
  String get baseUrl {
    if (kIsWeb) {
      // Para web, usar HTTP para evitar problemas de SSL
      return 'http://localhost:5001/api';
    } else {
      // Para mobile/desktop, usar HTTPS
      return 'https://localhost:7001/api';
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await TokenStorage().getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ========== SERVIÇOS ==========

  /// Lista todos os serviços ativos
  Future<List<Service>> getActiveServices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar serviços: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Lista serviços por tipo
  Future<List<Service>> getServicesByType(String serviceType) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services/type/${Uri.encodeComponent(serviceType)}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar serviços: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Lista serviços por localização
  Future<List<Service>> getServicesByLocation(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services/location/${Uri.encodeComponent(location)}'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar serviços: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Obtém todos os serviços do usuário logado
  Future<List<Service>> getMyServices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services/my-services'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar meus serviços: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Obtém um serviço por ID
  Future<Service> getServiceById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Service.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Serviço não encontrado');
      } else {
        throw Exception('Erro ao carregar serviço: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }


  /// Cria um novo serviço
  Future<Service> createService(CreateServiceRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/services'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Service.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao criar serviço';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Atualiza um serviço
  Future<Service> updateService(int id, CreateServiceRequest request) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/services/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Service.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao atualizar serviço';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Exclui um serviço
  Future<void> deleteService(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/services/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 204) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao excluir serviço';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // ========== PROPOSTAS ==========

  /// Obtém todas as propostas do usuário logado
  Future<List<Proposal>> getMyProposals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/proposals/my-proposals'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Proposal.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar minhas propostas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Lista propostas por serviço
  Future<List<Proposal>> getProposalsByServiceId(int serviceId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/proposals/service/$serviceId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Proposal.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar propostas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }


  /// Obtém uma proposta por ID
  Future<Proposal> getProposalById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/proposals/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Proposal.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Proposta não encontrada');
      } else {
        throw Exception('Erro ao carregar proposta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Cria uma nova proposta
  Future<Proposal> createProposal(int serviceId, CreateProposalRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/proposals/service/$serviceId'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Proposal.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao criar proposta';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Atualiza uma proposta
  Future<Proposal> updateProposal(int id, CreateProposalRequest request) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/proposals/$id'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Proposal.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao atualizar proposta';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Exclui uma proposta
  Future<void> deleteProposal(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/proposals/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 204) {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao excluir proposta';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Aceita uma proposta
  Future<Proposal> acceptProposal(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/proposals/$id/accept'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Proposal.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao aceitar proposta';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Rejeita uma proposta
  Future<Proposal> rejectProposal(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/proposals/$id/reject'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Proposal.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao rejeitar proposta';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Conclui uma proposta aceita
  Future<Proposal> completeProposal(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/proposals/$id/complete'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Proposal.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao concluir proposta';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  /// Avalia uma proposta concluída
  Future<Proposal> evaluateProposal(int id, EvaluateProposalRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/proposals/$id/evaluate'),
        headers: await _getHeaders(),
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Proposal.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Erro ao avaliar proposta';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
