import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/comment_controller.dart';
import '../models/comment_model.dart';

class CommentView extends StatelessWidget {
  final String bookId;  // ID buku yang diambil dari buku yang dipilih
  final CommentController commentController = Get.put(CommentController());

  CommentView({required this.bookId});

  @override
  Widget build(BuildContext context) {
    TextEditingController commentControllerText = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Comments')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              var comments = commentController.getCommentsForBook(bookId);
              return ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return ListTile(
                    title: Text(comment.content),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        commentController.deleteComment(comment.id); // Hapus komentar
                      },
                    ),
                    onTap: () {
                      // Dialog untuk mengupdate komentar
                      TextEditingController updateController = TextEditingController(text: comment.content);
                      Get.defaultDialog(
                        title: "Edit Comment",
                        content: TextField(controller: updateController),
                        confirm: ElevatedButton(
                          onPressed: () {
                            commentController.updateComment(comment.id, updateController.text);
                            Get.back();  // Menutup dialog
                          },
                          child: Text('Update'),
                        ),
                        cancel: ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text('Cancel'),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentControllerText,
                    decoration: InputDecoration(labelText: 'Add a comment'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    commentController.addComment(bookId, commentControllerText.text);
                    commentControllerText.clear();  // Hapus teks setelah menambah komentar
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
