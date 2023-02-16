import SwiftUI
import Castify

struct LiveView : View {

  @StateObject var model = LiveViewModel()
  
  @State var started = false {
    willSet {
      if newValue {
        model.broadcaster.start()
      }
      else {
        model.broadcaster.pause()
      }
    }
  }

  var body: some View {
    VStack {
      Castify.Preview(model.broadcaster.media)
      Button(action: { started.toggle() }) {
        Text(started ? "Paused" : "Start")
      }
    }
  }
}

class LiveViewModel : ObservableObject, BroadcasterDelegate {

  let broadcaster = Broadcaster(app)
  
  @Published var state = Broadcaster.State.closed(cause: nil)

  init() {
    broadcaster.delegate = self
    broadcaster.audio = Microphone()
    broadcaster.video = Camera(position: .front)
    broadcaster.audioEncoderSetting = .AAC(bps: 192_000)
    broadcaster.videoEncoderSetting = .H264(bps: 1_500_000)
  }

  func on(event: Broadcaster.Event, from host: Broadcaster) {
    switch event {
    case .stateChange(let state):
      self.state = state

    case .broadcast(let broadcast):
      print("broadcast: \(broadcast)")

    default: ()
    }
  }
}
