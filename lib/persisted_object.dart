class PersistedObject {
  final Map<String, dynamic> _data;
  final String _id;

  PersistedObject(this._id, this._data);

  String getID() {
    return _id;
  }

  Map<String, dynamic> getData() {
    return _data;
  }
}