class ApiConfig {
  static const String baseUrl = 'https://www.bytesymphony.dev/TestAPI';

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String me = '/api/me';

  // Client endpoints
  static const String clients = '/api/clients';
  static String clientById(int id) => '/api/clients/$id';

  // Invoice endpoints
  static const String invoices = '/api/invoices';
  static String invoiceById(int id) => '/api/invoices/$id';

  // Ping
  static const String ping = '/api/ping';

  // Demo credentials
  static const String demoEmail = 'admin@demo.dev';
  static const String demoPassword = 'Admin@123';
}
