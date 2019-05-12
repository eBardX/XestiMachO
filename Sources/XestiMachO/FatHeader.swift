// © 2019 J. G. Pusey (see LICENSE.md)

public class FatHeader: ItemDescriptor {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: Int,
                magic: Magic,
                archs: [FatArch]) throws {
        guard
            magic.isFat
            else { throw MachObject.Error.badFatHeader }

        self.archs = archs
        self.magic = magic

        try super.init(offset: offset,
                       size: size)
    }

    // MARK: Public Instance Properties

    public let archs: [FatArch]
    public let magic: Magic
}

// MARK: -

public extension FatHeader {

    // MARK: Public Instance Properties

    var architecture: MachObject.Architecture {
        return .universal(archs.map { $0.header.architecture })
    }
}
