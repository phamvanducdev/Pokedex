import 'package:pokedex/shared/getit/repository_register.dart';
import 'package:pokedex/shared/getit/storage_register.dart';
import 'package:pokedex/shared/getit/viewmodel_register.dart';

abstract class IGetItRegister {
  void register();
}

class GetItRegister {
  static register() {
    StorageRegister().register();
    RepositoryRegister().register();
    ViewModelRegister().register();
  }
}
