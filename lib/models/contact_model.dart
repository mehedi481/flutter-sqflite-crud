class ContactModel {
  static const tableName = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colMobile = 'mobile';
  int? id;
  String? name;
  String? mobile;
  ContactModel({this.id, this.name, this.mobile});

  ContactModel.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    mobile = map[colMobile];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colName: name,
      colMobile: mobile,
    };
    if (id != null) map[colId] = id;
    return map;
  }
}
