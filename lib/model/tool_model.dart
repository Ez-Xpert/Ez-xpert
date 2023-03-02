class ToolModel {
  String? id;
  String? name;
  String? description;
  String? notes;
  String? status;

  ToolModel({
    this.description,
    this.id,
    this.name,
    this.notes,
    this.status,
  });

  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
      description: json['description'].toString(),
      id: json['id'].toString(),
      name: json['name'].toString(),
      notes: json['notes'].toString(),
      status: json['status'].toString(),
    );
  }
}
