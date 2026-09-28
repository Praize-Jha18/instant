import 'package:json_annotation/json_annotation.dart';

/// Platform roles. One account may hold several roles (§2).
@JsonEnum(valueField: 'json')
enum UserRole {
  customer('customer'),
  rider('rider'),
  vendorOwner('vendor_owner'),
  vendorStaff('vendor_staff'),
  admin('admin');

  const UserRole(this.json);
  final String json;

  static UserRole fromJson(String value) => _lookup(values, (e) => e.json, value);

  /// True for roles that are scoped to a vendor.
  bool get isVendorScoped =>
      this == rider || this == vendorOwner || this == vendorStaff;
}

/// Account status of a user.
@JsonEnum(valueField: 'json')
enum UserStatus {
  active('active'),
  suspended('suspended');

  const UserStatus(this.json);
  final String json;
  static UserStatus fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// Vendor lifecycle status.
@JsonEnum(valueField: 'json')
enum VendorStatus {
  pending('pending'),
  active('active'),
  suspended('suspended');

  const VendorStatus(this.json);
  final String json;
  static VendorStatus fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// Product publication status.
@JsonEnum(valueField: 'json')
enum ProductStatus {
  draft('draft'),
  active('active'),
  archived('archived');

  const ProductStatus(this.json);
  final String json;
  static ProductStatus fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// SubOrder status (§6). `awaitingPayment` exists before the payment webhook
/// confirms and is hidden from vendors.
@JsonEnum(valueField: 'json')
enum SubOrderStatus {
  awaitingPayment('awaiting_payment'),
  placed('placed'),
  accepted('accepted'),
  preparing('preparing'),
  ready('ready'),
  outForDelivery('out_for_delivery'),
  delivered('delivered'),
  cancelled('cancelled');

  const SubOrderStatus(this.json);
  final String json;
  static SubOrderStatus fromJson(String value) => _lookup(values, (e) => e.json, value);

  /// Terminal states: nothing follows.
  bool get isTerminal => this == delivered || this == cancelled;

  /// True once the order is visible to and being worked on by the vendor.
  bool get isActive => !isTerminal && this != awaitingPayment;
}

/// Payment status shared by orders and payments.
@JsonEnum(valueField: 'json')
enum PaymentStatus {
  pending('pending'),
  paid('paid'),
  failed('failed'),
  refunded('refunded'),
  partiallyRefunded('partially_refunded');

  const PaymentStatus(this.json);
  final String json;
  static PaymentStatus fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// Delivery status (§6).
@JsonEnum(valueField: 'json')
enum DeliveryStatus {
  unassigned('unassigned'),
  offered('offered'),
  accepted('accepted'),
  pickedUp('picked_up'),
  delivered('delivered'),
  failed('failed');

  const DeliveryStatus(this.json);
  final String json;
  static DeliveryStatus fromJson(String value) => _lookup(values, (e) => e.json, value);

  bool get isTerminal => this == delivered || this == failed;
}

/// Rider profile status.
@JsonEnum(valueField: 'json')
enum RiderStatus {
  pending('pending'),
  active('active'),
  suspended('suspended');

  const RiderStatus(this.json);
  final String json;
  static RiderStatus fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// Reason for an inventory movement.
@JsonEnum(valueField: 'json')
enum InventoryReason {
  sale('sale'),
  restock('restock'),
  adjustment('adjustment'),
  returned('return'),
  cancel('cancel');

  const InventoryReason(this.json);
  final String json;
  static InventoryReason fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// Vendor ledger row type.
@JsonEnum(valueField: 'json')
enum LedgerEntryType {
  sale('sale'),
  commission('commission'),
  refund('refund'),
  payout('payout');

  const LedgerEntryType(this.json);
  final String json;
  static LedgerEntryType fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// Payout request status.
@JsonEnum(valueField: 'json')
enum PayoutStatus {
  requested('requested'),
  paid('paid'),
  failed('failed');

  const PayoutStatus(this.json);
  final String json;
  static PayoutStatus fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// Sync push op action (§7).
@JsonEnum(valueField: 'json')
enum SyncOpAction {
  upsert('upsert'),
  delete('delete'),
  custom('custom');

  const SyncOpAction(this.json);
  final String json;
  static SyncOpAction fromJson(String value) => _lookup(values, (e) => e.json, value);
}

/// Server result status for a pushed op (§7).
@JsonEnum(valueField: 'json')
enum SyncOpStatus {
  applied('applied'),
  duplicate('duplicate'),
  rejected('rejected');

  const SyncOpStatus(this.json);
  final String json;
  static SyncOpStatus fromJson(String value) => _lookup(values, (e) => e.json, value);
}

T _lookup<T extends Enum>(List<T> values, String Function(T) key, String value) {
  for (final v in values) {
    if (key(v) == value) return v;
  }
  throw ArgumentError.value(value, 'value', 'Unknown ${T.toString()}');
}
