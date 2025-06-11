import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/custom_header.dart';
import 'dart:math' as math;

// Define a class to hold color schemes for the card
class CardColorScheme {
  final List<Color> frontGradientColors;
  final List<Color> backGradientColors;
  final Color textColor;
  final Color accentColor;

  CardColorScheme({
    required this.frontGradientColors,
    required this.backGradientColors,
    required this.textColor,
    required this.accentColor,
  });

  // Predefined color scheme (only ABA theme)
  static final abaTheme = CardColorScheme(
    frontGradientColors: [
      Color(0xFF1A2A44),
      Color(0xFFA67B5B),
      Color(0xFFD4A017)
    ],
    backGradientColors: [Color(0xFF2F2F2F), Color(0xFF4A4A4A)],
    textColor: Colors.white,
    accentColor: Colors.white.withOpacity(0.2),
  );
}

// Data class to hold dynamic card information
class CardData {
  final String balance;
  final String accountNumber;
  final String nextSalaryDate;
  final String accountHolder;
  final String jobTitle;
  final String cvv;
  final String validUntil;
  final String idCard;

  CardData({
    required this.balance,
    required this.accountNumber,
    required this.nextSalaryDate,
    required this.accountHolder,
    required this.jobTitle,
    required this.cvv,
    required this.validUntil,
    required this.idCard,
  });
}

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  // State to hold the current color scheme
  final CardColorScheme _currentColorScheme = CardColorScheme.abaTheme;

  // Card data instance
  final CardData _cardData = CardData(
    balance: '\$2,450.75',
    accountNumber: '1234 5678 9012',
    nextSalaryDate: 'June 30, 2025',
    accountHolder: 'SOPHAT ROEUN',
    jobTitle: 'Software Engineer',
    cvv: '123',
    validUntil: '12/28',
    idCard: 'ABA001234567',
  );

  // Function to update the color scheme (though only one scheme is used now)
  // void _changeColorScheme(CardColorScheme newScheme) {
  //   setState(() {
  //     _currentColorScheme = newScheme;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ប្រាក់បៀវត្សរ៍",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: CustomHeader(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SalaryCard(
                  cardData: _cardData,
                  colorScheme: _currentColorScheme,
                ),
                SizedBox(height: 20),
                // Color selection button (only ABA)
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _ColorButton(
                //       label: 'ABA',
                //       onTap: () => _changeColorScheme(CardColorScheme.abaTheme),
                //       color: CardColorScheme.abaTheme.frontGradientColors[0],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget for color selection buttons
// class _ColorButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   final Color color;

//   const _ColorButton({
//     required this.label,
//     required this.onTap,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }

class SalaryCard extends StatefulWidget {
  final CardData cardData;
  final CardColorScheme colorScheme;

  const SalaryCard({
    super.key,
    required this.cardData,
    required this.colorScheme,
  });

  @override
  State<SalaryCard> createState() => _SalaryCardState();
}

class _SalaryCardState extends State<SalaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isBalanceVisible = true;
  bool _isCvvVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _isBalanceVisible = !_isBalanceVisible;
    });
  }

  void _toggleCvvVisibility() {
    setState(() {
      _isCvvVisible = !_isCvvVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * math.pi;
          final isFrontVisible = angle < math.pi / 2 || angle > 3 * math.pi / 2;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspective
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isFrontVisible
                ? _buildFrontCard()
                : Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: _buildBackCard(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      key: ValueKey('front'),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.colorScheme.frontGradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Balance',
                  style: TextStyle(
                    color: widget.colorScheme.textColor.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.colorScheme.accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: widget.colorScheme.textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  _isBalanceVisible ? widget.cardData.balance : '••••••',
                  style: TextStyle(
                    color: widget.colorScheme.textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: _toggleBalanceVisibility,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: widget.colorScheme.textColor.withOpacity(0.8),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Number',
                      style: TextStyle(
                        color: widget.colorScheme.textColor.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.cardData.accountNumber,
                      style: TextStyle(
                        color: widget.colorScheme.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Next Salary',
                      style: TextStyle(
                        color: widget.colorScheme.textColor.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.cardData.nextSalaryDate,
                      style: TextStyle(
                        color: widget.colorScheme.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cardData.accountHolder,
                      style: TextStyle(
                        color: widget.colorScheme.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.cardData.jobTitle,
                      style: TextStyle(
                        color: widget.colorScheme.textColor.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.flip_camera_android,
                      color: widget.colorScheme.textColor.withOpacity(0.7),
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Container(
      key: ValueKey('back'),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: widget.colorScheme.backGradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account Holder',
                  style: TextStyle(
                    color: widget.colorScheme.textColor.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.flip_camera_android,
                  color: widget.colorScheme.textColor.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cardData.accountHolder,
                  style: TextStyle(
                    color: widget.colorScheme.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ID Card: ${widget.cardData.idCard}',
                  style: TextStyle(
                    color: widget.colorScheme.textColor.withOpacity(0.8),
                    fontSize: 12,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CVV',
                      style: TextStyle(
                        color: widget.colorScheme.textColor.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.colorScheme.accentColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  widget.colorScheme.textColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _isCvvVisible ? widget.cardData.cvv : '•••',
                            style: TextStyle(
                              color: widget.colorScheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: _toggleCvvVisibility,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              _isCvvVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color:
                                  widget.colorScheme.textColor.withOpacity(0.8),
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Valid Until',
                      style: TextStyle(
                        color: widget.colorScheme.textColor.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.cardData.validUntil,
                      style: TextStyle(
                        color: widget.colorScheme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
