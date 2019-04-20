// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

internal struct FatHeader: ItemDescriptor {

    // MARK: Internal Initializers

    internal init?(magic: Magic,
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

    // MARK: Internal Instance Properties

    internal let archs: [FatArch]
    internal let count: Int
    internal let item: Any
    internal let magic: Magic
    internal let offset: UInt64

    internal var architecture: MachObject.Architecture {
        return .universal(archs.map { $0.header.architecture })
    }
}
