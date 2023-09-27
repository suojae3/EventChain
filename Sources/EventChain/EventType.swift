import Foundation

enum EventType<DataType> {
    case producer(() -> DataType)
    case consumer((DataType) -> Void)
    case chaining((DataType) -> DataType)
}
