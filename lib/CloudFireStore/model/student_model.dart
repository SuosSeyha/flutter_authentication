class Student{
  final String name,gender;
  final int score;

  Student({
    required this.name,
    required this.gender,
    required this.score
  });

  Map<String, dynamic> toMap(){
    return {
      'name':name,
      'gender':gender,
      'score':score
    };
  }
}