using namespace System.Management.Automation.Host
param(
    # Sparsity of the matrix effect (1 is fully dense, 0.1 is sparse)
    [ValidateRange(0.0001, 1)][double]$Sparsity = 0.1,
    # Sleep time in milliseconds between each frame
    [ValidateRange(1)][int]$SleepTime = 50,
    [ValidateSet("Windows", "Unix")][string]$Renderer = "Unix",
    [Switch]$SpecialChars,
    [Switch]$Debug
)
# =======================================START=OF=COMPILER==========================================================|
#    The Following Code was added by AP-Compiler 1.6 (APC: 1.2) To Make this program independent of AP-Core Engine
#    GitHub: https://github.com/avdaredevil/AP-Compiler
# ==================================================================================================================|
$Script:PSHell=$(if($PSHell){$PSHell}elseif($PSScriptRoot){$PSScriptRoot}else{"."});
$Script:AP_Console = @{version=[version]'1.2'; isShim = $true}
function B64 {param([Parameter(ValueFromPipeline=$true)][String]$Text, [ValidateSet("UTF8","Unicode")][String]$Encoding = "UTF8")     [System.Text.Encoding]::$Encoding.GetString([System.Convert]::FromBase64String($Text))}
# This syntax is to prevent AV's from misclassifying this as anything but innocuous
& (Get-Alias iex) (B64 "ZnVuY3Rpb24gR2V0LVBhdGgge3BhcmFtKCRtYXRjaCwgW3N0cmluZ10kUGF0aFZhciA9ICJQQVRIIikKDQogICAgJFB0aCA9IFtFbnZpcm9ubWVudF06OkdldEVudmlyb25tZW50VmFyaWFibGUoJFBhdGhWYXIpDQogICAgJElzVW5peCA9ICRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiDQogICAgJFBhdGhTZXAgPSAkKGlmICgkSXNVbml4KSB7IjoifSBlbHNlIHsiOyJ9KQ0KICAgIGlmICghJFB0aCkge3JldHVybiBAKCl9DQogICAgU2V0LVBhdGggJFB0aCAtUGF0aFZhciAkUGF0aFZhcg0KICAgICRkID0gKCRQdGgpLnNwbGl0KCRQYXRoU2VwKQ0KICAgIGlmICgkbWF0Y2gpIHskZCAtbWF0Y2ggJG1hdGNofSBlbHNlIHskZH0NCn0KCmZ1bmN0aW9uIEtleVByZXNzZWQge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bU3RyaW5nW11dJEtleSwgJFN0b3JlID0gIl5eXiIpCg0KICAgIGlmICgkU3RvcmUgLWVxICJeXl4iIC1hbmQgJEhvc3QuVUkuUmF3VUkuS2V5QXZhaWxhYmxlKSB7JFN0b3JlID0gJEhvc3QuVUkuUmF3VUkuUmVhZEtleSgiSW5jbHVkZUtleVVwLE5vRWNobyIpfSBlbHNlIHtpZiAoJFN0b3JlIC1lcSAiXl5eIikge3JldHVybiAkRmFsc2V9fQ0KICAgICRBbnMgPSAkRmFsc2UNCiAgICAkS2V5IHwgJSB7DQogICAgICAgICRTT1VSQ0UgPSAkXw0KICAgICAgICB0cnkgew0KICAgICAgICAgICAgJEFucyA9ICRBbnMgLW9yIChLZXlQcmVzc2VkQ29kZSAkU09VUkNFICRTdG9yZSkNCiAgICAgICAgfSBjYXRjaCB7DQogICAgICAgICAgICBGb3JlYWNoICgkSyBpbiAkU09VUkNFKSB7DQogICAgICAgICAgICAgICAgW1N0cmluZ10kSyA9ICRLDQogICAgICAgICAgICAgICAgaWYgKCRLLmxlbmd0aCAtZ3QgNCAtYW5kICgkS1swLDEsLTEsLTJdIC1qb2luKCIiKSkgLWVxICJ+fn5+Iikgew0KICAgICAgICAgICAgICAgICAgICAkQW5zID0gJEFOUyAtb3IgKEtleVByZXNzZWRDb2RlIChLZXlUcmFuc2xhdGUoJEspKSAkU3RvcmUpDQogICAgICAgICAgICAgICAgfSBlbHNlIHsNCiAgICAgICAgICAgICAgICAgICAgJEFucyA9ICRBTlMgLW9yICgkSy5jaGFycygwKSAtaW4gJFN0b3JlLkNoYXJhY3RlcikNCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICB9DQogICAgcmV0dXJuICRBbnMNCn0KCmZ1bmN0aW9uIEFsaWduLVRleHQge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bU3RyaW5nW11dJFRleHQsIFtWYWxpZGF0ZVNldCgiQ2VudGVyIiwiUmlnaHQiLCJMZWZ0IildW1N0cmluZ10kQWxpZ249J0NlbnRlcicpCg0KICAgIGlmICgkVGV4dC5jb3VudCAtZ3QgMSkgew0KICAgICAgICAkYW5zID0gQCgpDQogICAgICAgIGZvcmVhY2ggKCRsbiBpbiAkVGV4dCkgeyRBbnMgKz0gQWxpZ24tVGV4dCAkbG4gJEFsaWdufQ0KICAgICAgICByZXR1cm4gKCRhbnMpDQogICAgfSBlbHNlIHsNCiAgICAgICAgJFdpblNpemUgPSBbY29uc29sZV06OkJ1ZmZlcldpZHRoDQogICAgICAgICRDbGVhblRleHRTaXplID0gKFN0cmlwLUNvbG9yQ29kZXMgKCIiKyRUZXh0KSkuTGVuZ3RoDQogICAgICAgIGlmICgkQ2xlYW5UZXh0U2l6ZSAtZ2UgJFdpblNpemUpIHsNCiAgICAgICAgICAgICRBcHBlbmRlciA9IEAoIiIpOw0KICAgICAgICAgICAgJGogPSAwDQogICAgICAgICAgICBmb3JlYWNoICgkcCBpbiAwLi4oJENsZWFuVGV4dFNpemUtMSkpew0KICAgICAgICAgICAgICAgIGlmICgoJHArMSklJHdpbnNpemUgLWVxIDApIHskaisrOyRBcHBlbmRlciArPSAiIn0NCiAgICAgICAgICAgICAgICAjICIiKyRqKyIgLSAiKyRwDQogICAgICAgICAgICAgICAgJEFwcGVuZGVyWyRqXSArPSAkVGV4dC5jaGFycygkcCkNCiAgICAgICAgICAgIH0NCiAgICAgICAgICAgIHJldHVybiAoQWxpZ24tVGV4dCAkQXBwZW5kZXIgJEFsaWduKQ0KICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgaWYgKCRBbGlnbiAtZXEgIkNlbnRlciIpIHsNCiAgICAgICAgICAgICAgICByZXR1cm4gKCIgIipbbWF0aF06OnRydW5jYXRlKCgkV2luU2l6ZS0kQ2xlYW5UZXh0U2l6ZSkvMikrJFRleHQpDQogICAgICAgICAgICB9IGVsc2VpZiAoJEFsaWduIC1lcSAiUmlnaHQiKSB7DQogICAgICAgICAgICAgICAgcmV0dXJuICgiICIqKCRXaW5TaXplLSRDbGVhblRleHRTaXplLTEpKyRUZXh0KQ0KICAgICAgICAgICAgfSBlbHNlIHsNCiAgICAgICAgICAgICAgICByZXR1cm4gKCRUZXh0KQ0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgfQ0KfQoKZnVuY3Rpb24gU2V0LVBhdGggew0KICAgIFtjbWRsZXRiaW5kaW5nKCldDQogICAgcGFyYW0oDQogICAgICAgIFtQYXJhbWV0ZXIoTWFuZGF0b3J5ID0gJHRydWUsIFZhbHVlRnJvbVBpcGVsaW5lID0gJHRydWUpXVtzdHJpbmdbXV0kUGF0aCwNCiAgICAgICAgW3N0cmluZ10kUGF0aFZhciA9ICJQQVRIIg0KICAgICkNCiAgICBiZWdpbiB7DQogICAgICAgIFtzdHJpbmdbXV0kRmluYWxQYXRoDQogICAgfQ0KICAgIHByb2Nlc3Mgew0KICAgICAgICAkUGF0aCB8ICUgew0KICAgICAgICAgICAgJEZpbmFsUGF0aCArPSAkXw0KICAgICAgICB9DQogICAgfQ0KICAgIGVuZCB7DQogICAgICAgICRJc1VuaXggPSAkUFNWZXJzaW9uVGFibGUuUGxhdGZvcm0gLWVxICJVbml4Ig0KICAgICAgICAkUGF0aFNlcCA9ICQoaWYgKCRJc1VuaXgpIHsiOiJ9IGVsc2UgeyI7In0pDQogICAgICAgICRQdGggPSAkRmluYWxQYXRoIC1qb2luICRQYXRoU2VwDQogICAgICAgICRQdGggPSAoJFB0aCAtcmVwbGFjZSgiJFBhdGhTZXArIiwgJFBhdGhTZXApIC1yZXBsYWNlKCJcXCRQYXRoU2VwfFxcJCIsICRQYXRoU2VwKSkudHJpbSgkUGF0aFNlcCkNCiAgICAgICAgJFB0aCA9ICgoJFB0aCkuc3BsaXQoJFBhdGhTZXApIHwgc2VsZWN0IC11bmlxdWUpIC1qb2luICRQYXRoU2VwDQogICAgICAgIFtFbnZpcm9ubWVudF06OlNldEVudmlyb25tZW50VmFyaWFibGUoJFBhdGhWYXIsICRQdGgpDQogICAgfQ0KfQoKZnVuY3Rpb24gQVAtQ29udmVydFBhdGgge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bU3RyaW5nXSRQYXRoKQoNCiAgICAkUGF0aFNlcCA9IFtJTy5QYXRoXTo6RGlyZWN0b3J5U2VwYXJhdG9yQ2hhcg0KICAgIHJldHVybiAkUGF0aCAtcmVwbGFjZSANCiAgICAgICAgIjxEZXA+IiwiPExpYj4ke1BhdGhTZXB9RGVwZW5kZW5jaWVzIiAtcmVwbGFjZSANCiAgICAgICAgIjxMaWI+IiwiPEhvbWU+JHtQYXRoU2VwfUFQLUxpYnJhcmllcyIgLXJlcGxhY2UgDQogICAgICAgICI8Q29tcChvbmVudHMpPz4iLCI8SG9tZT4ke1BhdGhTZXB9QVAtQ29tcG9uZW50cyIgLXJlcGxhY2UgDQogICAgICAgICI8SG9tZT4iLCRQU0hlbGx9CgpmdW5jdGlvbiBXcml0ZS1BUCB7DQogICAgW0NtZGxldEJpbmRpbmcoKV0NCiAgICBwYXJhbShbUGFyYW1ldGVyKFZhbHVlRnJvbVBpcGVsaW5lPSR0cnVlLCBNYW5kYXRvcnk9JFRydWUpXSRUZXh0LFtTd2l0Y2hdJE5vU2lnbixbU3dpdGNoXSRQbGFpblRleHQsW1ZhbGlkYXRlU2V0KCJDZW50ZXIiLCJSaWdodCIsIkxlZnQiKV1bU3RyaW5nXSRBbGlnbj0nTGVmdCcsW1N3aXRjaF0kUGFzc1RocnUpDQogICAgYmVnaW4geyRUVCA9IEAoKX0NCiAgICBQcm9jZXNzIHskVFQgKz0gLCRUZXh0fQ0KICAgIEVORCB7DQogICAgICAgICRCbHVlID0gJChpZiAoJFdSSVRFX0FQX0xFR0FDWV9DT0xPUlMpezN9ZWxzZXsnQmx1ZSd9KQ0KICAgICAgICBpZiAoJFRULmNvdW50IC1lcSAxKSB7JFRUID0gJFRUWzBdfTskVGV4dCA9ICRUVA0KICAgICAgICBpZiAoJHRleHQuY291bnQgLWd0IDEgLW9yICR0ZXh0LkdldFR5cGUoKS5OYW1lIC1tYXRjaCAiXFtcXSQiKSB7DQogICAgICAgICAgICByZXR1cm4gJFRleHQgfCA/IHsiJF8ifSB8ICUgew0KICAgICAgICAgICAgICAgIFdyaXRlLUFQICRfIC1Ob1NpZ246JE5vU2lnbiAtUGxhaW5UZXh0OiRQbGFpblRleHQgLUFsaWduICRBbGlnbiAtUGFzc1RocnU6JFBhc3NUaHJ1DQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICAgICAgaWYgKCEkdGV4dCAtb3IgJHRleHQgLW5vdG1hdGNoICJeKCg/PE5OTD54KXwoPzxOUz5ucz8pKXswLDJ9KD88dD5cPiopKD88cz5bXCtcLVwhXCpcI1xAX10pKD88dz4uKikiKSB7cmV0dXJuICRUZXh0fQ0KICAgICAgICAkdGIgID0gIiAgICAiKiRNYXRjaGVzLnQubGVuZ3RoDQogICAgICAgICRDb2wgPSBAeycrJz0nMic7Jy0nPScxMic7JyEnPScxNCc7JyonPSRCbHVlOycjJz0nRGFya0dyYXknOydAJz0nR3JheSc7J18nPSd3aGl0ZSd9WygkU2lnbiA9ICRNYXRjaGVzLlMpXQ0KICAgICAgICBpZiAoISRDb2wpIHtUaHJvdyAiSW5jb3JyZWN0IFNpZ24gWyRTaWduXSBQYXNzZWQhIn0NCiAgICAgICAgJFNpZ24gPSAkKGlmICgkTm9TaWduIC1vciAkTWF0Y2hlcy5OUykgeyIifSBlbHNlIHsiWyRTaWduXSAifSkNCiAgICAgICAgJERhdGEgPSAiJHRiJFNpZ24kKCRNYXRjaGVzLlcpIjtpZiAoISREYXRhKSB7cmV0dXJufQ0KICAgICAgICBpZiAoQVAtUmVxdWlyZSAiZnVuY3Rpb246QWxpZ24tVGV4dCIgLXBhKSB7DQogICAgICAgICAgICAkRGF0YSA9IEFsaWduLVRleHQgLUFsaWduICRBbGlnbiAiJHRiJFNpZ24kKCRNYXRjaGVzLlcpIg0KICAgICAgICB9DQogICAgICAgIGlmICgkUGxhaW5UZXh0KSB7cmV0dXJuICREYXRhfQ0KICAgICAgICBXcml0ZS1Ib3N0IC1Ob05ld0xpbmU6JChbYm9vbF0kTWF0Y2hlcy5OTkwpIC1mICRDb2wgJERhdGENCiAgICAgICAgaWYgKCRQYXNzVGhydSkge3JldHVybiAkRGF0YX0NCiAgICB9DQp9CgpmdW5jdGlvbiBHZXQtV2hlcmUgew0KICAgIFtDbWRsZXRCaW5kaW5nKERlZmF1bHRQYXJhbWV0ZXJTZXROYW1lPSJOb3JtYWwiKV0NCiAgICBwYXJhbSgNCiAgICAgICAgW1BhcmFtZXRlcihNYW5kYXRvcnk9JHRydWUsIFBvc2l0aW9uPTApXVtzdHJpbmddJEZpbGUsDQogICAgICAgIFtTd2l0Y2hdJEFsbCwNCiAgICAgICAgW1BhcmFtZXRlcihQYXJhbWV0ZXJTZXROYW1lPSdOb3JtYWwnKV1bUGFyYW1ldGVyKFBhcmFtZXRlclNldE5hbWU9J1NjYW4nKV1bU3dpdGNoXSRNYW51YWxTY2FuLA0KICAgICAgICBbUGFyYW1ldGVyKFBhcmFtZXRlclNldE5hbWU9J1NjYW4nKV1bU3dpdGNoXSREYmcsDQogICAgICAgIFtQYXJhbWV0ZXIoUGFyYW1ldGVyU2V0TmFtZT0nU2NhbicpXVtzdHJpbmddJFBhdGhWYXIgPSAiUEFUSCINCiAgICApDQogICAgJElzVmVyYm9zZSA9ICREYmcgLW9yICRQU0JvdW5kUGFyYW1ldGVycy5Db250YWluc0tleSgnVmVyYm9zZScpIC1vciAkUFNCb3VuZFBhcmFtZXRlcnMuQ29udGFpbnNLZXkoJ0RlYnVnJykNCiAgICAkV2hlcmVCaW5FeGlzdHMgPSBHZXQtQ29tbWFuZCAid2hlcmUiIC1lYSBTaWxlbnRseUNvbnRpbnVlDQogICAgJElzVW5peCA9ICRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiDQogICAgaWYgKCRGaWxlIC1lcSAid2hlcmUiIC1vciAkRmlsZSAtZXEgIndoZXJlLmV4ZSIpIHtyZXR1cm4gJFdoZXJlQmluRXhpc3RzfQ0KICAgIGlmICgkV2hlcmVCaW5FeGlzdHMgLWFuZCAhJE1hbnVhbFNjYW4pIHsNCiAgICAgICAgJE91dD0kbnVsbA0KICAgICAgICBpZiAoJElzVW5peCkgew0KICAgICAgICAgICAgJE91dCA9IHdoaWNoICRmaWxlIDI+JG51bGwNCiAgICAgICAgfSBlbHNlIHskT3V0ID0gd2hlcmUuZXhlICRmaWxlIDI+JG51bGx9DQogICAgICAgIA0KICAgICAgICBpZiAoISRPdXQpIHtyZXR1cm59DQogICAgICAgIGlmICgkQWxsKSB7cmV0dXJuICRPdXR9DQogICAgICAgIHJldHVybiBAKCRPdXQpWzBdDQogICAgfQ0KICAgIGZvcmVhY2ggKCRGb2xkZXIgaW4gKEdldC1QYXRoIC1QYXRoVmFyICRQYXRoVmFyKSkgew0KICAgICAgICBpZiAoJElzVW5peCkgew0KICAgICAgICAgICAgJExvb2t1cCA9ICIkRm9sZGVyLyRGaWxlIg0KICAgICAgICAgICAgaWYgKCRJc1ZlcmJvc2UpIHtXcml0ZS1BUCAiKkNoZWNraW5nIFskTG9va3VwXSJ9DQogICAgICAgICAgICBpZiAoIShUZXN0LVBhdGggLVBhdGhUeXBlIExlYWYgJExvb2t1cCkpIHtjb250aW51ZX0NCiAgICAgICAgICAgIFJlc29sdmUtUGF0aCAkTG9va3VwIHwgJSBQYXRoDQogICAgICAgICAgICBpZiAoISRBbGwpIHtyZXR1cm59DQogICAgICAgIH0gZWxzZSB7DQogICAgICAgICAgICBmb3JlYWNoICgkRXh0ZW5zaW9uIGluIChHZXQtUGF0aCAtUGF0aFZhciBQQVRIRVhUKSkgew0KICAgICAgICAgICAgICAgICRMb29rdXAgPSAiJEZvbGRlci8kRmlsZSRFeHRlbnNpb24iDQogICAgICAgICAgICAgICAgaWYgKCRJc1ZlcmJvc2UpIHtXcml0ZS1BUCAiKkNoZWNraW5nIFskTG9va3VwXSJ9DQogICAgICAgICAgICAgICAgaWYgKCEoVGVzdC1QYXRoIC1QYXRoVHlwZSBMZWFmICRMb29rdXApKSB7Y29udGludWV9DQogICAgICAgICAgICAgICAgUmVzb2x2ZS1QYXRoICRMb29rdXAgfCAlIFBhdGgNCiAgICAgICAgICAgICAgICBpZiAoISRBbGwpIHtyZXR1cm59DQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICB9DQp9CgpmdW5jdGlvbiBBUC1SZXF1aXJlIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kVHJ1ZSldW0FsaWFzKCJGdW5jdGlvbmFsaXR5IiwiTGlicmFyeSIpXVtTdHJpbmddJExpYiwgW1NjcmlwdEJsb2NrXSRPbkZhaWwsIFtTd2l0Y2hdJFBhc3NUaHJ1KQoNCiAgICAkTG9hZE1vZHVsZSA9IHsNCiAgICAgICAgcGFyYW0oJEZpbGUsW2Jvb2xdJEltcG9ydCkNCiAgICAgICAgdHJ5IHtJbXBvcnQtTW9kdWxlICRGaWxlIC1lYSBzdG9wO3JldHVybiAxfSBjYXRjaCB7fQ0KICAgICAgICAkTGliPUFQLUNvbnZlcnRQYXRoICI8TElCPiI7JExGID0gIiRMaWJcJEZpbGUiDQogICAgICAgIFtzdHJpbmddJGYgPSBpZih0ZXN0LXBhdGggLXQgbGVhZiAkTEYpeyRMRn1lbHNlaWYodGVzdC1wYXRoIC10IGxlYWYgIiRMRi5kbGwiKXsiJExGLmRsbCJ9DQogICAgICAgIGlmICgkZiAtYW5kICRJbXBvcnQpIHtJbXBvcnQtTW9kdWxlICRmfQ0KICAgICAgICByZXR1cm4gJGYNCiAgICB9DQogICAgJFN0YXQgPSAkKHN3aXRjaCAtcmVnZXggKCRMaWIudHJpbSgpKSB7DQogICAgICAgICJeSW50ZXJuZXQkIiAgICAgICAgICAgICAgIHt0ZXN0LWNvbm5lY3Rpb24gZ29vZ2xlLmNvbSAtQ291bnQgMSAtUXVpZXR9DQogICAgICAgICJeb3M6KHdpbnxsaW51eHx1bml4KSQiICAgIHskSXNVbml4ID0gJFBTVmVyc2lvblRhYmxlLlBsYXRmb3JtIC1lcSAiVW5peCI7aWYgKCRNYXRjaGVzWzFdIC1lcSAid2luIikgeyEkSXNVbml4fSBlbHNlIHskSXNVbml4fX0NCiAgICAgICAgIl5hZG1pbiQiICAgICAgICAgICAgICAgICAge1Rlc3QtQWRtaW5pc3RyYXRvcn0NCiAgICAgICAgIl5kZXA6KC4qKSQiICAgICAgICAgICAgICAge0dldC1XaGVyZSAkTWF0Y2hlc1sxXX0NCiAgICAgICAgIl4obGlifG1vZHVsZSk6KC4qKSQiICAgICAgeyRMb2FkTW9kdWxlLmludm9rZSgkTWF0Y2hlc1syXSwgJHRydWUpfQ0KICAgICAgICAiXihsaWJ8bW9kdWxlKV90ZXN0OiguKikkIiB7JExvYWRNb2R1bGUuaW52b2tlKCRNYXRjaGVzWzJdKX0NCiAgICAgICAgIl5mdW5jdGlvbjooLiopJCIgICAgICAgICAge2djbSAkTWF0Y2hlc1sxXSAtZWEgU2lsZW50bHlDb250aW51ZX0NCiAgICAgICAgIl5zdHJpY3RfZnVuY3Rpb246KC4qKSQiICAge1Rlc3QtUGF0aCAiRnVuY3Rpb246XCQoJE1hdGNoZXNbMV0pIn0NCiAgICAgICAgZGVmYXVsdCB7V3JpdGUtQVAgIiFJbnZhbGlkIHNlbGVjdG9yIHByb3ZpZGVkIFskKCIkTGliIi5zcGxpdCgnOicpWzBdKV0iO3Rocm93ICdCQURfU0VMRUNUT1InfQ0KICAgIH0pDQogICAgaWYgKCEkU3RhdCAtYW5kICRPbkZhaWwpIHskT25GYWlsLkludm9rZSgpfQ0KICAgIGlmICgkUGFzc1RocnUgLW9yICEkT25GYWlsKSB7cmV0dXJuICRTdGF0fQ0KfQoKZnVuY3Rpb24gU3RyaXAtQ29sb3JDb2RlcyB7cGFyYW0oJFN0cikKDQogICAgJFN0ciB8ICUgeyRfIC1yZXBsYWNlICIkKFtyZWdleF06OmVzY2FwZSgiJChHZXQtRXNjYXBlKVsiKSlcZCsoXDtcZCspKm0iLCIifQ0KfQoKZnVuY3Rpb24gUGxhY2UtQnVmZmVyZWRDb250ZW50IHtwYXJhbSgkVGV4dCwgJHgsICR5LCBbQ29uc29sZUNvbG9yXSRGb3JlZ3JvdW5kQ29sb3I9W0NvbnNvbGVdOjpGb3JlZ3JvdW5kQ29sb3IsIFtDb25zb2xlQ29sb3JdJEJhY2tncm91bmRDb2xvcj1bQ29uc29sZV06OkJhY2tncm91bmRDb2xvcikKDQogICAgJGNyZCA9IFtNYW5hZ2VtZW50LkF1dG9tYXRpb24uSG9zdC5Db29yZGluYXRlc106Om5ldygkeCwkeSkNCiAgICAkYiA9ICRIb3N0LlVJLlJhd1VJDQogICAgJGFyciA9ICRiLk5ld0J1ZmZlckNlbGxBcnJheShAKCRUZXh0KSwgJEZvcmVncm91bmRDb2xvciwgJEJhY2tncm91bmRDb2xvcikNCiAgICAkeCA9IFtDb25zb2xlXTo6QnVmZmVyV2lkdGgtMS0kVGV4dC5sZW5ndGgNCiAgICAkYi5TZXRCdWZmZXJDb250ZW50cygkY3JkLCAkYXJyKQ0KfQoKZnVuY3Rpb24gS2V5VHJhbnNsYXRlIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kVHJ1ZSldW1N0cmluZ10kS2V5KQoNCiAgICAkSGFzaEtleSA9IEB7DQogICAgICAgICJ+fkN0cmxDfn4iPTY3DQogICAgICAgICJ+flNwYWNlfn4iPTMyDQogICAgICAgICJ+fkVTQ0FQRX5+Ij0yNw0KICAgICAgICAifn5FbnRlcn5+Ij0xMw0KICAgICAgICAifn5TaGlmdH5+Ij0xNg0KICAgICAgICAifn5Db250cm9sfn4iPTE3DQogICAgICAgICJ+fkFsdH5+Ij0xOA0KICAgICAgICAifn5CYWNrU3BhY2V+fiI9OA0KICAgICAgICAifn5EZWxldGV+fiI9NDYNCiAgICAgICAgIn5+ZjF+fiI9MTEyDQogICAgICAgICJ+fmYyfn4iPTExMw0KICAgICAgICAifn5mM35+Ij0xMTQNCiAgICAgICAgIn5+ZjR+fiI9MTE1DQogICAgICAgICJ+fmY1fn4iPTExNg0KICAgICAgICAifn5mNn5+Ij0xMTcNCiAgICAgICAgIn5+Zjd+fiI9MTE4DQogICAgICAgICJ+fmY4fn4iPTExOQ0KICAgICAgICAifn5mOX5+Ij0xMjANCiAgICAgICAgIn5+ZjEwfn4iPTEyMQ0KICAgICAgICAifn5mMTF+fiI9MTIyDQogICAgICAgICJ+fmYxMn5+Ij0xMjMNCiAgICAgICAgIn5+TXV0ZX5+Ij0xNzMNCiAgICAgICAgIn5+SW5zZXJ0fn4iPTQ1DQogICAgICAgICJ+flBhZ2VVcH5+Ij0zMw0KICAgICAgICAifn5QYWdlRG93bn5+Ij0zNA0KICAgICAgICAifn5FTkR+fiI9MzUNCiAgICAgICAgIn5+SE9NRX5+Ij0zNg0KICAgICAgICAifn50YWJ+fiI9OQ0KICAgICAgICAifn5DYXBzTG9ja35+Ij0yMA0KICAgICAgICAifn5OdW1Mb2Nrfn4iPTE0NA0KICAgICAgICAifn5TY3JvbGxMb2Nrfn4iPTE0NQ0KICAgICAgICAifn5XaW5kb3dzfn4iPTkxDQogICAgICAgICJ+fkxlZnR+fiI9MzcNCiAgICAgICAgIn5+VXB+fiI9MzgNCiAgICAgICAgIn5+UmlnaHR+fiI9MzkNCiAgICAgICAgIn5+RG93bn5+Ij00MA0KICAgICAgICAifn5LUDB+fiI9OTYNCiAgICAgICAgIn5+S1Axfn4iPTk3DQogICAgICAgICJ+fktQMn5+Ij05OA0KICAgICAgICAifn5LUDN+fiI9OTkNCiAgICAgICAgIn5+S1A0fn4iPTEwMA0KICAgICAgICAifn5LUDV+fiI9MTAxDQogICAgICAgICJ+fktQNn5+Ij0xMDINCiAgICAgICAgIn5+S1A3fn4iPTEwMw0KICAgICAgICAifn5LUDh+fiI9MTA0DQogICAgICAgICJ+fktQOX5+Ij0xMDUNCiAgICB9DQogICAgaWYgKFtpbnRdJENvbnZlcnQgPSAkSGFzaEtleS4kS2V5KSB7cmV0dXJuICRDb252ZXJ0fQ0KICAgIFRocm93ICJJbnZhbGlkIFNwZWNpYWwgS2V5IENvbnZlcnNpb24iDQp9CgpmdW5jdGlvbiBHZXQtRXNjYXBlIHtbQ2hhcl0weDFifQoKZnVuY3Rpb24gS2V5UHJlc3NlZENvZGUge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bSW50XSRLZXksICRTdG9yZT0iXl5eIikKDQogICAgaWYgKCEkSG9zdC5VSS5SYXdVSS5LZXlBdmFpbGFibGUgLWFuZCAkU3RvcmUgLWVxICJeXl4iKSB7UmV0dXJuICRGYWxzZX0NCiAgICBpZiAoJFN0b3JlIC1lcSAiXl5eIikgeyRTdG9yZSA9ICRIb3N0LlVJLlJhd1VJLlJlYWRLZXkoIkluY2x1ZGVLZXlVcCxOb0VjaG8iKX0NCiAgICByZXR1cm4gKCRLZXkgLWluICRTdG9yZS5WaXJ0dWFsS2V5Q29kZSkNCn0KCmZ1bmN0aW9uIFRlc3QtQWRtaW5pc3RyYXRvciB7DQogICAgaWYgKCRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiKSB7DQogICAgICAgIGlmICgkKHdob2FtaSkgLWVxICJyb290Iikgew0KICAgICAgICAgICAgcmV0dXJuICR0cnVlDQogICAgICAgIH0NCiAgICAgICAgZWxzZSB7DQogICAgICAgICAgICByZXR1cm4gJGZhbHNlDQogICAgICAgIH0NCiAgICB9DQogICAgIyBXaW5kb3dzDQogICAgKE5ldy1PYmplY3QgU2VjdXJpdHkuUHJpbmNpcGFsLldpbmRvd3NQcmluY2lwYWwgKFtTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c0lkZW50aXR5XTo6R2V0Q3VycmVudCgpKSkuSXNJblJvbGUoW1NlY3VyaXR5LlByaW5jaXBhbC5XaW5kb3dzQnVpbHRpblJvbGVdOjpBZG1pbmlzdHJhdG9yKQ0KfQo=")
# ========================================END=OF=COMPILER===========================================================|

