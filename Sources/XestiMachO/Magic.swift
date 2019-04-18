// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public struct Magic: Equatable, RawRepresentable {

    // MARK: Public Initializers

    public init?(rawValue: UInt32) {
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
            return nil
        }
    }

    // MARK: Public Instance Properties

    public let rawValue: UInt32

    public var is64Bit: Bool {
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

    public var isFat: Bool {
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

    public var isSwapped: Bool {
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
