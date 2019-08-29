// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public class LoadCommand {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: UInt32,
                kind: Kind,
                rawData: NSData) throws {
        self.kind = kind
        self.offset = offset
        self.rawData = rawData as Data
        self.size = size
    }

    // MARK: Public Instance Properties

    public let kind: Kind
    public let offset: UInt64
    public let size: UInt32

    // MARK: Public Instance Methods

    public func copy() throws -> LoadCommand {
        return try .init(offset: offset,
                         size: size,
                         kind: kind,
                         rawData: rawData as NSData)
    }

    // MARK: Internal Instance Properties

    internal let rawData: Data
}
