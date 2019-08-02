import 'dart:io';
import 'package:expended/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:expended/database/db.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final PermissionHandler _permissionHandler = PermissionHandler();

  static const String APK_URL =
      'https://drive.google.com/drive/folders/1NX00j8iN3RCLcLdQBbQjVwVNWKSH3Mso?usp=sharing';

  Future<bool> requestPermission() async {
    PermissionStatus status =
        await _permissionHandler.checkPermissionStatus(PermissionGroup.storage);
    if (status == PermissionStatus.unknown) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await _permissionHandler
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return false;
      } else {
        return true;
      }
    }

    return status == PermissionStatus.granted;
  }

  void backupAccounts() async {
    if (!await requestPermission()) {
      Fluttertoast.showToast(msg: 'Please allow for storage permission.');
      await _permissionHandler.requestPermissions([PermissionGroup.storage]);
      return;
    }

    final Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;

    await AppDatabase.instance
        .backupDatabaseToFolder(downloadsDirectory.path)
        .then((_) => Fluttertoast.showToast(
            msg: 'Backed up accounts.db to downloads folder'));
  }

  void restoreAccounts() async {
    if (!await requestPermission()) {
      Fluttertoast.showToast(msg: 'Permission not granted');
      _permissionHandler.openAppSettings();
      return;
    }

    final Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;

    final String accountsDBPath = join(downloadsDirectory.path, 'accounts.db');
    File accountsDBFile = File.fromUri(Uri(path: accountsDBPath));

    if (!await accountsDBFile.exists()) {
      Fluttertoast.showToast(
          msg: 'accounts.db does not exist in the downloads folder.');
      return;
    }

    Fluttertoast.showToast(
        msg: 'Attempting to restore accounts. Please wait...');

    Database currentDB = await AppDatabase.instance.database;

    await currentDB.close();

    final String oldDBPath = currentDB.path;
    await File.fromUri(Uri(path: currentDB.path))
        .rename(currentDB.path + '.backup');

    await accountsDBFile.copy(oldDBPath);

    await AppDatabase.instance.reopenDatabase();

    Fluttertoast.showToast(msg: 'Restored accounts');
    BlocProvider.of<AccountBloc>(this.context).dispatch(LoadAllAccounts());
  }

  void openAPKFolder() async {
    if (await canLaunch(APK_URL)) {
      await launch(APK_URL);
    } else {
      Fluttertoast.showToast(msg: 'Could not open the link');
    }
  }

  Widget _buildBackupSettings() {
    return Container(
      child: ListTile(
        leading: Icon(
          MaterialCommunityIcons.backup_restore,
          color: AppColors.seance,
        ),
        title: Container(
          padding: EdgeInsets.only(top: 14),
          child: Text(
            'Backup',
            style: TextStyle(
              color: AppColors.seance,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
              textColor: AppColors.seance,
              child: Text('Backup Accounts'),
              onPressed: backupAccounts,
            ),
            FlatButton(
              textColor: AppColors.seance,
              child: Text('Restore Accounts'),
              onPressed: restoreAccounts,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateSettings() {
    return Container(
      child: ListTile(
        leading: Icon(
          MaterialCommunityIcons.upload_outline,
          color: AppColors.seance,
        ),
        title: Container(
          child: Text(
            'Update',
            style:
                TextStyle(color: AppColors.seance, fontWeight: FontWeight.w600),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
              textColor: AppColors.seance,
              child: Text('Open download links'),
              onPressed: openAPKFolder,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            children: <Widget>[
              _buildBackupSettings(),
              _buildUpdateSettings(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        'settings',
        title: 'Settings',
      ),
    );
  }
}