function Get-RandomChar {
    if (!$SpecialChars) {return [char](Get-Random -Minimum 33 -Maximum 126)}
   $charSets = @(
        # Katakana characters
        @(0x30A0..0x30FF),
        # Latin letters (uppercase and lowercase)
        @(0x0041..0x005A + 0x0061..0x007A),
        # Digits
        @(0x0030..0x0039),
        # Some special characters
        @(0x0021, 0x0023, 0x0024, 0x0025, 0x002B, 0x003D, 0x003F, 0x0040),
        # Additional Matrix-like symbols
        @(0x25A0, 0x25A1, 0x25B2, 0x25B3, 0x25BC, 0x25BD)
    )

    $weights = @(
        70, # Weight for Katakana
        20, # Weight for Latin letters
        5,  # Weight for digits
        3,  # Weight for special characters
        2   # Weight for additional symbols
    )

    $totalWeight = ($weights | Measure-Object -Sum).Sum
    $randomValue = Get-Random -Minimum 1 -Maximum ($totalWeight + 1)

    $currentWeight = 0
    $selectedSet = -1
    for ($i = 0; $i -lt $weights.Count; $i++) {
        $currentWeight += $weights[$i]
        if ($randomValue -le $currentWeight) {
            $selectedSet = $i
            break
        }
    }

    try {
        $char = [char](Get-Random -InputObject $charSets[$selectedSet])
    } catch {
        Write-Host "Selected set: $selectedSet | Set count: $($charSets.Count)"
        exit
    }

    return $char
}

