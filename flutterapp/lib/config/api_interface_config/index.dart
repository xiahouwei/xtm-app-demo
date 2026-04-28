import 'api_auth.dart';
import 'api_im.dart';
import 'api_image.dart';
import 'api_mine.dart';
import 'api_message.dart';

class Api {
  final AuthApi auth = AuthApi();
  final ImApi im = ImApi();
  final ImageApi image = ImageApi();
  final MineApi mine = MineApi();
  final ApiMessage message = ApiMessage();
}

final xtmApi = Api();
