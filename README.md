# SwiftUIPullToRefresh


## Usage

```swift
import SwiftUI
import SwiftUIPullToRefresh


struct ExamplePullToRefreshView: View {
    @State private var isRefreshing = false
    @State private var array: [String] = []
    
    var body: some View {
        NavigationView {
            List(array, id: \.self) { text in
                Text(text)
            }
            .navigationBarTitle("SwiftUIPullToRefresh")
            .navigationBarTitleDisplayMode(.inline)
            .onPullToRefresh(isRefreshing: $isRefreshing, perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isRefreshing = false
                    self.array.insert(Date().description, at: 0)
                }
            })
        }
    }
}


struct ExamplePullToRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        ExamplePullToRefreshView()
    }
}
```
