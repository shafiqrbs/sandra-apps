class Expense {
  final String? id;
  final String? invoice;
  final String? remark;
  final String? amount;
  final String? categoryId;
  final String? category;
  final String? accountHeadId;
  final String? accountHead;
  final String? createdById;
  final String? touser;
  final String? createdBy;
  final String? approvedBy;
  final String? created;

  Expense({
    this.id,
    this.invoice,
    this.remark,
    this.amount,
    this.categoryId,
    this.category,
    this.accountHeadId,
    this.accountHead,
    this.createdById,
    this.touser,
    this.createdBy,
    this.approvedBy,
    this.created,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      invoice: json['invoice'] as String?,
      remark: json['remark'] as String?,
      amount: json['amount'] as String?,
      categoryId: json['category_id'] as String?,
      category: json['category'] as String?,
      accountHeadId: json['account_head_id'] as String?,
      accountHead: json['account_head'] as String?,
      createdById: json['creatdBy_id'] as String?,
      touser: json['touser'] as String?,
      createdBy: json['created_by'] as String?,
      approvedBy: json['approved_by'] as String?,
      created: json['created'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice': invoice,
      'remark': remark,
      'amount': amount,
      'category_id': categoryId,
      'category': category,
      'account_head_id': accountHeadId,
      'account_head': accountHead,
      'creatdBy_id': createdById,
      'touser': touser,
      'created_by': createdBy,
      'approved_by': approvedBy,
      'created': created,
    };
  }
}