class MatrixLine {
    [char[]]$Line
    [int]$xOffset
    [int]$Speed = 1
    [int]$Size = 1
    [bool]$IsDead = $false
    hidden [int]$yOffset = 0

    MatrixLine([int]$xOffset) {
        $this.xOffset = $xOffset
        $this.initialize()
        $this.Speed = Get-Random -Minimum 1 -Maximum ([Math]::Max(2, $this.Size * .3))
    }
    MatrixLine([int]$xOffset, [int]$Speed) {
        $this.xOffset = $xOffset
        $this.Speed = $Speed
        $this.initialize()
    }
    Hidden initialize() {
        $this.Line = @()
        $ConsoleHeight = $global:Host.UI.RawUI.WindowSize.Height
        # Randomize the length of the line between 9% and 40% of the console height
        $this.Size = Get-Random -Minimum ([Math]::Max(1, $ConsoleHeight * .09)) -Maximum ([Math]::Min([Math]::Max(2, $ConsoleHeight * .70), 50))
    }
    [bool]ValidateIsInBounds() {
        if ($this.IsDead) { return $false }
        $ConsoleWidth = $global:Host.UI.RawUI.WindowSize.Width
        $ConsoleHeight = $global:Host.UI.RawUI.WindowSize.Height
        if (($this.yOffset - $this.Size - 1) -gt $ConsoleHeight) {
            $this.Die()
            return $false
        }
        if ($this.xOffset -lt 0 -or $this.xOffset -ge $ConsoleWidth) {
            $this.Die()
            return $false
        }
        return $true
    }
    Tick() {
        # Write-AP "x*","n_Ticking ($($this.IsDead) | $($this.ValidateIsInBounds()) | $($this.Line.Length) | $($this.Size) | $($this.yOffset) | $($this.xOffset))"
        if (!$this.ValidateIsInBounds()) { return }
        if ($this.Line.Length -lt $this.Size) {
            $this.Line += Get-RandomChar
        }
        $this.Draw()
        $this.yOffset += $this.Speed
    }
    Draw() {
        $ConsoleHeight = $global:Host.UI.RawUI.WindowSize.Height
        for ($i = 0; $i -lt $this.Line.Length; $i++) {
            if ($this.yOffset + $i -ge $ConsoleHeight) { break }
            $char = Get-RandomChar
            if ($Script:Debug) {Place-BufferedContent -x ([Console]::WindowWidth - 50) -y 0 -Text "  i: $i | $char | $($this.Line.Length) | $($this.yOffset + $i) | $($this.Line.Length - 1) "}
            $RatioToFront = $(if ($i -eq ($this.Line.Length - 1) -and $this.yOffset) {1} else {$i / $this.Line.Length})

            # WriteTo the Correct position
            DrawTo -x $this.xOffset -y ($this.yOffset + $i) -RatioToFront $RatioToFront -text $char
        }
        # Erase the last character of the line
        $LastYs = ($this.yOffset - $this.Line.Length)..($this.yOffset - $this.Line.Length - $this.Speed)
        $LastYs | ? {$_ -ge 0 -and $_ -le $ConsoleHeight} | % {
            DrawTo -x $this.xOffset -y $_ -RatioToFront -1 -text " "
        }
    }
    Die() {
        $this.IsDead = $true
    }
}

