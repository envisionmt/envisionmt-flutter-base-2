import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/styles/text_styles.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    this.title,
    this.description,
    this.acceptText,
    this.cancelText,
    this.titleWidget,
    required this.onYes,
  }) : super(key: key);

  final String? cancelText;
  final String? acceptText;
  final String? title;
  final String? description;
  final Widget? titleWidget;
  final Function() onYes;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              titleWidget ??
                  Text(
                    title ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.black,
                    ),
                  ),
              if ((description ?? '').isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    description ?? '',
                    style: const TextStyle(fontSize: 16, color: AppColors.grey),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _onBack(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.gray1000),
                    ),
                    child: Text(cancelText ?? 'No', style: TextStyles.whiteHeaderBold),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: onYes,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                    ),
                    child: Text(acceptText ?? 'Yes', style: TextStyles.whiteHeaderBold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onBack(BuildContext context) {
    Navigator.pop(context);
  }

  void show(BuildContext context) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => this,
    );
  }
}
