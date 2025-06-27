import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';

final bookingProvider = StateNotifierProvider<BookingNotifier, List<BookingModel>>(
    (ref) => BookingNotifier());

class BookingNotifier extends StateNotifier<List<BookingModel>> {
  BookingNotifier() : super([]);

  final _db = FirebaseFirestore.instance;

  Future<void> fetchBookings({String? tenantId, String? propertyId, String? status}) async {
    try {
      Query query = _db.collection('bookings');
      
      if (tenantId != null) {
        query = query.where('tenantId', isEqualTo: tenantId);
      }
      if (propertyId != null) {
        query = query.where('propertyId', isEqualTo: propertyId);
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      final snapshot = await query.get();
      state = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      final docRef = await _db.collection('bookings').add({
        ...booking.toJson(),
        'status': 'en_attente',
        'paymentStatus': 'en_attente',
        'contractSigned': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      final doc = await docRef.get();
      final newBooking = BookingModel.fromFirestore(doc);
      state = [...state, newBooking];
      return newBooking;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status, {String? reason}) async {
    try {
      final updates = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (reason != null) {
        updates['cancellationReason'] = reason;
      }
      await _db.collection('bookings').doc(bookingId).update(updates);

      state = state.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
        }
        return booking;
      }).toList();
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  Future<void> updatePaymentStatus(String bookingId, String paymentStatus) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'paymentStatus': paymentStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      state = state.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            paymentStatus: paymentStatus,
            updatedAt: DateTime.now(),
          );
        }
        return booking;
      }).toList();
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  Future<void> updateContractStatus(String bookingId, bool signed, {String? contractUrl}) async {
    try {
      final updates = {
        'contractSigned': signed,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (contractUrl != null) {
        updates['contractUrl'] = contractUrl;
      }

      await _db.collection('bookings').doc(bookingId).update(updates);

      state = state.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            contractSigned: signed,
            contractUrl: contractUrl ?? booking.contractUrl,
            updatedAt: DateTime.now(),
          );
        }
        return booking;
      }).toList();
    } catch (e) {
      throw Exception('Failed to update contract status: $e');
    }
  }

  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'status': 'annule',
        'cancellationReason': reason,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      state = state.map((booking) {
        if (booking.id == bookingId) {
          return booking.copyWith(
            status: 'annule',
            cancellationReason: reason,
            updatedAt: DateTime.now(),
          );
        }
        return booking;
      }).toList();
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  Future<void> fetchOwnerBookings(String ownerId) async {
    try {
      final snapshot = await _db.collection('bookings')
          .where('ownerId', isEqualTo: ownerId)
          .get();
      state = snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch owner bookings: $e');
    }
  }

  List<BookingModel> getUpcomingBookings() {
    return state.where((booking) => booking.isUpcoming).toList();
  }

  List<BookingModel> getCurrentBookings() {
    return state.where((booking) =>
        booking.startDate.isBefore(DateTime.now()) &&
        booking.endDate.isAfter(DateTime.now()) &&
        booking.status == 'confirme')
    .toList();
  }

  List<BookingModel> getPastBookings() {
    return state.where((booking) => booking.isPast).toList();
  }
}