function DrawTo([int]$x, [int]$y, [decimal]$RatioToFront, [string]$text) {
    if ($Renderer -eq "Windows") {
        if ($RatioToFront -eq -1) {
            # Clear the position
            Place-BufferedContent -x $x -y $y -Text " "
            return
        }
        $Styles = @{
            ForegroundColor = ""
            BackgroundColor = [Console]::BackgroundColor
        }
        $Styles.ForegroundColor = $(if ($RatioToFront -eq 1) {"White"} elseif ($RatioToFront -ge 0.7) {"Green"} else {"DarkGreen"})
        if ($RatioToFront -ge 0.7) {$Styles.BackgroundColor = "DarkGreen"}
        Place-BufferedContent -x $x -y $y -Text "$text" @Styles
    } elseif ($Renderer -eq "Unix") {
        if ($RatioToFront -eq -1) {
            # Clear the position
            Write-Host -NoNewline "`e[$y;${x}H "
            return
        }

        # Base green color (dark green to bright green)
        $baseGreen = [Math]::Max(0, [Math]::Min(255, [int](50 + (205 * $RatioToFront))))

        # Enhanced glow effect for leading characters
        if ($RatioToFront -gt 0.7) {
            $glowIntensity = ($RatioToFront - 0.7) / 0.3  # Normalized to 0-1 range
            $red = [Math]::Min(255, [int](200 * $glowIntensity))
            $green = 255  # Max brightness for green
            $blue = [Math]::Min(255, [int](100 * $glowIntensity))
            $escapeSequence = "`e[$y;${x}H`e[38;2;$red;$green;$blue m"
        } else {
            $escapeSequence = "`e[$y;${x}H`e[38;2;0;$baseGreen;0m"
        }
        
        Write-Host -NoNewline "$escapeSequence$text`e[0m"
    }
}

