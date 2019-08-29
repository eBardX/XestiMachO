// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation
import MachO

public final class FatArch {

    // MARK: Public Initializers

    public init(item: Item<fat_arch>) throws {
        self.itemFormat = .itemFormat32(item)
    }

    public init(item: Item<fat_arch_64>) throws {
        self.itemFormat = .itemFormat64(item)
    }

    // MARK: Public Instance Properties

    public var alignment: UInt32 {
        switch itemFormat {
        case let .itemFormat32(item):
            return item.ptr.pointee.align

        case let .itemFormat64(item):
            return item.ptr.pointee.align
        }
    }

    public var cpuSubtype: CPUSubtype {
        switch itemFormat {
        case let .itemFormat32(item):
            return CPUSubtype(UInt64(item.ptr.pointee.cputype) << 32 | UInt64(item.ptr.pointee.cpusubtype))

        case let .itemFormat64(item):
            return CPUSubtype(UInt64(item.ptr.pointee.cputype) << 32 | UInt64(item.ptr.pointee.cpusubtype))
        }
    }

    public var cpuType: CPUType {
        switch itemFormat {
        case let .itemFormat32(item):
            return CPUType(UInt32(item.ptr.pointee.cputype))

        case let .itemFormat64(item):
            return CPUType(UInt32(item.ptr.pointee.cputype))
        }
    }

    public var objectOffset: UInt64 {
        switch itemFormat {
        case let .itemFormat32(item):
            return UInt64(item.ptr.pointee.offset)

        case let .itemFormat64(item):
            return item.ptr.pointee.offset
        }
    }

    public var objectSize: UInt64 {
        switch itemFormat {
        case let .itemFormat32(item):
            return UInt64(item.ptr.pointee.size)

        case let .itemFormat64(item):
            return item.ptr.pointee.size
        }
    }

    public var offset: UInt64 {
        switch itemFormat {
        case let .itemFormat32(item):
            return item.offset

        case let .itemFormat64(item):
            return item.offset
        }
    }

    public var size: UInt32 {
        switch itemFormat {
        case let .itemFormat32(item):
            return item.size

        case let .itemFormat64(item):
            return item.size
        }
    }

    // MARK: Public Instance Methods

    public func copy() throws -> FatArch {
        switch itemFormat {
        case let .itemFormat32(item):
            return .init(itemFormat: .itemFormat32(try item.copy()))

        case let .itemFormat64(item):
            return .init(itemFormat: .itemFormat64(try item.copy()))
        }
    }

    // MARK: Internal Instance Properties

    internal var rawData: Data {
        switch itemFormat {
        case let .itemFormat32(item):
            return item.rawData as Data

        case let .itemFormat64(item):
            return item.rawData as Data
        }
    }

    // MARK: Private Nested Types

    private enum ItemFormat {
        case itemFormat32(Item<fat_arch>)
        case itemFormat64(Item<fat_arch_64>)
    }

    // MARK: Private Initializers

    private init(itemFormat: ItemFormat) {
        self.itemFormat = itemFormat
    }

    // MARK: Private Instance Properties

    private let itemFormat: ItemFormat
}

// MARK: -

public extension FatArch {

    // MARK: Public Instance Properties

    var architecture: MachObject.Architecture {
        return .init(cpuType: cpuType,
                     cpuSubtype: cpuSubtype)
    }
}
