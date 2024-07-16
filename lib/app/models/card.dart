class Card {
  Card({
    this.id,
    this.cardType,
    this.actionType,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.userId,
    this.name,
    this.number1,
    this.number2,
    this.expiryMonth,
    this.expiryYear,
    this.limit,
  });

  final String? id;
  final int? cardType;
  final String? actionType;
  final DateTime? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final String? userId;
  final String? name;
  final String? number1;
  final String? number2;
  final String? expiryMonth;
  final String? expiryYear;
  final String? limit;



  Card copyWith({
    String? id,
    int? cardType,
    String? actionType,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    String? userId,
    String? name,
    String? number1,
    String? number2,
    String? expiryMonth,
    String? expiryYear,
    String? limit,
  }) {
    return Card(
      id: id??this.id,
      cardType: cardType??this.cardType,
      actionType: actionType ?? this.actionType,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      number1: number1 ?? this.number1,
      number2: number2 ?? this.number2,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      limit: limit ?? this.limit,
    );
  }

  factory Card.fromJson(Map<String, dynamic> json){
    return Card(
      id: json["id"],
      cardType: json["card_type"],
      actionType: json["action_type"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      userId: json["user_id"],
      name: json["name"],
      number1: json["number1"],
      number2: json["number2"],
      expiryMonth: json["expiry_month"],
      expiryYear: json["expiry_year"],
      limit: json["limit"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "card_type": cardType,
    "action_type": actionType,
    "updated_at": updatedAt?.toIso8601String(),
    "created_by": createdBy,
    "updated_by": updatedBy,
    "user_id": userId,
    "name": name,
    "number1": number1,
    "number2": number2,
    "expiry_month": expiryMonth,
    "expiry_year": expiryYear,
    "limit": limit,
  };

  @override
  String toString(){
    return "$id, $actionType, $updatedAt, $createdBy, $updatedBy, $userId, $name, $number1, $number2, $expiryMonth, $expiryYear, $limit, ";
  }

}

/*
{
	"action_type": "string",
	"updated_at": "2024-02-19T09:12:51.119Z",
	"created_by": "string",
	"updated_by": "string",
	"user_id": "string",
	"name": "string",
	"number1": "stri",
	"number2": "stri",
	"expiry_month": "st",
	"expiry_year": "stri",
	"limit": "string"
}*/