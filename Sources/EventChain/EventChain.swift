// MARK: - Internal Shared Context

class ChainContext {
    var data: [String: Any] = [:]
}

// MARK: - Event Type

typealias ChainEvent = (ChainContext) -> Void
public typealias UserEvent = () -> Void

// MARK: - EventChainBuilder

public class EventChainBuilder {
    private var events: [(event: ChainEvent, description: String)] = []
    private let context = ChainContext()

    public func setEventCount(_ count: Int) {
        events.reserveCapacity(count)
    }

    public func addEvent(_ description: String, event: @escaping UserEvent) {
        let chainEvent: ChainEvent = { _ in
            event()
        }
        events.append((event: chainEvent, description: description))
    }

    public func insertEvent(at index: Int, description: String, event: @escaping UserEvent) {
        guard index >= 0 && index <= events.count else {
            print("Invalid index. Event not inserted.")
            return
        }
        
        let chainEvent: ChainEvent = { _ in
            event()
        }
        events.insert((event: chainEvent, description: description), at: index)
    }

    public func build() -> UserEvent {
        return {
            for eventTuple in self.events {
                eventTuple.event(self.context)
            }
        }
    }

    public func describeChain() {
        print("Logic of the chain:")
        for (index, eventTuple) in events.enumerated() {
            print("\(index + 1). \(eventTuple.description)")
        }
    }
}
