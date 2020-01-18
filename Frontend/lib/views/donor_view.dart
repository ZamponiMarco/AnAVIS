import 'package:anavis/models/closedprenotation.dart';
import 'package:anavis/models/donationreport.dart';
import 'package:anavis/providers/app_state.dart';
import 'package:anavis/providers/current_donor_state.dart';
import 'package:anavis/services/donation_service.dart';
import 'package:anavis/services/donor_service.dart';
import 'package:anavis/services/prenotation_service.dart';
import 'package:anavis/services/request_service.dart';
import 'package:anavis/views/widgets/button_fab_homepage.dart';
import 'package:anavis/views/widgets/clip_path.dart';
import 'package:anavis/views/widgets/confirmation_flushbar.dart';
import 'package:anavis/views/widgets/main_card_donation.dart';
import 'package:badges/badges.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class DonorView extends StatefulWidget {
  @override
  _DonorViewState createState() => _DonorViewState();
}

class _DonorViewState extends State<DonorView> {
  bool _donorCanDonate = false;
  String _email = "";

  bool showLegend = true;

  int prenotationCount = 0;
  int pendingCount = 0;
  int pendingRequestCount = 0;

  List<int> selectedSpots = [];
  int touchedIndex;
  int lastPanStartOnIndex = -1;
  PrenotationService _prenotationService;
  RequestService _requestService;
  DonationService _donationService;
  DonorService _donorService;

  int getPrenotationCount() {
    _prenotationService.getPrenotationsByDonor(this._email).then(
      (onValue) {
        setState(() {
          prenotationCount = onValue.length;
        });
      },
    );
    return prenotationCount;
  }

  int getPendingCount() {
    _prenotationService.getDonorNotConfirmedPrenotations(this._email).then(
      (onValue) {
        setState(() {
          pendingCount = onValue.length;
        });
      },
    );
    return pendingCount;
  }

  int getPendingRequestCount() {
    _requestService.getRequestsByDonor(this._email).then(
      (onValue) {
        setState(() {
          pendingRequestCount = onValue.length;
        });
      },
    );
    return pendingRequestCount;
  }

