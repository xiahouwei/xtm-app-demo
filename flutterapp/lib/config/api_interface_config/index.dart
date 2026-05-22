import 'api_auth.dart';
import 'api_im.dart';
import 'api_image.dart';

class Api {
  final AuthApi auth = AuthApi();
  final ImApi im = ImApi();
  final ImageApi image = ImageApi();
}

final xtmApi = Api();
