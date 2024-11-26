// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'dart:convert';

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

class Article {
    int totalArticles;
    List<ArticleElement> articles;

    Article({
        required this.totalArticles,
        required this.articles,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        totalArticles: json["totalArticles"],
        articles: List<ArticleElement>.from(json["articles"].map((x) => ArticleElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "totalArticles": totalArticles,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
    };
}

class ArticleElement {
    String title;
    String description;
    String content;
    String url;
    String image;
    DateTime publishedAt;
    Source source;

    ArticleElement({
        required this.title,
        required this.description,
        required this.content,
        required this.url,
        required this.image,
        required this.publishedAt,
        required this.source,
    });

    factory ArticleElement.fromJson(Map<String, dynamic> json) => ArticleElement(
        title: json["title"],
        description: json["description"],
        content: json["content"],
        url: json["url"],
        image: json["image"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        source: Source.fromJson(json["source"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "content": content,
        "url": url,
        "image": image,
        "publishedAt": publishedAt.toIso8601String(),
        "source": source.toJson(),
    };
}

class Source {
    String name;
    String url;

    Source({
        required this.name,
        required this.url,
    });

    factory Source.fromJson(Map<String, dynamic> json) => Source(
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
    };
}
