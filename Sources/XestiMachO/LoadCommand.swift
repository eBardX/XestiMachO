// © 2019 J. G. Pusey (see LICENSE.md)

public class LoadCommand: ItemDescriptor {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: Int,
                kind: Kind) throws {
        self.kind = kind

        try super.init(offset: offset,
                       size: size)
    }

    // MARK: Public Instance Properties

    public let kind: Kind
}
