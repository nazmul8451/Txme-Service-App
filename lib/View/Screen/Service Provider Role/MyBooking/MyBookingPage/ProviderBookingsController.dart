import 'package:get/get.dart';
import 'ProviderbookingModel.dart'; // ProviderbookingModel import korte hobe

class ProviderBookingsController extends GetxController {
  // Reactive lists
  var currentJob = <ProviderbookingModel>[].obs;
  var pending = <ProviderbookingModel>[].obs;
  var completed = <ProviderbookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings(); // Page load e data fetch
  }

  /// TODO: Replace with your real API link
  final String apiUrl = "https://yourapi.com/bookings";

  /// Function to fetch bookings from API
  void fetchBookings() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Example: API response parsing
      // final response = await http.get(Uri.parse(apiUrl));
      // if (response.statusCode == 200) {
      //   var data = jsonDecode(response.body);
      //   // parse JSON and update lists
      // }

      // Dummy data for now
      var dummyCurrent = [
        ProviderbookingModel(
          name: "Jane Doe",
          image: "https://i.pravatar.cc/150?img=1",
          date: "Mon, Nov 6, 2:00 PM",
          service: "1 hour Cleaning",
          status: "Started",
        ),
      ];

      var dummyPending = [
        ProviderbookingModel(
          name: "John Smith",
          image: "https://i.pravatar.cc/150?img=2",
          date: "Tue, Nov 7, 3:00 PM",
          service: "2 hour Gardening",
          status: "Pending",
        ),
      ];

      var dummyCompleted = [
        ProviderbookingModel(
          name: "Alice Brown",
          image: "https://i.pravatar.cc/150?img=3",
          date: "Wed, Nov 8, 1:00 PM",
          service: "1 hour Cleaning",
          status: "Confirmed",
        ),
      ];

      // Update reactive lists
      currentJob.assignAll(dummyCurrent);
      pending.assignAll(dummyPending);
      completed.assignAll(dummyCompleted);

    } catch (e) {
      // Handle errors
      print("Error fetching bookings: $e");
    }
  }
}