  void setCanDonate() async {
    this._donorCanDonate =
        await _donorService.checkDonationPossibility(this._email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _prenotationService = new PrenotationService(context);
    _requestService = new RequestService(context);
    _donationService = new DonationService(context);
    _donorService = new DonorService(context);
    _email = AppState().getUserMail();
    this.setCanDonate();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: (MediaQuery.of(context).size.height / 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.5, 0.7, 0.9],
                  colors: [
                    Colors.red[800],
                    Colors.red[700],
                    Colors.red[600],
                    Colors.red[400],
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 46, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 24,
                ),
                Flexible(
                  child: AutoSizeText(
                    'Benvenuto,',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: AutoSizeText(
                    _email,
                    style: TextStyle(
                      fontSize: 52,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Row(
                    children: <Widget>[
                      Chip(
                        backgroundColor:
                            this._donorCanDonate ? Colors.green : Colors.red,
                        elevation: 14,
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            this._donorCanDonate ? Icons.check : Icons.warning,
                            color: this._donorCanDonate
                                ? Colors.green
                                : Colors.red,
                            size: 18.0,
                          ),
                        ),
                        label: Text(
                          this._donorCanDonate
                              ? 'Puoi donare'
                              : 'Non puoi donare',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Chip(
                        backgroundColor: Colors.grey[600],
                        elevation: 14,
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.map,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                        ),
                        label: Text(
                          'Il tuo centro AVIS',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Center(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    top: (MediaQuery.of(context).size.height / 4),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FutureBuilder<List<ClosedPrenotation>>(
                        future:
                            _donationService.getDonationsByDonor(this._email),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(26.0),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text("Storico donazioni vuoto"),
                                    subtitle: Text(
                                        "Non è presente alcuna donazione effettuata"),
                                  ),
                                ),
                              ),
                            );
                          }

                          if (snapshot.data.length == 1) {
                            return Center(
                              child: Container(
                                width: 330,
                                height:
                                    (MediaQuery.of(context).size.height / 1.7),
                                child: MainCardDonorRecapDonation(
                                  closedPrenotation: snapshot.data[0],
                                ),
                              ),
                            );
                          }

                          return Swiper(
                            itemBuilder: (BuildContext context, int index) {
                              return MainCardDonorRecapDonation(
                                closedPrenotation: snapshot.data[index],
                              );
                            },
                            itemCount: snapshot.data.length,
                            itemWidth: 330.0,
                            index: 0,
                            itemHeight:
                                (MediaQuery.of(context).size.height / 1.7),
                            layout: SwiperLayout.STACK,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ButtonFABHomePage(
        iconFab: iconFAB(),
      ),
    );
  }

  List<SpeedDialChild> iconFAB() {
    return <SpeedDialChild>[
      SpeedDialChild(
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.pushNamed(context, '/donor/candonate',
              arguments: _donorCanDonate);
        },
        label: 'Possibilità di donare',
        labelBackgroundColor: Colors.redAccent,
        backgroundColor: Colors.redAccent,
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
      SpeedDialChild(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: 'Richiesta di donazione',
        labelBackgroundColor: Colors.redAccent,
        backgroundColor: Colors.redAccent,
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        onTap: () {
          if (_donorCanDonate) {
            Navigator.pushNamed(
              context,
              '/donor/officerequest',
            );
          } else {
            ConfirmationFlushbar(
              "Operazione non consentita",
              "Al momento non puoi richiedere di prenotare una donazione, prova tra un pò di giorni.",
              false,
            ).show(context);
            /* Provider.of<AppState>(context).showFlushbar(
                "Operazione non consentita",
                "Al momento non puoi richiedere di prenotare una donazione, prova tra un pò di giorni.",
                false,
                context);*/
          }
        },
      ),
      SpeedDialChild(
        label: 'Lista di prenotazioni',
        labelBackgroundColor: Colors.redAccent,
        backgroundColor: Colors.redAccent,
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        child: Center(
          child: Badge(
            toAnimate: false,
            showBadge: getPrenotationCount() > 0 ? true : false,
            badgeContent: Padding(
              padding: const EdgeInsets.all(1.4),
              child: Text(getPrenotationCount().toString()),
            ),
            position: BadgePosition.topRight(top: -9, right: -2),
            badgeColor: Colors.white,
            child: Icon(
              Icons.receipt,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/donor/prenotationsview',
          );
        },
      ),
      SpeedDialChild(
        label: 'Lista di richieste',
        labelBackgroundColor: Colors.redAccent,
        backgroundColor: Colors.redAccent,
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        child: Center(
          child: Badge(
            toAnimate: false,
            showBadge: getPendingRequestCount() > 0 ? true : false,
            badgeContent: Padding(
              padding: const EdgeInsets.all(1.4),
              child: Text(getPendingRequestCount().toString()),
            ),
            position: BadgePosition.topRight(top: -9, right: -2),
            badgeColor: Colors.white,
            child: Icon(
              Icons.calendar_view_day,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/donor/requestsview',
          );
        },
      ),
      SpeedDialChild(
        label: 'Modifiche dall\'ufficio',
        labelBackgroundColor: Colors.redAccent,
        backgroundColor: Colors.redAccent,
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        child: Center(
          child: Badge(
            toAnimate: false,
            showBadge: getPendingCount() > 0 ? true : false,
            badgeContent: Padding(
              padding: const EdgeInsets.all(1.4),
              child: Text(getPendingCount().toString()),
            ),
            position: BadgePosition.topRight(top: -9, right: -2),
            badgeColor: Colors.white,
            child: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/donor/pendingprenotationsview',
          );
        },
      ),
      SpeedDialChild(
        label: 'Profilo',
        labelBackgroundColor: Colors.redAccent,
        backgroundColor: Colors.redAccent,
        labelStyle: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
        ),
        child: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        onTap: () {},
      ),
    ];
  }
}
