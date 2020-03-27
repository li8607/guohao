class BlogLabelEntity {
  static final tblBlogLabel = "taskLabel";
  static final dbId = "id";
  static final dbBlogId = "taskId";
  static final dbLabelId = "labelId";

  int id, blogId, labelId;

  BlogLabelEntity.create(this.blogId, this.labelId);

  BlogLabelEntity.update({this.id, this.blogId, this.labelId});

  BlogLabelEntity.fromJson(Map<String, dynamic> map)
      : this.update(
            id: map[dbId], blogId: map[dbBlogId], labelId: map[dbLabelId]);
}
