//
//  EventsView.swift
//  UDFTest
//
//  Created by Vladislav Myakotin on 23.11.2021.
//

import SwiftUI
import Combine
import ComposableArchitecture

public struct EventsView: View {

    private var store: Store<EventsState, EventsAction>

    public init(store: Store<EventsState, EventsAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.filteredEvents) { event in
                    NavigationLink(destination: Text(event.name), tag: event, selection: viewStore.binding(
                        get: \.selectedEvent,
                        send: EventsAction.select
                    )) {
                        Text(event.name)
                        Text(event.date.description)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    EventFilterPicker(binding: viewStore.binding(
                        get: \.filter,
                        send: EventsAction.set(filter:)
                    ))
                }
            }
            .navigationTitle("Events")
        }
    }
}

public struct Speech: Equatable, Hashable {
    public var name: String
    public var speakerName: String
}

public struct Event: Equatable, Identifiable, Hashable {
    public var id: UUID = UUID()
    public var name: String
    public var description: String
    public var speeches: [Speech]
    public var date: Date

}

public enum EventsFilter {
    case future
    case past
}

public struct EventsState: Equatable {
    public var events: [Event]
    public var filteredEvents: [Event] {
        let today = Date()
        switch self.filter {
        case .future:
            return self.events
                .filter { $0.date >= today }
                .sorted { $0.date > $1.date }
        case .past:
            return self.events
                .filter { $0.date < today }
                .sorted { $0.date > $1.date }
        }
    }
    public var filter: EventsFilter = .future
    public var selectedEvent: Event?
}

public enum EventsAction {
    case set(filter: EventsFilter)
    case refresh
    case select(event: Event?)
}

extension Reducer where State == EventsState, Action == EventsAction, Environment == Void {
    static let events = Reducer { state, action, env in
        switch action {
        case .refresh:
            return .none
        case let .select(event):
            state.selectedEvent = event
            return .none
        case let .set(filter):
            state.filter = filter
            return .none
        }
    }
}

#if DEBUG
struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventsView(store: .init(
                initialState: .init(events: [
                    Event(
                        name: "Ивент 1",
                        description: "dsfsdf",
                        speeches: [],
                        date: Date()
                    ),
                    Event(
                        name: "Ивент 2",
                        description: "dsfsdf",
                        speeches: [],
                        date: Date().addingTimeInterval(-60*60*24*3)
                    ),
                    Event(
                        name: "Ивент 3",
                        description: "dsfsdf",
                        speeches: [],
                        date: Date().addingTimeInterval(-60*60*24*2)
                    ),
                    Event(
                        name: "Ивент 4",
                        description: "dsfsdf",
                        speeches: [],
                        date: Date().addingTimeInterval(-60*60*24)
                    ),
                    Event(
                        name: "Ивент 5",
                        description: "dsfsdf",
                        speeches: [],
                        date: Date().addingTimeInterval(60*60*24*2)
                    )
                ]),
                reducer: .events,
                environment: ()
            ))
        }
    }
}
#endif

struct EventFilterPicker: View {
    var binding: Binding<EventsFilter>

    var body: some View {
        Picker("Events filter", selection: binding) {
            Text("Future").tag(EventsFilter.future)
            Text("Past").tag(EventsFilter.past)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
