class Transaction {
  final int id;
  final DateTime date;
  final String giver;
  final double amountSR;
  final String typeSR; // "Debit" or "Credit"
  final String receiver;
  final double amountPKR;
  final String typePKR; // "Debit" or "Credit"
  final String remarks;
  final String userName;

  Transaction({
    required this.id,
    required this.date,
    required this.giver,
    required this.amountSR,
    required this.typeSR,
    required this.receiver,
    required this.amountPKR,
    required this.typePKR,
    required this.remarks,
    required this.userName,
  });
}
