import SwiftUI
import Castify

let app = CastifyApp(token: <#YOUR_API_TOKEN#>)

@main
struct DemoApp: App {

  var body: some Scene {
    WindowGroup {
      NavigationView {
        VStack(spacing: 16) {
          NavigationLink(destination: { LiveView() }) {
            Text("配信のサンプル")
          }
          NavigationLink(destination: { PlayView() }) {
            Text("視聴のサンプル")
          }
        }
      }
      .navigationViewStyle(.stack)
    }
  }
}
