import 'package:ecommerce_starter_app/src/app.dart';
import 'package:ecommerce_starter_app/src/constants/test_products.dart';
import 'package:ecommerce_starter_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_starter_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_starter_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_starter_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/authentication/auth_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester),
        golden = GoldenRobot(tester);
  final WidgetTester tester;
  final AuthRobot auth;
  final GoldenRobot golden;

  Future<void> pumpMyApp() async {
    final productsRepository = FakeProductsRepository(addDelay: false);
    final authRepository = FakeAuthRepository(addDelay: false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productsRepositoryProvider.overrideWithValue(productsRepository),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectFindAllProductsCard() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }
}
