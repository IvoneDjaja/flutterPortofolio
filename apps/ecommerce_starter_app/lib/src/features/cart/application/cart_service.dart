import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_starter_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_starter_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_starter_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_starter_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_starter_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_starter_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  CartService(this.ref);
  final Ref ref;

  /// Fetch the cart from the local or remote repository depending on the user
  /// auth state.
  Future<Cart> _fetchCart() async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).fetchCart(user.uid);
    } else {
      return ref.read(localCartRepositoryProvider).fetchCart();
    }
  }

  /// Save the cart to the local or remote repository depending on the user auth
  /// state.
  Future<void> _setCart(Cart cart) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).setCart(user.uid, cart);
    } else {
      return ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }

  /// Sets an item in the local or remote cart depending on the user auth state.
  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.setItem(item);
    await _setCart(updated);
  }

  /// Adds an item in the local or remote cart depending on the user auth state
  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.addItem(item);
    await _setCart(updated);
  }

  Future<void> removeItemById(ProductID productId) async {
    final cart = await _fetchCart();
    final updated = cart.removeItemById(productId);
    await _setCart(updated);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref);
});
