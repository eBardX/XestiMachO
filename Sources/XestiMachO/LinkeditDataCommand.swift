// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public final class LinkeditDataCommand: LoadCommand {

    // MARK: Public Initializers

    public init(item: Item<linkedit_data_command>) throws {
        self.item = item

        try super.init(offset: item.offset,
                       size: item.size,
                       kind: LoadCommand.Kind(item.ptr.pointee.cmd),
                       rawData: item.rawData)
    }

    // MARK: Public Instance Properties

    public var dataOffset: UInt32 {
        return item.ptr.pointee.dataoff
    }

    public var dataSize: UInt32 {
        return item.ptr.pointee.datasize
    }

    // MARK: Private Instance Properties

    private let item: Item<linkedit_data_command>
}
