import 'dart:convert';

Articles articlesFromJson(String str) => Articles.fromJson(json.decode(str));

String articlesToJson(Articles data) => json.encode(data.toJson());

class Articles {
  String status;
  String copyright;
  int numResults;
  DateTime lastModified;
  Results results;

  Articles({
    required this.status,
    required this.copyright,
    required this.numResults,
    required this.lastModified,
    required this.results,
  });

  factory Articles.fromJson(Map<String, dynamic> json) => Articles(
    status: json["status"],
    copyright: json["copyright"],
    numResults: json["num_results"],
    lastModified: DateTime.parse(json["last_modified"]),
    results: Results.fromJson(json["results"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "copyright": copyright,
    "num_results": numResults,
    "last_modified": lastModified.toIso8601String(),
    "results": results.toJson(),
  };
}

class Results {
  String listName;
  String listNameEncoded;
  DateTime bestsellersDate;
  DateTime publishedDate;
  String publishedDateDescription;
  String nextPublishedDate;
  DateTime previousPublishedDate;
  String displayName;
  int normalListEndsAt;
  String updated;
  List<Book> books;
  List<dynamic> corrections;

  Results({
    required this.listName,
    required this.listNameEncoded,
    required this.bestsellersDate,
    required this.publishedDate,
    required this.publishedDateDescription,
    required this.nextPublishedDate,
    required this.previousPublishedDate,
    required this.displayName,
    required this.normalListEndsAt,
    required this.updated,
    required this.books,
    required this.corrections,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
    listName: json["list_name"],
    listNameEncoded: json["list_name_encoded"],
    bestsellersDate: DateTime.parse(json["bestsellers_date"]),
    publishedDate: DateTime.parse(json["published_date"]),
    publishedDateDescription: json["published_date_description"],
    nextPublishedDate: json["next_published_date"],
    previousPublishedDate: DateTime.parse(json["previous_published_date"]),
    displayName: json["display_name"],
    normalListEndsAt: json["normal_list_ends_at"],
    updated: json["updated"],
    books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
    corrections: List<dynamic>.from(json["corrections"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "list_name": listName,
    "list_name_encoded": listNameEncoded,
    "bestsellers_date": "${bestsellersDate.year.toString().padLeft(4, '0')}-${bestsellersDate.month.toString().padLeft(2, '0')}-${bestsellersDate.day.toString().padLeft(2, '0')}",
    "published_date": "${publishedDate.year.toString().padLeft(4, '0')}-${publishedDate.month.toString().padLeft(2, '0')}-${publishedDate.day.toString().padLeft(2, '0')}",
    "published_date_description": publishedDateDescription,
    "next_published_date": nextPublishedDate,
    "previous_published_date": "${previousPublishedDate.year.toString().padLeft(4, '0')}-${previousPublishedDate.month.toString().padLeft(2, '0')}-${previousPublishedDate.day.toString().padLeft(2, '0')}",
    "display_name": displayName,
    "normal_list_ends_at": normalListEndsAt,
    "updated": updated,
    "books": List<dynamic>.from(books.map((x) => x.toJson())),
    "corrections": List<dynamic>.from(corrections.map((x) => x)),
  };
}

class Book {
  int rank;
  int rankLastWeek;
  int weeksOnList;
  int asterisk;
  int dagger;
  String primaryIsbn10;
  String primaryIsbn13;
  String publisher;
  String description;
  String price;
  String title;
  String author;
  String contributor;
  String contributorNote;
  String bookImage;
  int bookImageWidth;
  int bookImageHeight;
  String amazonProductUrl;
  String ageGroup;
  String bookReviewLink;
  String firstChapterLink;
  String sundayReviewLink;
  String articleChapterLink;
  List<Isbn> isbns;
  List<BuyLink> buyLinks;
  String bookUri;

  Book({
    required this.rank,
    required this.rankLastWeek,
    required this.weeksOnList,
    required this.asterisk,
    required this.dagger,
    required this.primaryIsbn10,
    required this.primaryIsbn13,
    required this.publisher,
    required this.description,
    required this.price,
    required this.title,
    required this.author,
    required this.contributor,
    required this.contributorNote,
    required this.bookImage,
    required this.bookImageWidth,
    required this.bookImageHeight,
    required this.amazonProductUrl,
    required this.ageGroup,
    required this.bookReviewLink,
    required this.firstChapterLink,
    required this.sundayReviewLink,
    required this.articleChapterLink,
    required this.isbns,
    required this.buyLinks,
    required this.bookUri,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    rank: json["rank"],
    rankLastWeek: json["rank_last_week"],
    weeksOnList: json["weeks_on_list"],
    asterisk: json["asterisk"],
    dagger: json["dagger"],
    primaryIsbn10: json["primary_isbn10"],
    primaryIsbn13: json["primary_isbn13"],
    publisher: json["publisher"],
    description: json["description"],
    price: json["price"],
    title: json["title"],
    author: json["author"],
    contributor: json["contributor"],
    contributorNote: json["contributor_note"],
    bookImage: json["book_image"],
    bookImageWidth: json["book_image_width"],
    bookImageHeight: json["book_image_height"],
    amazonProductUrl: json["amazon_product_url"],
    ageGroup: json["age_group"],
    bookReviewLink: json["book_review_link"],
    firstChapterLink: json["first_chapter_link"],
    sundayReviewLink: json["sunday_review_link"],
    articleChapterLink: json["article_chapter_link"],
    isbns: List<Isbn>.from(json["isbns"].map((x) => Isbn.fromJson(x))),
    buyLinks: List<BuyLink>.from(json["buy_links"].map((x) => BuyLink.fromJson(x))),
    bookUri: json["book_uri"],
  );

  Map<String, dynamic> toJson() => {
    "rank": rank,
    "rank_last_week": rankLastWeek,
    "weeks_on_list": weeksOnList,
    "asterisk": asterisk,
    "dagger": dagger,
    "primary_isbn10": primaryIsbn10,
    "primary_isbn13": primaryIsbn13,
    "publisher": publisher,
    "description": description,
    "price": price,
    "title": title,
    "author": author,
    "contributor": contributor,
    "contributor_note": contributorNote,
    "book_image": bookImage,
    "book_image_width": bookImageWidth,
    "book_image_height": bookImageHeight,
    "amazon_product_url": amazonProductUrl,
    "age_group": ageGroup,
    "book_review_link": bookReviewLink,
    "first_chapter_link": firstChapterLink,
    "sunday_review_link": sundayReviewLink,
    "article_chapter_link": articleChapterLink,
    "isbns": List<dynamic>.from(isbns.map((x) => x.toJson())),
    "buy_links": List<dynamic>.from(buyLinks.map((x) => x.toJson())),
    "book_uri": bookUri,
  };
}

class Isbn {
  String isbn10;
  String isbn13;

  Isbn({
    required this.isbn10,
    required this.isbn13,
  });

  factory Isbn.fromJson(Map<String, dynamic> json) => Isbn(
    isbn10: json["isbn10"],
    isbn13: json["isbn13"],
  );

  Map<String, dynamic> toJson() => {
    "isbn10": isbn10,
    "isbn13": isbn13,
  };
}

class BuyLink {
  String name;
  String url;

  BuyLink({
    required this.name,
    required this.url,
  });

  factory BuyLink.fromJson(Map<String, dynamic> json) => BuyLink(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };
}
