param([switch]$Build)

$ErrorActionPreference = 'Stop'
$javaCommand = if ($env:JAVA_HOME) {
    Join-Path $env:JAVA_HOME 'bin\java.exe'
} else {
    (Get-Command java -ErrorAction Stop).Source
}
if (-not (Test-Path -LiteralPath $javaCommand)) {
    throw 'JAVA_HOME must point to a JDK 17 or later installation.'
}

Push-Location $PSScriptRoot
try {
    if ($Build -or -not (Test-Path -LiteralPath 'ruoyi-admin\target\ruoyi-admin.jar')) {
        & .\mvnw.cmd -B clean package
        if ($LASTEXITCODE -ne 0) { throw 'Maven build failed.' }
    }
    & $javaCommand '-Duser.timezone=Asia/Shanghai' -jar ruoyi-admin/target/ruoyi-admin.jar
    exit $LASTEXITCODE
} finally {
    Pop-Location
}
