import 'package:faker/faker.dart' as fakers;
import 'package:number_to_character/number_to_character.dart';
import 'package:sandra/app/core/importer.dart';

import '/app/entity/purchase.dart';
import '/app/entity/sales.dart';

final converter = NumberToCharacterConverter('en');

Future<void> clearSalesTable() async {
  await db.deleteAll(tbl: dbTables.tableSale);
}

Future<void> clearSPurchaseTable() async {
  await db.deleteAll(tbl: dbTables.tablePurchase);
}

Sales generateRandomSales({
  required int? isHold,
}) {
  final faker = fakers.Faker();
  return Sales(
    salesId: faker.guid.guid(),
    deviceSalesId: faker.randomGenerator.integer(10000),
    invoice: faker.randomGenerator.integer(10000).toString(),
    createdAt: '09-08-2024 12:23 PM',
    updatedAt: '09-08-2024 12:23 PM',
    subTotal: faker.randomGenerator.decimal(min: 100, scale: 2),
    discount: faker.randomGenerator.decimal(min: 5, scale: 2),
    discountCalculation: faker.randomGenerator.decimal(min: 1, scale: 2),
    vat: faker.randomGenerator.decimal(min: 1, scale: 2),
    sd: faker.randomGenerator.decimal(min: 1, scale: 2),
    netTotal: faker.randomGenerator.decimal(min: 100, scale: 2),
    purchasePrice: faker.randomGenerator.decimal(min: 50, scale: 2),
    received: faker.randomGenerator.decimal(min: 50, scale: 2),
    due: faker.randomGenerator.decimal(min: 10, scale: 2),
    deliveryCharge: faker.randomGenerator.integer(50),
    paymentInWord: faker.randomGenerator.decimal(min: 100, scale: 2).toString(),
    process: faker.lorem.word(),
    discountType: faker.lorem.word(),
    revised: faker.randomGenerator.integer(5),
    printWithoutDiscount: faker.randomGenerator.integer(2),
    isHold: isHold,
    createdById: faker.randomGenerator.integer(100),
    createdBy: faker.person.name(),
    salesById: faker.randomGenerator.integer(100),
    salesBy: faker.randomGenerator.string(100),
    approvedById: faker.randomGenerator.integer(100),
    approvedBy: faker.randomGenerator.string(100),
    customerId: faker.randomGenerator.integer(100),
    customerName: faker.randomGenerator.string(100),
    customerMobile: faker.randomGenerator.string(100),
    customerAddress: faker.address.streetAddress(),
    methodId: faker.randomGenerator.integer(10),
    methodName: faker.lorem.word(),
    methodMode: faker.lorem.word(),
    comment: faker.lorem.sentence(),
    tokenNo: faker.guid.guid(),
    couponCode: faker.randomGenerator.integer(1000).toString(),
    salesItem: [],
    // You can generate random SalesItem objects similarly
    isOnline: faker.randomGenerator.integer(2),
  );
}

Purchase generateRandomPurchase({
  required int? isHold,
}) {
  final faker = fakers.Faker();
  return Purchase(
    purchaseId: faker.guid.guid(),
    deviceSalesId: faker.randomGenerator.integer(10000),
    invoice: faker.randomGenerator.integer(10000).toString(),
    createdAt: '09-08-2024 12:23 PM',
    updatedAt: '09-08-2024 12:23 PM',
    subTotal: faker.randomGenerator.decimal(min: 100, scale: 2),
    discount: faker.randomGenerator.decimal(min: 5, scale: 2),
    discountCalculation: faker.randomGenerator.decimal(min: 1, scale: 2),
    netTotal: faker.randomGenerator.decimal(min: 100, scale: 2),
    purchasePrice: faker.randomGenerator.decimal(min: 50, scale: 2),
    received: faker.randomGenerator.decimal(min: 50, scale: 2),
    due: faker.randomGenerator.decimal(min: 10, scale: 2),
    deliveryCharge: faker.randomGenerator.integer(50),
    paymentInWord: faker.randomGenerator.decimal(min: 100, scale: 2).toString(),
    process: faker.lorem.word(),
    revised: faker.randomGenerator.integer(5),
    printWithoutDiscount: faker.randomGenerator.integer(2),
    isHold: isHold,
    createdById: faker.randomGenerator.integer(100),
    createdBy: faker.person.name(),
    salesById: faker.randomGenerator.integer(100),
    salesBy: faker.randomGenerator.string(100),
    approvedById: faker.randomGenerator.integer(100),
    approvedBy: faker.randomGenerator.string(100),
    vendorId: faker.randomGenerator.integer(100),
    vendorName: faker.randomGenerator.string(100),
    vendorMobile: faker.randomGenerator.string(100),
    vendorAddress: faker.address.streetAddress(),
    methodId: faker.randomGenerator.integer(10),
    methodName: faker.lorem.word(),
    methodMode: faker.lorem.word(),
    comment: faker.lorem.sentence(),
    tokenNo: faker.guid.guid(),
    couponCode: faker.randomGenerator.integer(1000).toString(),
    purchaseItem: [],
    // You can generate random SalesItem objects similarly
    isOnline: faker.randomGenerator.integer(2),
  );
}
