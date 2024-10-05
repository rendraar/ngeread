import 'package:get/get.dart';
import '../models/comment_model.dart';

class CommentController extends GetxController {
  var commentList = <Comment>[].obs;  // List untuk menyimpan komentar

  // CREATE: Menambah komentar
  void addComment(String bookId, String content) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    commentList.add(Comment(id: id, bookId: bookId, content: content));
  }

  // READ: Mendapatkan semua komentar untuk buku tertentu
  List<Comment> getCommentsForBook(String bookId) {
    return commentList.where((comment) => comment.bookId == bookId).toList();
  }

  // UPDATE: Mengubah komentar
  void updateComment(String id, String newContent) {
    var index = commentList.indexWhere((comment) => comment.id == id);
    if (index != -1) {
      commentList[index] = Comment(id: id, bookId: commentList[index].bookId, content: newContent);
    }
  }

  // DELETE: Menghapus komentar
  void deleteComment(String id) {
    commentList.removeWhere((comment) => comment.id == id);
  }
}
