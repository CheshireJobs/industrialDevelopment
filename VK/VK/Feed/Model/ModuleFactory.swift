import Foundation
import UIKit

enum ModuleFactory {
    static func makeFeedModule() -> FeedViewController {
        let viewModel = FeedViewModel()
        let feedViewController = FeedViewController(viewModel: viewModel)
        return feedViewController
    }
}
