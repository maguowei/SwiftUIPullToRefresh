import SwiftUI

@available(iOS 14.0, *)
public struct PullToRefresh: UIViewRepresentable {
    @Binding private(set) var isRefreshing: Bool
    let perform: () -> Void

    public init(isRefreshing: Binding<Bool>, perform: @escaping () -> Void) {
        self._isRefreshing = isRefreshing
        self.perform = perform
    }

    public class Coordinator {
        let isRefreshing: Binding<Bool>
        let perform: () -> Void

        init(isRefreshing: Binding<Bool>, perform: @escaping () -> Void) {
            self.isRefreshing = isRefreshing
            self.perform = perform
        }

        @objc
        func onValueChanged() {
            isRefreshing.wrappedValue = true
            perform()
        }
    }

    public func makeUIView(context: UIViewRepresentableContext<PullToRefresh>) -> UIView {
        return UIView(frame: .zero)
    }

    private func tableView(root: UIView) -> UITableView? {
        for subview in root.subviews {
            if let tableView = subview as? UITableView {
                return tableView
            } else if let tableView = tableView(root: subview) {
                return tableView
            }
        }
        
        return nil
    }

    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PullToRefresh>) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let viewHost = uiView.superview?.superview,
                let tableView = self.tableView(root: viewHost) else {
                    return
            }

            if let refreshControl = tableView.refreshControl {
                self.isRefreshing ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
                
                return
            }

            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(context.coordinator,
                                     action: #selector(Coordinator.onValueChanged),
                                     for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(isRefreshing: $isRefreshing, perform: perform)
    }
}

@available(iOS 14.0, *)
public extension View {
    func onPullToRefresh(isRefreshing: Binding<Bool>, perform: @escaping () -> Void) -> some View {
        overlay(
            PullToRefresh(isRefreshing: isRefreshing, perform: perform)
                .frame(width: 0, height: 0)
        )
    }
}
