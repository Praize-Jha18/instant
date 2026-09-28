import 'package:core_models/core_models.dart';

import '../../catalog/domain/vendor_helpers.dart';

/// One vendor's share of the cart with its delivery estimate.
class VendorCartGroup {
  const VendorCartGroup({
    required this.vendorId,
    required this.vendor,
    required this.items,
    required this.subtotalKobo,
    required this.deliveryFeeKobo,
    required this.distanceKm,
  });

  final String vendorId;
  final Vendor? vendor;
  final List<CartItem> items;
  final int subtotalKobo;

  /// Null when the vendor (or its fee config) is unknown locally.
  final int? deliveryFeeKobo;

  /// Null when either the dropoff or the vendor location is unknown.
  final double? distanceKm;

  String get vendorName => vendor?.name ?? 'Vendor';
  int get itemCount => items.fold(0, (a, i) => a + i.qty);
}

class CartTotals {
  const CartTotals({
    required this.groups,
    required this.subtotalKobo,
    required this.deliveryTotalKobo,
    required this.hasUnknownDelivery,
    required this.hasDropoff,
  });

  static const CartTotals empty =
      CartTotals(groups: [], subtotalKobo: 0, deliveryTotalKobo: 0, hasUnknownDelivery: false, hasDropoff: false);

  final List<VendorCartGroup> groups;
  final int subtotalKobo;

  /// Sum of the known delivery estimates.
  final int deliveryTotalKobo;

  /// True when at least one vendor's fee could not be estimated.
  final bool hasUnknownDelivery;

  /// False when no address is selected (estimates then assume 0 km).
  final bool hasDropoff;

  int get totalKobo => subtotalKobo + deliveryTotalKobo;
  int get itemCount => groups.fold(0, (a, g) => a + g.itemCount);
  bool get isEmpty => groups.isEmpty;
}

/// Groups [cart] by vendor and estimates delivery with
/// [DeliveryFeeConfig.estimateKobo] using the distance from [dropoff] to the
/// vendor's address (0 km when either side is unknown).
CartTotals computeCartTotals({
  required Cart cart,
  required Map<String, Vendor> vendors,
  GeoPoint? dropoff,
}) {
  if (cart.isEmpty) return CartTotals.empty;
  final groups = <VendorCartGroup>[];
  var subtotal = 0;
  var delivery = 0;
  var unknown = false;

  for (final entry in cart.itemsByVendor.entries) {
    final vendor = vendors[entry.key];
    final groupSubtotal = entry.value.fold(0, (a, i) => a + i.lineTotalKobo);
    final distance = vendor?.distanceFrom(dropoff);
    final fee = vendor?.estimateDeliveryKobo(distance: distance ?? 0, subtotalKobo: groupSubtotal);
    if (fee == null) {
      unknown = true;
    } else {
      delivery += fee;
    }
    subtotal += groupSubtotal;
    groups.add(VendorCartGroup(
      vendorId: entry.key,
      vendor: vendor,
      items: entry.value,
      subtotalKobo: groupSubtotal,
      deliveryFeeKobo: fee,
      distanceKm: dropoff == null ? null : distance,
    ));
  }
  groups.sort((a, b) => a.vendorName.compareTo(b.vendorName));
  return CartTotals(
    groups: groups,
    subtotalKobo: subtotal,
    deliveryTotalKobo: delivery,
    hasUnknownDelivery: unknown,
    hasDropoff: dropoff != null,
  );
}
