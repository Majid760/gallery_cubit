class Image {
  String? fileName;
  String? filePath;
  int? isPrimaryPhoto;
  String? fileType;
  int? createdDate;
  int? updatedDate;

  Image(
      {this.fileName,
      this.filePath,
      this.isPrimaryPhoto,
      this.fileType,
      this.createdDate,
      this.updatedDate});

  Image.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    filePath = json['filePath'];
    isPrimaryPhoto = json['isPrimaryPhoto'];
    fileType = json['fileType'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fileName'] = fileName;
    data['filePath'] = filePath;
    data['isPrimaryPhoto'] = isPrimaryPhoto;
    data['fileType'] = fileType;
    data['createdDate'] = createdDate;
    data['updatedDate'] = updatedDate;
    return data;
  }
}
