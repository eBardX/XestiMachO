// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

internal struct FatArch: ItemDescriptor {

    // MARK: Internal Initializers

    internal init?(offset: UInt64,
                   count: Int,
                   item: Any,
                   header: MachHeader) {
        guard
            count > 0,
            (item is fat_arch
                || item is fat_arch_64)
            else { return nil }

        self.count = count
        self.header = header
        self.item = item
        self.offset = offset
    }

    // MARK: Internal Instance Properties

    internal let count: Int
    internal let header: MachHeader
    internal let item: Any
    internal let offset: UInt64
}
