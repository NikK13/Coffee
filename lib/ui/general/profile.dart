import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:coffee/data/utils/app.dart';
import 'package:coffee/data/utils/appnavigator.dart';
import 'package:coffee/data/utils/extensions.dart';
import 'package:coffee/data/utils/localization.dart';
import 'package:coffee/data/utils/phonecode.dart';
import 'package:coffee/ui/provider/prefsprovider.dart';
import 'package:coffee/ui/widgets/appbar.dart';
import 'package:coffee/ui/widgets/photoavatar.dart';
import 'package:coffee/ui/widgets/platform_button.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 16, left: 16, top: 24,
          ),
          child: provider.name != null ?
          const ProfileView() :
          NewProfile(provider: provider)
        ),
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    return Column(
      children: [
        PlatformAppBar(
          title:  AppLocalizations.of(context, 'profile_title'),
          titleFontSize: 28,
        ),
        const SizedBox(height: 44),
        Expanded(
          child: Column(
            children: [
              ProfilePhoto(
                photo: provider.photo ?? "default",
                size: 150,
                radius: 40,
              ),
              const SizedBox(height: 12),
              Text(
                provider.name!,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(AppLocalizations.of(context, 'profile_delete')),
                      onPressed: () async{
                        await provider.deleteAllData();
                        AppNavigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        primary: HexColor.fromHex(App.appColor),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: App.font
                        )
                      )
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      child: Text(AppLocalizations.of(context, 'profile_edit')),
                      onPressed: () async{
                        AppNavigator.of(context).push(NewProfile(
                          provider: provider,
                        ));
                      },
                      style: TextButton.styleFrom(
                        primary: HexColor.fromHex(App.appColor),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: App.font
                        )
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}


class NewProfile extends StatefulWidget {
  final PreferenceProvider? provider;

  const NewProfile({Key? key, this.provider}) : super(key: key);

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  //final _webController = TextEditingController();

  final double imageSize = 80;
  final ImagePicker _picker = ImagePicker();

  Uint8List? _image;
  int _index = 0;

  late String _defaultCode;

  PreferenceProvider get prefsProvider => widget.provider!;

  bool get userExists => prefsProvider.name != null;

  @override
  void initState() {
    if(userExists){
      _nameController.text = prefsProvider.name!;
      _phoneController.text = prefsProvider.phoneNum!;
    }
    if(prefsProvider.photo != null){
      _image = imageBytes(prefsProvider.photo!);
    }
    setState(() {
      _defaultCode = PhoneCodes.countryCodes.firstWhere((element) => element == "BY");
      _index = PhoneCodes.countryCodes.indexOf(_defaultCode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(userExists) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 16, left: 16, top: 24,
            ),
            child: buildView
          ),
        ),
      );
    }
    return buildView;
  }

  Widget get buildView{
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            PlatformAppBar(
              title: !userExists ?
              AppLocalizations.of(context, 'profile_new_title') :
              AppLocalizations.of(context, 'profile_edit'),
              titleFontSize: 28,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                GestureDetector(
                  onTap: () async{
                    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null){
                      File? croppedFile = await ImageCropper().cropImage(
                          sourcePath: pickedImage.path,
                          aspectRatioPresets: [
                            CropAspectRatioPreset.square,
                          ],
                          androidUiSettings: const AndroidUiSettings(
                            toolbarTitle: 'Cropper',
                            toolbarColor: Colors.deepOrange,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false
                          ),
                          iosUiSettings: const IOSUiSettings(
                            minimumAspectRatio: 1.0,
                          )
                        );
                        if(croppedFile != null){
                          setState(() {
                            _image = croppedFile.readAsBytesSync();
                          });
                        }
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: (_image != null) ? Image.memory(
                        _image!,
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.cover,
                      ) : Image.asset(
                        "assets/images/def.png",
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    )
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: accent(context),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          textAlign: TextAlign.start,
                          autofocus: false,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: accent(context)
                          ),
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context, 'profile_name'),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              //showCountriesDialog(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: accent(context),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _defaultCode,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: accent(context),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: accent(context),
                                    size: 28,
                                  ),
                                ],
                              )
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: accent(context),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '+',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: accent(context),
                                    ),
                                  ),
                                  Text(
                                    PhoneCodes.countryPhones[_index],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: accent(context),
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textAlign: TextAlign.start,
                                      autofocus: false,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: accent(context)
                                      ),
                                      controller: _phoneController,
                                      decoration: const InputDecoration(
                                        hintText: "__ ___ __ __",
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: PlatformButton(
                text: !userExists ?
                AppLocalizations.of(context, 'profile_create') :
                AppLocalizations.of(context, 'profile_save'),
                onPressed: (){
                  final name = _nameController.text.trim();
                  final phone = _phoneController.text.trim();
                  if(name.isNotEmpty && name.length > 1){
                    if(phone.isNotEmpty && phone.length == 9){
                      prefsProvider
                        ..savePreference('name', name)
                        ..savePreference('phoneNum', phone)
                        ..savePreference('phoneCode', _defaultCode);
                      if(_image != null){
                        prefsProvider.savePreference('photo', base64Encode(_image!));
                      }
                      AppNavigator.of(context).pop();
                    }
                    else{
                      debugPrint("CHECK PHONE NUMBER");
                    }
                  }
                  else{
                    debugPrint("CHECK NAME..MUST BE MORE THAN 1 SYMBOL");
                  }
                }
              ),
            )
          ],
        ),
      ),
    );
  }

  showCountriesDialog(context){
    showDialog(
      context: context,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).brightness == Brightness.light ?
            Colors.white : App.colorDark
          ),
          child: ListView.builder(
            itemCount: PhoneCodes.countryPhones.length,
            shrinkWrap: true,
            itemBuilder: (context, id){
              final smallCode = PhoneCodes.countryCodes[id];
              final code = PhoneCodes.countryPhones[id];
              final country = PhoneCodes.countryNames[id];
              return GestureDetector(
                onTap: (){
                  setState(() {
                    _index = PhoneCodes.countryCodes.indexOf(smallCode);
                    _defaultCode = smallCode;
                  });
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 4
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Theme.of(context).brightness == Brightness.light ?
                        Colors.black : Colors.white,
                      )
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "+$code",
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).brightness == Brightness.light ?
                            Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text(
                          country,
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).brightness == Brightness.light ?
                            Colors.black : Colors.white,
                          ),
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

