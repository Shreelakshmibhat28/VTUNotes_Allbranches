
// Note class
class Note {
  final int? id;
  final String title;
  final String pdfPath;
  final String? branches;
  final String? year; // Make it nullable
  final String? scheme; // Make it nullable
  final String? semester; // Make it nullable

  Note({
    this.id,
    required this.title,
    required this.pdfPath,
    this.branches,
    this.year,
    this.scheme,
    this.semester,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'pdfPath': pdfPath,
      'branches': branches,
      'year': year,
      'scheme': scheme,
      'semester': semester,

    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      pdfPath: map['pdfPath'],
      branches: map['branches'],
      year: map['year'],
      scheme: map['scheme'],
      semester: map['semester'],

    );
  }
}
