// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public class SymtabCommand: LoadCommand {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: Int,
                kind: Kind,
                data: NSMutableData,
                isSwapped: Bool) throws {
        let ptr = try data.extractSymtabCommand(isSwapped)

        self.stringTableOffset = UInt64(ptr.pointee.stroff)
        self.stringTableSize = Int(ptr.pointee.strsize)
        self.symbolCount = Int(ptr.pointee.nsyms)
        self.symbolTableOffset = UInt64(ptr.pointee.symoff)

        try super.init(offset: offset,
                       size: size,
                       kind: kind)
    }

    // MARK: Public Instance Properties

    public let stringTableOffset: UInt64
    public let stringTableSize: Int
    public let symbolCount: Int
    public let symbolTableOffset: UInt64
}
