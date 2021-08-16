import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_list/src/Movie.dart';
import 'package:movie_list/src/movie_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getAllmovies();
  }

  List<Movie> movieslist = List<Movie>.empty(growable: true);

  getAllmovies() async {
    var movie = Movie();
    var movieservice = MovieService();
    movieslist = List<Movie>.empty(growable: true);
    var movies = await movieservice.readMovies();
    movies.forEach((element) {
      setState(() {
        var moviemodel = Movie();
        moviemodel.id = element['id'];
        moviemodel.MovieName = element['mname'];
        moviemodel.MovieDirector = element['mdirector'];
        moviemodel.Imagepath = element['imagepath'];
        movieslist.add(moviemodel);
      });
    });
    print(movieslist);
  }

  _showFormDialog(BuildContext context) {
    var movie = Movie();
    var movieservice = MovieService();
    TextEditingController moviename = new TextEditingController();
    TextEditingController moviedirector = new TextEditingController();
    String movieimagepath;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text("Movie Details"),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    movie.MovieName = moviename.text;
                    movie.MovieDirector = moviedirector.text;
                    movie.Imagepath = movieimagepath;
                    var result = await movieservice.saveMovie(movie);
                    Navigator.pop(context);
                    getAllmovies();
                    print(result);
                  },
                  child: Text("Add Movie")),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              )
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: moviename,
                    decoration: InputDecoration(
                        hintText: "Movie Name", labelText: "Movie Name"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: moviedirector,
                    decoration: InputDecoration(
                        hintText: "Director Name", labelText: "Director Name"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        var image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          movieimagepath = image.path;
                        });
                      },
                      child: Text("Add Movie Poster")),
                ],
              ),
            ),
          );
        });
  }

  _EditFormDialog(BuildContext context, Movie movieslist) {
    var movie = Movie();
    var movieservice = MovieService();
    TextEditingController moviename = new TextEditingController();
    TextEditingController moviedirector = new TextEditingController();
    String movieimagepath;
    moviename.text = movieslist.MovieName;
    moviedirector.text = movieslist.MovieDirector;
    movieimagepath = movieslist.Imagepath;

    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            title: Text("Edit Movie Details"),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    movie.id = movieslist.id;
                    movie.MovieName = moviename.text;
                    movie.MovieDirector = moviedirector.text;
                    movie.Imagepath = movieimagepath;
                    var result = await movieservice.updateMovie(movie);
                    getAllmovies();
                    Navigator.pop(context);
                    print(result);
                  },
                  child: Text("Update")),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              )
            ],
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: moviename,
                    decoration: InputDecoration(
                        hintText: "Movie Name", labelText: "Movie Name"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: moviedirector,
                    decoration: InputDecoration(
                        hintText: "Director Name", labelText: "Director Name"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        var image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          movieimagepath = image.path;
                        });
                      },
                      child: Text("Edit Movie Poster")),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Movies'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showFormDialog(context);
            getAllmovies();
          },
          child: Icon(Icons.add),
        ),
        body: movieslist.length <= 0
            ? Container()
            : ListView.builder(
                itemCount: movieslist.length,
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          // leading: Icon(Icons.arrow_drop_down_circle),
                          title:
                              Text("Movie Name:" + movieslist[index].MovieName),
                          subtitle: Text(
                            "Director" + movieslist[index].MovieDirector,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        movieslist[index].Imagepath == null
                            ? Text("No Image selected")
                            : Image.file(
                                File(movieslist[index].Imagepath),
                              ),
                        ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {
                                // Perform some action
                                _EditFormDialog(context, movieslist[index]);
                              },
                              child: const Text('Edit'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Perform some action
                                var movieservice = MovieService();
                                movieservice.deleteMovie(movieslist[index]);
                                setState(() {
                                  movieslist = movieslist;
                                });
                                getAllmovies();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }));
  }
}
