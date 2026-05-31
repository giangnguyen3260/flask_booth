import 'package:injectable/injectable.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/stand_by/provider/stand_by_listen_state.dart';

@injectable
class StandByProvider extends BaseProvider<StandByListenState> {
  StandByProvider() : super();
}
