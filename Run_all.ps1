# Run_all.ps1 – Chay toan bo demo va test mot lan
# Sinh vien: Pham Do Duy Thanh | N24DCDT086 | DT070
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  CHAY DEMO VA KIEM THU – DT070 LinkedQueue" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

Write-Host "`n[1/3] Chay Demo Ca 1..." -ForegroundColor Yellow
julia --startup-file=no demo.jl --ca=1

Write-Host "`n[2/3] Chay Demo Ca 2..." -ForegroundColor Yellow
julia --startup-file=no demo.jl --ca=2

Write-Host "`n[3/3] Chay Bo Kiem Thu..." -ForegroundColor Yellow
julia --startup-file=no test/runtests.jl

Write-Host "`n============================================================" -ForegroundColor Green
Write-Host "  HOAN TAT!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
