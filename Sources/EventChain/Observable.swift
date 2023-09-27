import Foundation

public class Observable<DataType> {
    
    
    public typealias Observer = (DataType) -> Void
    
    private var observers: [Observer] = []
    
    private var value: DataType? {
        didSet {
            value.map { self.notify($0) }
        }
    }
    
    public init(_ value: DataType? = nil) {
        self.value = value
    }
    
    public func bind(observer: @escaping Observer) {
        observers.append(observer)
        value.map { observer($0) }
    }
    
    private func notify(_ value: DataType) {
        for observer in observers {
            observer(value)
        }
    }
    
    public func update(_ newValue: DataType) {
        value = newValue
    }
}
