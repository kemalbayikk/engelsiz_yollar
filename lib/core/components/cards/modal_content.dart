import 'package:engelsiz_yollar/core/extensions/context_extensions.dart';
import 'package:engelsiz_yollar/core/extensions/num_extensions.dart';
import 'package:engelsiz_yollar/core/init/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

import 'custom_card.dart';

class ModalContent extends StatelessWidget {
  final Map item;
  final Function(String pinId) onTap;

  const ModalContent({Key key, @required this.item, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: context.customHeight(3),
          child: Row(
            children: [
              Expanded(
                child: MyCard(
                  child: FadeInImage(
                    alignment: Alignment.center,
                    placeholder: AssetImage('assets/images/loader.gif'),
                    image: NetworkImage(
                      item['mediaUrl'],
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Expanded(
                child: MyCard(
                    align: Alignment.topLeft,
                    child: Text('${item['description']}')),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            print('${item['mediaUrl']}');
            onTap(item['pinId']);
            if (NavigationService.instance.canPop) {
              NavigationService.instance.navPop;
            }
          },
          child: MyCard(
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Düzeltildi Olarak İşaretle',
                  style:
                      context.textTheme.headline5.copyWith(color: Colors.white),
                ),
                Icon(
                  Icons.check,
                  color: Colors.white,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
