import ActivityKit
import ComposableArchitecture
import Foundation
import SwiftUI

extension Activity: Equatable {
    public static func == (lhs: Activity<Attributes>, rhs: Activity<Attributes>) -> Bool {
        lhs.id == rhs.id
    }
}

enum LiveActivityItem: String, CaseIterable, Equatable, Identifiable {
    var id: Self { self }
    case item1 = "🐳"
    case item2 = "🐬"
    case item3 = "🐋"
    case item4 = "🐟"
    case item5 = "🐠"
}

@Reducer
struct LiveActivityReducer {
    @ObservableState
    struct State: Equatable {
        var activity: Activity<SampleLiveActivityAttributes>?
        var centerSelectedItem: LiveActivityItem = .item1
        var bottomSelectedItem: LiveActivityItem = .item1
        var leadingSelectedItem: LiveActivityItem = .item1
    }

    enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case tapStartLiveActivity
        case tapUpdateLiveActivity
        case tapEndLiveActivity
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .tapStartLiveActivity:
                let attributes = SampleLiveActivityAttributes(dynamicIslandLeadingItem: "dynamicIslandLeadingItem",
                                                              dynamicIslandTrailingItem: "dynamicIslandTrailingItem",
                                                              dynamicIslandMinimalItem: "dynamicIslandMinimalItem")
                let contentState = SampleLiveActivityAttributes.ContentState(dynamicIslandCenterItem: state.centerSelectedItem.rawValue,
                                                                             dynamicIslandBottomItem: state.bottomSelectedItem.rawValue,
                                                                             compactLeadingItem: state.leadingSelectedItem.rawValue,
                                                                             compactTrailingItem: Calendar.current.date(byAdding: .minute, value: 8, to: Date()) ?? Date())
                do {
                    state.activity =  try Activity<SampleLiveActivityAttributes>.request(attributes: attributes, content: .init(state: contentState, staleDate: nil))
                } catch (let error) {
                    print(error.localizedDescription)
                }
                return .none
            case .tapUpdateLiveActivity:
                guard let activity = state.activity else { return .none }
                let updateState = SampleLiveActivityAttributes.ContentState(dynamicIslandCenterItem: state.centerSelectedItem.rawValue,
                                                                             dynamicIslandBottomItem: state.bottomSelectedItem.rawValue,
                                                                             compactLeadingItem: state.leadingSelectedItem.rawValue,
                                                                             compactTrailingItem: Calendar.current.date(byAdding: .minute, value: 8, to: Date()) ?? Date())
                return .run { _ in
                    await activity.update(.init(state: updateState, staleDate: nil))
                }
            case .tapEndLiveActivity:
                guard let activity = state.activity else { return .none }
                let updateState = SampleLiveActivityAttributes.ContentState(dynamicIslandCenterItem: state.centerSelectedItem.rawValue,
                                                                            dynamicIslandBottomItem: state.bottomSelectedItem.rawValue,
                                                                            compactLeadingItem: state.leadingSelectedItem.rawValue,
                                                                            compactTrailingItem: Calendar.current.date(byAdding: .minute, value: 8, to: Date()) ?? Date())
                return .run { _ in
                    await activity.end(.init(state: updateState, staleDate: nil), dismissalPolicy: .default)
                }
            }
        }
    }
}

struct LiveActivityView: View {
    @Bindable var store: StoreOf<LiveActivityReducer>

    var body: some View {
        VStack {
            VStack(alignment: .trailing) {
                HStack {
                    Text("DynamicIslandExpandedRegion(.center)")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ItemPickerView(selectedItem: $store.state.centerSelectedItem)

                }
                .padding(4)
                HStack {
                    Text("DynamicIslandExpandedRegion(.bottom)")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ItemPickerView(selectedItem: $store.state.bottomSelectedItem)
                }
                .padding(4)
                HStack {
                    Text("compactLeading")
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    ItemPickerView(selectedItem: $store.state.leadingSelectedItem)
                }
                .padding(4)
            }
            Button(action: {
                store.send(.tapStartLiveActivity)
            }, label: {
                Text("Start Activity")
            })
            .padding(20)
            
            Button(action: {
                
            }, label: {
                Text("Update Activity")
            })
            .padding(20)
            
            Button(action: {
                
            }, label: {
                Text("End Activity")
            })
            .padding(20)
        }
    }

    struct ItemPickerView: View {
        @Binding var selectedItem: LiveActivityItem

        var body: some View {
            Picker("Item", selection: self.$selectedItem) {
                ForEach(LiveActivityItem.allCases) { item in
                    Text(item.rawValue)
                        .tag(item)
                }
            }
        }
    }
}

#Preview {
    LiveActivityView(store: .init(initialState: LiveActivityReducer.State(), reducer: {
        LiveActivityReducer()
    }))
}
