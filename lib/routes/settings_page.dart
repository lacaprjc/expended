import 'dart:io';
import 'package:expended/bloc/bloc.dart';
import 'package:expended/misc/formatter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:expended/database/db.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sembast/sembast.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final PermissionHandler _permissionHandler = PermissionHandler();

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

  void requestBackup(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              textColor: AppColors.seance,
              child: Text('Save to Downloads folders'),
              onPressed: () {
                Navigator.pop(context);
                backupAccounts();
              },
            ),
            FlatButton(
              textColor: AppColors.seance,
              child: Text('Export'),
              onPressed: () {
                Navigator.pop(context);
                exportAccounts();
              },
            ),
          ],
        ),
      ),
    );
  }

  void exportAccounts() async {
    Database db = await AppDatabase.instance.database;
    File dbFile = File.fromUri(Uri(path: db.path));

    await WcFlutterShare.share(
      sharePopupTitle: 'Make sure to save this to Google Drive',
      mimeType: 'application/octet-stream',
      fileName: 'Expended_${Formatter.dateFormat.format(DateTime.now())}.db',
      bytesOfFile: await dbFile.readAsBytes(),
    );
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
        .then((_) =>
            Fluttertoast.showToast(msg: 'Backed up to downloads folder'));
  }

  void restoreAccounts() async {
    if (!await requestPermission()) {
      Fluttertoast.showToast(msg: 'Permission not granted');
      _permissionHandler.openAppSettings();
      return;
    }

    File newDBFile = await FilePicker.getFile(type: FileType.ANY);
    if (newDBFile == null) {
      return;
    }

    if (newDBFile.path.substring(newDBFile.path.length - 3) != '.db') {
      await Fluttertoast.showToast(msg: 'Invalid database file');
      return;
    }

    Fluttertoast.showToast(
        msg: 'Attempting to restore accounts. Please wait...');

    Database currentDB = await AppDatabase.instance.database;

    await currentDB.close();

    final String oldDBPath = currentDB.path;
    await File.fromUri(Uri(path: currentDB.path))
        .rename(currentDB.path + '.backup');

    await newDBFile.copy(oldDBPath);

    await AppDatabase.instance.reopenDatabase();

    Fluttertoast.showToast(msg: 'Restored accounts');
    BlocProvider.of<AccountBloc>(this.context).dispatch(LoadAllAccounts());
  }

  Widget _buildBackupSettings(BuildContext context) {
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
              onPressed: () => requestBackup(context),
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

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            children: <Widget>[
              _buildBackupSettings(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: CustomBottomNavigationBar(
        'settings',
        title: 'Settings',
      ),
    );
  }
}
