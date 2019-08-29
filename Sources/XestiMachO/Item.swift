// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public final class Item<T> {

    // MARK: Public Instance Properties

    public let offset: UInt64
    public let ptr: UnsafeMutablePointer<T>

    public var size: UInt32 {
        return UInt32(swappedData.length)
    }

    // MARK: Public Instance Methods

    public func copy() throws -> Item<T> {
        return try Item(self)
    }

    public func string(at offset: UInt32) throws -> String {
        return try swappedData.extractString(at: offset)
    }

    // MARK: Internal Initializers

    internal init(_: T.Type,
                  offset: UInt64,
                  data: NSMutableData,
                  isSwapped: Bool = false,
                  swapper: ((UnsafeMutablePointer<T>, NXByteOrder) -> Void)? = nil) throws {
        guard
            let copiedData = data.mutableCopy() as? NSMutableData,
            let ptr = copiedData.bindMutable(T.self)
            else { throw MachObject.Error.badItem }

        if isSwapped {
            swapper?(ptr, NX_UnknownByteOrder)
        }

        self.offset = offset
        self.ptr = ptr
        self.rawData = data
        self.swappedData = copiedData
    }

    // MARK: Internal Instance Properties

    internal let rawData: NSMutableData

    // MARK: Private Initializers

    private init(_ template: Item<T>) throws {
        guard
            let data = template.rawData.mutableCopy() as? NSMutableData,
            let copiedData = template.swappedData.mutableCopy() as? NSMutableData,
            let ptr = copiedData.bindMutable(T.self)
            else { throw MachObject.Error.badItem }

        self.offset = template.offset
        self.ptr = ptr
        self.rawData = data
        self.swappedData = copiedData
    }

    // MARK: Private Instance Properties

    private let swappedData: NSMutableData
}
