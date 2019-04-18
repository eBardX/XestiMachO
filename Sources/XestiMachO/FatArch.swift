// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

internal struct FatArch: ItemDescriptor {

    // MARK: Public Initializers

    public init?(offset: UInt64,
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

    // MARK: Public Instance Properties

    public let count: Int
    public let header: MachHeader
    public let item: Any
    public let offset: UInt64
}
