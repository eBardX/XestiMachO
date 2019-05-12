// © 2019 J. G. Pusey (see LICENSE.md)

import Foundation

public class LinkeditDataCommand: LoadCommand {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: Int,
                kind: Kind,
                data: NSMutableData,
                isSwapped: Bool) throws {
        let ptr = try data.extractLinkeditDataCommand(isSwapped)

        self.dataOffset = UInt64(ptr.pointee.dataoff)
        self.dataSize = Int(ptr.pointee.datasize)

        try super.init(offset: offset,
                       size: size,
                       kind: kind)
    }

    // MARK: Public Instance Properties

    public let dataOffset: UInt64
    public let dataSize: Int
}
