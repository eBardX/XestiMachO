// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public final class DylibCommand: LoadCommand {

    // MARK: Public Initializers

    public init(item: Item<dylib_command>) throws {
        self.item = item
        self.name = ""      // temporary…

        try super.init(offset: item.offset,
                       size: item.size,
                       kind: LoadCommand.Kind(item.ptr.pointee.cmd),
                       rawData: item.rawData)

        self.name = try item.string(at: nameOffset)
    }

    // MARK: Public Instance Properties

    public private(set) var name: String

    public var compatibilityVersion: UInt32 {
        return item.ptr.pointee.dylib.compatibility_version
    }

    public var currentVersion: UInt32 {
        return item.ptr.pointee.dylib.current_version
    }

    public var nameOffset: UInt32 {
        return item.ptr.pointee.dylib.name.offset
    }

    public var timestamp: UInt32 {
        return item.ptr.pointee.dylib.timestamp
    }

    // MARK: Private Instance Properties

    private let item: Item<dylib_command>
}