function Setup-Console {
    # Back up the current terminal buffer content
    $Script:CurrBuffer = [Rectangle]::new(0, 0, $Host.UI.RawUI.BufferSize.Width, $Host.UI.RawUI.BufferSize.Height)
    if ($Renderer -eq "Windows") {
        try {
            $Script:BufferContent = $Host.UI.RawUI.GetBufferContents($Script:CurrBuffer)
            
            # Save the current cursor position
            $Script:CursorPos = $Host.UI.RawUI.CursorPosition
            
            # Hide the cursor
            [Console]::CursorVisible = $false
        } catch {
            Write-AP "x*","n_Failed to get the current terminal buffer content: $_"
            Start-Sleep 1
        }
    } elseif ($Renderer -eq "Unix") {
        # Print ESC[?47h to save the current terminal buffer content
        Write-Host "`e[?47h"

        # # Save the current cursor position with ESC[s
        # Write-Host "`e[s"

        # Save Cursor Exact Position with ESC[6n
        Write-Host "`e[6n"
        while (!$Host.UI.RawUI.KeyAvailable) {Start-Sleep -Milliseconds 10; if ($iters -gt 15) {
            Write-AP "-[Unix Renderer] Failed to get the cursor position"
            exit
        }}
        $Global:cp = $Script:CursorPosUnix = $(while ($Host.UI.RawUI.KeyAvailable) {
            $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,IncludeKeyUp")
        }).Character -join ""

        # Hide the cursor with ESC[?25l
        Write-Host -NoNewline "`e[?25l"
    }
    Clear-Host
}

