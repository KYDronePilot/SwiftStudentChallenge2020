import Cocoa
import SwiftUI
import PlaygroundSupport

var str = "Hello, playground"

struct ContentView: View {
    var body: some View {
        FullView()
            .background(Color.white)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
