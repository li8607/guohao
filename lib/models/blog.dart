import 'package:guohao/repositorys/blog/blog_entity.dart';

// class Blog {
//   String title, comment, categoryName;
//   int id, dueDate, categoryId, categoryColor;
//   List<String> labelNames;
//   List<int> labelIDs;
//   Blog(
//       {this.id,
//       this.title,
//       this.comment,
//       this.categoryName,
//       this.dueDate,
//       this.categoryId,
//       this.categoryColor,
//       this.labelNames,
//       this.labelIDs});

//   BlogEntity toEntity() {
//     return BlogEntity(
//         id: id,
//         title: title,
//         comment: comment,
//         categoryId: categoryId,
//         dueDate: dueDate);
//   }

//   @override
//   int get hashCode =>
//       id.hashCode ^
//       title.hashCode ^
//       categoryId.hashCode ^
//       categoryColor.hashCode ^
//       comment.hashCode ^
//       categoryName.hashCode ^
//       dueDate.hashCode ^
//       categoryName.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Blog &&
//           runtimeType == other.runtimeType &&
//           id == other.id &&
//           title == other.title &&
//           comment == other.comment &&
//           categoryName == other.categoryName &&
//           dueDate == other.dueDate &&
//           categoryId == other.categoryId &&
//           categoryColor == other.categoryColor &&
//           labelNames == other.labelNames &&
//           dueDate == other.dueDate;

//   static Blog fromEntity(BlogEntity entity) {
//     return Blog(
//         id: entity.id,
//         title: entity.title,
//         comment: entity.comment,
//         dueDate: entity.dueDate,
//         categoryId: entity.categoryId,
//         categoryName: entity.categoryName,
//         labelNames: entity.labelList,
//         categoryColor: entity.categoryColor);
//   }

//   Blog copyWith(
//       {int id,
//       int categoryId,
//       int categoryColor,
//       int dueDate,
//       String title,
//       String comment,
//       List<String> labelNames,
//       String categoryName}) {
//     return Blog(
//       id: id ?? this.id,
//       categoryId: categoryId ?? this.categoryId,
//       categoryColor: categoryColor ?? this.categoryColor,
//       dueDate: dueDate ?? this.dueDate,
//       title: title ?? this.title,
//       comment: comment ?? this.comment,
//       labelNames: labelNames ?? this.labelNames,
//       categoryName: categoryName ?? this.categoryName,
//     );
//   }
// }
