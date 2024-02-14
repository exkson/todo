class Event {
  String uid;
  String summary;
  String description;
  String? location;
  String? status;
  String? url;

  Event({
    required this.uid,
    required this.summary,
    this.description = "",
    this.location,
    this.status,
    this.url,
  });
}
