class InvoiceModel {
  final int? id;
  final String invoiceNo;
  final int clientId;
  final double total;
  final String status;
  final String? clientName;

  InvoiceModel({
    this.id,
    required this.invoiceNo,
    required this.clientId,
    required this.total,
    required this.status,
    this.clientName,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] as int?,
      invoiceNo: json['invoiceNo'] as String? ?? '',
      clientId: json['clientId'] as int? ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Pending',
      clientName: json['clientName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'invoiceNo': invoiceNo,
      'clientId': clientId,
      'total': total,
      'status': status,
    };
    if (id != null) {
      data['id'] = id!;
    }
    if (clientName != null) {
      data['clientName'] = clientName!;
    }
    return data;
  }

  InvoiceModel copyWith({
    int? id,
    String? invoiceNo,
    int? clientId,
    double? total,
    String? status,
    String? clientName,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      clientId: clientId ?? this.clientId,
      total: total ?? this.total,
      status: status ?? this.status,
      clientName: clientName ?? this.clientName,
    );
  }
}
