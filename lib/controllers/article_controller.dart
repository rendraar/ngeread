import 'package:get/get.dart';
import '../views/article.dart';
import 'package:http/http.dart' as http;

class ArticleController extends GetxController {
  var articles = Articles(
    status: "",
    copyright: "",
    numResults: 0,
    lastModified: DateTime.now(),
    results: Results(
      listName: "",
      listNameEncoded: "",
      bestsellersDate: DateTime.now(),
      publishedDate: DateTime.now(),
      publishedDateDescription: "",
      nextPublishedDate: "",
      previousPublishedDate: DateTime.now(),
      displayName: "",
      normalListEndsAt: 0,
      updated: "",
      books: [],
      corrections: [],
    ),
  ).obs;

  var isLoading = true.obs;

  @override
  void onInit() {
    fetchArticles();
    super.onInit();
  }

  void fetchArticles() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("https://api.nytimes.com/svc/books/v3/lists/current/hardcover-fiction.json?api-key=2r6tZBhRwjehucaJfFEYv8JLuUpztvgg"));
      if (response.statusCode == 200) {
        articles.value = articlesFromJson(response.body);
      } else {
        throw Exception("Failed to load articles");
      }
    } finally {
      isLoading(false);
    }
  }
}
