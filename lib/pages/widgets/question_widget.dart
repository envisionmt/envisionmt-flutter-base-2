import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:project_care_app/common/resources/app_colors.dart';
import 'package:project_care_app/entities/answer.dart';
import 'package:project_care_app/entities/question.dart';

import '../../common/utils/url_utils.dart';
import '../../entities/question_option.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    Key? key,
    this.question,
    this.index,
    this.onAnswerChanged,
    this.textTypeBackground,
    this.showTextTypeInputField = true,
    this.selectedColor,
  }) : super(key: key);

  final Question? question;
  final int? index;
  final Function(Answer? result)? onAnswerChanged;
  final Color? textTypeBackground;
  final bool showTextTypeInputField;
  final Color? selectedColor;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> with AutomaticKeepAliveClientMixin {
  late final Answer _result = Answer(questionID: widget.question?.id);

  @override
  void initState() {
    super.initState();

    switch (widget.question?.type) {
      case QuestionType.datetime:
        _result.answer = DateTime.now();
        break;
      case QuestionType.rate:
        _result.answer = 0;
        break;
      default:
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.question == null) {
      return Container();
    }

    switch (widget.question!.type) {
      case QuestionType.options:
        return _optionWidget(widget.question);
      case QuestionType.options4:
        return _optionWidget(widget.question, multipleChoice: true, otherDescribe: true);
      case QuestionType.options3:
        return _option3Widget(widget.question);
      case QuestionType.options2:
        return _yesNo2Widget(widget.question);
      case QuestionType.yesNo1:
        return _yesNo1Widget(widget.question);
      case QuestionType.yesNo2:
        return _yesNo2Widget(widget.question);
      case QuestionType.datetime:
        return _datetimeWidget(widget.question);
      case QuestionType.rate:
        return _rateWidget(widget.question);
      case QuestionType.text:
        return _textWidget(widget.question);
      default:
        return Container();
    }
  }

  String _getTitle() {
    return ((widget.index?.toString() ?? '').isEmpty ? '' : (widget.index!.toString() + '. ')) +
        (widget.question?.title ?? '');
  }

  Widget _option3Widget(Question? question) {
    return Column(
      children: [
        if ((question?.title ?? '').isNotEmpty)
          Container(
            width: double.infinity,
            color: Colors.orangeAccent[100]?.withOpacity(0.6),
            padding: const EdgeInsets.all(8),
            child: Html(
              data: question?.title ?? '',
              onLinkTap: (url, _, __, ___) async => await launchURL(url),
              style: {
                'body': Style(
                  fontWeight: FontWeight.bold,
                  fontSize: const FontSize(18),
                )
              },
            ),
          ),
        ...(question?.options ?? []).asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Material(
                color: AppColors.transparent,
                child: InkWell(
                  onTap: () {
                    if (question?.options?[e.key].id == _result.optionID) {
                      if (_result.optionID != null) {
                        _result.optionID = null;
                        _result.answer = null;
                      }
                    } else {
                      _result.optionID = question?.options?[e.key].id;
                      _result.answer = e.key + 1;
                    }
                    setState(() {});
                    widget.onAnswerChanged?.call(_result);
                  },
                  child: Ink(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: question?.options?[e.key].id == _result.optionID
                        ? (widget.selectedColor ?? Colors.redAccent[100]?.withOpacity(1))
                        : Colors.redAccent[100]?.withOpacity(0.6),
                    child: Text(
                      (e.key + 1).toString() + ') ' + (e.value.key ?? ''),
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 16)
      ],
    );
  }

  Widget _textWidget(Question? question) {
    return Container(
      color: widget.textTypeBackground ?? Colors.redAccent[100]?.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Html(
                data: _getTitle(),
                onLinkTap: (url, _, __, ___) async => await launchURL(url),
                style: {
                  'body': Style(
                    fontWeight: FontWeight.bold,
                    fontSize: const FontSize(18),
                  )
                },
              ),
            ),
          ),
          if (widget.showTextTypeInputField) const SizedBox(height: 8),
          if (widget.showTextTypeInputField)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                  ),
                  // return null if valid
                  validator: (val) => val!.isEmpty ? 'Other' : null,
                  onChanged: (val) {
                    _result.answer = val;
                    widget.onAnswerChanged?.call(_result);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Container _rateWidget(Question? question) {
    return Container(
      color: Colors.redAccent[100]?.withOpacity(0.1),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Html(
                data: _getTitle(),
                onLinkTap: (url, _, __, ___) async => await launchURL(url),
                style: {
                  'body': Style(
                    fontWeight: FontWeight.bold,
                    fontSize: const FontSize(18),
                  )
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("Very poor"), Text("Very good")]),
          ),
          Slider(
            value: (_result.answer as int).toDouble(),
            activeColor: Colors.red,
            inactiveColor: Colors.pink[50],
            label: "Value: ${(_result.answer)}",
            min: 0,
            max: 100,
            divisions: 100,
            // label: stressIntensity.round().toString(),
            onChanged: (val) {
              _result.answer = val.toInt();
              widget.onAnswerChanged?.call(_result);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Container _datetimeWidget(Question? question) {
    return Container(
      color: Colors.redAccent[100]?.withOpacity(0.1),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Html(
              data: _getTitle(),
              onLinkTap: (url, _, __, ___) async => await launchURL(url),
              style: {
                'body': Style(
                  fontWeight: FontWeight.bold,
                  fontSize: const FontSize(18),
                )
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("hour"),
                  NumberPicker(
                    value: (_result.answer is DateTime
                            ? (_result.answer as DateTime?) ?? DateTime.now()
                            : DateTime.now())
                        .hour,
                    minValue: 0,
                    maxValue: 23,
                    step: 1,
                    itemHeight: 50,
                    axis: Axis.vertical,
                    onChanged: (value) {
                      if (_result.answer is DateTime) {
                        DateTime currentTime = _result.answer as DateTime;
                        DateTime newTime = DateTime(currentTime.year, currentTime.month,
                            currentTime.day, value, currentTime.minute);
                        _result.answer = newTime;
                        widget.onAnswerChanged?.call(_result);
                        print(_result.answer);
                        setState(() {});
                      }
                    },
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ],
              ),
              const Text(
                ':',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              Column(
                children: [
                  const Text("minute"),
                  NumberPicker(
                    value: (_result.answer is DateTime
                            ? (_result.answer as DateTime?) ?? DateTime.now()
                            : DateTime.now())
                        .minute,
                    minValue: 0,
                    maxValue: 59,
                    step: 1,
                    itemHeight: 50,
                    axis: Axis.vertical,
                    onChanged: (value) {
                      if (_result.answer is DateTime) {
                        DateTime currentTime = _result.answer as DateTime;
                        DateTime newTime = DateTime(currentTime.year, currentTime.month,
                            currentTime.day, currentTime.hour, value);
                        _result.answer = newTime;
                        widget.onAnswerChanged?.call(_result);
                        print(_result.answer);
                        setState(() {});
                      }
                    },
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _yesNo2Widget(Question? question) {
    return Column(
      children: [
        if ((question?.description ?? '').isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.orangeAccent[100]?.withOpacity(0.6),
            width: double.infinity,
            child: Html(
              data: question?.description ?? '',
              onLinkTap: (url, _, __, ___) async => await launchURL(url),
              style: {
                'body': Style(
                  fontWeight: FontWeight.bold,
                  fontSize: const FontSize(18),
                )
              },
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            color: Colors.redAccent[100]?.withOpacity(0.6),
            child: Html(
              data: _getTitle(),
              style: {
                'body': Style(
                  fontWeight: FontWeight.bold,
                  fontSize: const FontSize(18),
                )
              },
              onLinkTap: (url, _, __, ___) async => await launchURL(url),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 120,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: _result.optionID == question?.options?.firstOrNull?.id
                          ? (widget.selectedColor ?? Colors.deepOrange[100]?.withOpacity(1))
                          : Colors.deepOrange[100]?.withOpacity(0.5),
                    ),
                    child: Text(
                      question?.options?.firstOrNull?.key ?? 'Yes',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () => _onOption2Changed(question?.options?.firstOrNull)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 120,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: _result.optionID == question?.options?.lastOrNull?.id
                          ? (widget.selectedColor ?? Colors.deepOrange[100]?.withOpacity(1))
                          : Colors.deepOrange[100]?.withOpacity(0.5),
                    ),
                    child: Text(
                      question?.options?.lastOrNull?.key ?? 'No',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () => _onOption2Changed(question?.options?.lastOrNull)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container _yesNo1Widget(Question? question) {
    return Container(
      color: Colors.redAccent[100]?.withOpacity(0.1),
      padding: const EdgeInsets.fromLTRB(0, 20, 15, 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Html(
                data: _getTitle(),
                onLinkTap: (url, _, __, ___) async => await launchURL(url),
                style: {
                  'body': Style(
                    fontWeight: FontWeight.bold,
                    fontSize: const FontSize(18),
                  )
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          CheckboxGroup(
            activeColor: Colors.deepOrangeAccent,
            labels: const ['Yes', 'No'],
            onChange: (bool isChecked, String label, int index) {
              _result.answer = isChecked;
              if (index < (question?.options ?? []).length) {
                _result.optionID = question?.options?[index].id;
              }
              widget.onAnswerChanged?.call(_result);
            },
            onSelected: (List<String> checked) {
              if (checked.length == 2) {
                checked.removeAt(0);
              }
            },
          ),
        ],
      ),
    );
  }

  Container _optionWidget(Question? question,
      {bool multipleChoice = false, bool otherDescribe = false}) {
    return Container(
      color: Colors.redAccent[100]?.withOpacity(0.1),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Html(
                data: _getTitle(),
                onLinkTap: (url, _, __, ___) async => await launchURL(url),
                style: {
                  'body': Style(
                    fontWeight: FontWeight.bold,
                    fontSize: const FontSize(18),
                  )
                },
              ),
            ),
          ),
          CheckboxGroup(
            // checked: (question?.options ?? [])
            //     .where((element) => element.id == _result?.optionID)
            //     .map((e) => e.title ?? '')
            //     .toList(),
            activeColor: Colors.deepOrangeAccent,
            labels: (question?.options ?? []).map((e) => e.key ?? '').toList(),
            onChange: (bool isChecked, String label, int index) =>
                _onOptionChanged(question, isChecked, label, index, multipleChoice: multipleChoice),
            onSelected: multipleChoice
                ? null
                : (List<String> checked) {
                    if (checked.length == 2) {
                      checked.removeAt(0);
                    }
                  },
          ),
          if (otherDescribe)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                  ),
                  // return null if valid
                  validator: (val) => val!.isEmpty ? 'Other' : null,
                  onChanged: (val) {
                    _result.answer = val;
                    widget.onAnswerChanged?.call(_result);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _onOptionChanged(Question? question, bool isChecked, String label, int index,
      {bool multipleChoice = false}) {
    if (multipleChoice) {
      if ((_result.multipleOptionIDs ?? []).contains(question?.options?[index].id)) {
        if (!isChecked) {
          _result.multipleOptionIDs?.removeWhere((element) => element == question?.options?[index].id);
          // _result.answer = null;
        }
      } else {
        final options = (_result.multipleOptionIDs ?? []);
        options.add(question?.options?[index].id ?? '');
        _result.multipleOptionIDs = options;
        _result.answer = question?.options?[index].value;
      }
      widget.onAnswerChanged?.call(_result);
      return;
    }

    if (question?.options?[index].id == _result.optionID) {
      if (!isChecked) {
        _result.optionID = null;
        _result.answer = null;
      }
    } else {
      _result.optionID = question?.options?[index].id;
      _result.answer = question?.options?[index].value;
    }
    widget.onAnswerChanged?.call(_result);
  }

  void _onOption2Changed(QuestionOption? option) {
    _result.answer = option?.value;
    _result.optionID = option?.id;
    setState(() {});
    widget.onAnswerChanged?.call(_result);
  }
}
