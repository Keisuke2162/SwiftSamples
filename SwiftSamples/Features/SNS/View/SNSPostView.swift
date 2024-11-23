import SwiftUI
import _PhotosUI_SwiftUI

public struct SNSPostView: View {
  @StateObject private var viewModel: SNSPostViewModel
  // @Environment(\.dismiss) var dismiss
  
  public init(viewModel: SNSPostViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  public var body: some View {
    ZStack {
      VStack {
        if let postImage = viewModel.postImage {
          ZStack {
            Image(uiImage: postImage)
              .resizable()
              .frame(maxWidth: .infinity)
              .aspectRatio(1, contentMode: .fill)
              .clipped()

            VStack {
              Spacer()
              HStack {
                Spacer()
                Button {
                  viewModel.isImagePickerPresented = true
                } label: {
                  Image(systemName: "camera.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(8)
                    .foregroundStyle(Color.black)
                    .background(Color.gray)
                    .clipShape(Circle())
                }
              }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
          }
        } else {
          ZStack {
            Color.gray.opacity(0.4)
              .frame(maxWidth: .infinity)
              .aspectRatio(1, contentMode: .fill)
            // Button
            Button {
              viewModel.isImagePickerPresented = true
            } label: {
              Image(systemName: "camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .padding(16)
                .foregroundStyle(Color.black)
                .background(Color.gray)
                .clipShape(Circle())
            }

          }
        }
        
        TextEditor(text: $viewModel.text)
          .padding(.horizontal, 16)

        Spacer()
        Button {
          Task {
            await viewModel.sendPost()
            // TODO: checkmark表示にアニメーションをつけてその分dismissをディレイしたい
            // dismiss()
          }
        } label: {
          Text("Post")
        }

      }
      .photosPicker(isPresented: $viewModel.isImagePickerPresented, selection: $viewModel.postPhotoItem)

      if viewModel.isLoading {
        SNSLoadingView()
          .ignoresSafeArea()
      }
      
      if viewModel.isSuccessPost {
        Color.blue.opacity(0.3)
          .background(ignoresSafeAreaEdges: .bottom)
        Text("Success Post!")
          .font(.title)
          .padding()
          .background(Color.blue)
          .foregroundStyle(Color.white)
      }

      if !viewModel.errorMessage.isEmpty {
        Color.red.opacity(0.3)
          .background(ignoresSafeAreaEdges: .bottom)
        Text(viewModel.errorMessage)
          .font(.title)
          .padding()
          .background(Color.red)
          .foregroundStyle(Color.white)
      }
    }
  }
}
