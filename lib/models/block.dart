class Block {
  late String id;
  late BlockHeader header;
  List<Transaction> transactions = [];

  Block.fromJson(blockData) {
    List<Transaction> _transactions = [];
    blockData['transactions']?.map((transactionData) {
          return Transaction.fromJson(transactionData);
        })
        .cast<Transaction>()
        .forEach((Transaction t) => _transactions.add(t));
    this.id = blockData['blockID'];
    this.transactions = _transactions;
    this.header = BlockHeader.fromJson(blockData['block_header']);
  }
}

class BlockHeader {
  late int number;
  late String witnessAddress;
  late String witnessSignature;
  late String txTrieRoot;
  late String parentHash;
  late int version;
  late DateTime timestamp;

  BlockHeader.fromJson(blockHeaderData) {
    this.number = blockHeaderData["raw_data"]["number"];
    this.witnessAddress = blockHeaderData["raw_data"]["witness_address"];
    this.txTrieRoot = blockHeaderData["raw_data"]["txTrieRoot"];
    this.parentHash = blockHeaderData["raw_data"]["parentHash"];
    this.version = blockHeaderData["raw_data"]["version"];
    this.timestamp = new DateTime.fromMillisecondsSinceEpoch(
        blockHeaderData["raw_data"]["timestamp"]);
    this.witnessSignature = blockHeaderData["witness_signature"];
  }
}

class Transaction {
  late String id;
  late String rawDataHex;
  late DateTime timestamp;
  List<String> signature = [];
  late List<ContractEntry> contract;

  Transaction.fromJson(transactionData) {
    this.id = transactionData["txID"];
    this.timestamp = new DateTime.fromMicrosecondsSinceEpoch(
        transactionData["raw_data"]["timestamp"]);
    this.rawDataHex = transactionData['raw_data_hex'];
    List<ContractEntry> _contract = [];
    for (int i = 0; i < transactionData['signature'].length; ++i) {
      signature.add(transactionData['signature'][i]);
    }
    transactionData['raw_data']['contract']
        .map((contractEntryData) {
          return ContractEntry.fromJson(contractEntryData);
        })
        .cast<ContractEntry>()
        .forEach((ContractEntry ce) => _contract.add(ce));
    this.contract = _contract;
  }
}

class ContractEntry {
  late String type;
  late String typeUrl;
  late int amount;
  late String ownerAddress;
  late String toAddress;

  ContractEntry.fromJson(contractEntryData) {
    this.type = contractEntryData['type'];
    this.typeUrl = contractEntryData['parameter']['type_url'];
    this.amount = contractEntryData['parameter']['value']['amount'];
    this.ownerAddress =
        contractEntryData['parameter']['value']['owner_address'];
    this.toAddress = contractEntryData['parameter']['value']['to_address'];
  }
}
