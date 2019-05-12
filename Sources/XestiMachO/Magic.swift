// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public struct Magic: Equatable, Hashable, RawRepresentable {

    // MARK: Public Initializers

    public init(_ rawValue: UInt32) throws {
        switch rawValue {
        case FAT_CIGAM,
             FAT_CIGAM_64,
             FAT_MAGIC,
             FAT_MAGIC_64,
             MH_CIGAM,
             MH_CIGAM_64,
             MH_MAGIC,
             MH_MAGIC_64:
            self.rawValue = rawValue

        default:
            throw MachObject.Error.badMagic
        }
    }

    public init?(rawValue: UInt32) {
        try? self.init(rawValue)
    }

    // MARK: Public Instance Properties

    public let rawValue: UInt32
}

// MARK: -

public extension Magic {

    // MARK: Public Instance Properties

    var is64Bit: Bool {
        switch rawValue {
        case FAT_CIGAM_64,
             FAT_MAGIC_64,
             MH_CIGAM_64,
             MH_MAGIC_64:
            return true

        default:
            return false
        }
    }

    var isFat: Bool {
        switch rawValue {
        case FAT_CIGAM,
             FAT_CIGAM_64,
             FAT_MAGIC,
             FAT_MAGIC_64:
            return true

        default:
            return false
        }
    }

    var isSwapped: Bool {
        switch rawValue {
        case FAT_CIGAM,
             FAT_CIGAM_64,
             MH_CIGAM,
             MH_CIGAM_64:
            return true

        default:
            return false
        }
    }
}

// MARK: - CustomStringConvertible

extension Magic: CustomStringConvertible {
    public var description: String {
        switch rawValue {
        case FAT_CIGAM,
             FAT_MAGIC:
            return "FAT_MAGIC"

        case FAT_CIGAM_64,
             FAT_MAGIC_64:
            return "FAT_MAGIC_64"

        case MH_CIGAM,
             MH_MAGIC:
            return "MH_MAGIC"

        case MH_CIGAM_64,
             MH_MAGIC_64:
            return "MH_MAGIC_64"

        default:
            return "'\(rawValue)'"
        }
    }
}
