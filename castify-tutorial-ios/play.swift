import SwiftUI
import Castify

struct PlayView : View {
  
  @StateObject var model = PlayViewModel()
  
  var body: some View {
    VStack {
      Castify.Preview(model.player.media)
      HStack {
        Button(action: { model.played.toggle() }) {
          Text(model.played ? "Stop" : "Play")
        }
        TextField("Broadcast ID", text: $model.broadcastId)
      }
    }
  }
}

class PlayViewModel : ObservableObject {
  
  let player = Player(app)

  @Published var broadcastId = ""

  @Published var played = false {
    didSet {
      task?.cancel()
      if played {
        task = Task { try await play() }
      }
      else {
        player.play(nil)
      }
    }
  }

  private var task: Task<Void, Error>? = nil
  
  private func play() async throws {
    let source = Source(app, broadcast: broadcastId)
    let metadata = try await source.load()
    if metadata.stoppedAt == nil {
      player.play(source) // ライブとして再生
    }
    else {
      player.play(source, from: 0)
    }
  }
}
