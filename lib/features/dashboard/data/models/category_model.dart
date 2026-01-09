import 'package:equatable/equatable.dart';
import 'transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'category_model.g.dart';

/// Category model for Supabase
@HiveType(typeId: 2)
class CategoryModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String iconName;
  @HiveField(4)
  final String colorHex;
  @HiveField(5)
  final TransactionType type;
  @HiveField(6)
  final bool isDefault;
  @HiveField(7)
  final DateTime createdAt;

  const CategoryModel({
    required this.id,
    this.userId,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.type,
    required this.isDefault,
    required this.createdAt,
  });

  /// Create from Supabase JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      name: json['name'] as String,
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Convert to Supabase JSON (for insert/update)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'icon_name': iconName,
      'color_hex': colorHex,
      'type': type.name,
      'is_default': isDefault,
    };
  }

  /// Copy with new values
  CategoryModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? iconName,
    String? colorHex,
    TransactionType? type,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    iconName,
    colorHex,
    type,
    isDefault,
    createdAt,
  ];
}
