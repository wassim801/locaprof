import 'package:cloud_firestore/cloud_firestore.dart';
class RentalFees {
  final double baseAmount;
  final double charges;
  final double deposit;
  final double total;

  RentalFees({
    required this.baseAmount,
    required this.charges,
    required this.deposit,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'baseAmount': baseAmount,
      'charges': charges,
      'deposit': deposit,
      'total': total,
    };
  }

  factory RentalFees.fromJson(Map<String, dynamic> json) {
    return RentalFees(
      baseAmount: (json['baseAmount'] as num).toDouble(),
      charges: (json['charges'] as num).toDouble(),
      deposit: (json['deposit'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class BookingModel {
  final String id;
  final String propertyId;
  final String tenantId;
  final String ownerId;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;
  final RentalFees fees;
  final String status; // en_attente, confirme, refuse, annule, termine
  final String paymentStatus; // en_attente, paye, rembourse
  final bool contractSigned;
  final String? contractUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? cancellationReason;
  final String? notes;

  BookingModel({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.ownerId,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.fees,
    required this.status,
    required this.paymentStatus,
    required this.contractSigned,
    this.contractUrl,
    required this.createdAt,
    required this.updatedAt,
    this.cancellationReason,
    this.notes,
  });

  BookingModel copyWith({
    String? status,
    String? paymentStatus,
    bool? contractSigned,
    String? contractUrl,
    DateTime? updatedAt,
    String? cancellationReason,
    String? notes,
  }) {
    return BookingModel(
      id: id,
      propertyId: propertyId,
      tenantId: tenantId,
      ownerId: ownerId,
      startDate: startDate,
      endDate: endDate,
      duration: duration,
      fees: fees,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      contractSigned: contractSigned ?? this.contractSigned,
      contractUrl: contractUrl ?? this.contractUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      cancellationReason: cancellationReason ?? this.cancellationReason,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'tenantId': tenantId,
      'ownerId': ownerId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'duration': duration,
      'fees': fees.toJson(),
      'status': status,
      'paymentStatus': paymentStatus,
      'contractSigned': contractSigned,
      'contractUrl': contractUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'cancellationReason': cancellationReason,
      'notes': notes,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String,
      tenantId: json['tenantId'] as String,
      ownerId: json['ownerId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      duration: json['duration'] as int,
      fees: RentalFees.fromJson(json['fees'] as Map<String, dynamic>),
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      contractSigned: json['contractSigned'] as bool,
      contractUrl: json['contractUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cancellationReason: json['cancellationReason'] as String?,
      notes: json['notes'] as String?,
    );
  }

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      propertyId: data['propertyId'] as String,
      tenantId: data['tenantId'] as String,
      ownerId: data['ownerId'] as String,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      duration: data['duration'] as int,
      fees: RentalFees.fromJson(data['fees'] as Map<String, dynamic>),
      status: data['status'] as String,
      paymentStatus: data['paymentStatus'] as String,
      contractSigned: data['contractSigned'] as bool,
      contractUrl: data['contractUrl'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      cancellationReason: data['cancellationReason'] as String?,
      notes: data['notes'] as String?,
    );
  }

  bool get isUpcoming =>
      status == 'confirme' && startDate.isAfter(DateTime.now());

  bool get isPast =>
      status == 'termine' ||
      (status == 'confirme' && endDate.isBefore(DateTime.now()));

  bool get isPending => status == 'en_attente';

  bool get isConfirmed => status == 'confirme';

  bool get isCancelled => status == 'annule';

  bool get isRefused => status == 'refuse';

  bool get isCompleted => status == 'termine';

  bool get isPaid => paymentStatus == 'paye';

  bool get isPaymentPending => paymentStatus == 'en_attente';

  bool get isRefunded => paymentStatus == 'rembourse';
}
