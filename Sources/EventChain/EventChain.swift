// MARK: - Event Type

public typealias ProducerEvent = () -> String
public typealias ConsumerEvent = (String) -> Void

// MARK: - EventChainBuilder

public class EventChainBuilder {
    
    private enum EventType {
        case producer(ProducerEvent)
        case consumer(ConsumerEvent)
    }

    private var events: [(event: EventType, description: String)] = []
    
    public init() {}

    public func setEventCount(_ count: Int) {
        events.reserveCapacity(count)
    }

    public func addProducerEvent(_ description: String, event: @escaping ProducerEvent) {
        events.append((event: .producer(event), description: description))
    }

    public func addConsumerEvent(_ description: String, event: @escaping ConsumerEvent) {
        events.append((event: .consumer(event), description: description))
    }

    public func build() -> () -> Void {
        return {
            var sharedData: String?
            for eventTuple in self.events {
                sharedData = self.execute(eventTuple, with: sharedData)
            }
        }
    }

    private func execute(_ eventTuple: (event: EventType, description: String), with data: String?) -> String? {
        switch eventTuple.event {
        case .producer(let producer):
            return producer()
        case .consumer(let consumer):
            if let data = data {
                consumer(data)
            }
            return nil
        }
    }

    public func describeChain() {
        print("Logic of the chain:")
        for (index, eventTuple) in events.enumerated() {
            print("\(index + 1). \(eventTuple.description)")
        }
    }
}
