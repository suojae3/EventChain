import Foundation

public class ReactiveEventChainBuilder<DataType> {
    
    private var events: [(event: EventType<DataType>, description: String)] = []
    
    public init() {}
    
    public func setEventCount(_ count: Int) {
        events.reserveCapacity(count)
    }
    
    public func addProducerEvent(_ description: String, event: @escaping () -> DataType) {
        events.append((event: .producer(event), description: description))
    }
    
    public func addConsumerEvent(_ description: String, event: @escaping (DataType) -> Void) {
        events.append((event: .consumer(event), description: description))
    }
    
    public func addChainingEvent(_ description: String, event: @escaping (DataType) -> DataType) {
        events.append((event: .transformer(event), description: description))
    }
    
    public func build() -> () -> DataType? {
        return {
            var sharedData: DataType?
            for eventTuple in self.events {
                switch eventTuple.event {
                case .producer(let producer):
                    sharedData = producer()
                case .consumer(let consumer):
                    if let data = sharedData {
                        consumer(data)
                        sharedData = nil
                    }
                case .transformer(let transformer):
                    if let data = sharedData {
                        sharedData = transformer(data)
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
    
    public func bindToObservable(_ observable: Observable<DataType>) {
        observable.bind { [weak self] _ in
            self?.build()()
        }
    }
}
