import Foundation
import PackagePlugin

@main
struct LocalizePlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {
        let input = target.directory.appending(subpath: "\(target.name)/Resources/en.lproj/Localizable.strings")

        let output = context.pluginWorkDirectory.appending(subpath: "\(target.name)/Localized-Generated.swift")
        try FileManager.default.createDirectory(atPath: output.removingLastComponent().string, withIntermediateDirectories: false)

        let executable = context.package.directory
            .removingLastComponent()
            .appending(subpath: "scripts/Localizable")

        return [
            .prebuildCommand(
                displayName: "Generate Localized.swift [Prebuild Command] for \(target.name)",
                executable: executable,
                arguments: [
                    "generateCode",
                    input,
                    "-o=\(output)",
                    "-m=1"
                ],
                environment: [:],
                outputFilesDirectory: context.pluginWorkDirectory
            )
        ]
    }
}
