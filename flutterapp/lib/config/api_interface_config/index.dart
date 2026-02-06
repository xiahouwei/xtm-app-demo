import 'api_auth.dart';
import 'api_image.dart';
import 'api_mine.dart';

class Api {
  final AuthApi auth = AuthApi();
  final MineApi mine = MineApi();
  final ImageApi image = ImageApi();
}

final xtmApi = Api();
