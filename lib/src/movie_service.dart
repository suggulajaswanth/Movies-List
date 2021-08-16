import 'package:movie_list/src/Movie.dart';
import 'package:movie_list/src/Repository.dart';

class MovieService {
  Repository _repository;
  MovieService() {
    _repository = Repository();
  }

  saveMovie(Movie movie) async {
    return await _repository.insertData('movies', movie.movieMap());
  }

  deleteMovie(Movie movie) async {
    return await _repository.deleteData('movies', movie.movieMap());
  }

  updateMovie(Movie movie) async {
    return await _repository.updateData('movies', movie.movieMap());
  }

  readMovies() async {
    return await _repository.readData('movies');
  }
}
