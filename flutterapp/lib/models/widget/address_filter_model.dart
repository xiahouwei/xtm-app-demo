class AddressFilterModel {
  /// 发货地址
  String sendAddress;
  int sendCode;

  /// 收货地址
  String receiveAddress;
  int receiveCode;

  AddressFilterModel({
    this.sendAddress,
    this.sendCode,
    this.receiveAddress,
    this.receiveCode,
  });
}
