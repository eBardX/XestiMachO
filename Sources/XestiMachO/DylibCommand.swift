// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public class DylibCommand: LoadCommand {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: Int,
                kind: Kind,
                data: NSMutableData,
                isSwapped: Bool) throws {
        let ptr = try data.extractDylibCommand(isSwapped)
        let nameOffset = Int(ptr.pointee.dylib.name.offset)

        self.compatibilityVersion = ptr.pointee.dylib.compatibility_version
        self.currentVersion = ptr.pointee.dylib.current_version
        self.name = try data.extractString(at: nameOffset)
        self.nameOffset = nameOffset
        self.timestamp = ptr.pointee.dylib.timestamp

        try super.init(offset: offset,
                       size: size,
                       kind: kind)
    }

    // MARK: Public Instance Properties

    public let compatibilityVersion: UInt32
    public let currentVersion: UInt32
    public let name: String
    public let nameOffset: Int
    public let timestamp: UInt32
}
