import SwiftUI
import Kingfisher

public struct SNSHomeView: View {
  @StateObject private var viewModel: SNSHomeViewModel
  
  public init(viewModel: SNSHomeViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  public var body: some View {
    VStack(spacing: 32) {
      if viewModel.isLoggedIn {
        VStack(spacing: 16) {
          KFImage(viewModel.profileImageURL)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 160, height: 160)
            .clipShape(Circle())
          Text(viewModel.userName)
            .font(.title2.bold())
        }

        VStack(spacing: 16) {
          Button {

          } label: {
            Text("Post")
          }

          Button {

          } label: {
            Text("Timeline")
          }

          Button {

          } label: {
            Text("Profile")
          }

          Button {
            viewModel.logout()
          } label: {
            Text("Logout")
              .foregroundStyle(Color.red)
          }
        }
      } else {
        ZStack {
          Color.blue
          // 未ログイン時はスプラッシュ画面表示
          Image("pixel_bird")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
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
      Task {
        await viewModel.onAppear()
      }
    }
  }
}

#Preview {
  SNSHomeView(viewModel: SNSHomeViewModel())
}
