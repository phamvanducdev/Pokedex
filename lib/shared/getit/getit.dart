import 'package:flutter_pokedex/shared/getit/repository_register.dart';
import 'package:flutter_pokedex/shared/getit/viewmodel_register.dart';

abstract class IGetItRegister {
  void register();
}

class GetItRegister {
  static register() {
    RepositoryRegister().register();
    ViewModelRegister().register();
  }
}
