<#
|====================================================================================>|
   Matrix Animation [PwShell] by APoorv Verma [AP] on 8/21/2024
|====================================================================================>|
      $) Multiple renderers (Windows, Unix)
      $) Random Character Generation (+ Special Character Mode, like from the movie)
      $) Object Oriented Model for Matrix Line (using Ticking logic)
      $) Buffer / Cursor Position Saving (platform agnostic)
      $) Dynamic Console Size Detection
      $) Restore Console Properties upon Close
|====================================================================================>|
#>
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
& (Get-Alias iex) (B64 "ZnVuY3Rpb24gU3RyaXAtQ29sb3JDb2RlcyB7cGFyYW0oJFN0cikKDQogICAgJFN0ciB8ICUgeyRfIC1yZXBsYWNlICIkKFtyZWdleF06OmVzY2FwZSgiJChHZXQtRXNjYXBlKVsiKSlcZCsoXDtcZCspKm0iLCIifQ0KfQoKZnVuY3Rpb24gQVAtUmVxdWlyZSB7cGFyYW0oW1BhcmFtZXRlcihNYW5kYXRvcnk9JFRydWUpXVtBbGlhcygiRnVuY3Rpb25hbGl0eSIsIkxpYnJhcnkiKV1bU3RyaW5nXSRMaWIsIFtTY3JpcHRCbG9ja10kT25GYWlsLCBbU3dpdGNoXSRQYXNzVGhydSkKDQogICAgJExvYWRNb2R1bGUgPSB7DQogICAgICAgIHBhcmFtKCRGaWxlLFtib29sXSRJbXBvcnQpDQogICAgICAgIHRyeSB7SW1wb3J0LU1vZHVsZSAkRmlsZSAtZWEgc3RvcDtyZXR1cm4gMX0gY2F0Y2gge30NCiAgICAgICAgJExpYj1BUC1Db252ZXJ0UGF0aCAiPExJQj4iOyRMRiA9ICIkTGliXCRGaWxlIg0KICAgICAgICBbc3RyaW5nXSRmID0gaWYodGVzdC1wYXRoIC10IGxlYWYgJExGKXskTEZ9ZWxzZWlmKHRlc3QtcGF0aCAtdCBsZWFmICIkTEYuZGxsIil7IiRMRi5kbGwifQ0KICAgICAgICBpZiAoJGYgLWFuZCAkSW1wb3J0KSB7SW1wb3J0LU1vZHVsZSAkZn0NCiAgICAgICAgcmV0dXJuICRmDQogICAgfQ0KICAgICRTdGF0ID0gJChzd2l0Y2ggLXJlZ2V4ICgkTGliLnRyaW0oKSkgew0KICAgICAgICAiXkludGVybmV0JCIgICAgICAgICAgICAgICB7dGVzdC1jb25uZWN0aW9uIGdvb2dsZS5jb20gLUNvdW50IDEgLVF1aWV0fQ0KICAgICAgICAiXm9zOih3aW58bGludXh8dW5peCkkIiAgICB7JElzVW5peCA9ICRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiO2lmICgkTWF0Y2hlc1sxXSAtZXEgIndpbiIpIHshJElzVW5peH0gZWxzZSB7JElzVW5peH19DQogICAgICAgICJeYWRtaW4kIiAgICAgICAgICAgICAgICAgIHtUZXN0LUFkbWluaXN0cmF0b3J9DQogICAgICAgICJeZGVwOiguKikkIiAgICAgICAgICAgICAgIHtHZXQtV2hlcmUgJE1hdGNoZXNbMV19DQogICAgICAgICJeKGxpYnxtb2R1bGUpOiguKikkIiAgICAgIHskTG9hZE1vZHVsZS5pbnZva2UoJE1hdGNoZXNbMl0sICR0cnVlKX0NCiAgICAgICAgIl4obGlifG1vZHVsZSlfdGVzdDooLiopJCIgeyRMb2FkTW9kdWxlLmludm9rZSgkTWF0Y2hlc1syXSl9DQogICAgICAgICJeZnVuY3Rpb246KC4qKSQiICAgICAgICAgIHtnY20gJE1hdGNoZXNbMV0gLWVhIFNpbGVudGx5Q29udGludWV9DQogICAgICAgICJec3RyaWN0X2Z1bmN0aW9uOiguKikkIiAgIHtUZXN0LVBhdGggIkZ1bmN0aW9uOlwkKCRNYXRjaGVzWzFdKSJ9DQogICAgICAgIGRlZmF1bHQge1dyaXRlLUFQICIhSW52YWxpZCBzZWxlY3RvciBwcm92aWRlZCBbJCgiJExpYiIuc3BsaXQoJzonKVswXSldIjt0aHJvdyAnQkFEX1NFTEVDVE9SJ30NCiAgICB9KQ0KICAgIGlmICghJFN0YXQgLWFuZCAkT25GYWlsKSB7JE9uRmFpbC5JbnZva2UoKX0NCiAgICBpZiAoJFBhc3NUaHJ1IC1vciAhJE9uRmFpbCkge3JldHVybiAkU3RhdH0NCn0KCmZ1bmN0aW9uIFRlc3QtQWRtaW5pc3RyYXRvciB7DQogICAgaWYgKCRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiKSB7DQogICAgICAgIGlmICgkKHdob2FtaSkgLWVxICJyb290Iikgew0KICAgICAgICAgICAgcmV0dXJuICR0cnVlDQogICAgICAgIH0NCiAgICAgICAgZWxzZSB7DQogICAgICAgICAgICByZXR1cm4gJGZhbHNlDQogICAgICAgIH0NCiAgICB9DQogICAgIyBXaW5kb3dzDQogICAgKE5ldy1PYmplY3QgU2VjdXJpdHkuUHJpbmNpcGFsLldpbmRvd3NQcmluY2lwYWwgKFtTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c0lkZW50aXR5XTo6R2V0Q3VycmVudCgpKSkuSXNJblJvbGUoW1NlY3VyaXR5LlByaW5jaXBhbC5XaW5kb3dzQnVpbHRpblJvbGVdOjpBZG1pbmlzdHJhdG9yKQ0KfQoKZnVuY3Rpb24gS2V5VHJhbnNsYXRlIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kVHJ1ZSldW1N0cmluZ10kS2V5KQoNCiAgICAkSGFzaEtleSA9IEB7DQogICAgICAgICJ+fkN0cmxDfn4iPTY3DQogICAgICAgICJ+flNwYWNlfn4iPTMyDQogICAgICAgICJ+fkVTQ0FQRX5+Ij0yNw0KICAgICAgICAifn5FbnRlcn5+Ij0xMw0KICAgICAgICAifn5TaGlmdH5+Ij0xNg0KICAgICAgICAifn5Db250cm9sfn4iPTE3DQogICAgICAgICJ+fkFsdH5+Ij0xOA0KICAgICAgICAifn5CYWNrU3BhY2V+fiI9OA0KICAgICAgICAifn5EZWxldGV+fiI9NDYNCiAgICAgICAgIn5+ZjF+fiI9MTEyDQogICAgICAgICJ+fmYyfn4iPTExMw0KICAgICAgICAifn5mM35+Ij0xMTQNCiAgICAgICAgIn5+ZjR+fiI9MTE1DQogICAgICAgICJ+fmY1fn4iPTExNg0KICAgICAgICAifn5mNn5+Ij0xMTcNCiAgICAgICAgIn5+Zjd+fiI9MTE4DQogICAgICAgICJ+fmY4fn4iPTExOQ0KICAgICAgICAifn5mOX5+Ij0xMjANCiAgICAgICAgIn5+ZjEwfn4iPTEyMQ0KICAgICAgICAifn5mMTF+fiI9MTIyDQogICAgICAgICJ+fmYxMn5+Ij0xMjMNCiAgICAgICAgIn5+TXV0ZX5+Ij0xNzMNCiAgICAgICAgIn5+SW5zZXJ0fn4iPTQ1DQogICAgICAgICJ+flBhZ2VVcH5+Ij0zMw0KICAgICAgICAifn5QYWdlRG93bn5+Ij0zNA0KICAgICAgICAifn5FTkR+fiI9MzUNCiAgICAgICAgIn5+SE9NRX5+Ij0zNg0KICAgICAgICAifn50YWJ+fiI9OQ0KICAgICAgICAifn5DYXBzTG9ja35+Ij0yMA0KICAgICAgICAifn5OdW1Mb2Nrfn4iPTE0NA0KICAgICAgICAifn5TY3JvbGxMb2Nrfn4iPTE0NQ0KICAgICAgICAifn5XaW5kb3dzfn4iPTkxDQogICAgICAgICJ+fkxlZnR+fiI9MzcNCiAgICAgICAgIn5+VXB+fiI9MzgNCiAgICAgICAgIn5+UmlnaHR+fiI9MzkNCiAgICAgICAgIn5+RG93bn5+Ij00MA0KICAgICAgICAifn5LUDB+fiI9OTYNCiAgICAgICAgIn5+S1Axfn4iPTk3DQogICAgICAgICJ+fktQMn5+Ij05OA0KICAgICAgICAifn5LUDN+fiI9OTkNCiAgICAgICAgIn5+S1A0fn4iPTEwMA0KICAgICAgICAifn5LUDV+fiI9MTAxDQogICAgICAgICJ+fktQNn5+Ij0xMDINCiAgICAgICAgIn5+S1A3fn4iPTEwMw0KICAgICAgICAifn5LUDh+fiI9MTA0DQogICAgICAgICJ+fktQOX5+Ij0xMDUNCiAgICB9DQogICAgaWYgKFtpbnRdJENvbnZlcnQgPSAkSGFzaEtleS4kS2V5KSB7cmV0dXJuICRDb252ZXJ0fQ0KICAgIFRocm93ICJJbnZhbGlkIFNwZWNpYWwgS2V5IENvbnZlcnNpb24iDQp9CgpmdW5jdGlvbiBLZXlQcmVzc2VkQ29kZSB7cGFyYW0oW1BhcmFtZXRlcihNYW5kYXRvcnk9JFRydWUpXVtJbnRdJEtleSwgJFN0b3JlPSJeXl4iKQoNCiAgICBpZiAoISRIb3N0LlVJLlJhd1VJLktleUF2YWlsYWJsZSAtYW5kICRTdG9yZSAtZXEgIl5eXiIpIHtSZXR1cm4gJEZhbHNlfQ0KICAgIGlmICgkU3RvcmUgLWVxICJeXl4iKSB7JFN0b3JlID0gJEhvc3QuVUkuUmF3VUkuUmVhZEtleSgiSW5jbHVkZUtleVVwLE5vRWNobyIpfQ0KICAgIHJldHVybiAoJEtleSAtaW4gJFN0b3JlLlZpcnR1YWxLZXlDb2RlKQ0KfQoKZnVuY3Rpb24gR2V0LVBhdGgge3BhcmFtKCRtYXRjaCwgW3N0cmluZ10kUGF0aFZhciA9ICJQQVRIIikKDQogICAgJFB0aCA9IFtFbnZpcm9ubWVudF06OkdldEVudmlyb25tZW50VmFyaWFibGUoJFBhdGhWYXIpDQogICAgJElzVW5peCA9ICRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiDQogICAgJFBhdGhTZXAgPSAkKGlmICgkSXNVbml4KSB7IjoifSBlbHNlIHsiOyJ9KQ0KICAgIGlmICghJFB0aCkge3JldHVybiBAKCl9DQogICAgU2V0LVBhdGggJFB0aCAtUGF0aFZhciAkUGF0aFZhcg0KICAgICRkID0gKCRQdGgpLnNwbGl0KCRQYXRoU2VwKQ0KICAgIGlmICgkbWF0Y2gpIHskZCAtbWF0Y2ggJG1hdGNofSBlbHNlIHskZH0NCn0KCmZ1bmN0aW9uIEdldC1Fc2NhcGUge1tDaGFyXTB4MWJ9CgpmdW5jdGlvbiBBUC1Db252ZXJ0UGF0aCB7cGFyYW0oW1BhcmFtZXRlcihNYW5kYXRvcnk9JFRydWUpXVtTdHJpbmddJFBhdGgpCg0KICAgICRQYXRoU2VwID0gW0lPLlBhdGhdOjpEaXJlY3RvcnlTZXBhcmF0b3JDaGFyDQogICAgcmV0dXJuICRQYXRoIC1yZXBsYWNlIA0KICAgICAgICAiPERlcD4iLCI8TGliPiR7UGF0aFNlcH1EZXBlbmRlbmNpZXMiIC1yZXBsYWNlIA0KICAgICAgICAiPExpYj4iLCI8SG9tZT4ke1BhdGhTZXB9QVAtTGlicmFyaWVzIiAtcmVwbGFjZSANCiAgICAgICAgIjxDb21wKG9uZW50cyk/PiIsIjxIb21lPiR7UGF0aFNlcH1BUC1Db21wb25lbnRzIiAtcmVwbGFjZSANCiAgICAgICAgIjxIb21lPiIsJFBTSGVsbH0KCmZ1bmN0aW9uIFNldC1QYXRoIHsNCiAgICBbY21kbGV0YmluZGluZygpXQ0KICAgIHBhcmFtKA0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeSA9ICR0cnVlLCBWYWx1ZUZyb21QaXBlbGluZSA9ICR0cnVlKV1bc3RyaW5nW11dJFBhdGgsDQogICAgICAgIFtzdHJpbmddJFBhdGhWYXIgPSAiUEFUSCINCiAgICApDQogICAgYmVnaW4gew0KICAgICAgICBbc3RyaW5nW11dJEZpbmFsUGF0aA0KICAgIH0NCiAgICBwcm9jZXNzIHsNCiAgICAgICAgJFBhdGggfCAlIHsNCiAgICAgICAgICAgICRGaW5hbFBhdGggKz0gJF8NCiAgICAgICAgfQ0KICAgIH0NCiAgICBlbmQgew0KICAgICAgICAkSXNVbml4ID0gJFBTVmVyc2lvblRhYmxlLlBsYXRmb3JtIC1lcSAiVW5peCINCiAgICAgICAgJFBhdGhTZXAgPSAkKGlmICgkSXNVbml4KSB7IjoifSBlbHNlIHsiOyJ9KQ0KICAgICAgICAkUHRoID0gJEZpbmFsUGF0aCAtam9pbiAkUGF0aFNlcA0KICAgICAgICAkUHRoID0gKCRQdGggLXJlcGxhY2UoIiRQYXRoU2VwKyIsICRQYXRoU2VwKSAtcmVwbGFjZSgiXFwkUGF0aFNlcHxcXCQiLCAkUGF0aFNlcCkpLnRyaW0oJFBhdGhTZXApDQogICAgICAgICRQdGggPSAoKCRQdGgpLnNwbGl0KCRQYXRoU2VwKSB8IHNlbGVjdCAtdW5pcXVlKSAtam9pbiAkUGF0aFNlcA0KICAgICAgICBbRW52aXJvbm1lbnRdOjpTZXRFbnZpcm9ubWVudFZhcmlhYmxlKCRQYXRoVmFyLCAkUHRoKQ0KICAgIH0NCn0KCmZ1bmN0aW9uIFBsYWNlLUJ1ZmZlcmVkQ29udGVudCB7cGFyYW0oJFRleHQsICR4LCAkeSwgW0NvbnNvbGVDb2xvcl0kRm9yZWdyb3VuZENvbG9yPVtDb25zb2xlXTo6Rm9yZWdyb3VuZENvbG9yLCBbQ29uc29sZUNvbG9yXSRCYWNrZ3JvdW5kQ29sb3I9W0NvbnNvbGVdOjpCYWNrZ3JvdW5kQ29sb3IpCg0KICAgICRjcmQgPSBbTWFuYWdlbWVudC5BdXRvbWF0aW9uLkhvc3QuQ29vcmRpbmF0ZXNdOjpuZXcoJHgsJHkpDQogICAgJGIgPSAkSG9zdC5VSS5SYXdVSQ0KICAgICRhcnIgPSAkYi5OZXdCdWZmZXJDZWxsQXJyYXkoQCgkVGV4dCksICRGb3JlZ3JvdW5kQ29sb3IsICRCYWNrZ3JvdW5kQ29sb3IpDQogICAgJHggPSBbQ29uc29sZV06OkJ1ZmZlcldpZHRoLTEtJFRleHQubGVuZ3RoDQogICAgJGIuU2V0QnVmZmVyQ29udGVudHMoJGNyZCwgJGFycikNCn0KCmZ1bmN0aW9uIEFsaWduLVRleHQge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bU3RyaW5nW11dJFRleHQsIFtWYWxpZGF0ZVNldCgiQ2VudGVyIiwiUmlnaHQiLCJMZWZ0IildW1N0cmluZ10kQWxpZ249J0NlbnRlcicpCg0KICAgIGlmICgkVGV4dC5jb3VudCAtZ3QgMSkgew0KICAgICAgICAkYW5zID0gQCgpDQogICAgICAgIGZvcmVhY2ggKCRsbiBpbiAkVGV4dCkgeyRBbnMgKz0gQWxpZ24tVGV4dCAkbG4gJEFsaWdufQ0KICAgICAgICByZXR1cm4gKCRhbnMpDQogICAgfSBlbHNlIHsNCiAgICAgICAgJFdpblNpemUgPSBbY29uc29sZV06OkJ1ZmZlcldpZHRoDQogICAgICAgICRDbGVhblRleHRTaXplID0gKFN0cmlwLUNvbG9yQ29kZXMgKCIiKyRUZXh0KSkuTGVuZ3RoDQogICAgICAgIGlmICgkQ2xlYW5UZXh0U2l6ZSAtZ2UgJFdpblNpemUpIHsNCiAgICAgICAgICAgICRBcHBlbmRlciA9IEAoIiIpOw0KICAgICAgICAgICAgJGogPSAwDQogICAgICAgICAgICBmb3JlYWNoICgkcCBpbiAwLi4oJENsZWFuVGV4dFNpemUtMSkpew0KICAgICAgICAgICAgICAgIGlmICgoJHArMSklJHdpbnNpemUgLWVxIDApIHskaisrOyRBcHBlbmRlciArPSAiIn0NCiAgICAgICAgICAgICAgICAjICIiKyRqKyIgLSAiKyRwDQogICAgICAgICAgICAgICAgJEFwcGVuZGVyWyRqXSArPSAkVGV4dC5jaGFycygkcCkNCiAgICAgICAgICAgIH0NCiAgICAgICAgICAgIHJldHVybiAoQWxpZ24tVGV4dCAkQXBwZW5kZXIgJEFsaWduKQ0KICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgaWYgKCRBbGlnbiAtZXEgIkNlbnRlciIpIHsNCiAgICAgICAgICAgICAgICByZXR1cm4gKCIgIipbbWF0aF06OnRydW5jYXRlKCgkV2luU2l6ZS0kQ2xlYW5UZXh0U2l6ZSkvMikrJFRleHQpDQogICAgICAgICAgICB9IGVsc2VpZiAoJEFsaWduIC1lcSAiUmlnaHQiKSB7DQogICAgICAgICAgICAgICAgcmV0dXJuICgiICIqKCRXaW5TaXplLSRDbGVhblRleHRTaXplLTEpKyRUZXh0KQ0KICAgICAgICAgICAgfSBlbHNlIHsNCiAgICAgICAgICAgICAgICByZXR1cm4gKCRUZXh0KQ0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgfQ0KfQoKZnVuY3Rpb24gR2V0LVdoZXJlIHsNCiAgICBbQ21kbGV0QmluZGluZyhEZWZhdWx0UGFyYW1ldGVyU2V0TmFtZT0iTm9ybWFsIildDQogICAgcGFyYW0oDQogICAgICAgIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSR0cnVlLCBQb3NpdGlvbj0wKV1bc3RyaW5nXSRGaWxlLA0KICAgICAgICBbU3dpdGNoXSRBbGwsDQogICAgICAgIFtQYXJhbWV0ZXIoUGFyYW1ldGVyU2V0TmFtZT0nTm9ybWFsJyldW1BhcmFtZXRlcihQYXJhbWV0ZXJTZXROYW1lPSdTY2FuJyldW1N3aXRjaF0kTWFudWFsU2NhbiwNCiAgICAgICAgW1BhcmFtZXRlcihQYXJhbWV0ZXJTZXROYW1lPSdTY2FuJyldW1N3aXRjaF0kRGJnLA0KICAgICAgICBbUGFyYW1ldGVyKFBhcmFtZXRlclNldE5hbWU9J1NjYW4nKV1bc3RyaW5nXSRQYXRoVmFyID0gIlBBVEgiDQogICAgKQ0KICAgICRJc1ZlcmJvc2UgPSAkRGJnIC1vciAkUFNCb3VuZFBhcmFtZXRlcnMuQ29udGFpbnNLZXkoJ1ZlcmJvc2UnKSAtb3IgJFBTQm91bmRQYXJhbWV0ZXJzLkNvbnRhaW5zS2V5KCdEZWJ1ZycpDQogICAgJFdoZXJlQmluRXhpc3RzID0gR2V0LUNvbW1hbmQgIndoZXJlIiAtZWEgU2lsZW50bHlDb250aW51ZQ0KICAgICRJc1VuaXggPSAkUFNWZXJzaW9uVGFibGUuUGxhdGZvcm0gLWVxICJVbml4Ig0KICAgIGlmICgkRmlsZSAtZXEgIndoZXJlIiAtb3IgJEZpbGUgLWVxICJ3aGVyZS5leGUiKSB7cmV0dXJuICRXaGVyZUJpbkV4aXN0c30NCiAgICBpZiAoJFdoZXJlQmluRXhpc3RzIC1hbmQgISRNYW51YWxTY2FuKSB7DQogICAgICAgICRPdXQ9JG51bGwNCiAgICAgICAgaWYgKCRJc1VuaXgpIHsNCiAgICAgICAgICAgICRPdXQgPSB3aGljaCAkZmlsZSAyPiRudWxsDQogICAgICAgIH0gZWxzZSB7JE91dCA9IHdoZXJlLmV4ZSAkZmlsZSAyPiRudWxsfQ0KICAgICAgICANCiAgICAgICAgaWYgKCEkT3V0KSB7cmV0dXJufQ0KICAgICAgICBpZiAoJEFsbCkge3JldHVybiAkT3V0fQ0KICAgICAgICByZXR1cm4gQCgkT3V0KVswXQ0KICAgIH0NCiAgICBmb3JlYWNoICgkRm9sZGVyIGluIChHZXQtUGF0aCAtUGF0aFZhciAkUGF0aFZhcikpIHsNCiAgICAgICAgaWYgKCRJc1VuaXgpIHsNCiAgICAgICAgICAgICRMb29rdXAgPSAiJEZvbGRlci8kRmlsZSINCiAgICAgICAgICAgIGlmICgkSXNWZXJib3NlKSB7V3JpdGUtQVAgIipDaGVja2luZyBbJExvb2t1cF0ifQ0KICAgICAgICAgICAgaWYgKCEoVGVzdC1QYXRoIC1QYXRoVHlwZSBMZWFmICRMb29rdXApKSB7Y29udGludWV9DQogICAgICAgICAgICBSZXNvbHZlLVBhdGggJExvb2t1cCB8ICUgUGF0aA0KICAgICAgICAgICAgaWYgKCEkQWxsKSB7cmV0dXJufQ0KICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgZm9yZWFjaCAoJEV4dGVuc2lvbiBpbiAoR2V0LVBhdGggLVBhdGhWYXIgUEFUSEVYVCkpIHsNCiAgICAgICAgICAgICAgICAkTG9va3VwID0gIiRGb2xkZXIvJEZpbGUkRXh0ZW5zaW9uIg0KICAgICAgICAgICAgICAgIGlmICgkSXNWZXJib3NlKSB7V3JpdGUtQVAgIipDaGVja2luZyBbJExvb2t1cF0ifQ0KICAgICAgICAgICAgICAgIGlmICghKFRlc3QtUGF0aCAtUGF0aFR5cGUgTGVhZiAkTG9va3VwKSkge2NvbnRpbnVlfQ0KICAgICAgICAgICAgICAgIFJlc29sdmUtUGF0aCAkTG9va3VwIHwgJSBQYXRoDQogICAgICAgICAgICAgICAgaWYgKCEkQWxsKSB7cmV0dXJufQ0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgfQ0KfQoKZnVuY3Rpb24gS2V5UHJlc3NlZCB7cGFyYW0oW1BhcmFtZXRlcihNYW5kYXRvcnk9JFRydWUpXVtTdHJpbmdbXV0kS2V5LCAkU3RvcmUgPSAiXl5eIikKDQogICAgaWYgKCRTdG9yZSAtZXEgIl5eXiIgLWFuZCAkSG9zdC5VSS5SYXdVSS5LZXlBdmFpbGFibGUpIHskU3RvcmUgPSAkSG9zdC5VSS5SYXdVSS5SZWFkS2V5KCJJbmNsdWRlS2V5VXAsTm9FY2hvIil9IGVsc2Uge2lmICgkU3RvcmUgLWVxICJeXl4iKSB7cmV0dXJuICRGYWxzZX19DQogICAgJEFucyA9ICRGYWxzZQ0KICAgICRLZXkgfCAlIHsNCiAgICAgICAgJFNPVVJDRSA9ICRfDQogICAgICAgIHRyeSB7DQogICAgICAgICAgICAkQW5zID0gJEFucyAtb3IgKEtleVByZXNzZWRDb2RlICRTT1VSQ0UgJFN0b3JlKQ0KICAgICAgICB9IGNhdGNoIHsNCiAgICAgICAgICAgIEZvcmVhY2ggKCRLIGluICRTT1VSQ0UpIHsNCiAgICAgICAgICAgICAgICBbU3RyaW5nXSRLID0gJEsNCiAgICAgICAgICAgICAgICBpZiAoJEsubGVuZ3RoIC1ndCA0IC1hbmQgKCRLWzAsMSwtMSwtMl0gLWpvaW4oIiIpKSAtZXEgIn5+fn4iKSB7DQogICAgICAgICAgICAgICAgICAgICRBbnMgPSAkQU5TIC1vciAoS2V5UHJlc3NlZENvZGUgKEtleVRyYW5zbGF0ZSgkSykpICRTdG9yZSkNCiAgICAgICAgICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgICAgICAgICAkQW5zID0gJEFOUyAtb3IgKCRLLmNoYXJzKDApIC1pbiAkU3RvcmUuQ2hhcmFjdGVyKQ0KICAgICAgICAgICAgICAgIH0NCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAgIH0NCiAgICByZXR1cm4gJEFucw0KfQoKZnVuY3Rpb24gV3JpdGUtQVAgew0KICAgIFtDbWRsZXRCaW5kaW5nKCldDQogICAgcGFyYW0oW1BhcmFtZXRlcihWYWx1ZUZyb21QaXBlbGluZT0kdHJ1ZSwgTWFuZGF0b3J5PSRUcnVlKV0kVGV4dCxbU3dpdGNoXSROb1NpZ24sW1N3aXRjaF0kUGxhaW5UZXh0LFtWYWxpZGF0ZVNldCgiQ2VudGVyIiwiUmlnaHQiLCJMZWZ0IildW1N0cmluZ10kQWxpZ249J0xlZnQnLFtTd2l0Y2hdJFBhc3NUaHJ1KQ0KICAgIGJlZ2luIHskVFQgPSBAKCl9DQogICAgUHJvY2VzcyB7JFRUICs9ICwkVGV4dH0NCiAgICBFTkQgew0KICAgICAgICAkQmx1ZSA9ICQoaWYgKCRXUklURV9BUF9MRUdBQ1lfQ09MT1JTKXszfWVsc2V7J0JsdWUnfSkNCiAgICAgICAgaWYgKCRUVC5jb3VudCAtZXEgMSkgeyRUVCA9ICRUVFswXX07JFRleHQgPSAkVFQNCiAgICAgICAgaWYgKCR0ZXh0LmNvdW50IC1ndCAxIC1vciAkdGV4dC5HZXRUeXBlKCkuTmFtZSAtbWF0Y2ggIlxbXF0kIikgew0KICAgICAgICAgICAgcmV0dXJuICRUZXh0IHwgPyB7IiRfIn0gfCAlIHsNCiAgICAgICAgICAgICAgICBXcml0ZS1BUCAkXyAtTm9TaWduOiROb1NpZ24gLVBsYWluVGV4dDokUGxhaW5UZXh0IC1BbGlnbiAkQWxpZ24gLVBhc3NUaHJ1OiRQYXNzVGhydQ0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgICAgIGlmICghJHRleHQgLW9yICR0ZXh0IC1ub3RtYXRjaCAiXigoPzxOTkw+eCl8KD88TlM+bnM/KSl7MCwyfSg/PHQ+XD4qKSg/PHM+W1wrXC1cIVwqXCNcQF9dKSg/PHc+LiopIikge3JldHVybiAkVGV4dH0NCiAgICAgICAgJHRiICA9ICIgICAgIiokTWF0Y2hlcy50Lmxlbmd0aA0KICAgICAgICAkQ29sID0gQHsnKyc9JzInOyctJz0nMTInOychJz0nMTQnOycqJz0kQmx1ZTsnIyc9J0RhcmtHcmF5JzsnQCc9J0dyYXknOydfJz0nd2hpdGUnfVsoJFNpZ24gPSAkTWF0Y2hlcy5TKV0NCiAgICAgICAgaWYgKCEkQ29sKSB7VGhyb3cgIkluY29ycmVjdCBTaWduIFskU2lnbl0gUGFzc2VkISJ9DQogICAgICAgICRTaWduID0gJChpZiAoJE5vU2lnbiAtb3IgJE1hdGNoZXMuTlMpIHsiIn0gZWxzZSB7IlskU2lnbl0gIn0pDQogICAgICAgICREYXRhID0gIiR0YiRTaWduJCgkTWF0Y2hlcy5XKSI7aWYgKCEkRGF0YSkge3JldHVybn0NCiAgICAgICAgaWYgKEFQLVJlcXVpcmUgImZ1bmN0aW9uOkFsaWduLVRleHQiIC1wYSkgew0KICAgICAgICAgICAgJERhdGEgPSBBbGlnbi1UZXh0IC1BbGlnbiAkQWxpZ24gIiR0YiRTaWduJCgkTWF0Y2hlcy5XKSINCiAgICAgICAgfQ0KICAgICAgICBpZiAoJFBsYWluVGV4dCkge3JldHVybiAkRGF0YX0NCiAgICAgICAgV3JpdGUtSG9zdCAtTm9OZXdMaW5lOiQoW2Jvb2xdJE1hdGNoZXMuTk5MKSAtZiAkQ29sICREYXRhDQogICAgICAgIGlmICgkUGFzc1RocnUpIHtyZXR1cm4gJERhdGF9DQogICAgfQ0KfQo=")
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
