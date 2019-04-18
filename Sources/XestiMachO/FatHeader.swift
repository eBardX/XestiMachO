// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

internal struct FatHeader: ItemDescriptor {

    // MARK: Public Initializers

    public init?(magic: Magic,
                 offset: UInt64,
                 count: Int,
                 item: Any,
                 archs: [FatArch]) {
        guard
            magic.isFat,
            count > 0,
            item is fat_header
            else { return nil }

        self.archs = archs
        self.count = count
        self.item = item
        self.magic = magic
        self.offset = offset
    }

    // MARK: Public Instance Properties

    public let archs: [FatArch]
    public let count: Int
    public let item: Any
    public let magic: Magic
    public let offset: UInt64

    public var architecture: MachObject.Architecture {
        return .universal(archs.map { $0.header.architecture })
    }
}
