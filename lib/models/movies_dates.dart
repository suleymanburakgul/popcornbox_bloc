class MovieDates {
  final String maximum;
  final String minimum;

  MovieDates({required this.maximum, required this.minimum});

  factory MovieDates.fromJson(Map<String, dynamic> json) {
    return MovieDates(
      maximum: json['maximum'],
      minimum: json['minimum'],
    );
  }


}