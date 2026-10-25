param([string]$Julia='julia')
$ErrorActionPreference='Stop'
$codeRoot=$PSScriptRoot
function Run-JuliaStep([string[]]$JuliaArgs) {
    & $Julia @JuliaArgs
    if ($LASTEXITCODE -ne 0) { throw ('Julia failed: '+($JuliaArgs -join ' ')) }
}
Run-JuliaStep @('--version')
for ($caseId=1; $caseId -le 8; $caseId++) {
    Write-Output "=== DEMO $caseId ==="
    Run-JuliaStep @('--startup-file=no',(Join-Path $codeRoot 'demo.jl'),('--ca='+$caseId))
}
Write-Output "=== RUNTESTS (26 CA KIEM THU) ==="
Run-JuliaStep @('--startup-file=no',(Join-Path $codeRoot 'test/runtests.jl'))

Write-Output "=== VERIFY EXHAUSTIVE (ORACLE DOI CHUNG 20.000 THAO TAC) ==="
Run-JuliaStep @('--startup-file=no',(Join-Path $codeRoot 'test/verify_exhaustive.jl'))

Write-Output "=== TEST CATALOG (BANG INPUT/EXPECTED/ACTUAL/PASS) ==="
Run-JuliaStep @('--startup-file=no',(Join-Path $codeRoot 'scripts/test_catalog.jl'))

Write-Output "=== TRACE & SCALES (BANG TRACE VA KHAO SAT 10, 50, 200) ==="
Run-JuliaStep @('--startup-file=no',(Join-Path $codeRoot 'scripts/trace_and_scales.jl'))

Write-Output 'END_TO_END_OK: Tat ca demo, test suite, oracle va khao sat DT070 da hoan thanh xuat sac.'
