import Foundation
import UIKit

enum ModuleFactory {
    static func makeFeedModule() -> FeedViewController {
        let model = Model()
        let viewModel = FeedViewModel(model: model)
        let feedViewController = FeedViewController(viewModel: viewModel)
        return feedViewController
    }
}
