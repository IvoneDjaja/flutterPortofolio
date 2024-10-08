import 'package:ecommerce_starter_app/src/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// API for reading, watching and writing cart data for a specific user ID
abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);
}

final remoteCartRepositoryProvider = Provider<RemoteCartRepository>((ref) {
  throw UnimplementedError();
});
