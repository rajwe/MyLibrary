import Foundation
import PackagePlugin

@main
struct LocalizePlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        let input = target.directory.appending(subpath: "\(target.name)/Resources/en.lproj/Localizable.strings")

        let output = context.pluginWorkDirectory.appending(subpath: "\(target.name)/Localized.swift")
//        try FileManager.default.createDirectory(atPath: output.removingLastComponent().string, withIntermediateDirectories: false)
        debugPrint("PluginWorkDirectory: \(context.pluginWorkDirectory)")

        let executable = context.package.directory
            .removingLastComponent()
            .appending(subpath: "scripts/Localizable")
        debugPrint("Excecutable \(executable)")

        return [
            .buildCommand(
                displayName: "Generate Localized.swift [build Command] for \(target.name)",
                executable: executable,
                arguments: [
                    "generateCode",
                    input,
                    "-o=\(output)",
                    "-m=1"
                ],
                environment: [:],
                inputFiles: [input],
                outputFiles: [output]
            )
        ]
    }
}
