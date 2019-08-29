// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public final class RpathCommand: LoadCommand {

    // MARK: Public Initializers

    public init(item: Item<rpath_command>) throws {
        self.item = item
        self.path = ""      // temporary…

        try super.init(offset: item.offset,
                       size: item.size,
                       kind: LoadCommand.Kind(item.ptr.pointee.cmd),
                       rawData: item.rawData)

        self.path = try item.string(at: pathOffset)
    }

    // MARK: Public Instance Properties

    public private(set) var path: String

    public var pathOffset: UInt32 {
        return item.ptr.pointee.path.offset
    }

    // MARK: Private Instance Properties

    private let item: Item<rpath_command>
}
