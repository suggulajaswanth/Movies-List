class Movie{
  int id;
  String MovieName;
  String MovieDirector;
  String Imagepath;

  movieMap(){
    var mapping = Map<String, dynamic>();
    mapping['id']=id;
    mapping['mname']=MovieName;
    mapping['mdirector']=MovieDirector;
    mapping['imagepath'] = Imagepath;

    return mapping;
  }
}