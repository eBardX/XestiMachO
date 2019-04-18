// swift-tools-version:4.2

// © 2019 J. G. Pusey (see LICENSE.md)

import PackageDescription

let package = Package(name: "XestiMachO",
                      products: [.library(name: "XestiMachO",
                                          targets: ["XestiMachO"])],
                      dependencies: [.package(url: "https://github.com/eBardX/XestiPath.git",
                                              from: "1.0.0")],
                      targets: [.target(name: "XestiMachO",
                                        dependencies: ["XestiPath"])])
