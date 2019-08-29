// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public final class SymtabCommand: LoadCommand {

    // MARK: Public Initializers

    public init(item: Item<symtab_command>) throws {
        self.item = item

        try super.init(offset: item.offset,
                       size: item.size,
                       kind: LoadCommand.Kind(item.ptr.pointee.cmd),
                       rawData: item.rawData)
    }

    // MARK: Public Instance Properties

    public var stringTableOffset: UInt32 {
        return item.ptr.pointee.stroff
    }

    public var stringTableSize: UInt32 {
        return item.ptr.pointee.strsize
    }

    public var symbolCount: UInt32 {
        return item.ptr.pointee.nsyms
    }

    public var symbolTableOffset: UInt32 {
        return item.ptr.pointee.symoff
    }

    // MARK: Private Instance Properties

    private let item: Item<symtab_command>
}
