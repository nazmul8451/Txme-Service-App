import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:txme_app/Utils/AppColors/app_colors.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/WorkerCard/WorkerCard.dart';
import 'Electrician_Providers_controller.dart';

class Electricianproviders extends StatelessWidget {
  const Electricianproviders({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProviderController());

    return Scaffold(
      backgroundColor: AppColors.FFFFFF,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (controller.isLoading.value && controller.providers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.providers.isEmpty) {
            return const Center(child: Text("No providers found for your filter."));
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  itemCount: controller.providers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return WorkerCard(
                      provider: controller.providers[index],
                    );
                  },
                ),
              ),

              Obx(() {
                if (controller.isMoreLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.page >= controller.totalPage) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.getAllProviders();
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }
}
