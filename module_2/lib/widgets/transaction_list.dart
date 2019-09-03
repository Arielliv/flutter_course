import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function _deleteTransactionHandler;

  TransactionList(this._transactions, this._deleteTransactionHandler);

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(
            builder: (contex, constrains) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constrains.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : ListView(
            children: <Widget>[
              ..._transactions
                  .map((transaction) => TransactionItem(
                        key: ValueKey(transaction.id),
                        transaction: transaction,
                        deleteTransactionHandler: _deleteTransactionHandler,
                      ))
                  .toList()
            ],
          );
  }
}
