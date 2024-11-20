import SwiftUI

@MainActor
public class SNSHomeViewModel: ObservableObject {
  public init() {
  }
}

public struct SNSHomeView: View {
  @StateObject private var viewModel: SNSHomeViewModel
  
  public init(viewModel: SNSHomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    Text("Complete Login")
  }
}

#Preview {
  SNSHomeView(viewModel: SNSHomeViewModel())
}
