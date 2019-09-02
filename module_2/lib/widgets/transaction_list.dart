import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transaction;

  TransactionList(this._transaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: _transaction.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        )),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '\$${_transaction[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              _transaction[index].title,
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                          Text(
                            DateFormat.yMMMd().format(_transaction[index].date),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: _transaction.length,
            ),
    );
  }
}
