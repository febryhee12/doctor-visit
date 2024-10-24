import '../helpers/dialog_helper.dart';
import 'app_exceptions.dart';

class BaseController {
  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErrorDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showErrorDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErrorDialog(description: 'Oops! respon teralu lama.');
    }
    return;
  }

  showLoading() {
    DialogHelper.showLoading();
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }
}
