import 'package:dosador_concreto/my_classes.dart';

List<String> marcasList = [
  'Votoran',
  'Itaú',
  'Poty',
  'Tocantins',
  'CSN',
  'Holcim',
  'InterCement',
  'Nacional',
  'Itambé',
  'Tupi',
  'Mizu',
];

List<String> siglaList = [
  'CP I',
  'CP I-S',
  'CP II-E',
  'CP II-F',
  'CP II-Z',
  'CP III',
  'CP IV',
  'CP V',
  'CPB',
];

List<String> classeList = ['25', '32', '40', 'ARI'];

enum Unidades { massa, custom }

List<String?> mySettings = ['azul', 'light'];

Units customUnits = Units(
  unc: Unit(un: 'sac', fac: 50),
  una: Unit(un: 'car', fac: 80),
  unp: Unit(un: 'car', fac: 80),
  unac: Unit(un: 'bal', fac: 18),
);
