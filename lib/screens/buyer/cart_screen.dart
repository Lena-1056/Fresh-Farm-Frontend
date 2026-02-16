import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes.dart';
import '../../models/cart_api_model.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.loading && cart.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (cart.error != null && cart.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(cart.error!, style: const TextStyle(color: Colors.red)),
              ),
            );
          }
          if (cart.items.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return CartItemTile(
                      item: item,
                      onRemove: () async {
                        try {
                          await cart.removeFromCart(item.id);
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Total: ₹${cart.total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0DF20D),
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          try {
                            await cart.placeOrder();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order placed!")));
                              Navigator.pushReplacementNamed(context, AppRoutes.tracking);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
                              );
                            }
                          }
                        },
                        child: const Text("Place Order"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartApiModel item;
  final VoidCallback onRemove;

  const CartItemTile({super.key, required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: item.productImageUrl != null && item.productImageUrl!.isNotEmpty
          ? Image.network(item.productImageUrl!, width: 50, height: 50, fit: BoxFit.cover)
          : const Icon(Icons.shopping_bag),
      title: Text(item.productName),
      subtitle: Text("₹${item.productPrice.toStringAsFixed(2)} × ${item.quantity} = ₹${item.subtotal.toStringAsFixed(2)}"),
      trailing: IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: onRemove),
    );
  }
}
