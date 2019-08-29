// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation
import MachO

public final class MachHeader {

    // MARK: Public Initializers

    public init(item: Item<mach_header>,
                magic: Magic) throws {
        self.itemFormat = .itemFormat32(item)
        self.magic = magic
    }

    public init(item: Item<mach_header_64>,
                magic: Magic) throws {
        self.itemFormat = .itemFormat64(item)
        self.magic = magic
    }

    // MARK: Public Instance Properties

    public let magic: Magic

    public var commandCount: UInt32 {
        get {
            switch itemFormat {
            case let .itemFormat32(item):
                return item.ptr.pointee.ncmds

            case let .itemFormat64(item):
                return item.ptr.pointee.ncmds
            }
        }
        set {
            switch itemFormat {
            case let .itemFormat32(item):
                item.ptr.pointee.ncmds = newValue

            case let .itemFormat64(item):
                item.ptr.pointee.ncmds = newValue
            }
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

    public var fileType: FileType {
        switch itemFormat {
        case let .itemFormat32(item):
            return FileType(item.ptr.pointee.filetype)

        case let .itemFormat64(item):
            return FileType(item.ptr.pointee.filetype)
        }
    }

    public var flags: Flags {
        switch itemFormat {
        case let .itemFormat32(item):
            return Flags(rawValue: item.ptr.pointee.flags)

        case let .itemFormat64(item):
            return Flags(rawValue: item.ptr.pointee.flags)
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

    public var totalCommandSize: UInt32 {
        get {
            switch itemFormat {
            case let .itemFormat32(item):
                return item.ptr.pointee.sizeofcmds

            case let .itemFormat64(item):
                return item.ptr.pointee.sizeofcmds
            }
        }
        set {
            switch itemFormat {
            case let .itemFormat32(item):
                item.ptr.pointee.sizeofcmds = newValue

            case let .itemFormat64(item):
                item.ptr.pointee.sizeofcmds = newValue
            }
        }
    }

    // MARK: Public Instance Methods

    public func copy() throws -> MachHeader {
        switch itemFormat {
        case let .itemFormat32(item):
            return .init(itemFormat: .itemFormat32(try item.copy()),
                         magic: magic)

        case let .itemFormat64(item):
            return .init(itemFormat: .itemFormat64(try item.copy()),
                         magic: magic)
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
        case itemFormat32(Item<mach_header>)
        case itemFormat64(Item<mach_header_64>)
    }

    // MARK: Private Initializers

    private init(itemFormat: ItemFormat,
                 magic: Magic) {
        self.itemFormat = itemFormat
        self.magic = magic
    }

    // MARK: Private Instance Properties

    private let itemFormat: ItemFormat
}

// MARK: -

public extension MachHeader {

    // MARK: Public Instance Properties

    var architecture: MachObject.Architecture {
        return .init(cpuType: cpuType,
                     cpuSubtype: cpuSubtype)
    }
}
