abstract class BlockchainApi {
  Future<Map> last(String address) {
    throw UnimplementedError();
  }

  Future<void> updateLastBlock() {
    throw UnimplementedError();
  }
}
