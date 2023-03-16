enum GaussianBlurPageStatus { first, second, fullScreen }

class GaussianBlurPageState {

  GaussianBlurPageStatus states = GaussianBlurPageStatus.first;

  GaussianBlurPageState init() {
    return GaussianBlurPageState();
  }

  GaussianBlurPageState clone() {
    return GaussianBlurPageState()
    ..states = states;
  }
}
