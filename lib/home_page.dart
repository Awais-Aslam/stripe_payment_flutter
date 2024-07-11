import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment_flutter/custom_text_field.dart';
import 'package:stripe_payment_flutter/payment.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();
  final formKey6 = GlobalKey<FormState>();

  final List<String> currencyList = [
    "USD",
    "INR",
    "EUR",
    "JPY",
    "GBP",
    "AED",
  ];

  String selectedCurrency = "USD";

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
        name: nameController.text,
        address: addressController.text,
        pin: pinCodeController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
        currency: selectedCurrency,
        amount: (int.parse(amountController.text) * 100).toString(),
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Image(
              image: AssetImage('assets/image.jpg'),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            hasDonated
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thanks for your ${amountController.text} $selectedCurrency donation',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          'We appreciate your support',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                hasDonated = false;
                                amountController.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.shade400,
                            ),
                            child: const Text(
                              "Donate Again",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Support us with your donations',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: CustomTextField(
                                title: "Donation Amount",
                                hint: "Any amount you like",
                                isNumber: true,
                                controller: amountController,
                                formKey: formKey,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            DropdownMenu<String>(
                              inputDecorationTheme: InputDecorationTheme(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 0,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                  ))),
                              initialSelection: currencyList.first,
                              onSelected: (String? value) {
                                setState(() {
                                  selectedCurrency = value!;
                                });
                              },
                              dropdownMenuEntries: currencyList
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry(
                                    value: value, label: value);
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          title: "Name",
                          hint: "Ex. John Doe",
                          controller: nameController,
                          formKey: formKey1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          title: "Address Line",
                          hint: "Ex. 123 main st",
                          controller: addressController,
                          formKey: formKey2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: CustomTextField(
                                title: "City",
                                hint: "Ex. New Delhi",
                                controller: cityController,
                                formKey: formKey3,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 5,
                              child: CustomTextField(
                                title: "State (Short Code)",
                                hint: "Ex. DL",
                                controller: stateController,
                                formKey: formKey4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: CustomTextField(
                                title: "Country (Short Code)",
                                hint: "Ex. India",
                                controller: countryController,
                                formKey: formKey5,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 5,
                              child: CustomTextField(
                                title: "Pincode",
                                hint: "Ex. 1234",
                                controller: pinCodeController,
                                formKey: formKey6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate() &&
                                  formKey1.currentState!.validate() &&
                                  formKey2.currentState!.validate() &&
                                  formKey3.currentState!.validate() &&
                                  formKey4.currentState!.validate() &&
                                  formKey5.currentState!.validate() &&
                                  formKey6.currentState!.validate()) {
                                await initPaymentSheet();
                                try {
                                  await Stripe.instance.presentPaymentSheet();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Payment Done",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  setState(() {
                                    hasDonated = true;
                                  });

                                  nameController.clear();
                                  pinCodeController.clear();
                                  cityController.clear();
                                  stateController.clear();
                                  countryController.clear();
                                  addressController.clear();
                                } catch (e) {
                                  print('Payment sheet failed');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Payment failed",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.shade400,
                            ),
                            child: const Text(
                              "Proceed to Pay",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
