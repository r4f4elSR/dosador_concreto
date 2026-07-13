// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_classes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MixAdapter extends TypeAdapter<Mix> {
  @override
  final typeId = 0;

  @override
  Mix read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mix(
      a: (fields[0] as num).toDouble(),
      p: (fields[1] as num).toDouble(),
      ac: (fields[2] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Mix obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.a)
      ..writeByte(1)
      ..write(obj.p)
      ..writeByte(2)
      ..write(obj.ac);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CimAdapter extends TypeAdapter<Cim> {
  @override
  final typeId = 1;

  @override
  Cim read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cim(
      marca: fields[0] as String,
      resc: fields[1] as String,
      tipo: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Cim obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.marca)
      ..writeByte(1)
      ..write(obj.resc)
      ..writeByte(2)
      ..write(obj.tipo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CimAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MixsAdapter extends TypeAdapter<Mixs> {
  @override
  final typeId = 2;

  @override
  Mixs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mixs(
      id: fields[6] as String,
      nom: fields[0] as String?,
      cim: fields[1] as Cim?,
      res: (fields[2] as num?)?.toDouble(),
      arg: (fields[3] as num).toDouble(),
      abt: (fields[4] as num?)?.toInt(),
      mix: fields[5] as Mix?,
    );
  }

  @override
  void write(BinaryWriter writer, Mixs obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nom)
      ..writeByte(1)
      ..write(obj.cim)
      ..writeByte(2)
      ..write(obj.res)
      ..writeByte(3)
      ..write(obj.arg)
      ..writeByte(4)
      ..write(obj.abt)
      ..writeByte(5)
      ..write(obj.mix)
      ..writeByte(6)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MixsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataAdapter extends TypeAdapter<Data> {
  @override
  final typeId = 3;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      id: fields[6] as String,
      nom: fields[0] as String?,
      cim: fields[1] as Cim?,
      res: (fields[2] as num).toDouble(),
      abt: (fields[3] as num?)?.toInt(),
      mix: fields[4] as Mix,
      ativo: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nom)
      ..writeByte(1)
      ..write(obj.cim)
      ..writeByte(2)
      ..write(obj.res)
      ..writeByte(3)
      ..write(obj.abt)
      ..writeByte(4)
      ..write(obj.mix)
      ..writeByte(5)
      ..write(obj.ativo)
      ..writeByte(6)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UnitAdapter extends TypeAdapter<Unit> {
  @override
  final typeId = 4;

  @override
  Unit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Unit(un: fields[0] as String, fac: (fields[1] as num).toDouble());
  }

  @override
  void write(BinaryWriter writer, Unit obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.un)
      ..writeByte(1)
      ..write(obj.fac);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UnitsAdapter extends TypeAdapter<Units> {
  @override
  final typeId = 5;

  @override
  Units read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Units(
      unc: fields[0] as Unit,
      una: fields[1] as Unit,
      unp: fields[2] as Unit,
      unac: fields[3] as Unit,
    );
  }

  @override
  void write(BinaryWriter writer, Units obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.unc)
      ..writeByte(1)
      ..write(obj.una)
      ..writeByte(2)
      ..write(obj.unp)
      ..writeByte(3)
      ..write(obj.unac);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
