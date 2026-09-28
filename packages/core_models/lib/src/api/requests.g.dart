// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    _RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      vendorId: json['vendorId'] as String?,
      vendorName: json['vendorName'] as String?,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(_RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'fullName': instance.fullName,
      'phone': ?instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'vendorId': ?instance.vendorId,
      'vendorName': ?instance.vendorName,
      'deviceId': ?instance.deviceId,
    };

const _$UserRoleEnumMap = {
  UserRole.customer: 'customer',
  UserRole.rider: 'rider',
  UserRole.vendorOwner: 'vendor_owner',
  UserRole.vendorStaff: 'vendor_staff',
  UserRole.admin: 'admin',
};

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'deviceId': ?instance.deviceId,
    };

_RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    _RefreshTokenRequest(
      refreshToken: json['refreshToken'] as String,
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$RefreshTokenRequestToJson(
  _RefreshTokenRequest instance,
) => <String, dynamic>{
  'refreshToken': instance.refreshToken,
  'deviceId': ?instance.deviceId,
};

_CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    _CreateOrderRequest(
      addressId: json['addressId'] as String,
      note: json['note'] as String?,
      paymentProvider: json['paymentProvider'] as String? ?? 'stripe',
      idempotencyKey: json['idempotencyKey'] as String?,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(_CreateOrderRequest instance) =>
    <String, dynamic>{
      'addressId': instance.addressId,
      'note': ?instance.note,
      'paymentProvider': instance.paymentProvider,
      'idempotencyKey': ?instance.idempotencyKey,
    };

_StockAdjustRequest _$StockAdjustRequestFromJson(Map<String, dynamic> json) =>
    _StockAdjustRequest(
      variantId: json['variantId'] as String?,
      delta: (json['delta'] as num).toInt(),
      reason:
          $enumDecodeNullable(_$InventoryReasonEnumMap, json['reason']) ??
          InventoryReason.adjustment,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$StockAdjustRequestToJson(_StockAdjustRequest instance) =>
    <String, dynamic>{
      'variantId': ?instance.variantId,
      'delta': instance.delta,
      'reason': _$InventoryReasonEnumMap[instance.reason]!,
      'note': ?instance.note,
    };

const _$InventoryReasonEnumMap = {
  InventoryReason.sale: 'sale',
  InventoryReason.restock: 'restock',
  InventoryReason.adjustment: 'adjustment',
  InventoryReason.returned: 'return',
  InventoryReason.cancel: 'cancel',
};

_UpdateSubOrderStatusRequest _$UpdateSubOrderStatusRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateSubOrderStatusRequest(
  status: $enumDecode(_$SubOrderStatusEnumMap, json['status']),
  note: json['note'] as String?,
);

Map<String, dynamic> _$UpdateSubOrderStatusRequestToJson(
  _UpdateSubOrderStatusRequest instance,
) => <String, dynamic>{
  'status': _$SubOrderStatusEnumMap[instance.status]!,
  'note': ?instance.note,
};

const _$SubOrderStatusEnumMap = {
  SubOrderStatus.awaitingPayment: 'awaiting_payment',
  SubOrderStatus.placed: 'placed',
  SubOrderStatus.accepted: 'accepted',
  SubOrderStatus.preparing: 'preparing',
  SubOrderStatus.ready: 'ready',
  SubOrderStatus.outForDelivery: 'out_for_delivery',
  SubOrderStatus.delivered: 'delivered',
  SubOrderStatus.cancelled: 'cancelled',
};

_AssignDeliveryRequest _$AssignDeliveryRequestFromJson(
  Map<String, dynamic> json,
) => _AssignDeliveryRequest(riderId: json['riderId'] as String);

Map<String, dynamic> _$AssignDeliveryRequestToJson(
  _AssignDeliveryRequest instance,
) => <String, dynamic>{'riderId': instance.riderId};

_RiderLocationUpdate _$RiderLocationUpdateFromJson(Map<String, dynamic> json) =>
    _RiderLocationUpdate(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      at: const DateTimeConverter().fromJson(json['at'] as Object),
      deliveryId: json['deliveryId'] as String?,
    );

Map<String, dynamic> _$RiderLocationUpdateToJson(
  _RiderLocationUpdate instance,
) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
  'heading': ?instance.heading,
  'speed': ?instance.speed,
  'at': const DateTimeConverter().toJson(instance.at),
  'deliveryId': ?instance.deliveryId,
};

_UpdateRiderProfileRequest _$UpdateRiderProfileRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateRiderProfileRequest(
  isOnline: json['isOnline'] as bool?,
  vehicleType: json['vehicleType'] as String?,
  plateNumber: json['plateNumber'] as String?,
);

Map<String, dynamic> _$UpdateRiderProfileRequestToJson(
  _UpdateRiderProfileRequest instance,
) => <String, dynamic>{
  'isOnline': ?instance.isOnline,
  'vehicleType': ?instance.vehicleType,
  'plateNumber': ?instance.plateNumber,
};

_RespondDeliveryRequest _$RespondDeliveryRequestFromJson(
  Map<String, dynamic> json,
) => _RespondDeliveryRequest(accept: json['accept'] as bool);

Map<String, dynamic> _$RespondDeliveryRequestToJson(
  _RespondDeliveryRequest instance,
) => <String, dynamic>{'accept': instance.accept};

_DeliverRequest _$DeliverRequestFromJson(Map<String, dynamic> json) =>
    _DeliverRequest(otp: json['otp'] as String?, note: json['note'] as String?);

Map<String, dynamic> _$DeliverRequestToJson(_DeliverRequest instance) =>
    <String, dynamic>{'otp': ?instance.otp, 'note': ?instance.note};

_RequestPayoutRequest _$RequestPayoutRequestFromJson(
  Map<String, dynamic> json,
) => _RequestPayoutRequest(
  amountKobo: (json['amountKobo'] as num?)?.toInt(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$RequestPayoutRequestToJson(
  _RequestPayoutRequest instance,
) => <String, dynamic>{
  'amountKobo': ?instance.amountKobo,
  'note': ?instance.note,
};

_MarkPayoutPaidRequest _$MarkPayoutPaidRequestFromJson(
  Map<String, dynamic> json,
) => _MarkPayoutPaidRequest(reference: json['reference'] as String?);

Map<String, dynamic> _$MarkPayoutPaidRequestToJson(
  _MarkPayoutPaidRequest instance,
) => <String, dynamic>{'reference': ?instance.reference};

_ProductInput _$ProductInputFromJson(Map<String, dynamic> json) =>
    _ProductInput(
      name: json['name'] as String?,
      description: json['description'] as String?,
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      basePriceKobo: (json['basePriceKobo'] as num?)?.toInt(),
      variants: (json['variants'] as List<dynamic>?)
          ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasVariants: json['hasVariants'] as bool?,
      stock: (json['stock'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$ProductStatusEnumMap, json['status']),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductInputToJson(_ProductInput instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'description': ?instance.description,
      'categoryIds': ?instance.categoryIds,
      'basePriceKobo': ?instance.basePriceKobo,
      'variants': ?instance.variants?.map((e) => e.toJson()).toList(),
      'hasVariants': ?instance.hasVariants,
      'stock': ?instance.stock,
      'status': ?_$ProductStatusEnumMap[instance.status],
      'tags': ?instance.tags,
      'images': ?instance.images?.map((e) => e.toJson()).toList(),
    };

const _$ProductStatusEnumMap = {
  ProductStatus.draft: 'draft',
  ProductStatus.active: 'active',
  ProductStatus.archived: 'archived',
};

_AddressInput _$AddressInputFromJson(Map<String, dynamic> json) =>
    _AddressInput(
      id: json['id'] as String?,
      label: json['label'] as String?,
      line1: json['line1'] as String?,
      line2: json['line2'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      isDefault: json['isDefault'] as bool?,
    );

Map<String, dynamic> _$AddressInputToJson(_AddressInput instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'label': ?instance.label,
      'line1': ?instance.line1,
      'line2': ?instance.line2,
      'city': ?instance.city,
      'state': ?instance.state,
      'lat': ?instance.lat,
      'lng': ?instance.lng,
      'phone': ?instance.phone,
      'isDefault': ?instance.isDefault,
    };

_VendorInput _$VendorInputFromJson(Map<String, dynamic> json) => _VendorInput(
  name: json['name'] as String?,
  description: json['description'] as String?,
  logoImageId: json['logoImageId'] as String?,
  coverImageId: json['coverImageId'] as String?,
  address: json['address'] == null
      ? null
      : VendorAddress.fromJson(json['address'] as Map<String, dynamic>),
  deliveryFee: json['deliveryFee'] == null
      ? null
      : DeliveryFeeConfig.fromJson(json['deliveryFee'] as Map<String, dynamic>),
  deliveryRadiusKm: (json['deliveryRadiusKm'] as num?)?.toDouble(),
  openingHours: (json['openingHours'] as List<dynamic>?)
      ?.map((e) => OpeningHours.fromJson(e as Map<String, dynamic>))
      .toList(),
  commissionBps: (json['commissionBps'] as num?)?.toInt(),
  payout: json['payout'] == null
      ? null
      : PayoutAccount.fromJson(json['payout'] as Map<String, dynamic>),
  status: $enumDecodeNullable(_$VendorStatusEnumMap, json['status']),
);

Map<String, dynamic> _$VendorInputToJson(_VendorInput instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'description': ?instance.description,
      'logoImageId': ?instance.logoImageId,
      'coverImageId': ?instance.coverImageId,
      'address': ?instance.address?.toJson(),
      'deliveryFee': ?instance.deliveryFee?.toJson(),
      'deliveryRadiusKm': ?instance.deliveryRadiusKm,
      'openingHours': ?instance.openingHours?.map((e) => e.toJson()).toList(),
      'commissionBps': ?instance.commissionBps,
      'payout': ?instance.payout?.toJson(),
      'status': ?_$VendorStatusEnumMap[instance.status],
    };

const _$VendorStatusEnumMap = {
  VendorStatus.pending: 'pending',
  VendorStatus.active: 'active',
  VendorStatus.suspended: 'suspended',
};

_CategoryInput _$CategoryInputFromJson(Map<String, dynamic> json) =>
    _CategoryInput(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      parentId: json['parentId'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
      imageId: json['imageId'] as String?,
    );

Map<String, dynamic> _$CategoryInputToJson(_CategoryInput instance) =>
    <String, dynamic>{
      'name': ?instance.name,
      'slug': ?instance.slug,
      'parentId': ?instance.parentId,
      'sortOrder': ?instance.sortOrder,
      'imageId': ?instance.imageId,
    };

_CartInput _$CartInputFromJson(Map<String, dynamic> json) => _CartInput(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CartItem>[],
  updatedAt: const NullableDateTimeConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$CartInputToJson(
  _CartInput instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'updatedAt': ?const NullableDateTimeConverter().toJson(instance.updatedAt),
};

_RevenueWindow _$RevenueWindowFromJson(Map<String, dynamic> json) =>
    _RevenueWindow(
      revenueKobo: (json['revenueKobo'] as num?)?.toInt() ?? 0,
      orders: (json['orders'] as num?)?.toInt() ?? 0,
      commissionKobo: (json['commissionKobo'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RevenueWindowToJson(_RevenueWindow instance) =>
    <String, dynamic>{
      'revenueKobo': instance.revenueKobo,
      'orders': instance.orders,
      'commissionKobo': instance.commissionKobo,
    };

_AdminCounts _$AdminCountsFromJson(Map<String, dynamic> json) => _AdminCounts(
  users: (json['users'] as num?)?.toInt() ?? 0,
  customers: (json['customers'] as num?)?.toInt() ?? 0,
  riders: (json['riders'] as num?)?.toInt() ?? 0,
  vendors:
      (json['vendors'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
  products: (json['products'] as num?)?.toInt() ?? 0,
  activeProducts: (json['activeProducts'] as num?)?.toInt() ?? 0,
  orders: (json['orders'] as num?)?.toInt() ?? 0,
  paidOrders: (json['paidOrders'] as num?)?.toInt() ?? 0,
  openSubOrders: (json['openSubOrders'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AdminCountsToJson(_AdminCounts instance) =>
    <String, dynamic>{
      'users': instance.users,
      'customers': instance.customers,
      'riders': instance.riders,
      'vendors': instance.vendors,
      'products': instance.products,
      'activeProducts': instance.activeProducts,
      'orders': instance.orders,
      'paidOrders': instance.paidOrders,
      'openSubOrders': instance.openSubOrders,
    };

_AdminRevenue _$AdminRevenueFromJson(Map<String, dynamic> json) =>
    _AdminRevenue(
      today: json['today'] == null
          ? const RevenueWindow()
          : RevenueWindow.fromJson(json['today'] as Map<String, dynamic>),
      last7d: json['last7d'] == null
          ? const RevenueWindow()
          : RevenueWindow.fromJson(json['last7d'] as Map<String, dynamic>),
      last30d: json['last30d'] == null
          ? const RevenueWindow()
          : RevenueWindow.fromJson(json['last30d'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminRevenueToJson(_AdminRevenue instance) =>
    <String, dynamic>{
      'today': instance.today.toJson(),
      'last7d': instance.last7d.toJson(),
      'last30d': instance.last30d.toJson(),
    };

_AdminStats _$AdminStatsFromJson(Map<String, dynamic> json) => _AdminStats(
  counts: json['counts'] == null
      ? const AdminCounts()
      : AdminCounts.fromJson(json['counts'] as Map<String, dynamic>),
  revenue: json['revenue'] == null
      ? const AdminRevenue()
      : AdminRevenue.fromJson(json['revenue'] as Map<String, dynamic>),
  generatedAt: const NullableDateTimeConverter().fromJson(json['generatedAt']),
);

Map<String, dynamic> _$AdminStatsToJson(_AdminStats instance) =>
    <String, dynamic>{
      'counts': instance.counts.toJson(),
      'revenue': instance.revenue.toJson(),
      'generatedAt': ?const NullableDateTimeConverter().toJson(
        instance.generatedAt,
      ),
    };

_ApiErrorBody _$ApiErrorBodyFromJson(Map<String, dynamic> json) =>
    _ApiErrorBody(
      statusCode: (json['statusCode'] as num).toInt(),
      code: json['code'] as String? ?? 'UNKNOWN',
      message: json['message'] as String? ?? '',
      details: json['details'],
    );

Map<String, dynamic> _$ApiErrorBodyToJson(_ApiErrorBody instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'code': instance.code,
      'message': instance.message,
      'details': ?instance.details,
    };

_UploadedImage _$UploadedImageFromJson(Map<String, dynamic> json) =>
    _UploadedImage(
      id: readId(json, 'id') as String,
      contentType: json['contentType'] as String?,
      size: (json['size'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UploadedImageToJson(_UploadedImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentType': ?instance.contentType,
      'size': ?instance.size,
      'width': ?instance.width,
      'height': ?instance.height,
    };
