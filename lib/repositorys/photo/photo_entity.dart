class PhotoEntity {
  static final tblPhoto = 'photos';
  static final dbId = 'identifier';
  static final dbMd5 = 'md5';
  static final dbType = 'type';
  static final dbPhoto = 'photo';
  static final dbWidth = 'width';
  static final dbHeight = 'height';
  static final dbBlogId = 'blogId';
  static final dbCreateTime = 'createTime';

  final String identifier;
  final String md5;
  final String type;
  final int height;
  final int width;
  final int blogId;
  final int createTime;

  PhotoEntity(
      {this.identifier,
      this.md5,
      this.type,
      this.height,
      this.width,
      this.createTime,
      this.blogId});

  @override
  String toString() {
    return 'PhotoEntity: {identifier:$identifier,md5:$md5,type:$type,height:$height,width:$width}';
  }

  static PhotoEntity fromJson(Map<String, Object> json) {
    return PhotoEntity(
      identifier: json['identifier'] as String,
      md5: json['md5'] as String,
      type: json['type'] as String,
      height: json['height'] as int,
      width: json['width'] as int,
      blogId: json['blogId'] as int,
      createTime: json['createTime'] as int,
    );
  }
}
