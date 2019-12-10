import 'package:anavis/model/app_state.dart';
import 'package:anavis/model/donor_request_recap_args.dart';
import 'package:anavis/widgets/donor_request_widget.dart';
import 'package:anavis/widgets/fab_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';

// /office/prenotations/timeview

class OfficePrenotationTimeView extends StatefulWidget {
  final String donor;

  OfficePrenotationTimeView({@required this.donor});

  @override
  _OfficePrenotationTimeViewState createState() =>
      _OfficePrenotationTimeViewState();
}

class _OfficePrenotationTimeViewState extends State<OfficePrenotationTimeView> {
  String _timeSelected;
  String _timeFormatted;

  void fetchTimeFromOffice() {
    Provider.of<AppState>(context).setOfficeTimeTables(this.widget.donor);
  }

  List<DropdownMenuItem> createListItem() {
    this.fetchTimeFromOffice();
    List<DropdownMenuItem> listTimeItem = new List<DropdownMenuItem>();
    for (var timeString
        in Provider.of<AppState>(context).getOfficeTimeTables()) {
      String restrictFractionalSeconds(String dateTime) =>
          dateTime.replaceFirstMapped(RegExp(r"(\.\d{6})\d+"), (m) => m[1]);
      _timeFormatted = formatDate(
          DateTime.parse(restrictFractionalSeconds(timeString)),
          ["Data: ", dd, '-', mm, '-', yyyy, " | Orario: ", HH, ":", nn]);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _timeSelected != null
          ? FABRightArrow(
              onPressed: () {
                // Navigator.pushReplacementNamed(
                //     context, '/donor/officerequest/recap',
                //     arguments: new DonorRequestRecapArgs(this.widget.office,
                //         this._timeSelected, this._timeFormatted));
                /*Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return DonorRequestRecap(
                    office: this.widget.office,
                    time: this._timeSelected,
                    nicerTime: this._timeFormatted,
                  );
                }));*/
              },
            )
          : FABLeftArrow(
              nameOffice: widget.donor
                  .split('@')
                  .map((String text) => text)
                  .elementAt(0),
              onPressed: () {
                Navigator.pop(context);
                /*  Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return DonorRequestOfficeView();
                }));*/
              },
            ),
      backgroundColor: Colors.white,
      body: BuildDonorRequestWidget(
        fetchItems: createListItem(),
        title: "Orario",
        subtitle:
            "Di seguito potrai selezionare l'orario in cui si vorrebbe far donare l'utente scelto",
        icon: Icon(
          Icons.access_time,
          size: 42,
          color: Colors.red,
        ),
        labelDropDown: "Seleziona l'orario",
        valueSelected: _timeSelected,
        onChanged: (newValue) {
          setState(() {
            _timeSelected = newValue;
          });
        },
      ),
    );
  }
}