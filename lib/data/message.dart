class Message {
  String msg, uid, timeStamp;
  bool isMe, _isDelivered = false;
  bool get isDelivered => _isDelivered;
  set isDelivered(bool status) {
    this._isDelivered = status;
  }

  Message(
      {this.msg = '', this.uid = '', this.isMe = true, this.timeStamp = ''});
}
