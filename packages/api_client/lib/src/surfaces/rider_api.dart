import 'package:core_models/core_models.dart';

import 'base_api.dart';

/// Rider routes (§5).
class RiderApi extends BaseApi {
  const RiderApi(super.client);

  /// `GET /rider/profile`.
  Future<RiderProfile> profile() async =>
      RiderProfile.fromJson(unwrap(await client.get('/rider/profile')));

  /// `PATCH /rider/profile { isOnline }`.
  Future<RiderProfile> updateProfile(UpdateRiderProfileRequest request) async =>
      RiderProfile.fromJson(unwrap(await client.patch('/rider/profile', data: request.toJson())));

  /// Shortcut for `PATCH /rider/profile { isOnline }`.
  Future<RiderProfile> setOnline(bool isOnline) =>
      updateProfile(UpdateRiderProfileRequest(isOnline: isOnline));

  /// `POST /rider/location` (the socket `rider.location` event is preferred
  /// while connected; this is the fallback/outbox path).
  Future<void> sendLocation(RiderLocationUpdate update) =>
      client.post('/rider/location', data: update.toJson());

  /// `GET /rider/deliveries?status=&cursor=`.
  Future<Paginated<Delivery>> deliveries({DeliveryStatus? status, String? cursor, int? limit}) async =>
      asPage(
        await client.get('/rider/deliveries', query: {'status': status, 'cursor': cursor, 'limit': limit}),
        Delivery.fromJson,
      );

  /// `GET /rider/deliveries/:id`.
  Future<Delivery> delivery(String id) async =>
      Delivery.fromJson(unwrap(await client.get('/rider/deliveries/$id')));

  /// `POST /rider/deliveries/:id/respond { accept }`. Online only.
  Future<Delivery> respond(String deliveryId, {required bool accept}) async =>
      Delivery.fromJson(unwrap(await client.post(
        '/rider/deliveries/$deliveryId/respond',
        data: RespondDeliveryRequest(accept: accept).toJson(),
      )));

  /// `POST /rider/deliveries/:id/pickup`.
  Future<Delivery> pickup(String deliveryId) async =>
      Delivery.fromJson(unwrap(await client.post('/rider/deliveries/$deliveryId/pickup')));

  /// `POST /rider/deliveries/:id/deliver` with `{ otp }` (JSON) or a
  /// multipart photo when [photoBytes] is given.
  Future<Delivery> deliver(
    String deliveryId, {
    String? otp,
    List<int>? photoBytes,
    String photoFilename = 'proof.jpg',
    String photoContentType = 'image/jpeg',
  }) async {
    final path = '/rider/deliveries/$deliveryId/deliver';
    final Object? body;
    if (photoBytes != null) {
      body = await client.upload(
        path,
        bytes: photoBytes,
        filename: photoFilename,
        field: 'photo',
        contentType: photoContentType,
        fields: {'otp': ?otp},
      );
    } else {
      body = await client.post(path, data: DeliverRequest(otp: otp).toJson());
    }
    return Delivery.fromJson(unwrap(body));
  }
}
