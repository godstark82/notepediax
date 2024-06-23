class GalleryImage {
  String url;
  String ref;
  GalleryImage({required this.url, required this.ref});

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      url: json['url'],
      ref: json['ref'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'ref': ref};
  }
}
