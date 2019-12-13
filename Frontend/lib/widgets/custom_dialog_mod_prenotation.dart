import 'package:anavis/model/app_state.dart';
import 'package:anavis/model/current_office_state.dart';
import 'package:anavis/widgets/button_card_bottom.dart';
import 'package:anavis/widgets/form_field_general.dart';
import 'package:date_format/date_format.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogModificationPrenotation extends StatefulWidget {
  @override
  final String email;

  DialogModificationPrenotation({
    @required this.email,
  });
  _DialogModificationPrenotationState createState() =>
      _DialogModificationPrenotationState();
}

class _DialogModificationPrenotationState
    extends State<DialogModificationPrenotation> {
  String _newOffice, _newHour;
  List<DropdownMenuItem> _offices, _hours;

  @override
  Widget build(BuildContext context) {
    _hours = this.createHourItem(context);
    _offices = this.createOfficeNames(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
      child: dialogContent(context),
    );
  }

  static String restrictFractionalSeconds(String dateTime) =>
      dateTime.replaceFirstMapped(RegExp(r"(\.\d{6})\d+"), (m) => m[1]);

  static String nicerTime(String timeNotNice) {
    return formatDate(DateTime.parse(restrictFractionalSeconds(timeNotNice)),
        ["Data: ", dd, '-', mm, '-', yyyy, " | Orario: ", HH, ":", nn]);
  }

  List<DropdownMenuItem> createOfficeNames(BuildContext context) {
    List<DropdownMenuItem> listOfficeItem = new List<DropdownMenuItem>();
    for (var officeString in Provider.of<AppState>(context).getOfficeNames()) {
      listOfficeItem.add(new DropdownMenuItem(
        value: officeString,
        child: Container(
          child: Text(
            officeString,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ));
    }
    return listOfficeItem;
  }

  List<DropdownMenuItem> createHourItem(BuildContext context) {
    List<DropdownMenuItem> listTimeItem = new List<DropdownMenuItem>();
    for (var timeString
        in Provider.of<CurrentOfficeState>(context).getOfficeTimeTables()) {
      String _timeFormatted = nicerTime(timeString);
      listTimeItem.add(new DropdownMenuItem(
        value: timeString,
        child: Container(
          child: Text(
            _timeFormatted,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ));
    }
    return listTimeItem;
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                "Modifica prenotazione",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.grey[850],
                    fontFamily: 'Rubik',
                    fontSize: 16,
                  ),
                  text:
                      "Mediante la seguente form si modificherà la prenotazione dell'utente ",
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              FormFieldGeneral(
                fetchItems: _offices,
                icon: Icon(
                  Icons.home,
                  color: Colors.red,
                ),
                labelDropDown: "Selezione l'ufficio",
                valueSelected: _newOffice,
                onChanged: (newValue) {
                  setState(() {
                    _newOffice = newValue;
                  });
                },
              ),
              SizedBox(height: 24.0),
              FormFieldGeneral(
                fetchItems: _hours,
                icon: Icon(
                  Icons.access_time,
                  color: Colors.red,
                ),
                labelDropDown: "Selezione l'orario",
                valueSelected: _newHour,
                onChanged: (newValue) {
                  setState(() {
                    _newHour = newValue;
                  });
                },
              ),
              SizedBox(height: 24.0),
              ButtonBar(
                children: <Widget>[
                  ButtonForCardBottom(
                    icon: Icon(
                      Icons.thumb_down,
                      color: Colors.white,
                    ),
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      Provider.of<AppState>(context).showFlushbar(
                        "Operazione annullata",
                        "L'operazione di modifica è stata annullata",
                        false,
                        context,
                      );
                    },
                    title: 'Annulla',
                  ),
                  ButtonForCardBottom(
                    icon: Icon(
                      Icons.thumb_up,
                    ),
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: 'Conferma',
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: Container(
            transform: Matrix4.translationValues(
                0.0, -Consts.avatarRadius + Consts.padding, 0.0),
            child: CircleAvatar(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              radius: Consts.avatarRadius,
              child: Text(
                widget.email.toString().substring(0, 2).toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 36.0;
}