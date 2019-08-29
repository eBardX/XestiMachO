// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation
import MachO

public final class FatHeader {

    // MARK: Public Initializers

    public init(item: Item<fat_header>,
                magic: Magic) throws {
        self.item = item
        self.magic = magic
    }

    // MARK: Public Instance Properties

    public let magic: Magic

    public var archCount: UInt32 {
        return item.ptr.pointee.nfat_arch
    }

    public var offset: UInt64 {
        return item.offset
    }

    public var size: UInt32 {
        return item.size
    }

    // MARK: Public Instance Methods

    public func copy() throws -> FatHeader {
        return try .init(item: item.copy(),
                         magic: magic)
    }

    // MARK: Internal Instance Properties

    internal var rawData: Data {
        return item.rawData as Data
    }

    // MARK: Private Instance Properties

    private let item: Item<fat_header>
}
