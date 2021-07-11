import 'dart:math';

import 'package:explorer/models/block.dart';
import 'package:flutter/material.dart';

import '../../client.dart';

class BlocksList extends StatefulWidget {
  BlocksList({Key? key}) : super(key: key);

  @override
  _BlocksListState createState() => _BlocksListState();
}

class _BlocksListState extends State<BlocksList> {
  List<Block> blocks = [];
  late int start;

  void _getNowBlock() {
    client.getNowBlock(context, (_nowBlockResponse) {
      if (_nowBlockResponse.block != null) {
        int newStart = max(_nowBlockResponse.block!.header.number - 9, 1);
        setState(() {
          start = newStart;
        });
        _getBlocks(context);
      }
    });
  }

  void _getBlocks(BuildContext context) {
    print('Getting blocks since $start');
    client.getBlocks(context, start, (_blocksListResponse) {
      setState(() {
        blocks = _blocksListResponse.blocks;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getNowBlock();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
          Row(
            children: <Widget>[
              TextButton(
                  child: Text("Previous"),
                  onPressed: () {
                    setState(() {
                      start -= min(10, start - 1);
                    });
                    _getBlocks(context);
                  }),
              if (blocks.length == 10)
                TextButton(
                    child: Text("Next"),
                    onPressed: () {
                      setState(() {
                        start += 10;
                      });
                      _getBlocks(context);
                    })
            ],
          ),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: blocks.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                          onTap: () => {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return BlockDetail(block: blocks[index]);
                                }))
                          },
                          leading: Text(blocks[index].header.number.toString()),
                          title: Text(blocks[index].id),
                        ));
                  }))
        ]));
  }
}

class BlockDetail extends StatefulWidget {
  final Block block;

  BlockDetail({Key? key, required this.block}) : super(key: key);

  @override
  _BlockDetailState createState() => _BlockDetailState();
}

class _BlockDetailState extends State<BlockDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Text("Block ID", style: TextStyle(color: Colors.grey)),
              Text(this.widget.block.id),
              Text("Timestamp", style: TextStyle(color: Colors.grey)),
              Text(this.widget.block.header.timestamp.toString()),
              Text("Transactions", style: TextStyle(color: Colors.grey)),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: this.widget.block.transactions.length,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                              onTap: () => {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return TransactionDetail(
                                          transaction:
                                          this.widget.block.transactions[index]);
                                    }))
                              },
                              title: Text(this.widget.block.transactions[index].id),
                            ));
                      }))
            ],
          ),
        ));
  }
}

class TransactionDetail extends StatefulWidget {
  final Transaction transaction;

  TransactionDetail({Key? key, required this.transaction}) : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Text("Transaction ID", style: TextStyle(color: Colors.grey)),
              Text(this.widget.transaction.id),
              Text("Contract entries", style: TextStyle(color: Colors.grey)),
              Expanded(
                  child: ListView.builder(
                      itemCount: this.widget.transaction.contract.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Text("From: " +
                              widget.transaction.contract[index].ownerAddress +
                              "\n" +
                              "To: " +
                              widget.transaction.contract[index].toAddress +
                              "\n" +
                              "Amount: " +
                              widget.transaction.contract[index].amount.toString()),
                        );
                      }))
            ],
          ),
        ));
  }
}
