// © 2019 J. G. Pusey (see LICENSE.md)

import MachO

public extension MachObject {
    enum Architecture {
        case arm
        case arm64
        case arm64_32
        case armv6
        case armv7
        case armv7s
        case armv8
        case i386
        case universal([Architecture])
        case unknown
        case x86
        case x86_64
    }
}

public extension MachObject.Architecture {
    init(cpuType: cpu_type_t,
         cpuSubtype: cpu_subtype_t) {
        switch cpuType {
        case CPU_TYPE_ARM:
            switch cpuSubtype {
            case CPU_SUBTYPE_ARM_V6:
                self = .armv6

            case CPU_SUBTYPE_ARM_V7:
                self = .armv7

            case CPU_SUBTYPE_ARM_V7S:
                self = .armv7s

            case CPU_SUBTYPE_ARM_V8:
                self = .armv8

            default:
                self = .arm
            }

        case CPU_TYPE_ARM64:
            self = .arm64

        case CPU_TYPE_ARM64_32:
            self = .arm64_32

        case CPU_TYPE_I386:
            self = .i386

        case CPU_TYPE_X86:
            self = .x86

        case CPU_TYPE_X86_64:
            self = .x86_64

        default:
            self = .unknown
        }
    }
}
