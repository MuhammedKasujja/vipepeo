import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:flutter_multi_chip_select/flutter_multi_chip_select.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vipepeo_app/blocs/blocs.dart';
import 'package:vipepeo_app/models/models.dart';
import 'package:vipepeo_app/utils/utils.dart';
import 'package:vipepeo_app/widgets/widgets.dart';

class AddCommunityScreen extends StatefulWidget {
  final Community community;
  final Function(Community community) updateCommunity;

  const AddCommunityScreen({Key key, this.community, this.updateCommunity})
      : super(key: key);
  @override
  _AddCommunityScreenState createState() => _AddCommunityScreenState();
}

class _AddCommunityScreenState extends State<AddCommunityScreen> {
  String _country = 'UG';
  String cachedFilePath;
  var photo;
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  List<ChildCondition> childConditions;
  List<dynamic> selectedConditions = [];
  // final _multiSelectKey = GlobalKey<MultiSelectDropdownState>();

  Future<void> _onLookupCoordinatesPressed(
      BuildContext context, Position pos) async {
    final List<Placemark> placemarks = await Future(
            () => placemarkFromCoordinates(pos.latitude, pos.longitude))
        .catchError((onError) {
      AppUtils.showToast(onError.toString());
      return Future.value(<Placemark>[]);
    });

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      if (mounted) {
        // _countryController.text = pos.isoCountryCode;
        _locationController.text = pos.locality;
      }
    }
  }

  @override
  void initState() {
    if (widget.community != null) _initialData(widget.community);
    if (widget.community != null) {
      AppUtils.cachedFilePath(widget.community.image).then((filepath) {
        setState(() {
          cachedFilePath = filepath;
        });
      });
    }
    _getUserPosition();
    final _childConditionsBloc = BlocProvider.of<ChildConditionsBloc>(context);
    if (_childConditionsBloc.state.data == null) {
      _childConditionsBloc.add(FetchChildConditions());
    }

    super.initState();
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
        title:
            Text(widget.community != null ? 'Edit Community' : "Add Community"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: BlocBuilder<GroupsBloc, GroupsState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                child: state.status == AppStatus.loading
                    ? const LinearProgressIndicator()
                    : Container(),
                color: Colors.black,
              );
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                color: Colors.grey[300],
                height: 200,
                width: double.infinity,
                child: photo == null && widget.community == null
                    ? const Icon(Icons.add_a_photo, size: 50)
                    : photo != null
                        ? Image.file(photo)
                        : CachedNetworkImage(imageUrl: widget.community.image),
              ),
              onTap: () {
                AppUtils.getImage().then((image) {
                  setState(() {
                    photo = image;
                  });
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextfieldControllerWidget(
                      controller: _nameController, hint: "Name"),
                  TextField(
                    controller: _descriptionController,
                    minLines: 5,
                    maxLines: 10,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: Constants.HINT_DESCRIPTION,
                        labelStyle:
                            TextStyle(color: AppTheme.PrimaryDarkColor)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CountryDropdownWidget(
                    defaultCountry: 'UG',
                    onCountySelected: (country) {
                      print(country);
                      setState(() {
                        _country = country;
                      });
                    },
                  ),
                  TextfieldControllerWidget(
                      controller: _locationController,
                      hint: Constants.HINT_DISTRICT),
                  const SizedBox(
                    height: 10,
                  ),
                  MultiSelectDialog(
                    title: 'Topics',
                    onselectedConditions: (conditions) {
                      print(conditions);
                      selectedConditions = conditions;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlocListener<GroupsBloc, GroupsState>(
                    listener: (context, state) {
                      if (state.status == AppStatus.failure) {
                        AppUtils.showToast(state.error);
                      }
                      if (state.status == AppStatus.loaded) {
                        AppUtils.showToast(state.message);
                      }
                    },
                    child: SubmitButtonWidget(
                        hint: widget.community != null
                            ? 'Save Changes'
                            : 'Submit',
                        onPressed: () {
                          if (widget.community != null) {
                            _saveData(
                                postType: PostData.Update,
                                communityId: widget.community.id);
                          } else {
                            _saveData(postType: PostData.Save);
                          }
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields() {
    return _nameController.text != null &&
        _nameController.text.isNotEmpty &&
        _descriptionController.text != null &&
        _descriptionController.text.isNotEmpty &&
        _locationController.text != null &&
        _locationController.text.isNotEmpty;
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  _initialData(Community community) {
    print(community.topics);
    _nameController.text = community.name;
    _descriptionController.text = community.description;
    _locationController.text = community.locDistrict;
    selectedConditions = List<int>.from(community.topics);
  }

  void _saveData({PostData postType, communityId}) {
    String filePath;
    if (widget.community != null && photo == null) {
      filePath = cachedFilePath;
    } else if (widget.community != null && photo != null) {
      filePath = photo.path;
    } else {
      filePath = photo.path;
    }
    if (_validateFields()) {
      var community = Community(
          name: _nameController.text,
          description: _descriptionController.text,
          //  topics: this._multiSelectKey.currentState.result,
          topics: selectedConditions,
          locDistrict: _locationController.text,
          country: _country,
          image: filePath);

      BlocProvider.of<GroupsBloc>(context).add(AddEditGroup(community,
          postType: postType, communityId: communityId));
    } else {
      AppUtils.showToast(Constants.HINT_FILL_ALL_FIELDS);
    }
  }
}
