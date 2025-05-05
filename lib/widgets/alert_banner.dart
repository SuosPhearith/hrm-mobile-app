import 'package:flutter/material.dart';
import 'package:mobile_app/shared/color/colors.dart';


class AlertBanner extends StatefulWidget {
  const AlertBanner({
    Key? key,
  }) : super(key: key);

  @override
  State<AlertBanner> createState() => _AlertBannerState();
}

class _AlertBannerState extends State<AlertBanner> {
  bool _isVisible = false;
  @override
 
  Widget build(BuildContext context) {
    if (_isVisible) return SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: HColors.eggs,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber,
            color: HColors.whiteBrown,
          ),
          SizedBox(
            width: 8,
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "សារសំខាន់\n",
                  style: TextStyle(
                    color: HColors.brown,
                    fontFamily: 'Kantumruy Pro',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "សូមភ្ជាប់តេលេក្រាមដើម្បីទទួលដំណឹងផ្សេងៗ",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Kantumruy Pro',
                    color: HColors.whiteBrown,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          InkWell(
            onTap: (){
              setState(() {
                _isVisible=! _isVisible;
              });
            },
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
