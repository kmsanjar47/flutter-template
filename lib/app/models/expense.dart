class Expense {
  String? id;
  String? actionType;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? userId;
  String? userName;
  String? referenceId;
  String? address;
  String? documentName;
  String? expenseDate;
  String? vendor;
  String? paymentMethod;
  String? status;
  String? totalBill;
  String? totalVat;
  int? currency;
  int? company;
  String? card;
  String? comment;
  String? description;
  int? typeOfCost;


  Expense(
      {this.id,
        this.actionType,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        this.userId,
        this.address,
        this.documentName,
        this.expenseDate,
        this.vendor,
        this.paymentMethod,
        this.status,
        this.totalBill,
        this.totalVat,
        this.currency,
        this.company,
        this.card,
        this.comment,
        this.description,
        this.typeOfCost});

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actionType = json['action_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    userId = json['user_id'];
    userName = json['user_name'];
    referenceId = json['reference_id'];
    address = json['address'];
    documentName = json['document_name'];
    expenseDate = json['expense_date'];
    vendor = json['vendor'];
    paymentMethod = json['payment_method'];
    status = json['status'];
    totalBill = json['total_bill'];
    totalVat = json['total_vat'];
    currency = json['currency'];
    company = json['company'];
    comment = json['comment'];
    card = json['card'];
    description = json['description'];
    typeOfCost = json['type_of_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['action_type'] = actionType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['reference_id'] = referenceId;
    data['address'] = address;
    data['document_name'] = documentName;
    data['expense_date'] = expenseDate;
    data['vendor'] = vendor;
    data['payment_method'] = paymentMethod;
    data['status'] = status;
    data['total_bill'] = totalBill;
    data['total_vat'] = totalVat;
    data['currency'] = currency;
    data['company'] = company;
    data['card'] = card;
    data['comment'] = comment;
    data['description'] = description;
    data['type_of_cost'] = typeOfCost;
    return data;
  }
}
