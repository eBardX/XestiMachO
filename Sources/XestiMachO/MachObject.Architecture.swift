// © 2019 J. G. Pusey (see LICENSE.md)

public extension MachObject {
    enum Architecture {
        case arm
        case arm64
        case arm64_32                   // swiftlint:disable:this identifier_name
        case arm64e
        case armv4t
        case armv5tej
        case armv6
        case armv6m
        case armv7
        case armv7em
        case armv7k
        case armv7m
        case armv7s
        case i386
        case universal([Architecture])
        case unknown
        case x86_64                     // swiftlint:disable:this identifier_name
        case x86_64h                    // swiftlint:disable:this identifier_name
    }
}

// MARK: -

public extension MachObject.Architecture {

    // MARK: Public Initializers

    init(cpuType: CPUType,
         cpuSubtype: CPUSubtype) {
        switch cpuType {
        case .CPU_TYPE_ARM:
            switch cpuSubtype {
            case .CPU_SUBTYPE_ARM_V4T:
                self = .armv4t

            case .CPU_SUBTYPE_ARM_V5TEJ:
                self = .armv5tej

            case .CPU_SUBTYPE_ARM_V6:
                self = .armv6

            case .CPU_SUBTYPE_ARM_V6M:
                self = .armv6m

            case .CPU_SUBTYPE_ARM_V7:
                self = .armv7

            case .CPU_SUBTYPE_ARM_V7EM:
                self = .armv7em

            case .CPU_SUBTYPE_ARM_V7K:
                self = .armv7k

            case .CPU_SUBTYPE_ARM_V7M:
                self = .armv7m

            case .CPU_SUBTYPE_ARM_V7S:
                self = .armv7s

            default:
                self = .arm
            }

        case .CPU_TYPE_ARM64:
            switch cpuSubtype {
            case .CPU_SUBTYPE_ARM64_E:
                self = .arm64e

            default:
                self = .arm64
            }

        case .CPU_TYPE_ARM64_32:
            self = .arm64_32

        case .CPU_TYPE_I386:
            self = .i386

        case .CPU_TYPE_X86_64:
            switch cpuSubtype {
            case .CPU_SUBTYPE_X86_64_H:
                self = .x86_64h

            default:
                self = .x86_64
            }

        default:
            self = .unknown
        }
    }
}

// MARK: - CustomStringConvertible

extension MachObject.Architecture: CustomStringConvertible {
    public var description: String {
        switch self {
        case .arm:
            return "arm"

        case .arm64:
            return "arm64"

        case .arm64e:
            return "arm64e"

        case .arm64_32:
            return "arm64_32"

        case .armv4t:
            return "armv4t"

        case .armv5tej:
            return "armv5tej"

        case .armv6:
            return "armv6"

        case .armv6m:
            return "armv6m"

        case .armv7:
            return "armv7"

        case .armv7em:
            return "armv7em"

        case .armv7k:
            return "armv7k"

        case .armv7m:
            return "armv7m"

        case .armv7s:
            return "armv7s"

        case .i386:
            return "i386"

        case let .universal(archs):
            return archs.map { $0.description }.joined(separator: " ")

        case .unknown:
            return "unknown"

        case .x86_64:
            return "x86_64"

        case .x86_64h:
            return "x86_64h"
        }
    }
}
