function Build-BrowserSection {
    return @(
        [ToolVersionNode]::new("Safari", $(Get-SafariVersion))
        [ToolVersionNode]::new("SafariDriver", $(Get-SafariDriverVersion))
        [ToolVersionNode]::new("Google Chrome", $(Get-ChromeVersion))
        [ToolVersionNode]::new("ChromeDriver", $(Get-ChromeDriverVersion))
        [ToolVersionNode]::new("Microsoft Edge", $(Get-EdgeVersion))
        [ToolVersionNode]::new("Microsoft Edge WebDriver", $(Get-EdgeDriverVersion))
        [ToolVersionNode]::new("Mozilla Firefox", $(Get-FirefoxVersion))
        [ToolVersionNode]::new("geckodriver", $(Get-GeckodriverVersion))
        [ToolVersionNode]::new("Selenium server", $(Get-SeleniumVersion))
    )
}

function Get-SafariVersion {
    $version = Run-Command "defaults read /Applications/Safari.app/Contents/Info CFBundleShortVersionString"
    $build = Run-Command "defaults read /Applications/Safari.app/Contents/Info CFBundleVersion"
    write-host "Safari version: $version ($build)"
    return "$version ($build)"
}

function Get-SafariDriverVersion {
    $version = Run-Command "safaridriver --version" | Take-Part -Part 3,4
    write-host "SafariDriver version: $version"
    return $version
}

function Get-ChromeVersion {
    $chromePath = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    $version = Run-Command "'${chromePath}' --version"
    write-host "Chrome version: $version"
    return ($version -replace ("^Google Chrome")).Trim()
}

function Get-ChromeDriverVersion {
    $rawOutput = Run-Command "chromedriver --version"
    $version = $rawOutput | Take-Part -Part 1
    write-host "ChromeDriver version: $version"
    return $version
}

function Get-EdgeVersion {
    $edgePath = "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
    $version = Run-Command "'${edgePath}' --version"
    write-host "Edge version: $version"
    return ($version -replace ("^Microsoft Edge")).Trim()
}

function Get-EdgeDriverVersion {
    $edgeRiver = Run-Command "msedgedriver --version" | Take-Part -Part 3
    write-host "EdgeDriver version: $edgeRiver"
    return $edgeRiver
}

function Get-FirefoxVersion {
    $firefoxPath = "/Applications/Firefox.app/Contents/MacOS/firefox"
    $version = Run-Command "'${firefoxPath}' --version"
    write-host "Firefox version: $version"
    return ($version -replace "^Mozilla Firefox").Trim()
}

function Get-GeckodriverVersion {
    $version = Run-Command "geckodriver --version" | Select-Object -First 1
    write-host "Geckodriver version: $version"
    return ($version -replace "^geckodriver").Trim()
}

function Get-SeleniumVersion {
    try {
        $seleniumServer = Get-Item -Path "/opt/homebrew/bin/selenium-server" -ErrorAction SilentlyContinue
        if ($seleniumServer) {
            $seleniumServerPath = $seleniumServer.Target
            $seleniumVersion = ($seleniumServerPath -split '/')[5]
            Write-Host "Selenium version: $seleniumVersion"
            return $seleniumVersion
        } else {
            Write-Host "Error: Selenium server not found."
            return $null
        }
    } catch {
        Write-Host "Error: Unable to get Selenium version."
        return $null
    }
}


function Build-BrowserWebdriversEnvironmentTable {
    $node = [HeaderNode]::new("Environment variables")

    $table = @(
        @{
            "Name" = "CHROMEWEBDRIVER"
            "Value" = $env:CHROMEWEBDRIVER
        },
        @{
            "Name" = "EDGEWEBDRIVER"
            "Value" = $env:EDGEWEBDRIVER
        },
        @{
            "Name" = "GECKOWEBDRIVER"
            "Value" = $env:GECKOWEBDRIVER
        }
    ) | ForEach-Object {
        [PSCustomObject] @{
            "Name" = $_.Name
            "Value" = $_.Value
        }
    }

    $node.AddTable($table)

    return $node
}
