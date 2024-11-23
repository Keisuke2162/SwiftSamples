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
          NavigationLink {
            SNSPostView(viewModel: SNSPostViewModel(userID: viewModel.userID))
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
            .ignoresSafeArea()
          SNSLoadingView()
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
