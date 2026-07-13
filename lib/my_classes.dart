import 'package:hive_ce/hive.dart';

part 'my_classes.g.dart';

@HiveType(typeId: 0)
class Mix {
  Mix({required this.a, required this.p, required this.ac});

  @HiveField(0)
  double a;

  @HiveField(1)
  double p;

  @HiveField(2)
  double ac;

  double get m => a + p;

  double get aAr => double.parse(a.toStringAsFixed(2));
  double get pAr => double.parse(p.toStringAsFixed(2));
  double get acAr => double.parse(ac.toStringAsFixed(2));
  double get mAr => double.parse(m.toStringAsFixed(2));

  String get aStrg => aAr.toString().replaceAll('.', ',');
  String get pStrg => pAr.toString().replaceAll('.', ',');
  String get acStrg => acAr.toString().replaceAll('.', ',');
  String get mStrg => mAr.toString().replaceAll('.', ',');

  @override
  String toString() {
    return '1:$aStrg:$pStrg  |  a/c: $acStrg';
  }
}

@HiveType(typeId: 1)
class Cim {
  Cim({required this.marca, required this.resc, required this.tipo});

  @HiveField(0)
  String marca;

  @HiveField(1)
  String resc;

  @HiveField(2)
  String tipo;

  String get cimStrg => 'Cimento $marca $tipo $resc';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cim &&
          marca == other.marca &&
          resc == other.resc &&
          tipo == other.tipo;

  @override
  int get hashCode => Object.hash(marca, resc, tipo);
}

@HiveType(typeId: 2)
class Mixs {
  Mixs({
    required this.id,
    required this.nom,
    required this.cim,
    required this.res,
    required this.arg,
    required this.abt,
    required this.mix,
  });

  @HiveField(0)
  String? nom;

  @HiveField(1)
  Cim? cim;

  @HiveField(2)
  double? res;

  @HiveField(3)
  double arg;

  @HiveField(4)
  int? abt;

  @HiveField(5)
  Mix? mix;

  @HiveField(6)
  final String id;

  double get argAr => double.parse((arg * 100).toStringAsFixed(2));
  String get argStr => argAr.toString().replaceAll('.', ',');
}

@HiveType(typeId: 3)
class Data {
  Data({
    required this.id,
    required this.nom,
    required this.cim,
    required this.res,
    required this.abt,
    required this.mix,
    required this.ativo,
  });

  @HiveField(0)
  String? nom;

  @HiveField(1)
  Cim? cim;

  @HiveField(2)
  double res;

  @HiveField(3)
  int? abt;

  @HiveField(4)
  Mix mix;

  @HiveField(5)
  bool ativo;

  @HiveField(6)
  final String id;

  double get arg => (1 + mix.a) / (1 + mix.a + mix.p);
  double get argAr => double.parse((arg).toStringAsFixed(2));
  String get argArStr => (argAr * 100).toStringAsFixed(0).replaceAll('.', ',');

  @override
  String toString() {
    return '$nom';
  }
}

@HiveType(typeId: 4)
class Unit {
  Unit({required this.un, required this.fac});

  @HiveField(0)
  String un;

  @HiveField(1)
  double fac;

  @override
  String toString() {
    return '($un, $fac)';
  }
}

@HiveType(typeId: 5)
class Units {
  Units({
    required this.unc,
    required this.una,
    required this.unp,
    required this.unac,
  });

  @HiveField(0)
  Unit unc;

  @HiveField(1)
  Unit una;

  @HiveField(2)
  Unit unp;

  @HiveField(3)
  Unit unac;

  List<Unit> get uList => [unc, una, unp, unac];

  @override
  String toString() {
    return '$unc, $una, $unp, $unac';
  }
}
