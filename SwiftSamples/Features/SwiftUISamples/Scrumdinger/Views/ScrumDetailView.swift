import SwiftUI

struct ScrumDetailView: View {
  // 大元（source of truth）はScrumViewのもの
  @Binding var scrum: DailyScrum
  
  // 編集画面に飛ばす用のプロパティ、編集完了（TapDone）したタイミングでscrumに反映する
  // 新規作成も同じ画面を使うのでデフォルトでempty用のデータを入れておく
  @State private var editingScrum = DailyScrum.emptyScrum
  @State private var isPresentingEditView = false
  
  var body: some View {
    List {
      Section(header: Text("Meeting Info")) {
        NavigationLink {
          MeetingView(scrum: $scrum)
        } label: {
          Label("Start Meeting", systemImage: "timer")
            .font(.headline)
            .foregroundColor(.accentColor)
        }
        HStack {
          Label("Length", systemImage: "clock")
          Spacer()
          Text("\(scrum.lengthInMinutes) minutes")
        }
        .accessibilityElement(children: .combine)
        HStack {
          Label("Theme", systemImage: "paintpalette")
          Spacer()
          Text(scrum.theme.name)
            .padding(4)
            .foregroundColor(scrum.theme.accentColor)
            .background(scrum.theme.mainColor)
            .cornerRadius(4)
        }
        .accessibilityElement(children: .combine)
      }
      Section(header: Text("Attendees")) {
        ForEach(scrum.attendees) { attendee in
          Label(attendee.name, systemImage: "person")
        }
      }
      Section(header: Text("History")) {
        if scrum.history.isEmpty {
          Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
        }
        ForEach(scrum.history) { history in
          HStack {
            Image(systemName: "calendar")
            Text(history.date, style: .date)
          }
        }
      }
    }
    .navigationTitle(scrum.title)
    .toolbar {
      Button("Edit") {
        isPresentingEditView = true
        editingScrum = scrum
      }
    }
    .sheet(isPresented: $isPresentingEditView) {
      NavigationStack {
        ScrumDetailEditView(scrum: $editingScrum)
        // 新規作成、編集で同じ画面を共用する。タイトルとツールバーは新規と編集で違うのでここで設定してる
          .navigationTitle(scrum.title)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                isPresentingEditView = false
              }
            }
            ToolbarItem(placement: .confirmationAction) {
              Button("Done") {
                isPresentingEditView = false
                scrum = editingScrum
              }
            }
          }
      }
    }
    .onAppear {
      print("テスト1")
    }
  }
}

#Preview {
  ScrumDetailView(scrum: .constant(DailyScrum.sampleData[0]))
}
