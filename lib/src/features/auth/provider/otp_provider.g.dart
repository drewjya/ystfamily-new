// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$intOtpHash() => r'22f8865ce7e5761fd6a22f04d3829e7b54a8062b';

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

/// See also [intOtp].
@ProviderFor(intOtp)
const intOtpProvider = IntOtpFamily();

/// See also [intOtp].
class IntOtpFamily extends Family<int> {
  /// See also [intOtp].
  const IntOtpFamily();

  /// See also [intOtp].
  IntOtpProvider call(
    DateTime time,
  ) {
    return IntOtpProvider(
      time,
    );
  }

  @override
  IntOtpProvider getProviderOverride(
    covariant IntOtpProvider provider,
  ) {
    return call(
      provider.time,
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
  String? get name => r'intOtpProvider';
}

/// See also [intOtp].
class IntOtpProvider extends AutoDisposeProvider<int> {
  /// See also [intOtp].
  IntOtpProvider(
    DateTime time,
  ) : this._internal(
          (ref) => intOtp(
            ref as IntOtpRef,
            time,
          ),
          from: intOtpProvider,
          name: r'intOtpProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$intOtpHash,
          dependencies: IntOtpFamily._dependencies,
          allTransitiveDependencies: IntOtpFamily._allTransitiveDependencies,
          time: time,
        );

  IntOtpProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.time,
  }) : super.internal();

  final DateTime time;

  @override
  Override overrideWith(
    int Function(IntOtpRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IntOtpProvider._internal(
        (ref) => create(ref as IntOtpRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        time: time,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _IntOtpProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IntOtpProvider && other.time == time;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, time.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IntOtpRef on AutoDisposeProviderRef<int> {
  /// The parameter `time` of this provider.
  DateTime get time;
}

class _IntOtpProviderElement extends AutoDisposeProviderElement<int>
    with IntOtpRef {
  _IntOtpProviderElement(super.provider);

  @override
  DateTime get time => (origin as IntOtpProvider).time;
}

String _$otpLengthHash() => r'3453ab24e72d0cbdfcc8c7f0a63f35a808fd0455';

/// See also [OtpLength].
@ProviderFor(OtpLength)
final otpLengthProvider =
    AutoDisposeNotifierProvider<OtpLength, DateTime?>.internal(
  OtpLength.new,
  name: r'otpLengthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$otpLengthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OtpLength = AutoDisposeNotifier<DateTime?>;
String _$otpHash() => r'9b815e9b9ae269c4974709b82da1eb847590e1a5';

/// See also [Otp].
@ProviderFor(Otp)
final otpProvider = AutoDisposeNotifierProvider<Otp, int>.internal(
  Otp.new,
  name: r'otpProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$otpHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Otp = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
