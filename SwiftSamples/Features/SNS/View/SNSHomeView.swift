import SwiftUI

public struct SNSHomeView: View {
  @StateObject private var viewModel: SNSHomeViewModel
  
  public init(viewModel: SNSHomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    ZStack {
      Color.indigo
      VStack {
        if viewModel.isLoggedIn {
          Text("Complete SignIn")
          Button {
            // ログアウト処理
            viewModel.logout()
          } label: {
            Text("Logout")
          }

        } else {
          // 未ログイン時はスプラッシュ画面表示
          Image(systemName: "circle")
        }
      }
    }
    .sheet(isPresented: $viewModel.isShowSignInView, content: {
      NavigationStack {
        SNSSigninView(viewModel: SNSSigninViewModel(onLoggedIn: {
          viewModel.onLoggedIn()
        }))
      }
    })
    .onAppear {
      viewModel.onAppear()
    }
  }
}

#Preview {
  SNSHomeView(viewModel: SNSHomeViewModel())
}
