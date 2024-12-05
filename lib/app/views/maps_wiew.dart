import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';
import '../controllers/maps_controller.dart';

class MapsView extends GetView<MapsController> {
  const MapsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapsController());
    final hoverColor1 = Rx<Color>(Colors.cyan.shade400);
    final hoverColor2 = Rx<Color>(Colors.cyan.shade400);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Lokasi Anda',
          style: TextStyle(
            color: Colors.black,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.cyan.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  controller.locationMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                MouseRegion(
                  onEnter: (_) => hoverColor1.value = Colors.cyan.shade500,
                  onExit: (_) => hoverColor1.value = Colors.cyan.shade400,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.loading.value
                            ? null
                            : controller.getCurrentLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hoverColor1.value,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 17),
                        ),
                        child: controller.loading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Dapatkan Lokasi',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      )),
                ),
                const SizedBox(height: 20),
                MouseRegion(
                  onEnter: (_) => hoverColor2.value = Colors.cyan.shade500,
                  onExit: (_) => hoverColor2.value = Colors.cyan.shade400,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.currentPosition.value != null
                            ? controller.openGoogleMaps
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hoverColor2.value,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 17),
                        ),
                        child: const Text(
                          'Buka di Google Maps',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
