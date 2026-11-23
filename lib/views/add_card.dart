import 'package:flutter/material.dart';
import 'package:flutter_banking_app/generated/assets.dart';
import 'package:flutter_banking_app/repo/repository.dart';
import 'package:flutter_banking_app/utils/layouts.dart';
import 'package:flutter_banking_app/utils/size_config.dart';
import 'package:flutter_banking_app/utils/styles.dart';
import 'package:flutter_banking_app/widgets/buttons.dart';
import 'package:flutter_banking_app/widgets/default_text_field.dart';
import 'package:flutter_banking_app/widgets/my_app_bar.dart';
import 'package:gap/gap.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardHolderName = TextEditingController();
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _expiryDate = TextEditingController();
  final TextEditingController _cvv = TextEditingController();

  final List<String> paymentCardsList = [
    Assets.cardsVisa,
    Assets.cardsMastercard,
    Assets.cardsPaypal,
    Assets.cardsSkrill,
  ];

  int selectedCard = 0;

  @override
  void initState() {
    super.initState();
    _cardHolderName.addListener(_refreshPreview);
    _cardNumber.addListener(_refreshPreview);
    _expiryDate.addListener(_refreshPreview);
  }

  void _refreshPreview() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cardHolderName.removeListener(_refreshPreview);
    _cardNumber.removeListener(_refreshPreview);
    _expiryDate.removeListener(_refreshPreview);
    _cardHolderName.dispose();
    _cardNumber.dispose();
    _expiryDate.dispose();
    _cvv.dispose();
    super.dispose();
  }

  String get _lastFour {
    final digits = _cardNumber.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '****';
    return digits.length <= 4 ? digits.padLeft(4, '*') : digits.substring(digits.length - 4);
  }

  String get _previewName =>
      _cardHolderName.text.trim().isEmpty ? 'CARD HOLDER' : _cardHolderName.text.trim().toUpperCase();

  String get _previewExpiry =>
      _expiryDate.text.trim().isEmpty ? 'MM/YY' : _expiryDate.text.trim();

  String? _validateCardNumber(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < 12 || digits.length > 19) {
      return 'Enter a valid card number';
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    final match = RegExp(r'^(0[1-9]|1[0-2])/(\d{2})).firstMatch(value?.trim() ?? '');
    if (match == null) return 'Use MM/YY';
    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    final now = DateTime.now();
    if (year < now.year || (year == now.year && month < now.month)) {
      return 'Card has expired';
    }
    return null;
  }

  String? _validateCvv(String? value) {
    if (!RegExp(r'^\d{3,4}).hasMatch(value?.trim() ?? '')) {
      return 'Enter a 3 or 4 digit security code';
    }
    return null;
  }

  void _validateDemoCard() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // This screen is a UI prototype. Never persist or transmit raw card details here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Details passed demo validation. No card was saved or charged.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    final cardSize = size.height * 0.23;
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Add Card', implyLeading: true, context: context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            SizedBox(
              width: double.infinity,
              height: cardSize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: cardSize * 0.35,
                    padding: const EdgeInsets.fromLTRB(16, 10, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      color: Styles.greenColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(Assets.cardsVisaWhite, width: 60, height: 45, fit: BoxFit.cover),
                        const Text('\$00.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 0, 20),
                    height: cardSize * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Styles.yellowColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customColumn(title: 'CARD NUMBER', subtitle: '**** **** **** $_lastFour'),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(child: customColumn(title: 'CARD HOLDER NAME', subtitle: _previewName)),
                            const Gap(12),
                            customColumn(title: 'VALID', subtitle: _previewExpiry),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: paymentCardsList.asMap().entries.map((entry) {
                final index = entry.key;
                final paymentCard = entry.value;
                return MaterialButton(
                  elevation: 0,
                  color: Repository.accentColor(context),
                  minWidth: 65,
                  height: 95,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  onPressed: () => setState(() => selectedCard = index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(paymentCard), fit: BoxFit.contain),
                        ),
                      ),
                      const Gap(12),
                      Icon(
                        selectedCard == index ? Icons.check_circle : Icons.circle_outlined,
                        color: selectedCard == index
                            ? Repository.selectedItemColor(context)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Gap(30),
            DefaultTextField(
              controller: _cardHolderName,
              title: 'Card Holder Name',
              validator: (value) => (value ?? '').trim().length < 2
                  ? 'Enter the name printed on the card'
                  : null,
            ),
            DefaultTextField(
              controller: _cardNumber,
              title: 'Card Number',
              label: 'Enter card number',
              keyboardType: TextInputType.number,
              validator: _validateCardNumber,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: DefaultTextField(
                    controller: _expiryDate,
                    title: 'Expiry date',
                    label: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                    validator: _validateExpiry,
                  ),
                ),
                const Gap(10),
                Flexible(
                  child: DefaultTextField(
                    controller: _cvv,
                    title: 'CVC/CVV',
                    label: '3 or 4 digits',
                    keyboardType: TextInputType.number,
                    obscure: true,
                    validator: _validateCvv,
                  ),
                ),
              ],
            ),
            const Gap(10),
            elevatedButton(
              color: Repository.selectedItemColor(context),
              context: context,
              callback: _validateDemoCard,
              text: 'Validate Card (Demo)',
            ),
            const Gap(12),
            Text(
              'Demo only: card details are validated on this screen but are not stored, sent to a bank, or used for payments.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Repository.subTextColor(context), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget customColumn({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12)),
        const Gap(4),
        Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
).firstMatch(value?.trim() ?? '');
    if (match == null) return 'Use MM/YY';
    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    final now = DateTime.now();
    if (year < now.year || (year == now.year && month < now.month)) {
      return 'Card has expired';
    }
    return null;
  }

  String? _validateCvv(String? value) {
    if (!RegExp(r'^\\d{3,4}$').hasMatch(value?.trim() ?? '')) {
      return 'Enter a 3 or 4 digit security code';
    }
    return null;
  }

  void _validateDemoCard() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // This screen is a UI prototype. Never persist or transmit raw card details here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Details passed demo validation. No card was saved or charged.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    final cardSize = size.height * 0.23;
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Add Card', implyLeading: true, context: context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            SizedBox(
              width: double.infinity,
              height: cardSize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: cardSize * 0.35,
                    padding: const EdgeInsets.fromLTRB(16, 10, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      color: Styles.greenColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(Assets.cardsVisaWhite, width: 60, height: 45, fit: BoxFit.cover),
                        const Text('\$00.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 0, 20),
                    height: cardSize * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Styles.yellowColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customColumn(title: 'CARD NUMBER', subtitle: '**** **** **** $_lastFour'),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(child: customColumn(title: 'CARD HOLDER NAME', subtitle: _previewName)),
                            const Gap(12),
                            customColumn(title: 'VALID', subtitle: _previewExpiry),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: paymentCardsList.asMap().entries.map((entry) {
                final index = entry.key;
                final paymentCard = entry.value;
                return MaterialButton(
                  elevation: 0,
                  color: Repository.accentColor(context),
                  minWidth: 65,
                  height: 95,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  onPressed: () => setState(() => selectedCard = index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(paymentCard), fit: BoxFit.contain),
                        ),
                      ),
                      const Gap(12),
                      Icon(
                        selectedCard == index ? Icons.check_circle : Icons.circle_outlined,
                        color: selectedCard == index
                            ? Repository.selectedItemColor(context)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Gap(30),
            DefaultTextField(
              controller: _cardHolderName,
              title: 'Card Holder Name',
              validator: (value) => (value ?? '').trim().length < 2
                  ? 'Enter the name printed on the card'
                  : null,
            ),
            DefaultTextField(
              controller: _cardNumber,
              title: 'Card Number',
              label: 'Enter card number',
              keyboardType: TextInputType.number,
              validator: _validateCardNumber,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: DefaultTextField(
                    controller: _expiryDate,
                    title: 'Expiry date',
                    label: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                    validator: _validateExpiry,
                  ),
                ),
                const Gap(10),
                Flexible(
                  child: DefaultTextField(
                    controller: _cvv,
                    title: 'CVC/CVV',
                    label: '3 or 4 digits',
                    keyboardType: TextInputType.number,
                    obscure: true,
                    validator: _validateCvv,
                  ),
                ),
              ],
            ),
            const Gap(10),
            elevatedButton(
              color: Repository.selectedItemColor(context),
              context: context,
              callback: _validateDemoCard,
              text: 'Validate Card (Demo)',
            ),
            const Gap(12),
            Text(
              'Demo only: card details are validated on this screen but are not stored, sent to a bank, or used for payments.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Repository.subTextColor(context), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget customColumn({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12)),
        const Gap(4),
        Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
).hasMatch(value?.trim() ?? '')) {
      return 'Enter a 3 or 4 digit security code';
    }
    return null;
  }

  void _validateDemoCard() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // This screen is a UI prototype. Never persist or transmit raw card details here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Details passed demo validation. No card was saved or charged.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    final cardSize = size.height * 0.23;
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Add Card', implyLeading: true, context: context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            SizedBox(
              width: double.infinity,
              height: cardSize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: cardSize * 0.35,
                    padding: const EdgeInsets.fromLTRB(16, 10, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      color: Styles.greenColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(Assets.cardsVisaWhite, width: 60, height: 45, fit: BoxFit.cover),
                        const Text('\$00.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 0, 20),
                    height: cardSize * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Styles.yellowColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customColumn(title: 'CARD NUMBER', subtitle: '**** **** **** $_lastFour'),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(child: customColumn(title: 'CARD HOLDER NAME', subtitle: _previewName)),
                            const Gap(12),
                            customColumn(title: 'VALID', subtitle: _previewExpiry),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: paymentCardsList.asMap().entries.map((entry) {
                final index = entry.key;
                final paymentCard = entry.value;
                return MaterialButton(
                  elevation: 0,
                  color: Repository.accentColor(context),
                  minWidth: 65,
                  height: 95,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  onPressed: () => setState(() => selectedCard = index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(paymentCard), fit: BoxFit.contain),
                        ),
                      ),
                      const Gap(12),
                      Icon(
                        selectedCard == index ? Icons.check_circle : Icons.circle_outlined,
                        color: selectedCard == index
                            ? Repository.selectedItemColor(context)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Gap(30),
            DefaultTextField(
              controller: _cardHolderName,
              title: 'Card Holder Name',
              validator: (value) => (value ?? '').trim().length < 2
                  ? 'Enter the name printed on the card'
                  : null,
            ),
            DefaultTextField(
              controller: _cardNumber,
              title: 'Card Number',
              label: 'Enter card number',
              keyboardType: TextInputType.number,
              validator: _validateCardNumber,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: DefaultTextField(
                    controller: _expiryDate,
                    title: 'Expiry date',
                    label: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                    validator: _validateExpiry,
                  ),
                ),
                const Gap(10),
                Flexible(
                  child: DefaultTextField(
                    controller: _cvv,
                    title: 'CVC/CVV',
                    label: '3 or 4 digits',
                    keyboardType: TextInputType.number,
                    obscure: true,
                    validator: _validateCvv,
                  ),
                ),
              ],
            ),
            const Gap(10),
            elevatedButton(
              color: Repository.selectedItemColor(context),
              context: context,
              callback: _validateDemoCard,
              text: 'Validate Card (Demo)',
            ),
            const Gap(12),
            Text(
              'Demo only: card details are validated on this screen but are not stored, sent to a bank, or used for payments.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Repository.subTextColor(context), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget customColumn({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12)),
        const Gap(4),
        Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
).firstMatch(value?.trim() ?? '');
    if (match == null) return 'Use MM/YY';
    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    final now = DateTime.now();
    if (year < now.year || (year == now.year && month < now.month)) {
      return 'Card has expired';
    }
    return null;
  }

  String? _validateCvv(String? value) {
    if (!RegExp(r'^\d{3,4}).hasMatch(value?.trim() ?? '')) {
      return 'Enter a 3 or 4 digit security code';
    }
    return null;
  }

  void _validateDemoCard() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // This screen is a UI prototype. Never persist or transmit raw card details here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Details passed demo validation. No card was saved or charged.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    final cardSize = size.height * 0.23;
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Add Card', implyLeading: true, context: context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            SizedBox(
              width: double.infinity,
              height: cardSize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: cardSize * 0.35,
                    padding: const EdgeInsets.fromLTRB(16, 10, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      color: Styles.greenColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(Assets.cardsVisaWhite, width: 60, height: 45, fit: BoxFit.cover),
                        const Text('\$00.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 0, 20),
                    height: cardSize * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Styles.yellowColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customColumn(title: 'CARD NUMBER', subtitle: '**** **** **** $_lastFour'),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(child: customColumn(title: 'CARD HOLDER NAME', subtitle: _previewName)),
                            const Gap(12),
                            customColumn(title: 'VALID', subtitle: _previewExpiry),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: paymentCardsList.asMap().entries.map((entry) {
                final index = entry.key;
                final paymentCard = entry.value;
                return MaterialButton(
                  elevation: 0,
                  color: Repository.accentColor(context),
                  minWidth: 65,
                  height: 95,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  onPressed: () => setState(() => selectedCard = index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(paymentCard), fit: BoxFit.contain),
                        ),
                      ),
                      const Gap(12),
                      Icon(
                        selectedCard == index ? Icons.check_circle : Icons.circle_outlined,
                        color: selectedCard == index
                            ? Repository.selectedItemColor(context)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Gap(30),
            DefaultTextField(
              controller: _cardHolderName,
              title: 'Card Holder Name',
              validator: (value) => (value ?? '').trim().length < 2
                  ? 'Enter the name printed on the card'
                  : null,
            ),
            DefaultTextField(
              controller: _cardNumber,
              title: 'Card Number',
              label: 'Enter card number',
              keyboardType: TextInputType.number,
              validator: _validateCardNumber,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: DefaultTextField(
                    controller: _expiryDate,
                    title: 'Expiry date',
                    label: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                    validator: _validateExpiry,
                  ),
                ),
                const Gap(10),
                Flexible(
                  child: DefaultTextField(
                    controller: _cvv,
                    title: 'CVC/CVV',
                    label: '3 or 4 digits',
                    keyboardType: TextInputType.number,
                    obscure: true,
                    validator: _validateCvv,
                  ),
                ),
              ],
            ),
            const Gap(10),
            elevatedButton(
              color: Repository.selectedItemColor(context),
              context: context,
              callback: _validateDemoCard,
              text: 'Validate Card (Demo)',
            ),
            const Gap(12),
            Text(
              'Demo only: card details are validated on this screen but are not stored, sent to a bank, or used for payments.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Repository.subTextColor(context), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget customColumn({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12)),
        const Gap(4),
        Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
).hasMatch(value?.trim() ?? '')) {
      return 'Enter a 3 or 4 digit security code';
    }
    return null;
  }

  void _validateDemoCard() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    // This screen is a UI prototype. Never persist or transmit raw card details here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Details passed demo validation. No card was saved or charged.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Layouts.getSize(context);
    final cardSize = size.height * 0.23;
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: Repository.bgColor(context),
      appBar: myAppBar(title: 'Add Card', implyLeading: true, context: context),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            SizedBox(
              width: double.infinity,
              height: cardSize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: cardSize * 0.35,
                    padding: const EdgeInsets.fromLTRB(16, 10, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      color: Styles.greenColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(Assets.cardsVisaWhite, width: 60, height: 45, fit: BoxFit.cover),
                        const Text('\$00.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 0, 20),
                    height: cardSize * 0.65,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                      color: Styles.yellowColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customColumn(title: 'CARD NUMBER', subtitle: '**** **** **** $_lastFour'),
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(child: customColumn(title: 'CARD HOLDER NAME', subtitle: _previewName)),
                            const Gap(12),
                            customColumn(title: 'VALID', subtitle: _previewExpiry),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: paymentCardsList.asMap().entries.map((entry) {
                final index = entry.key;
                final paymentCard = entry.value;
                return MaterialButton(
                  elevation: 0,
                  color: Repository.accentColor(context),
                  minWidth: 65,
                  height: 95,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  onPressed: () => setState(() => selectedCard = index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(paymentCard), fit: BoxFit.contain),
                        ),
                      ),
                      const Gap(12),
                      Icon(
                        selectedCard == index ? Icons.check_circle : Icons.circle_outlined,
                        color: selectedCard == index
                            ? Repository.selectedItemColor(context)
                            : Colors.white.withOpacity(0.5),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Gap(30),
            DefaultTextField(
              controller: _cardHolderName,
              title: 'Card Holder Name',
              validator: (value) => (value ?? '').trim().length < 2
                  ? 'Enter the name printed on the card'
                  : null,
            ),
            DefaultTextField(
              controller: _cardNumber,
              title: 'Card Number',
              label: 'Enter card number',
              keyboardType: TextInputType.number,
              validator: _validateCardNumber,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: DefaultTextField(
                    controller: _expiryDate,
                    title: 'Expiry date',
                    label: 'MM/YY',
                    keyboardType: TextInputType.datetime,
                    validator: _validateExpiry,
                  ),
                ),
                const Gap(10),
                Flexible(
                  child: DefaultTextField(
                    controller: _cvv,
                    title: 'CVC/CVV',
                    label: '3 or 4 digits',
                    keyboardType: TextInputType.number,
                    obscure: true,
                    validator: _validateCvv,
                  ),
                ),
              ],
            ),
            const Gap(10),
            elevatedButton(
              color: Repository.selectedItemColor(context),
              context: context,
              callback: _validateDemoCard,
              text: 'Validate Card (Demo)',
            ),
            const Gap(12),
            Text(
              'Demo only: card details are validated on this screen but are not stored, sent to a bank, or used for payments.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Repository.subTextColor(context), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget customColumn({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(fontSize: 12)),
        const Gap(4),
        Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
