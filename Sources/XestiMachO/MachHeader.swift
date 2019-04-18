// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

internal struct MachHeader: ItemDescriptor {

    // MARK: Public Initializers

    public init?(magic: Magic,
                 offset: UInt64,
                 count: Int,
                 item: Any) {
        guard
            !magic.isFat,
            count > 0,
            (item is mach_header
                || item is mach_header_64)
            else { return nil }

        self.count = count
        self.item = item
        self.magic = magic
        self.offset = offset
    }

    // MARK: Public Instance Properties

    public let count: Int
    public let item: Any
    public let magic: Magic
    public let offset: UInt64

    public var architecture: MachObject.Architecture {
        switch item {
        case let header as mach_header:
            return .init(cpuType: header.cputype,
                         cpuSubtype: header.cpusubtype)

        case let header as mach_header_64:
            return .init(cpuType: header.cputype,
                         cpuSubtype: header.cpusubtype)

        default:
            return .unknown
        }
    }
}
