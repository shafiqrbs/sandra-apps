import 'package:sandra/app/core/core_model/logged_user.dart';
import 'package:sandra/app/core/importer.dart';

bool get isManager => LoggedUser().roles?.contains('ROLE_MANAGER') ?? false;

bool get isRoleSetting => LoggedUser().roles?.contains('ROLE_SETTING') ?? false;

bool get isRolePurchase =>
    LoggedUser().roles?.contains('ROLE_PURCHASE') ?? false;

bool get isRoleSales => LoggedUser().roles?.contains('ROLE_SALES') ?? false;

bool get isRoleExpense => LoggedUser().roles?.contains('ROLE_EXPENSE') ?? false;

bool get isRoleStock => LoggedUser().roles?.contains('ROLE_STOCK') ?? false;

bool get isRoleAccountReceive =>
    LoggedUser().roles?.contains('ROLE_ACCOUNT_RECEIVE') ?? false;

bool get isRoleAccountPayment =>
    LoggedUser().roles?.contains('ROLE_ACCOUNT_PAYMENT') ?? false;

DbHelper get db => DbHelper.instance;

DbTables get dbTables => DbTables();

SessionManager get prefs => SessionManager();

Services get services => Services.instance;