function Reset-Console {
    if ($Renderer -eq "Windows") {
        # Show the cursor
        [Console]::CursorVisible = $true

        # Clear the screen
        Clear-Host

        # Restore the original terminal buffer content
        if ($Script:BufferContent) {
            try {
                Write-AP "x*","n_Restoring the original terminal buffer content"
                $Coords = [Coordinates]::new(0, 0)
                $Host.UI.RawUI.SetBufferContents($Coords, $Script:BufferContent)
            } catch {
                Write-Host -f Red "Failed to restore the original terminal buffer content: $_"
            }
        }

        # Restore the original cursor position
        if ($Script:CursorPos) {
            try {
                $Host.UI.RawUI.CursorPosition = $Script:CursorPos
            } catch {
                Write-Host -f Red "Failed to restore the original cursor position: $_"
            }
        }
    } elseif ($Renderer -eq "Unix") {
        # Print ESC[?47l to restore the original terminal buffer content
        Write-Host "`e[?47l"

        # Show the cursor with ESC[?25h
        Write-Host "`e[?25h"

        # # Restore the original cursor position with ESC[u
        # Write-Host "`e[u"

        # Restor the cursor position with ESC[<row>;<column>R
        Write-Host "$Script:CursorPosUnix"
    }
}
$Script:CurrMatrixLines = @()

