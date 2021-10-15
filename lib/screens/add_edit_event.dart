import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/states/app_state.dart';
import 'package:vipepeo_app/utils/app_theme.dart';
import 'package:vipepeo_app/utils/app_utils.dart';
import 'package:vipepeo_app/utils/constants.dart';
import 'package:vipepeo_app/widgets/country_dropdown.dart';
import 'package:vipepeo_app/widgets/datepicker.dart';
import 'package:vipepeo_app/widgets/submit_button.dart';
import 'package:vipepeo_app/widgets/textfield.with.controller.dart';
import 'package:vipepeo_app/widgets/timepicker.dart';
import 'package:geolocator/geolocator.dart';

class AddEditEventScreen extends StatefulWidget {
  final Event event;
  final Function(Event event) updateEvent;

  const AddEditEventScreen({Key key, this.event, this.updateEvent})
      : super(key: key);
  @override
  _AddEditEventScreenState createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  String _country = 'UG';
  File photo;
  String cachedFilePath;
  bool isUpdated = false;
  bool isSubmitting = false;
  TextEditingController _districtController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();
  TextEditingController _themeController = TextEditingController();
  TextEditingController _speakerController = TextEditingController();
  TextEditingController _organizerController = TextEditingController();

  Future<void> _onLookupCoordinatesPressed(
      BuildContext context, Position pos) async {
    final List<Placemark> placemarks = await Future(
            () => placemarkFromCoordinates(pos.latitude, pos.longitude))
        .catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(onError.toString()),
      ));
      return Future.value(<Placemark>[]);
    });

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      // _countryController.text = pos.isoCountryCode;
      _districtController.text = '${pos.locality}';
      _streetController.text = pos.thoroughfare;
      // setState(() {});
      // final List<String> coords = placemarks
      //     .map((placemark) =>
      //         pos.position?.latitude.toString() +
      //         ', ' +
      //         pos.position?.longitude.toString())
      //     .toList();
    }
  }

  AppState _appState;
  @override
  void initState() {
    if (widget.event != null)
      AppUtils.cachedFilePath(widget.event.photo).then((filepath) {
        if (mounted)
          setState(() {
            cachedFilePath = filepath;
          });
      });
    _appState = Provider.of<AppState>(context, listen: false);
    if (widget.event != null) AppUtils.cachedFilePath(widget.event.photo);
    if (widget.event != null) _initialData(widget.event);
    _getUserPosition();
    super.initState();
    // print('MyCountry: ${widget.event.country}');
  }

  _getUserPosition() async {
    await Geolocator.getCurrentPosition().then((pos) {
      _onLookupCoordinatesPressed(context, pos);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event != null ? 'Edit Event' : "Add Event"),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     if (widget.event != null && isUpdated) {
        //       // AppUtils(context)
        //     } else {
        //       Navigator.pop(context);
        //     }
        //   },
        // ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: Container(
            width: double.infinity,
            child: isSubmitting ? LinearProgressIndicator() : Container(),
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  color: Colors.grey[300],
                  height: 200,
                  width: double.infinity,
                  child: photo == null && widget.event == null
                      ? Icon(Icons.add_a_photo, size: 50)
                      : photo != null
                          ? Image.file(photo)
                          : CachedNetworkImage(imageUrl: widget.event.photo),
                  // child: widget.event != null
                  //     ? Image.network(widget.event.photo)
                  //     : photo == null
                  //         ? Icon(Icons.add_a_photo, size: 50)
                  //         : Image.file(photo),
                ),
                onTap: () async {
                  // final picker = ImagePicker();
                  // final pickedFile =
                  //     await picker.getImage(source: ImageSource.gallery);
                  // setState(() {
                  //   photo = File(pickedFile.path);
                  // });
                  await AppUtils.getImage().then((image) {
                    setState(() {
                      photo = image;
                    });
                  }).catchError((onError) {
                    print(onError);
                  });
                },
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextfieldControllerWidget(
                        controller: _themeController, hint: 'Theme'),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Starting",
                        style: TextStyle(
                          color: AppTheme.PrimaryDarkColor,
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: DatepickerWidget(
                            controller: _startDateController,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: TimepickerWidget(
                            controller: _startTimeController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ending",
                        style: TextStyle(
                          color: AppTheme.PrimaryDarkColor,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 1,
                          child: DatepickerWidget(
                            controller: _endDateController,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          flex: 1,
                          child: TimepickerWidget(
                            controller: _endTimeController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextfieldControllerWidget(
                        controller: _speakerController, hint: 'Speaker'),
                    SizedBox(
                      height: 10,
                    ),
                    TextfieldControllerWidget(
                        controller: _organizerController, hint: 'Organizer'),
                    SizedBox(
                      height: 10,
                    ),
                    CountryDropdownWidget(
                      defaultCountry:
                          widget.event != null ? widget.event.country : 'UG',
                      onCountySelected: (country) {
                        print(country);
                        setState(() {
                          _country = country;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextfieldControllerWidget(
                        controller: _districtController, hint: 'District'),
                    SizedBox(
                      height: 5,
                    ),
                    TextfieldControllerWidget(
                        controller: _streetController, hint: 'Building Street'),
                    SizedBox(
                      height: 10,
                    ),
                    SubmitButtonWidget(
                        hint: widget.event == null ? 'Submit' : 'Save changes',
                        onPressed: () {
                          String filePath;
                          if (widget.event != null && photo == null) {
                            filePath = cachedFilePath;
                          } else if (widget.event != null && photo != null) {
                            filePath = photo.path;
                          } else {
                            filePath = photo.path;
                          }
                          if (_validateFields()) {
                            setState(() {
                              isSubmitting = true;
                            });
                            var event = Event(
                                speaker: _speakerController.text,
                                endDate: _endDateController.text,
                                startDate: _startDateController.text,
                                locDistrict: _districtController.text,
                                street: _streetController.text,
                                theme: _themeController.text,
                                startTime: _startTimeController.text,
                                endTime: _endTimeController.text,
                                country: _country,
                                organizer: _organizerController.text,
                                photo: filePath);
                            if (widget.event != null) {
                              _appState
                                  .addEditEvent(event,
                                      postType: PostData.Update,
                                      eventId: widget.event.id)
                                  .then((data) {
                                this.widget.updateEvent(event);
                                if (mounted)
                                  setState(() {
                                    isSubmitting = false;
                                    isUpdated = true;
                                  });
                                AppUtils.showToast("${data['response']}");
                                print("Response: $data");
                              }).catchError((onError) {
                                print('onError: $onError');
                                if (mounted)
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                AppUtils.showToast("Something went wrong");
                              });
                            } else {
                              _appState
                                  .addEditEvent(
                                event,
                              )
                                  .then((data) {
                                if (mounted)
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                AppUtils.showToast("${data['response']}");
                                print("Response: $data");
                              }).catchError((onError) {
                                print('onError: $onError');
                                if (mounted)
                                  setState(() {
                                    isSubmitting = false;
                                  });
                                AppUtils.showToast("Something went wrong");
                              });
                            }
                          } else {
                            AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    return _themeController.text != null &&
        _themeController.text.isNotEmpty &&
        _startDateController.text != null &&
        _startDateController.text.isNotEmpty &&
        _endDateController.text != null &&
        _endDateController.text.isNotEmpty &&
        _speakerController.text != null &&
        _speakerController.text.isNotEmpty &&
        _districtController.text != null &&
        _districtController.text.isNotEmpty &&
        _streetController.text != null &&
        _streetController.text.isNotEmpty &&
        _organizerController.text != null &&
        _organizerController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _districtController.dispose();
    _streetController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _themeController.dispose();
    _speakerController.dispose();
    _organizerController.dispose();
    super.dispose();
  }

  _initialData(Event event) {
    _districtController.text = event.locDistrict;
    _streetController.text = event.street;
    _startDateController.text = event.startDate;
    _endDateController.text = event.endDate;
    _startTimeController.text = event.startTime.replaceRange(5, 8, '');
    _endTimeController.text = event.endTime.replaceRange(5, 8, '');
    _themeController.text = event.theme;
    _speakerController.text = event.speaker;
    _organizerController.text = event.organizer;
    print('Country: ${event.country}');
    //  _country = event.country;
    // photo = File(path)
    //  setState(() {
    //    _defaultCountry = event.id;
    //  });
  }
}
