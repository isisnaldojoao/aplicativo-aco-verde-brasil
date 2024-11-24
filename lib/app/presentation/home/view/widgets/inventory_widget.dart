import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class InventoryWidget extends StatelessWidget {
  const InventoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/register-inventory');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColors.brand1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxText.headingTwo(
              'Inventário',
              color: Colors.white,
            ),
            const Space.x2(),
            BoxText.body(
              'Contagem inventário laminação',
              color: Colors.white,
            ),
            const Space.x6(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 130,
                  padding: const EdgeInsets.only(
                    top: 6,
                    bottom: 6,
                    left: 14,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BoxText.body(
                        'Começar',
                        color: AppColors.brand1,
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_right_alt,
                        size: 24,
                        color: AppColors.brand1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
