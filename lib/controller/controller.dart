import 'package:flutter/material.dart';
import 'package:notificatio_and_location_permission/model/model_button.dart';

List<ButtonModel> btnList = [
  ButtonModel(
    btnname: "Request Location Permission",
    btnColor: const Color(0xFF2f80ed),
    onTap: () {},
  ),
  ButtonModel(
    btnname: "Request Notification Permission",
    btnColor: const Color(0xFFf2c94c),
    onTap: () {},
  ),
  ButtonModel(
    btnname: "Start Location Update",
    btnColor: const Color(0xff27ae60),
    onTap: () {},
  ),
  ButtonModel(
    btnname: 'Stop Location Update',
    btnColor: const Color(0xFFeb5757),
    onTap: () {},
  )
];