function Get-GridColumns {
    $ConsoleWidth = $global:Host.UI.RawUI.WindowSize.Width
    return [Math]::Max(1, [Math]::Floor($ConsoleWidth * $Sparsity))
}

function Tick-MatrixAnimation {
    $ConsoleWidth = $global:Host.UI.RawUI.WindowSize.Width
    $TotalColumns = Get-GridColumns
    
    # Make sure CurrMatrixLines is the same length as the console width
    while ($Script:CurrMatrixLines.Length -lt $TotalColumns) {$Script:CurrMatrixLines += $null} # Add nulls until the length is correct
    $Script:CurrMatrixLines = $Script:CurrMatrixLines[0..($TotalColumns - 1)]                   # Trim the array to the correct length
    
    $EmptyLineIndeces = 0..($TotalColumns - 1) | ? { !$Script:CurrMatrixLines[$_] }
    
    0..$Script:CurrMatrixLines.length | % {
        if (!$Script:CurrMatrixLines[$_].IsDead) { return }
        $Script:CurrMatrixLines[$_] = $null # Remove dead lines
    }

    if ($EmptyLineIndeces.Count -ne 0) {
        # Generate Bounds for new Line
        $ColumnWidth = [Math]::Max(1, [int]($ConsoleWidth / $TotalColumns))

        $EmptyLineIndeces | Get-Random | % {
            $ColumnIdx = $_
            $ColumnMin = $ColumnIdx * $ColumnWidth
            $ColumnMax = [Math]::Max($ColumnMin + 1, $ColumnWidth * ($ColumnIdx + 1))
            if ($Debug) {Place-BufferedContent -x ([Console]::WindowWidth - 50) -y 1 -Text "  $ColumnIdx | $ColumnMin | $ColumnMax | $ColumnWidth | $ConsoleWidth/$TotalColumns       "}
            $RandomX = [Math]::Floor((Get-Random -Minimum $ColumnMin -Maximum $ColumnMax))
            $Script:CurrMatrixLines[$ColumnIdx] = [MatrixLine]::new($RandomX)
        }
    }
    
    $CurrMatrixLines | ? {$_} | % { $_.Tick() }
}
function Script-Tick {
    # Detect Escape and reset the terminal
    While ($Host.UI.RawUI.KeyAvailable) {
        $Store = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,IncludeKeyUp")
        if (KeyPressed "~~Escape~~" $Store) {
            Reset-Console
            exit
        }
    }
    Tick-MatrixAnimation
    Start-Sleep -Milliseconds $SleepTime
}

# Set up the console
Setup-Console

# Run the matrix effect
$Script:KnownDims = $Host.UI.RawUI.WindowSize
$SizeChanged = $false
while ($true) {
    # Reset the console if the window size has changed
    while (($Host.UI.RawUI.WindowSize.Width -ne $Script:KnownDims.Width) -or ($Host.UI.RawUI.WindowSize.Height -ne $Script:KnownDims.Height)) {
        Clear-Host
        $Script:KnownDims = $Host.UI.RawUI.WindowSize
        Write-Host "Window size changed. Resetting console. | $($Host.UI.RawUI.WindowSize.Width) | $($Host.UI.RawUI.WindowSize.Height) | $($Script:KnownDims.Width) | $($Script:KnownDims.Height) | $(Get-Random)"
        $SizeChanged = $true
        Start-Sleep 1
    }
    if ($SizeChanged) {Clear-Host;$SizeChanged = $false}
    Script-Tick
}
