import 'dart:math';
import 'package:dosador_concreto/my_classes.dart';
import 'package:dosador_concreto/pag_mixcreate.dart';

class AbramsPoint {
  final double ac;
  final double fcm;

  AbramsPoint({required this.ac, required this.fcm});

  @override
  String toString() => 'AbramsPoint(ac: $ac, fcm: $fcm)';
}

class AbramsFit {
  final double k1;
  final double k2;

  AbramsFit({required this.k1, required this.k2});

  double fcm(double ac) {
    return k1 / pow(k2, ac);
  }

  @override
  String toString() => 'k1 = $k1\nk2 = $k2';
}

AbramsFit fitAbrams(List<AbramsPoint> data) {
  if (data.length < 2) {
    throw ArgumentError('São necessários pelo menos dois pontos.');
  }

  final acs = data.map((p) => p.ac).toSet();

  if (acs.length < 2) {
    throw ArgumentError(
      'São necessários pelo menos dois valores distintos de a/c.',
    );
  }

  final n = data.length;

  double sumX = 0;
  double sumY = 0;
  double sumXX = 0;
  double sumXY = 0;

  for (final p in data) {
    if (p.fcm <= 0) {
      throw ArgumentError('Todos os valores de fcm devem ser positivos.');
    }

    final x = p.ac;
    final y = log(p.fcm);

    sumX += x;
    sumY += y;
    sumXX += x * x;
    sumXY += x * y;
  }

  final slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);

  final intercept = (sumY - slope * sumX) / n;

  final k1 = exp(intercept);
  final k2 = exp(-slope);

  return AbramsFit(k1: k1, k2: k2);
}

List<AbramsPoint> abramsList(List<Data> data) {
  List<AbramsPoint> myAbramsList = [];

  for (Data d in data) {
    myAbramsList.add(AbramsPoint(ac: d.mix.ac, fcm: d.res));
  }
  return myAbramsList;
}

class LysePoint {
  final double ac;
  final double m;

  LysePoint({required this.ac, required this.m});
}

class LyseFit {
  final double k3;
  final double k4;

  LyseFit({required this.k3, required this.k4});

  double m(double ac) {
    return k3 + k4 * ac;
  }

  @override
  String toString() => 'k3 = $k3\nk4 = $k4';
}

LyseFit fitLyse(List<LysePoint> data) {
  if (data.length < 2) {
    throw ArgumentError('São necessários pelo menos dois pontos.');
  }

  final n = data.length;

  double sumX = 0;
  double sumY = 0;
  double sumXX = 0;
  double sumXY = 0;

  for (final p in data) {
    sumX += p.ac;
    sumY += p.m;
    sumXX += p.ac * p.ac;
    sumXY += p.ac * p.m;
  }

  final denominator = n * sumXX - sumX * sumX;

  if (denominator == 0) {
    throw ArgumentError('Os valores de a/c não podem ser todos iguais.');
  }

  final k4 = (n * sumXY - sumX * sumY) / denominator;

  final k3 = (sumY - k4 * sumX) / n;

  return LyseFit(k3: k3, k4: k4);
}

List<LysePoint> lyseList(List<Data> data) {
  List<LysePoint> myLyseList = [];

  for (Data d in data) {
    myLyseList.add(LysePoint(ac: d.mix.ac, m: d.mix.m));
  }
  return myLyseList;
}

Mix calcMix(
  double fck,
  Conditions con,
  double k1,
  double k2,
  double k3,
  double k4,
  double arg,
) {
  double fcm = switch (con) {
    Conditions.alto => fck + (1.65 * 3),
    Conditions.medio => fck + (1.65 * 4),
    Conditions.baixo => fck + (1.65 * 5.5),
  };

  double ac = log(k1 / fcm) / log(k2);
  double m = k3 + (k4 * ac);
  double a = (arg * (1 + m)) - 1;
  double p = m - a;

  return Mix(a: a, p: p, ac: ac);
}
