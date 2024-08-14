// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$detailOrderHash() => r'b84bdeac6f5d62a844be7b7180815f0c80516215';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DetailOrder
    extends BuildlessAutoDisposeAsyncNotifier<OrderDetailModel> {
  late final int id;

  FutureOr<OrderDetailModel> build(
    int id,
  );
}

/// See also [DetailOrder].
@ProviderFor(DetailOrder)
const detailOrderProvider = DetailOrderFamily();

/// See also [DetailOrder].
class DetailOrderFamily extends Family<AsyncValue<OrderDetailModel>> {
  /// See also [DetailOrder].
  const DetailOrderFamily();

  /// See also [DetailOrder].
  DetailOrderProvider call(
    int id,
  ) {
    return DetailOrderProvider(
      id,
    );
  }

  @override
  DetailOrderProvider getProviderOverride(
    covariant DetailOrderProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'detailOrderProvider';
}

/// See also [DetailOrder].
class DetailOrderProvider extends AutoDisposeAsyncNotifierProviderImpl<
    DetailOrder, OrderDetailModel> {
  /// See also [DetailOrder].
  DetailOrderProvider(
    int id,
  ) : this._internal(
          () => DetailOrder()..id = id,
          from: detailOrderProvider,
          name: r'detailOrderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$detailOrderHash,
          dependencies: DetailOrderFamily._dependencies,
          allTransitiveDependencies:
              DetailOrderFamily._allTransitiveDependencies,
          id: id,
        );

  DetailOrderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<OrderDetailModel> runNotifierBuild(
    covariant DetailOrder notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(DetailOrder Function() create) {
    return ProviderOverride(
      origin: this,
      override: DetailOrderProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DetailOrder, OrderDetailModel>
      createElement() {
    return _DetailOrderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DetailOrderProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DetailOrderRef on AutoDisposeAsyncNotifierProviderRef<OrderDetailModel> {
  /// The parameter `id` of this provider.
  int get id;
}

class _DetailOrderProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DetailOrder,
        OrderDetailModel> with DetailOrderRef {
  _DetailOrderProviderElement(super.provider);

  @override
  int get id => (origin as DetailOrderProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
