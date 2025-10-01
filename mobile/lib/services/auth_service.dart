import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService {
  // URL da API - usa HTTP em web para evitar problemas de certificado SSL
  static String get baseUrl {
    // Em web (Chrome), usar HTTP para evitar problemas com certificado self-signed
    if (kIsWeb) {
      return 'http://localhost:5001/api';
    }
    // Em desktop/mobile, usar HTTPS
    return 'https://localhost:7001/api';
  }
  
  // Registrar novo usuário
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      if (kDebugMode) {
        print('Registrando usuário em: $baseUrl/auth/register');
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );

      if (kDebugMode) {
        print('Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(json.decode(response.body));
        return RegisterResult(success: true, authResponse: authResponse);
      }
      
      // Tratar erros específicos
      if (response.statusCode == 400) {
        try {
          final errorData = json.decode(response.body);
          
          // Verificar se é erro de email existente
          if (errorData['errorCode'] == 'EMAIL_EXISTS') {
            return RegisterResult(
              success: false,
              errorMessage: 'Este email já está cadastrado',
            );
          }
          
          // Verificar erros de validação
          if (errorData['errors'] != null) {
            final errors = errorData['errors'] as Map<String, dynamic>;
            
            // Verificar erro de telefone
            if (errors.containsKey('Phone')) {
              final phoneErrors = errors['Phone'] as List;
              return RegisterResult(
                success: false,
                errorMessage: phoneErrors.first.toString(),
              );
            }
            
            // Verificar outros erros
            if (errors.isNotEmpty) {
              final firstError = errors.values.first;
              if (firstError is List && firstError.isNotEmpty) {
                return RegisterResult(
                  success: false,
                  errorMessage: firstError.first.toString(),
                );
              }
            }
          }
          
          // Mensagem genérica da API
          if (errorData['message'] != null) {
            return RegisterResult(
              success: false,
              errorMessage: errorData['message'].toString(),
            );
          }
        } catch (e) {
          if (kDebugMode) {
            print('Erro ao parsear erro da API: $e');
          }
        }
      }
      
      return RegisterResult(
        success: false,
        errorMessage: 'Erro ao cadastrar. Verifique os dados e tente novamente.',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao registrar: $e');
      }
      return RegisterResult(
        success: false,
        errorMessage: 'Erro de conexão. Verifique se a API está rodando.',
      );
    }
  }

  // Login do usuário
  Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      if (kDebugMode) {
        print('Fazendo login em: $baseUrl/auth/login');
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (kDebugMode) {
        print('Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(json.decode(response.body));
      }
      
      if (kDebugMode) {
        print('Erro no login: ${response.statusCode} - ${response.body}');
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer login: $e');
      }
      return null;
    }
  }

  // Obter perfil do usuário
  Future<UserProfile?> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(json.decode(response.body));
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao obter perfil: $e');
      }
      return null;
    }
  }

  // Verificar se token é válido
  Future<bool> verifyToken(String token) async {
    try {
      if (kDebugMode) {
        print('Verificando token em: $baseUrl/auth/verify');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('Status verify: ${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar token: $e');
      }
      return false;
    }
  }
}

// Resultado do registro (com tratamento de erros)
class RegisterResult {
  final bool success;
  final AuthResponse? authResponse;
  final String? errorMessage;

  RegisterResult({
    required this.success,
    this.authResponse,
    this.errorMessage,
  });
}

// Modelo de resposta de autenticação
class AuthResponse {
  final String userId;
  final String name;
  final String email;
  final String token;
  final DateTime expiresAt;

  AuthResponse({
    required this.userId,
    required this.name,
    required this.email,
    required this.token,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}

// Modelo de perfil do usuário
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime createdAt;
  final bool isActive;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.createdAt,
    required this.isActive,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      isActive: json['isActive'],
    );
  }
}

