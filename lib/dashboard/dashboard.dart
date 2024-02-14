import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmz/appointment/todaysAppointment.dart';
import 'package:hmz/auth/providers/auth.dart';
import 'package:hmz/home/widgets/app_drawer.dart';
import 'package:hmz/home/widgets/bottom_navigation_bar.dart';
import 'package:hmz/prescription/screens/user_prescriptions_screen.dart';
import 'package:hmz/setting/setting.dart';
import 'package:hmz/utils/colors.dart';
import '../profile/fullProfile.dart';
import 'package:hmz/profile/changePassword.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:date_field/date_field.dart';

import 'dart:async';
import 'dart:convert';
import '../appointment/appointment.dart';
import '../appointment/showAppointment.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppintmentDetails {
  final String id;
  final String patient_name;
  final String doctor_name;
  final String date;
  final String start_time;
  final String end_time;
  final String status;
  final String remarks;
  final String jitsi_link;

  AppintmentDetails({
    this.id,
    this.patient_name,
    this.doctor_name,
    this.date,
    this.start_time,
    this.end_time,
    this.remarks,
    this.status,
    this.jitsi_link,
  });
}

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dsh';

  String idd;
  String useridd;

  DashboardScreen(this.idd, this.useridd);

  @override
  DashboardScreenState createState() =>
      DashboardScreenState(this.idd, this.useridd);
}

class DashboardScreenState extends State<DashboardScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _department = TextEditingController();
  String _image;

  bool _isloading = true;
  String url;

  Future<String> getSWData() async {
    url = Auth().linkURL + "api/getDoctorProfile?id=";
    print(useridd);
    String urrr1 = url + "${this.useridd}";
    var res = await http
        .get(Uri.encodeFull(urrr1), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      _email.text = resBody['email'];
      _name.text = resBody['name'];
      _phone.text = resBody['phone'];
      _department.text = resBody['department'];
      _address.text = resBody['address'];
      _image = resBody['img_url'];
      setState(() {
        this._isloading = false;
      });
    });
    return "Sucess";
  }

  String idd;
  String useridd;

  DashboardScreenState(this.idd, this.useridd);

  int len;

  Future<List<AppintmentDetails>> _responseFuture() async {
    var data = await http.get(Auth().linkURL +
        "api/getMyAllAppoinmentList?group=doctor&id=" +
        this.idd);
    var jsondata = json.decode(data.body);
    List<AppintmentDetails> _lcdata = [];

    for (var u in jsondata) {
      AppintmentDetails subdata = AppintmentDetails(
        id: u["id"],
        patient_name: u["patient_name"],
        doctor_name: u["doctor_name"],
        date: u["date"],
        start_time: u["start_time"],
        end_time: u["end_time"],
        remarks: u["remarks"],
        status: u["status"],
        jitsi_link: u["jitsi_link"],
      );
      _lcdata.add(subdata);
    }

    this.len = _lcdata.length;

    return _lcdata;
  }

  Future<List<AppintmentDetails>> allappointments;

  @override
  void initState() {
    super.initState();
    allappointments = _responseFuture();
    getSWData();
  }

  AppColor appcolor = new AppColor();

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //
      //   title: Text(AppLocalizations.of(context).dashboard, style: TextStyle(
      //     color: appcolor.appbartext(),
      //     fontWeight: appcolor.appbarfontweight(),
      //   ),),
      //   backgroundColor: appcolor.appbarbackground(),
      //
      //   elevation: 0,
      //   bottomOpacity: .1,
      //
      //   iconTheme: IconThemeData(color: appcolor.appbaricontheme()),
      //
      //
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(8),
      //       child: GestureDetector(
      //
      //         child: CircleAvatar(
      //           radius: 25,
      //
      //           child:Image.asset(
      //               'assets/images/icon.png'),
      //           backgroundColor: Colors.transparent,
      //
      //         ),
      //         onTap: (){
      //            Navigator.of(context).pushReplacementNamed(FullProfile.routeName);
      //         },
      //       ),
      //     )
      //   ],
      // ),

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: AppBar(
          backgroundColor: appcolor.appbarbackground(),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          //AppLocalizations.of(context).dashboard,
                          "Welcome",
                          style: TextStyle(
                            fontSize: 22,
                            color: appcolor.appbartext(),
                            fontWeight: appcolor.appbarfontweight(),
                          ),
                        ),
                        Text(
                          //AppLocalizations.of(context).dashboard,
                          _name.text,
                          style: TextStyle(
                            fontSize: 22,
                            color: appcolor.appbartext(),
                            fontWeight: appcolor.appbarfontweight(),
                          ),
                        ),
                        Text(
                          //AppLocalizations.of(context).dashboard,
                          _department.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: appcolor.appbartext(),
                            fontWeight: appcolor.appbarfontweight(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: _image != null && _image.isNotEmpty
                        ? Image.network(
                            "https://myconstituency.in/multi-hms/" + _image)
                        : Image.asset('assets/images/icon.png'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),

      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Colors.grey[200],
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Services",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shadowColor: Color.fromRGBO(0, 0, 0, 5),
                            elevation: 5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.redAccent,
                                size: 50,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                AppLocalizations.of(context).todaysAppointment,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                ShowTodaysAppointmentScreen.routeName);
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shadowColor: Color.fromRGBO(0, 0, 0, 5),
                            elevation: 5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.redAccent,
                                size: 50,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                AppLocalizations.of(context).addAppointment,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                AppointmentDetailsScreen.routeName);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shadowColor: Color.fromRGBO(0, 0, 0, 5),
                            elevation: 5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.list,
                                color: Colors.redAccent,
                                size: 50,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                AppLocalizations.of(context).appointments,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                ShowAppointmentScreen.routeName);
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,

                            shadowColor: Color.fromRGBO(0, 0, 0, 5),
                            elevation: 5, // foreground
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_copy,
                                color: Colors.redAccent,
                                size: 50,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                AppLocalizations.of(context).prescription,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                                UserPrescriptionsScreen.routeName);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,

                            shadowColor: Color.fromRGBO(0, 0, 0, 5),
                            elevation: 5, // foreground
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                color: Colors.redAccent,
                                size: 50,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                AppLocalizations.of(context).profile,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(FullProfile.routeName);
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,

                            shadowColor: Color.fromRGBO(0, 0, 0, 5),
                            elevation: 5, // foreground
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                color: Colors.redAccent,
                                size: 50,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                AppLocalizations.of(context).setting,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(SettingScreen.routeName);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),

      //bottomNavigationBar: AppBottomNavigationBar(screenNum: 0),
    );
  }
}
