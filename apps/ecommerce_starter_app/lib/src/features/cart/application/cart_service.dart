import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_starter_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_starter_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_starter_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_starter_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_starter_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_starter_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  CartService({
    required this.authRepository,
    required this.localCartRepository,
    required this.remoteCartRepository,
  });
  final FakeAuthRepository authRepository;
  final LocalCartRepository localCartRepository;
  final RemoteCartRepository remoteCartRepository;

  /// Fetch the cart from the local or remote repository depending on the user
  /// auth state.
  Future<Cart> _fetchCart() async {
    final user = authRepository.currentUser;
    if (user != null) {
      return remoteCartRepository.fetchCart(user.uid);
    } else {
      return localCartRepository.fetchCart();
    }
  }

  /// Save the cart to the local or remote repository depending on the user auth
  /// state.
  Future<void> _setCart(Cart cart) async {
    final user = authRepository.currentUser;
    if (user != null) {
      return remoteCartRepository.setCart(user.uid, cart);
    } else {
      return localCartRepository.setCart(cart);
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
  return CartService(
    authRepository: ref.watch(authRepositoryProvider),
    localCartRepository: ref.watch(localCartRepositoryProvider),
    remoteCartRepository: ref.watch(remoteCartRepositoryProvider),
  );
});
