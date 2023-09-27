import Foundation

public class EventChainBuilder<DataType> {
    
    private var events: [(event: EventType<DataType>, description: String)] = []
    
    private let semaphore = DispatchSemaphore(value: 0)
    
    public init() {}
    
    public func setEventCount(_ count: Int) {
        events.reserveCapacity(count)
    }
    
    public func addProducerEvent(_ description: String, event: @escaping () -> DataType) {
        let asyncEvent: () -> DataType = {
            let result = event()
            self.semaphore.signal()
            return result
        }
        events.append((event: .producer(asyncEvent), description: description))
    }
    
    public func addConsumerEvent(_ description: String, event: @escaping (DataType) -> Void) {
        let asyncEvent: (DataType) -> Void = { data in
            event(data)
            self.semaphore.signal()
        }
        events.append((event: .consumer(asyncEvent), description: description))
    }
    
    public func addChainingEvent(_ description: String, event: @escaping (DataType) -> DataType) {
        let asyncEvent: (DataType) -> DataType = { data in
            let result = event(data)
            self.semaphore.signal()
            return result
        }
        events.append((event: .chaining(asyncEvent), description: description))
    }
    
    public func build() -> () -> DataType? {
        return {
            var sharedData: DataType?
            for eventTuple in self.events {
                switch eventTuple.event {
                case .producer(let producer):
                    sharedData = producer()
                    self.semaphore.wait()
                    
                case .consumer(let consumer):
                    if let data = sharedData {
                        consumer(data)
                        sharedData = nil
                        self.semaphore.wait()
                    }
                case .chaining(let chaining):
                    if let data = sharedData {
                        sharedData = chaining(data)
                        self.semaphore.wait()
                    }
                }
            }
            return sharedData
        }
    }
    
    public func describeChain() {
        print("Logic of the chain:")
        for (index, eventTuple) in events.enumerated() {
            print("\(index + 1). \(eventTuple.description)")
        }
    }
    
    public func executeChain() -> DataType? {
        let chain = build()
        return chain()
    }
}
