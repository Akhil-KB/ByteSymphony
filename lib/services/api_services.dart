import 'package:bytesymphony/services/storage_services.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/client_model.dart';
import '../models/invoice_model.dart';
import '../models/user_model.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Helper method to extract error message safely
// Helper method to extract and truncate error message
  static String _extractErrorMessage(DioException e, String defaultMessage) {
    String errorMessage = defaultMessage;

    if (e.response?.data != null) {
      final data = e.response!.data;

      if (data is Map<String, dynamic>) {
        errorMessage = data['message'] ?? data['error'] ?? defaultMessage;
      } else if (data is String) {
        errorMessage = data;
      }
    } else if (e.message != null) {
      errorMessage = e.message!;
    }

    // Truncate long messages (max 100 characters)
    if (errorMessage.length > 100) {
      return '${errorMessage.substring(0, 100)}...';
    }

    return errorMessage;
  }


  // Add interceptor for token
  static void init() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await StorageService.clearAll();
          }
          return handler.next(error);
        },
      ),
    );
  }

  // ============ AUTH ============

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return {
        'success': true,
        'token': response.data['token'],
        'message': 'Login successful',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _extractErrorMessage(e, 'Login failed'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  static Future<UserModel?> getUserDetails() async {
    try {
      final response = await _dio.get(ApiConfig.me);
      return UserModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  // ============ CLIENTS ============

  static Future<List<ClientModel>> getClients({
    String? search,
    int page = 1,
    int pageSize = 20,
    String? sortBy,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      final response = await _dio.get(
        ApiConfig.clients,
        queryParameters: queryParams,
      );

      final data = response.data;
      List<dynamic> clientsList;

      if (data is Map && data.containsKey('items')) {
        clientsList = data['items'] as List;
      } else if (data is List) {
        clientsList = data;
      } else {
        return [];
      }

      return clientsList.map((json) => ClientModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load clients: $e');
    }
  }

  static Future<ClientModel?> getClientById(int id) async {
    try {
      final response = await _dio.get(ApiConfig.clientById(id));
      return ClientModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>> createClient(ClientModel client) async {
    try {
      final response = await _dio.post(
        ApiConfig.clients,
        data: client.toJson(),
      );
      return {
        'success': true,
        'client': ClientModel.fromJson(response.data),
        'message': 'Client created successfully',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _extractErrorMessage(e, 'Failed to create client'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  static Future<Map<String, dynamic>> updateClient(String id, ClientModel client) async {
    try {
      final response = await _dio.put(
        ApiConfig.clientById(int.parse(id)),
        data: client.toJson(),
      );
      return {
        'success': true,
        'client': ClientModel.fromJson(response.data),
        'message': 'Client updated successfully',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _extractErrorMessage(e, 'Failed to update client'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  static Future<Map<String, dynamic>> deleteClient(int id) async {
    try {
      await _dio.delete(ApiConfig.clientById(id));
      return {
        'success': true,
        'message': 'Client deleted successfully',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _extractErrorMessage(e, 'Failed to delete client'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // ============ INVOICES ============

  static Future<List<InvoiceModel>> getInvoices({
    int? clientId,
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };

      if (clientId != null) {
        queryParams['clientId'] = clientId;
      }

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dio.get(
        ApiConfig.invoices,
        queryParameters: queryParams,
      );

      final data = response.data;
      List<dynamic> invoicesList;

      if (data is Map && data.containsKey('items')) {
        invoicesList = data['items'] as List;
      } else if (data is List) {
        invoicesList = data;
      } else {
        return [];
      }

      return invoicesList.map((json) => InvoiceModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load invoices: $e');
    }
  }

  static Future<Map<String, dynamic>> createInvoice(InvoiceModel invoice) async {
    try {
      final response = await _dio.post(
        ApiConfig.invoices,
        data: invoice.toJson(),
      );
      return {
        'success': true,
        'invoice': InvoiceModel.fromJson(response.data),
        'message': 'Invoice created successfully',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _extractErrorMessage(e, 'Failed to create invoice'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  static Future<Map<String, dynamic>> updateInvoice(int id, InvoiceModel invoice) async {
    try {
      final response = await _dio.put(
        ApiConfig.invoiceById(id),
        data: invoice.toJson(),
      );
      return {
        'success': true,
        'invoice': InvoiceModel.fromJson(response.data),
        'message': 'Invoice updated successfully',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': _extractErrorMessage(e, 'Failed to update invoice'),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  // ============ PING ============

  static Future<bool> ping() async {
    try {
      await _dio.get(ApiConfig.ping);
      return true;
    } catch (e) {
      return false;
    }
  }
}
