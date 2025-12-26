import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../Widgegt/CustomBottomNavBar/CustomBottomNavBar.dart';
import '../../../../Widgegt/WorkerCard/WorkerCard.dart';
import '../models/provider_model.dart';
import 'Electrician_Providers_controller.dart';

class Electricianproviders extends StatefulWidget {
  const Electricianproviders({super.key});

  @override
  State<Electricianproviders> createState() => _ElectricianprovidersState();
}

class _ElectricianprovidersState extends State<Electricianproviders> {

  final controller = Get.put(ProviderController());


  @override
  void initState() {
    super.initState();
    controller.getAllProviders();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            itemCount: controller.providers.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.70,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return WorkerCard(provider: controller.providers[index]);
            },
          );
        })

      ),
      bottomNavigationBar: CustomBottomNavBar(selectedIndex: 0),
    );
  }
}
