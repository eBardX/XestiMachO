// © 2019 J. G. Pusey (see LICENSE.md)

public class ItemDescriptor {

    // MARK: Public Initializers

    public init(offset: UInt64,
                size: Int) throws {
        guard
            size > 0
            else { throw MachObject.Error.badItemDescriptor }

        self.offset = offset
        self.size = size
    }

    // MARK: Public Instance Properties

    let offset: UInt64
    let size: Int
}
