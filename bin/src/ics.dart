import 'dart:io';

class ICalendarParser {
  static Map<String, String> propertyMap = {
    'GEO': r"(-?[0-9]+\.[0-9]+;-?[0-9]+\.[0-9]+)",
    "VERSION": r"([0-2]\.[0-9])",
    "CALSCALE": r"(GREGORIAN)",
    "METHOD":
        r"(PUBLISH|REQUEST|REPLY|ADD|CANCEL|REFRESH|COUNTER|DECLINECOUNTER)",
  };
  String content;
  ICalendarParser({required this.content});

  String? _extract(String regex, [String? content]) {
    content ??= this.content;
    var match = RegExp(regex).firstMatch(content);
    if (match != null) {
      return match.namedGroup('value');
    }
    return null;
  }

  String? _extractProperty(String property, String regex, {String? content}) {
    return _extract("$property:(?<value>$regex)", content);
  }

  Map<String, String> parse() {
    var calendar =
        _extract(r"^BEGIN:VCALENDAR(?<value>(.|\n|\r\n)*?)END:VCALENDAR");

    if (calendar == null) {
      throw Exception("Invalid iCalendar file");
    }

    for (var property in propertyMap.keys) {
      var value = _extractProperty(property, propertyMap[property]!);
      print("$property: $value");
    }
    return {"hello": "world"};
  }

  Map<String, String> _parseEvent(String event) {
    var eventPropertyMap = {
      "DTSTART": r"(\d{8}T\d{6}Z)",
      "DTEND": r"(\d{8}T\d{6}Z)",
      "DTSTAMP": r"(\d{8}T\d{6}Z)",
      "UID": r"(.+)",
      "CREATED": r"(\d{8}T\d{6}Z)",
      "DESCRIPTION": r"(.+)",
      "LAST-MODIFIED": r"(\d{8}T\d{6}Z)",
      "LOCATION": r"(.+)",
      "SEQUENCE": r"(\d+)",
      "STATUS": r"(TENTATIVE|CONFIRMED|CANCELLED)",
      "SUMMARY": r"(.+)",
      "TRANSP": r"(OPAQUE|TRANSPARENT)",
      "URL": r"(.+)",
      "RECURRENCE-ID": r"(\d{8}T\d{6}Z)",
      "RRULE": r"(.+)",
      "DTSTART;TZID": r"(.+)",
      "DTEND;TZID": r"(.+)",
      "DURATION": r"(.+)",
      "ATTACH": r"(.+)",
      "ATTENDEE": r"(.+)",
      "CATEGORIES": r"(.+)",
      "COMMENT": r"(.+)",
      "CONTACT": r"(.+)",
      "EXDATE": r"(.+)",
      "RSTATUS": r"(.+)",
      "RELATED": r"(.+)",
      "RESOURCES": r"(.+)",
      "RDATE": r"(.+)",
    };

    var eventMap = <String, String>{};
    for (var property in eventPropertyMap.keys) {
      var value = _extractProperty(property, eventPropertyMap[property]!,
          content: event);
      if (value != null) {
        eventMap[property] = value;
      }
    }
    return eventMap;
  }

  List<Map<String, String>> getRawEvents() {
    return RegExp("(BEGIN:VEVENT(?<value>(.|\n|\r\n)*?)END:VEVENT)")
        .allMatches(content)
        .map((e) => e.namedGroup('value'))
        .map(
          (e) => _parseEvent(e!),
        )
        .toList();
  }
}

void main(List<String> args) {
  var content = File('agenda.ics').readAsStringSync().trim();
  var parser = ICalendarParser(content: content);
  print(parser.getRawEvents());
}
