class Invoice {
  num? id;
  num? invoiceNumber;
  String? invoiceDate;
  num? clientId;
  num? invoiceType;
  String? invoiceValue;
  String? invoiceReward;
  String? invoiceDiscount;

  Invoice({
    this.id,
    this.invoiceNumber,
    this.invoiceDate,
    this.clientId,
    this.invoiceType,
    this.invoiceValue,
    this.invoiceReward,
    this.invoiceDiscount,
  });
}
