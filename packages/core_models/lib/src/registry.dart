import 'models/models.dart';

/// Collection names as used by the backend, sync protocol and local store.
abstract final class Collections {
  static const String users = 'users';
  static const String vendors = 'vendors';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String inventoryMovements = 'inventoryMovements';
  static const String addresses = 'addresses';
  static const String carts = 'carts';
  static const String orders = 'orders';
  static const String subOrders = 'subOrders';
  static const String payments = 'payments';
  static const String vendorLedger = 'vendorLedger';
  static const String payouts = 'payouts';
  static const String riderProfiles = 'riderProfiles';
  static const String riderLocations = 'riderLocations';
  static const String deliveries = 'deliveries';
  static const String notifications = 'notifications';

  /// Collections the customer app pulls (§7).
  static const List<String> customerSync = [
    vendors, categories, products, addresses, carts, orders, subOrders, deliveries, notifications,
  ];

  /// Collections the vendor app pulls.
  static const List<String> vendorSync = [
    vendors, categories, products, inventoryMovements, subOrders, deliveries,
    riderProfiles, vendorLedger, payouts, notifications,
  ];

  /// Collections the rider app pulls.
  static const List<String> riderSync = [
    riderProfiles, deliveries, subOrders, notifications,
  ];
}

/// How to encode/decode one collection's documents.
class CollectionCodec<T extends Object> {
  const CollectionCodec({
    required this.collection,
    required this.fromJson,
    required this.toJson,
    required this.idOf,
    this.updatedAtOf,
  });

  final String collection;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T model) toJson;
  final String Function(T model) idOf;
  final DateTime? Function(T model)? updatedAtOf;

  Type get type => T;

  /// Untyped decode used by generic stores.
  Object decodeDynamic(Map<String, dynamic> json) => fromJson(json);

  /// Untyped encode used by generic stores. Throws when [model] is not a [T].
  Map<String, dynamic> encodeDynamic(Object model) => toJson(model as T);

  String idOfDynamic(Object model) => idOf(model as T);

  DateTime? updatedAtOfDynamic(Object model) => updatedAtOf?.call(model as T);
}

/// `collection → codec` registry so generic stores can turn JSON into typed
/// models without depending on each model. Apps may register extra codecs.
abstract final class ModelRegistry {
  static final Map<String, CollectionCodec<Object>> _byCollection = {
    for (final c in _defaults) c.collection: c,
  };
  static final Map<Type, CollectionCodec<Object>> _byType = {
    for (final c in _defaults) c.type: c,
  };

  static final List<CollectionCodec<Object>> _defaults = [
    CollectionCodec<User>(
      collection: Collections.users,
      fromJson: User.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<Vendor>(
      collection: Collections.vendors,
      fromJson: Vendor.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<Category>(
      collection: Collections.categories,
      fromJson: Category.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<Product>(
      collection: Collections.products,
      fromJson: Product.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<InventoryMovement>(
      collection: Collections.inventoryMovements,
      fromJson: InventoryMovement.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<Address>(
      collection: Collections.addresses,
      fromJson: Address.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<Cart>(
      collection: Collections.carts,
      fromJson: Cart.fromJson,
      toJson: (m) => m.toJson(),
      // One cart per user: key locally by userId so a locally created cart and
      // the server copy share an identity.
      idOf: (m) => m.userId,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<Order>(
      collection: Collections.orders,
      fromJson: Order.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<SubOrder>(
      collection: Collections.subOrders,
      fromJson: SubOrder.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<Payment>(
      collection: Collections.payments,
      fromJson: Payment.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<VendorLedgerEntry>(
      collection: Collections.vendorLedger,
      fromJson: VendorLedgerEntry.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<Payout>(
      collection: Collections.payouts,
      fromJson: Payout.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<RiderProfile>(
      collection: Collections.riderProfiles,
      fromJson: RiderProfile.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<RiderLocation>(
      collection: Collections.riderLocations,
      fromJson: RiderLocation.fromJson,
      toJson: (m) => m.toJson(),
      // Latest location per rider.
      idOf: (m) => m.id ?? m.riderId,
      updatedAtOf: (m) => m.at,
    ),
    CollectionCodec<Delivery>(
      collection: Collections.deliveries,
      fromJson: Delivery.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
    CollectionCodec<AppNotification>(
      collection: Collections.notifications,
      fromJson: AppNotification.fromJson,
      toJson: (m) => m.toJson(),
      idOf: (m) => m.id,
      updatedAtOf: (m) => m.updatedAt,
    ),
  ];

  /// Registers (or replaces) a codec.
  static void register<T extends Object>(CollectionCodec<T> codec) {
    _byCollection[codec.collection] = codec as CollectionCodec<Object>;
    _byType[T] = codec as CollectionCodec<Object>;
  }

  /// Codec for [collection], or null when unknown.
  static CollectionCodec<Object>? forCollection(String collection) =>
      _byCollection[collection];

  /// Codec for model type [T], or null when unknown.
  static CollectionCodec<Object>? forType<T>() => _byType[T];

  /// Collection name for model type [T].
  static String? collectionOf<T>() => _byType[T]?.collection;

  /// All registered collection names.
  static Iterable<String> get collections => _byCollection.keys;

  /// Decodes [json] into the typed model for [collection].
  /// Throws [ArgumentError] for an unknown collection.
  static Object decode(String collection, Map<String, dynamic> json) {
    final codec = forCollection(collection);
    if (codec == null) throw ArgumentError.value(collection, 'collection', 'No codec registered');
    return codec.decodeDynamic(json);
  }
}
