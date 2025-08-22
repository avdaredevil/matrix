<#
|====================================================================================>|
   Matrix Animation [PwShell] by APoorv Verma [AP] on 8/21/2024
|====================================================================================>|
      $) Multiple renderers (Windows, Unix): Default is Auto-Detect
      $) Sparsity of the matrix effect (1 is fully dense, 0.1 is sparse)
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
    [ValidateRange(1, 10000)][int]$SleepTime = 50,
    [ValidateSet("Windows", "Unix", "Auto-Detect")][string]$Renderer = "Auto-Detect",
    [Switch]$SpecialChars,
    [Switch]$Debug
)
# =======================================START=OF=COMPILER================================================================|
#    The Following Code was added by AP-Compiler 1.6 (APC: 1.3) To Make this program independent of AP-Core Engine
#    GitHub: https://github.com/avdaredevil/AP-Compiler
# ========================================================================================================================|
$Script:PSHell=$(if($PSHell){$PSHell}elseif($PSScriptRoot){$PSScriptRoot}else{"."});
if($AP_CONSOLE.mode -ne 'main' -or $AP_CONSOLE.customFlags.runAsCompiled) {
    $Script:AP_CONSOLE = [PsCustomObject]@{version=[version]'1.3'; mode = 'shim'; customFlags = @{}}
    function B64 {param([Parameter(ValueFromPipeline=$true)][String]$Text, [ValidateSet("UTF8","Unicode")][String]$Encoding = "UTF8")     [System.Text.Encoding]::$Encoding.GetString([System.Convert]::FromBase64String($Text))}
    # This syntax is to prevent AV's from misclassifying this as anything but innocuous
    & (Get-Alias iex) (B64 "ZnVuY3Rpb24gSW52b2tlLU9yUmV0dXJuIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kdHJ1ZSwgVmFsdWVGcm9tUGlwZWxpbmU9JHRydWUsIFBvc2l0aW9uPTApXVtBbGxvd051bGwoKV0kQ29kZSwgW1BhcmFtZXRlcihWYWx1ZUZyb21SZW1haW5pbmdBcmd1bWVudHM9MSldJF9fUmVzdCwgW1N3aXRjaF0kQXNQcm9jZXNzQmxvY2spDQoNCiAgICBpZiAoISgkQ29kZSAtaXMgW1NjcmlwdEJsb2NrXSkpIHtyZXR1cm4gJENvZGV9DQogICAgaWYgKCEkQXNQcm9jZXNzQmxvY2spIHtyZXR1cm4gJiAkQ29kZSBAX19SZXN0fQ0KICAgIHJldHVybiBGb3JFYWNoLU9iamVjdCAtcHJvY2VzcyAkQ29kZSAtSW5wdXRPYmplY3QgJF9fUmVzdA0KfQoKZnVuY3Rpb24gQVAtQ29udmVydFBhdGgge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bU3RyaW5nXSRQYXRoKQ0KDQogICAgJFBhdGhTZXAgPSBbSU8uUGF0aF06OkRpcmVjdG9yeVNlcGFyYXRvckNoYXINCiAgICByZXR1cm4gJFBhdGggLXJlcGxhY2UNCiAgICAgICAgIjxEZXA+IiwiPExpYj4ke1BhdGhTZXB9RGVwZW5kZW5jaWVzIiAtcmVwbGFjZQ0KICAgICAgICAiPExpYj4iLCI8SG9tZT4ke1BhdGhTZXB9QVAtTGlicmFyaWVzIiAtcmVwbGFjZQ0KICAgICAgICAiPENvbXAob25lbnRzKT8+IiwiPEhvbWU+JHtQYXRoU2VwfUFQLUNvbXBvbmVudHMiIC1yZXBsYWNlDQogICAgICAgICI8SG9tZT4iLCRQU0hlbGx9CgpmdW5jdGlvbiBBbGlnbi1UZXh0IHsNCiAgICBbQ21kbGV0QmluZGluZygpXQ0KICAgIFtPdXRwdXRUeXBlKFtTdHJpbmddLCBbSGFzaHRhYmxlXSldDQogICAgcGFyYW0oDQogICAgICAgIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PTEsIFZhbHVlRnJvbVBpcGVsaW5lPTEpXVtTdHJpbmdbXV0kVGV4dCwNCiAgICAgICAgW3N3aXRjaF0kQ29sb3JDb2Rlc0Rpc2NyZXRlUGVyTGluZSwNCiAgICAgICAgW3N3aXRjaF0kUG9yY2VsYWluLA0KICAgICAgICAjIFRoaXMgY2FuIGJlIFtpbnRdIG9yIFtzY3JpcHRibG9ja10NCiAgICAgICAgJENvbnN0cmFpblRvV2lkdGgsDQogICAgICAgIFtWYWxpZGF0ZVNldCgiQ2VudGVyIiwiUmlnaHQiLCJMZWZ0IildW1N0cmluZ10kQWxpZ249J0NlbnRlcicNCiAgICApDQogICAgYmVnaW4gew0KICAgICAgICAkaXNWZXJib3NlID0gJFBTQ21kbGV0Lk15SW52b2NhdGlvbi5Cb3VuZFBhcmFtZXRlcnMuVmVyYm9zZQ0KICAgICAgICAkRXNjYXBlQ29kZVNwbGl0dGVyID0gIiQoW3JlZ2V4XTo6ZXNjYXBlKCIkKEdldC1Fc2NhcGUpWyIpKVxkKyg/Olw7XGQrKSptIg0KICAgICAgICAkRGl2aWRlcnMgPSBAe2NodW5rID0gdSAiYHV7MTEyODh9Ijsgc3R5bGUgPSB1ICJgdXsxMjI4OH0ifQ0KICAgICAgICAkRmluYWxGb3JtYXR0ZXIgPSB7DQogICAgICAgICAgICBwYXJhbSgkTGluZXMsICRTdHlsZXMpDQogICAgICAgICAgICBpZiAoISRQb3JjZWxhaW4pIHtyZXR1cm4gJExpbmVzfQ0KICAgICAgICAgICAgaWYgKCRudWxsIC1lcSAkU3R5bGVzKSB7JFN0eWxlcyA9IFtSZWdleF06Ok1hdGNoZXMoKCRMaW5lcyAtam9pbiAiIiksICRFc2NhcGVDb2RlU3BsaXR0ZXIpLnZhbHVlfQ0KICAgICAgICAgICAgcmV0dXJuIEB7TGluZXMgPSAkTGluZXM7IFJ1bm5pbmdTdHlsZXMgPSAkU3R5bGVzfQ0KICAgICAgICB9DQogICAgfQ0KICAgIHByb2Nlc3Mgew0KICAgICAgICBpZiAoJEFsaWduIC1lcSAiTGVmdCIpIHtyZXR1cm4gJiAkRmluYWxGb3JtYXR0ZXIgJFRleHR9DQogICAgICAgIGlmICghIiRUZXh0Ii50cmltKCkpIHtyZXR1cm4gJFRleHR9DQogICAgICAgICRXaW5TaXplID0gPzogJENvbnN0cmFpblRvV2lkdGgge0ludm9rZS1PclJldHVybiAkQ29uc3RyYWluVG9XaWR0aH0gKFtjb25zb2xlXTo6QnVmZmVyV2lkdGgpDQogICAgICAgIA0KICAgICAgICAkVGV4dCA9ICRUZXh0IC1zcGxpdCAiYHI/YG4iDQogICAgICAgIGlmICgkVGV4dC5jb3VudCAtZ3QgMSkgew0KICAgICAgICAgICAgJExpbmVzID0gJFRleHQgfCBBbGlnbi1UZXh0IC1BbGlnbiAkQWxpZ24gLUNvbG9yQ29kZXNEaXNjcmV0ZVBlckxpbmU6JENvbG9yQ29kZXNEaXNjcmV0ZVBlckxpbmUgLVBvcmNlbGFpbg0KICAgICAgICAgICAgaWYgKCRDb2xvckNvZGVzRGlzY3JldGVQZXJMaW5lKSB7DQogICAgICAgICAgICAgICAgZm9yICgkaSA9IDE7ICRpIC1sdCAkTGluZXMuQ291bnQ7ICRpKyspIHsNCiAgICAgICAgICAgICAgICAgICAgJExpbmUgPSAkTGluZXNbJGldDQogICAgICAgICAgICAgICAgICAgICRQcmV2U3R5bGVzICs9ICRMaW5lc1skaSAtIDFdLlJ1bm5pbmdTdHlsZXMNCiAgICAgICAgICAgICAgICAgICAgJExpbmUuTGluZXMgPSAkTGluZS5MaW5lcyB8ICUgeyIkUHJldlN0eWxlcyRfIn0NCiAgICAgICAgICAgICAgICAgICAgJExpbmUuUnVubmluZ1N0eWxlcyA9ICIkUHJldlN0eWxlcyQoJExpbmUuUnVubmluZ1N0eWxlcykiDQogICAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgfQ0KICAgICAgICAgICAgcmV0dXJuICYgJEZpbmFsRm9ybWF0dGVyIChGbGF0dGVuICRMaW5lcy5MaW5lcykgKCRMaW5lcy5SdW5uaW5nU3R5bGVzIC1qb2luICIiKQ0KICAgICAgICB9DQogICAgICAgICMgU2luZ2xlIG5vbiBgbiBsaW5lIHByb2Nlc3MNCiAgICAgICAgJENsZWFuVGV4dFNpemUgPSAoU3RyaXAtQ29sb3JDb2RlcyAoIiIrJFRleHQpKS5MZW5ndGgNCg0KICAgICAgICAjID09PT09PT09IExpbmUgaXMgPCAkV2luU2l6ZSA9PT09PT09PT09PT09PXwNCiAgICAgICAgaWYgKCRDbGVhblRleHRTaXplIC1sZSAkV2luU2l6ZSkgew0KICAgICAgICAgICAgaWYgKCRBbGlnbiAtZXEgIkNlbnRlciIpIHsNCiAgICAgICAgICAgICAgICByZXR1cm4gJiAkRmluYWxGb3JtYXR0ZXIgKCIgIipbbWF0aF06OnRydW5jYXRlKCgkV2luU2l6ZS0kQ2xlYW5UZXh0U2l6ZSkvMikrJFRleHQpDQogICAgICAgICAgICB9DQogICAgICAgICAgICAjIFJpZ2h0DQogICAgICAgICAgICByZXR1cm4gJiAkRmluYWxGb3JtYXR0ZXIgKCIgIiooJFdpblNpemUtJENsZWFuVGV4dFNpemUpKyRUZXh0KQ0KICAgICAgICB9DQoNCiAgICAgICAgIyA9PT09PT09PSBMaW5lIGlzID49ICRXaW5TaXplID09PT09PT09PT09PT09fA0KICAgICAgICAjIFRyYWNraW5nIFN0eWxlcw0KICAgICAgICAkUnVubmluZ1N0eWxlcyA9ICIiDQogICAgICAgICRDdXJybGluZSA9IEB7DQogICAgICAgICAgICBzdHlsZWREYXRhID0gIiINCiAgICAgICAgICAgIGNvbnRlbnRTaXplID0gMA0KICAgICAgICAgICAgZmluYWxMaW5lcyA9IEAoKQ0KICAgICAgICAgICAgbmV4dCA9IHsNCiAgICAgICAgICAgICAgICAjIFdyaXRlLVZlcmJvc2UgIiokSW52b2sgfCBOZXcgTGluZSB8IExpbmVEYXRhOiAkKCgnJyskQ3VycmxpbmUuc3R5bGVkRGF0YS5MZW5ndGgpLlBhZExlZnQoMykpIg0KICAgICAgICAgICAgICAgICRDdXJybGluZS5maW5hbExpbmVzICs9ICwkQ3VycmxpbmUuc3R5bGVkRGF0YQ0KICAgICAgICAgICAgICAgICRDdXJybGluZS5zdHlsZWREYXRhID0gJFJ1bm5pbmdTdHlsZXMNCiAgICAgICAgICAgICAgICAkQ3VycmxpbmUuY29udGVudFNpemUgPSAwDQogICAgICAgICAgICAgICAgIyBXcml0ZS1WZXJib3NlICIqJEludm9rIHwgQ3VyciBUb3RhbCBMaW5lczogJCgkY3VycmxpbmUuZmluYWxMaW5lcy5Db3VudCkiDQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICAgICAgJEFsbENodW5rcyA9ICRUZXh0IC1yZXBsYWNlICIoJHtFc2NhcGVDb2RlU3BsaXR0ZXJ9KSsoLio/KSg/PSR7RXNjYXBlQ29kZVNwbGl0dGVyfXwkKSIsIiQoJERpdmlkZXJzLmNodW5rKWAkMSQoJERpdmlkZXJzLnN0eWxlKWAkMiIgLXNwbGl0ICREaXZpZGVycy5jaHVuaw0KICAgICAgICBpZiAoJEFsbENodW5rc1swXSAtbm90Y29udGFpbnMgJERpdmlkZXJzLnN0eWxlKSB7JEFsbENodW5rc1swXSA9ICIkKCREaXZpZGVycy5zdHlsZSkkKCRBbGxDaHVua3NbMF0pIn0gIyBUaGUgZmlyc3QgY2h1bmsgY291bGQgaGF2ZSBubyBzdHlsZXMNCiAgICAgICAgZm9yZWFjaCAoJEN1cnJDaHVuayBpbiAkQWxsQ2h1bmtzKSB7DQogICAgICAgICAgICAkU3R5bGUsJFRleHRDaHVuayA9ICRDdXJyQ2h1bmsgLXNwbGl0ICREaXZpZGVycy5zdHlsZQ0KICAgICAgICAgICAgJFJ1bm5pbmdTdHlsZXMgPSA/OiAkQ29sb3JDb2Rlc0Rpc2NyZXRlUGVyTGluZSAiJFJ1bm5pbmdTdHlsZXMkU3R5bGUiICRTdHlsZQ0KICAgICAgICAgICAgIyBXcml0ZS1Ib3N0IC1mIDIgKCJJbmNvbWluZ1N0eWxlOiAkU3R5bGUgfCBSdW5uaW5nU3R5bGVzOiAkUnVubmluZ1N0eWxlcyIgLXJlcGxhY2UgKFtyZWdleF06OkVzY2FwZSgkKEdldC1Fc2NhcGUpKSksJ1xlJykNCiAgICAgICAgICAgICMgV3JpdGUtSG9zdCAtZiBZZWxsb3cgIlRleHRDaHVuazogJFRleHRDaHVuayINCiAgICAgICAgICAgICRDdXJybGluZS5zdHlsZWREYXRhICs9ICRSdW5uaW5nU3R5bGVzDQogICAgICAgICAgICAkVGV4dENodW5rU3RySW5kZXggPSAwDQogICAgICAgICAgICAjIFdyaXRlLVZlcmJvc2UgIiokSW52b2sgfCBUZXh0Q2h1bms6ICRUZXh0Q2h1bmsgfCBBbGxDaHVua3NTaXplOiAkKCgnJyskQWxsQ2h1bmtzLkxlbmd0aCkuUGFkTGVmdCgzKSkiDQogICAgICAgICAgICB3aGlsZSgkVGV4dENodW5rU3RySW5kZXggLWx0ICRUZXh0Q2h1bmsuTGVuZ3RoKSB7DQogICAgICAgICAgICAgICAgaWYgKCRpc1ZlcmJvc2UpIHtQbGFjZS1CdWZmZXJlZENvbnRlbnQgKCIkSW52b2sgfCBMaW5lRGF0YTogJCgoJycrJEN1cnJsaW5lLnN0eWxlZERhdGEuTGVuZ3RoKS5QYWRMZWZ0KDMpKSB8IENodW5rSWR4OiAkKCgnJyskVGV4dENodW5rU3RySW5kZXgpLlBhZExlZnQoMykpIHwgQ2h1bmtMZW46ICQoJFRleHRDaHVuay5MZW5ndGgpIHwgRmluYWxMaW5lczogJCgkQ3VycmxpbmUuZmluYWxMaW5lcy5Db3VudCkiKSAteCAwIC15IChbQ29uc29sZV06OkJ1ZmZlckhlaWdodCAtIDEpIFllbGxvdyBEYXJrR3JheX0NCiAgICAgICAgICAgICAgICAkQ2h1bmtTaXplID0gJFRleHRDaHVuay5MZW5ndGggLSAkVGV4dENodW5rU3RySW5kZXgNCiAgICAgICAgICAgICAgICAjIFdyaXRlLVZlcmJvc2UgIipDaHVua1NpemU6ICRDaHVua1NpemUiDQogICAgICAgICAgICAgICAgaWYgKCgkQ3VycmxpbmUuY29udGVudFNpemUrJENodW5rU2l6ZSkgLWx0ICRXaW5TaXplKSB7DQogICAgICAgICAgICAgICAgICAgICMgSWYgdGhlIGN1cnJlbnQgY2h1bmsgZml0cyBpbiB0aGUgY3VycmVudCBsaW5lDQogICAgICAgICAgICAgICAgICAgICRDdXJybGluZS5zdHlsZWREYXRhICs9ICRUZXh0Q2h1bmsuU3Vic3RyaW5nKCRUZXh0Q2h1bmtTdHJJbmRleCkNCiAgICAgICAgICAgICAgICAgICAgJEN1cnJsaW5lLmNvbnRlbnRTaXplICs9ICRDaHVua1NpemUNCiAgICAgICAgICAgICAgICAgICAgJFRleHRDaHVua1N0ckluZGV4ICs9ICRDaHVua1NpemUNCiAgICAgICAgICAgICAgICAgICAgY29udGludWUNCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAgICAgIyBJZiB0aGUgY3VycmVudCBjaHVuayBkb2Vzbid0IGZpdCBpbiB0aGUgY3VycmVudCBsaW5lDQogICAgICAgICAgICAgICAgJG5ld0NvbnRlbnQgPSAkVGV4dENodW5rLlN1YnN0cmluZygkVGV4dENodW5rU3RySW5kZXgsICRXaW5TaXplLSRDdXJybGluZS5jb250ZW50U2l6ZSkNCiAgICAgICAgICAgICAgICAkQ3VycmxpbmUuc3R5bGVkRGF0YSArPSAkbmV3Q29udGVudA0KICAgICAgICAgICAgICAgICRDdXJybGluZS5jb250ZW50U2l6ZSArPSAkbmV3Q29udGVudC5sZW5ndGgNCiAgICAgICAgICAgICAgICAkVGV4dENodW5rU3RySW5kZXggKz0gJG5ld0NvbnRlbnQubGVuZ3RoDQogICAgICAgICAgICAgICAgJiAkQ3VycmxpbmUubmV4dA0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgICAgIGlmICgkQ3VycmxpbmUuY29udGVudFNpemUgLWd0IDApIHsNCiAgICAgICAgICAgIGlmICgkQ3VycmxpbmUuY29udGVudFNpemUpew0KICAgICAgICAgICAgICAgIEFsaWduLVRleHQgLUFsaWduICRBbGlnbiAtVGV4dCAkQ3VycmxpbmUuc3R5bGVkRGF0YSAtQ29sb3JDb2Rlc0Rpc2NyZXRlUGVyTGluZTokQ29sb3JDb2Rlc0Rpc2NyZXRlUGVyTGluZSB8ID8geyRffSB8ICUgew0KICAgICAgICAgICAgICAgICAgICAkQ3VycmxpbmUuZmluYWxMaW5lcyArPSAsJF8NCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgICAgICRDdXJybGluZS5maW5hbExpbmVzWy0xXSArPSAkQ3VycmxpbmUuc3R5bGVkRGF0YQ0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgICAgIHJldHVybiAmICRGaW5hbEZvcm1hdHRlciAkQ3VycmxpbmUuZmluYWxMaW5lcyAkUnVubmluZ1N0eWxlcw0KICAgICAgICByZXR1cm4gJEN1cnJsaW5lLmZpbmFsTGluZXMNCiAgICB9DQp9CgpmdW5jdGlvbiBHZXQtV2hlcmUgew0KICAgIFtDbWRsZXRCaW5kaW5nKERlZmF1bHRQYXJhbWV0ZXJTZXROYW1lPSJOb3JtYWwiKV0NCiAgICBwYXJhbSgNCiAgICAgICAgW1BhcmFtZXRlcihNYW5kYXRvcnk9JHRydWUsIFBvc2l0aW9uPTApXVtzdHJpbmddJEZpbGUsDQogICAgICAgIFtTd2l0Y2hdJEFsbCwNCiAgICAgICAgW1BhcmFtZXRlcihQYXJhbWV0ZXJTZXROYW1lPSdOb3JtYWwnKV1bUGFyYW1ldGVyKFBhcmFtZXRlclNldE5hbWU9J1NjYW4nKV1bU3dpdGNoXSRNYW51YWxTY2FuLA0KICAgICAgICBbUGFyYW1ldGVyKFBhcmFtZXRlclNldE5hbWU9J1NjYW4nKV1bU3dpdGNoXSREYmcsDQogICAgICAgIFtQYXJhbWV0ZXIoUGFyYW1ldGVyU2V0TmFtZT0nU2NhbicpXVtzdHJpbmddJFBhdGhWYXIgPSAiUEFUSCINCiAgICApDQogICAgJElzVmVyYm9zZSA9ICREYmcgLW9yICRQU0NtZGxldC5NeUludm9jYXRpb24uQm91bmRQYXJhbWV0ZXJzLlZlcmJvc2UgLW9yICRQU0NtZGxldC5NeUludm9jYXRpb24uQm91bmRQYXJhbWV0ZXJzLkRlYnVnDQogICAgJFdoZXJlQmluRXhpc3RzID0gR2V0LUNvbW1hbmQgIndoZXJlIiAtZWEgU2lsZW50bHlDb250aW51ZQ0KICAgICRJc1VuaXggPSAkUFNWZXJzaW9uVGFibGUuUGxhdGZvcm0gLWVxICJVbml4Ig0KICAgIGlmICgkRmlsZSAtZXEgIndoZXJlIiAtb3IgJEZpbGUgLWVxICJ3aGVyZS5leGUiKSB7cmV0dXJuICRXaGVyZUJpbkV4aXN0c30NCiAgICBpZiAoJFdoZXJlQmluRXhpc3RzIC1hbmQgISRNYW51YWxTY2FuKSB7DQogICAgICAgICRPdXQ9JG51bGwNCiAgICAgICAgaWYgKCRJc1VuaXgpIHsNCiAgICAgICAgICAgICRPdXQgPSB3aGljaCAkZmlsZSAyPiRudWxsDQogICAgICAgIH0gZWxzZSB7JE91dCA9IHdoZXJlLmV4ZSAkZmlsZSAyPiRudWxsfQ0KDQogICAgICAgIGlmICghJE91dCkge3JldHVybn0NCiAgICAgICAgaWYgKCRBbGwpIHtyZXR1cm4gJE91dH0NCiAgICAgICAgcmV0dXJuIEAoJE91dClbMF0NCiAgICB9DQogICAgZm9yZWFjaCAoJEZvbGRlciBpbiAoR2V0LVBhdGggLVBhdGhWYXIgJFBhdGhWYXIpKSB7DQogICAgICAgIGlmICgkSXNVbml4KSB7DQogICAgICAgICAgICAkTG9va3VwID0gIiRGb2xkZXIvJEZpbGUiDQogICAgICAgICAgICBpZiAoJElzVmVyYm9zZSkge1dyaXRlLUFQICIqQ2hlY2tpbmcgWyRMb29rdXBdIn0NCiAgICAgICAgICAgIGlmICghKFRlc3QtUGF0aCAtUGF0aFR5cGUgTGVhZiAkTG9va3VwKSkge2NvbnRpbnVlfQ0KICAgICAgICAgICAgUmVzb2x2ZS1QYXRoICRMb29rdXAgfCAlIFBhdGgNCiAgICAgICAgICAgIGlmICghJEFsbCkge3JldHVybn0NCiAgICAgICAgfSBlbHNlIHsNCiAgICAgICAgICAgIGZvcmVhY2ggKCRFeHRlbnNpb24gaW4gKEdldC1QYXRoIC1QYXRoVmFyIFBBVEhFWFQpKSB7DQogICAgICAgICAgICAgICAgJExvb2t1cCA9ICIkRm9sZGVyLyRGaWxlJEV4dGVuc2lvbiINCiAgICAgICAgICAgICAgICBpZiAoJElzVmVyYm9zZSkge1dyaXRlLUFQICIqQ2hlY2tpbmcgWyRMb29rdXBdIn0NCiAgICAgICAgICAgICAgICBpZiAoIShUZXN0LVBhdGggLVBhdGhUeXBlIExlYWYgJExvb2t1cCkpIHtjb250aW51ZX0NCiAgICAgICAgICAgICAgICBSZXNvbHZlLVBhdGggJExvb2t1cCB8ICUgUGF0aA0KICAgICAgICAgICAgICAgIGlmICghJEFsbCkge3JldHVybn0NCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAgIH0NCn0KCmZ1bmN0aW9uIEludm9rZS1UZXJuYXJ5IHtwYXJhbSgkZGVjaWRlciwgJGlmdHJ1ZSwgJGlmZmFsc2UgPSB7fSkNCg0KICAgICRJbnZva2VPclJldHVybiA9IHsNCiAgICAgICAgcGFyYW0oJENtZCkNCiAgICAgICAgaWYgKCRDbWQgLWlzIFtTY3JpcHRCbG9ja10pIHsmICRDbWR9IGVsc2UgeyRDbWR9DQogICAgfQ0KICAgIGlmICgkZGVjaWRlcikgeyAmICRJbnZva2VPclJldHVybiAkaWZ0cnVlIH0gZWxzZSB7ICYgJEludm9rZU9yUmV0dXJuICRpZmZhbHNlIH0NCn0KCmZ1bmN0aW9uIEFQLVJlcXVpcmUge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bQWxpYXMoIkZ1bmN0aW9uYWxpdHkiLCJMaWJyYXJ5IildW0FyZ3VtZW50Q29tcGxldGVyKHsNCiAgICBbT3V0cHV0VHlwZShbU3lzdGVtLk1hbmFnZW1lbnQuQXV0b21hdGlvbi5Db21wbGV0aW9uUmVzdWx0XSldDQogICAgcGFyYW0oDQogICAgICAgIFtzdHJpbmddICRDb21tYW5kTmFtZSwNCiAgICAgICAgW3N0cmluZ10gJFBhcmFtZXRlck5hbWUsDQogICAgICAgIFtzdHJpbmddICRXb3JkVG9Db21wbGV0ZSwNCiAgICAgICAgW1N5c3RlbS5NYW5hZ2VtZW50LkF1dG9tYXRpb24uTGFuZ3VhZ2UuQ29tbWFuZEFzdF0gJENvbW1hbmRBc3QsDQogICAgICAgIFtTeXN0ZW0uQ29sbGVjdGlvbnMuSURpY3Rpb25hcnldICRGYWtlQm91bmRQYXJhbWV0ZXJzDQogICAgKQ0KICAgICRDb21wbGV0aW9uUmVzdWx0cyA9IFtTeXN0ZW0uQ29sbGVjdGlvbnMuR2VuZXJpYy5MaXN0W1N5c3RlbS5NYW5hZ2VtZW50LkF1dG9tYXRpb24uQ29tcGxldGlvblJlc3VsdF1dOjpuZXcoKQ0KICAgICRMaWIgPSBAKCJJbnRlcm5ldCIsIm9zOndpbmRvd3MiLCJvczpsaW51eCIsIm9zOnVuaXgiLCJhZG1pbmlzdHJhdG9yIiwicm9vdCIsImRlcDoiLCJsaWI6IiwibGliX3Rlc3Q6IiwibW9kdWxlOiIsIm1vZHVsZV90ZXN0OiIsImZ1bmN0aW9uOiIsInN0cmljdF9mdW5jdGlvbjoiLCJhYmlsaXR5OmVzY2FwZV9jb2RlcyIsImFiaWxpdHk6ZW1vamlzIiwiYWJpbGl0eTpsb25nX3BhdGhzIiwiYWJpbGl0eTpjb25zb2xlX21hbmlwdWxhdGlvbiIpDQogICAgJGpzT3IgPSB7Zm9yZWFjaCAoJGEgaW4gJGFyZ3MpIHskYSA9ICQoaWYoJGEgLWlzIFtzY3JpcHRibG9ja10peyYkYX1lbHNleyRhfSk7aWYgKCEkYSl7Y29udGludWV9O3JldHVybiAkYX07cmV0dXJuICRhfSAjIE1hbnVhbGx5IGVtYmVkZGVkIEpTLU9SDQogICAgJiAkanNPciB7JExpYiB8ID8geyRfIC1saWtlICIkV29yZFRvQ29tcGxldGUqIn19IHskTGliIHwgPyB7JF8gLWxpa2UgIiokV29yZFRvQ29tcGxldGUqIn19IHwgJSB7DQogICAgICAgICRDb21wbGV0aW9uUmVzdWx0cy5BZGQoW1N5c3RlbS5NYW5hZ2VtZW50LkF1dG9tYXRpb24uQ29tcGxldGlvblJlc3VsdF06Om5ldygkXywgJF8sICdQYXJhbWV0ZXJWYWx1ZScsICRfKSkNCiAgICB9DQogICAgcmV0dXJuICRDb21wbGV0aW9uUmVzdWx0cw0KfSldW1N0cmluZ10kTGliLCBbU2NyaXB0QmxvY2tdJE9uRmFpbCwgW1N3aXRjaF0kUGFzc1RocnUpDQoNCiAgICAkTG9hZE1vZHVsZSA9IHsNCiAgICAgICAgcGFyYW0oJEZpbGUsW2Jvb2xdJEltcG9ydCkNCiAgICAgICAgdHJ5IHtJbXBvcnQtTW9kdWxlICRGaWxlIC1lYSBzdG9wO3JldHVybiAxfSBjYXRjaCB7fQ0KICAgICAgICAkTGliPUFQLUNvbnZlcnRQYXRoICI8TElCPiI7JExGID0gIiRMaWJcJEZpbGUiDQogICAgICAgICRmID0gJExGLCIkTEYucHNtMSIsIiRMRi5kbGwiIHwgPyB7dGVzdC1wYXRoIC10IGxlYWYgJF99IHwgc2VsZWN0IC1mIDENCiAgICAgICAgaWYgKCRmIC1hbmQgJEltcG9ydCkgew0KICAgICAgICAgICAgSW1wb3J0LU1vZHVsZSAkZg0KICAgICAgICAgICAgaWYgKCQ/KSB7cmV0dXJuICRmfSBlbHNlIHtXcml0ZS1BUCAiIUZhaWxlZCB0byBpbXBvcnQgWyRGaWxlIC0+ICRGXSI7cmV0dXJuIDB9DQogICAgICAgIH0NCiAgICAgICAgcmV0dXJuICRmDQogICAgfQ0KICAgICRJbnZva2VPclJldHVybiA9IHtwYXJhbSgkQ21kKSBpZiAoJENtZCAtaXMgW1NjcmlwdEJsb2NrXSkgeyYgJENtZH0gZWxzZSB7JENtZH19DQogICAgaWYgKCEkT25GYWlsKSB7JFBhc3NUaHJ1ID0gJHRydWV9DQogICAgJFN0YXQgPSAkKHN3aXRjaCAtcmVnZXggKCRMaWIudHJpbSgpKSB7DQogICAgICAgICJeSW50ZXJuZXQkIiAgICAgICAgICAgICAgICAgICB7dGVzdC1jb25uZWN0aW9uIGdvb2dsZS5jb20gLUNvdW50IDEgLVF1aWV0fQ0KICAgICAgICAiXm9zOih3aW4oZG93cyk/fGxpbnV4fHVuaXgpJCIgeyRJc1VuaXggPSAkUFNWZXJzaW9uVGFibGUuUGxhdGZvcm0gLWVxICJVbml4IjtpZiAoJE1hdGNoZXNbMV0gLW1hdGNoICJed2luIikgeyEkSXNVbml4fSBlbHNlIHskSXNVbml4fX0NCiAgICAgICAgIl5hZG1pbihpc3RyYXRvcik/JHxecm9vdCQiICAgIHtUZXN0LUFkbWluaXN0cmF0b3J9DQogICAgICAgICJeZGVwOiguKikkIiAgICAgICAgICAgICAgICAgICB7R2V0LVdoZXJlICRNYXRjaGVzWzFdfQ0KICAgICAgICAiXihsaWJ8bW9kdWxlKTooLiopJCIgICAgICAgICAgeyRMb2FkTW9kdWxlLmludm9rZSgkTWF0Y2hlc1syXSwgJHRydWUpfQ0KICAgICAgICAiXihsaWJ8bW9kdWxlKV90ZXN0OiguKikkIiAgICAgeyRMb2FkTW9kdWxlLmludm9rZSgkTWF0Y2hlc1syXSl9DQogICAgICAgICJeZnVuY3Rpb246KC4qKSQiICAgICAgICAgICAgICB7Z2NtICRNYXRjaGVzWzFdIC1lYSBTaWxlbnRseUNvbnRpbnVlfQ0KICAgICAgICAiXnN0cmljdF9mdW5jdGlvbjooLiopJCIgICAgICAge1Rlc3QtUGF0aCAiRnVuY3Rpb246XCQoJE1hdGNoZXNbMV0pIn0NCiAgICAgICAgIl5hYmlsaXR5Oihlc2NhcGVfY29kZXN8ZW1vamlzfGxvbmdfcGF0aHN8Y29uc29sZV9tYW5pcHVsYXRpb24pJCIgICAgIHsmICRJbnZva2VPclJldHVybiAoQHsNCiAgICAgICAgICAgIGVzY2FwZV9jb2RlcyA9ICRIb3N0LlVJLlN1cHBvcnRzVmlydHVhbFRlcm1pbmFsDQogICAgICAgICAgICBlbW9qaXMgPSAkZW52OldUX1NFU1NJT04gLW9yICRlbnY6V1RfUFJPRklMRV9JRA0KICAgICAgICAgICAgbG9uZ19wYXRocyA9ICRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiIC1vciAoR2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAiSEtMTTpcU1lTVEVNXEN1cnJlbnRDb250cm9sU2V0XENvbnRyb2xcRmlsZVN5c3RlbSIgfCAlIGxvbmdwYXRoc2VuYWJsZWQpDQogICAgICAgICAgICBjb25zb2xlX21hbmlwdWxhdGlvbiA9ICFbU3lzdGVtLkNvbnNvbGVdOjpJc091dHB1dFJlZGlyZWN0ZWQgLWFuZCAoJEhvc3QuTmFtZSAtZXEgJ0NvbnNvbGVIb3N0JykNCiAgICAgICAgfVskTWF0Y2hlc1sxXV0pfQ0KICAgICAgICBkZWZhdWx0IHtXcml0ZS1BUCAiIUludmFsaWQgc2VsZWN0b3IgcHJvdmlkZWQgWyQoIiRMaWIiLnNwbGl0KCc6JylbMF0pXSI7dGhyb3cgJ0JBRF9TRUxFQ1RPUid9DQogICAgfSkNCiAgICBpZiAoISRTdGF0IC1hbmQgJE9uRmFpbCkgeyYgJE9uRmFpbH0NCiAgICBpZiAoJFBhc3NUaHJ1IC1vciAhJE9uRmFpbCkge3JldHVybiAkU3RhdH0NCn0KCmZ1bmN0aW9uIEtleVByZXNzZWQge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bU3RyaW5nW11dJEtleSwgJFN0b3JlID0gIl5eXiIpDQoNCiAgICBpZiAoJFN0b3JlIC1lcSAiXl5eIiAtYW5kICRIb3N0LlVJLlJhd1VJLktleUF2YWlsYWJsZSkgeyRTdG9yZSA9ICRIb3N0LlVJLlJhd1VJLlJlYWRLZXkoIkluY2x1ZGVLZXlVcCxOb0VjaG8iKX0gZWxzZSB7aWYgKCRTdG9yZSAtZXEgIl5eXiIpIHtyZXR1cm4gJEZhbHNlfX0NCiAgICAkS2V5IHwgJSB7DQogICAgICAgICRTT1VSQ0UgPSAkXw0KICAgICAgICBGb3JlYWNoICgkSyBpbiAkU09VUkNFKSB7DQogICAgICAgICAgICBbU3RyaW5nXSRLID0gJEsNCiAgICAgICAgICAgIGlmICgkSyAtbWF0Y2ggIl5jLShcZCspJCIpIHsNCiAgICAgICAgICAgICAgICBpZiAoS2V5UHJlc3NlZENvZGUgJE1hdGNoZXNbMV0gJFN0b3JlKSB7cmV0dXJuICRUcnVlfQ0KICAgICAgICAgICAgfSBlbHNlaWYgKCRLIC1tYXRjaCAiXn5+KC4rKX5+JCIpIHsNCiAgICAgICAgICAgICAgICAkQ29kZSA9IEtleVRyYW5zbGF0ZSAkSw0KICAgICAgICAgICAgICAgIGlmICgkQ29kZSAtaXMgW2hhc2h0YWJsZV0pIHsNCiAgICAgICAgICAgICAgICAgICAgJEhhc0VuaGFuY2VkID0gJFN0b3JlLkNvbnRyb2xLZXlTdGF0ZS5IYXNGbGFnKFtTeXN0ZW0uTWFuYWdlbWVudC5BdXRvbWF0aW9uLkhvc3QuQ29udHJvbEtleVN0YXRlc106OkVuaGFuY2VkS2V5KQ0KICAgICAgICAgICAgICAgICAgICBpZiAoJENvZGUuZW5oYW5jZWQgLW5lICRIYXNFbmhhbmNlZCkge2NvbnRpbnVlfQ0KICAgICAgICAgICAgICAgICAgICAkQ29kZSA9ICRDb2RlLmNvZGUNCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAgICAgaWYgKEtleVByZXNzZWRDb2RlICRDb2RlICRTdG9yZSkge3JldHVybiAkVHJ1ZX0NCiAgICAgICAgICAgIH0gZWxzZSB7DQogICAgICAgICAgICAgICAgaWYgKCRLLmNoYXJzKDApIC1pbiAkU3RvcmUuQ2hhcmFjdGVyKSB7cmV0dXJuICRUcnVlfQ0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgfQ0KICAgIHJldHVybiAkRmFsc2UNCn0KCmZ1bmN0aW9uIEZsYXR0ZW4ge3BhcmFtKFtvYmplY3RbXV0keCkNCg0KICAgIGlmICghKCRYIC1pcyBbYXJyYXldKSkge3JldHVybiAkeH0NCiAgICBpZiAoJFguY291bnQgLWVxIDEpIHsNCiAgICAgICAgcmV0dXJuICR4IHwgJSB7JF99DQogICAgfQ0KICAgICR4IHwgJSB7RmxhdHRlbiAkX30NCn0KCmZ1bmN0aW9uIFNldC1QYXRoIHsNCiAgICBbY21kbGV0YmluZGluZygpXQ0KICAgIHBhcmFtKA0KICAgICAgICBbUGFyYW1ldGVyKE1hbmRhdG9yeSA9ICR0cnVlLCBWYWx1ZUZyb21QaXBlbGluZSA9ICR0cnVlKV1bc3RyaW5nW11dJFBhdGgsDQogICAgICAgIFtzdHJpbmddJFBhdGhWYXIgPSAiUEFUSCINCiAgICApDQogICAgYmVnaW4gew0KICAgICAgICBbc3RyaW5nW11dJEZpbmFsUGF0aA0KICAgIH0NCiAgICBwcm9jZXNzIHsNCiAgICAgICAgJFBhdGggfCAlIHsNCiAgICAgICAgICAgICRGaW5hbFBhdGggKz0gJF8NCiAgICAgICAgfQ0KICAgIH0NCiAgICBlbmQgew0KICAgICAgICAkSXNVbml4ID0gJFBTVmVyc2lvblRhYmxlLlBsYXRmb3JtIC1lcSAiVW5peCINCiAgICAgICAgJFBhdGhTZXAgPSAkKGlmICgkSXNVbml4KSB7IjoifSBlbHNlIHsiOyJ9KQ0KICAgICAgICAkUHRoID0gJEZpbmFsUGF0aCAtam9pbiAkUGF0aFNlcA0KICAgICAgICAkUHRoID0gKCRQdGggLXJlcGxhY2UoIiRQYXRoU2VwKyIsICRQYXRoU2VwKSAtcmVwbGFjZSgiXFwkUGF0aFNlcHxcXCQiLCAkUGF0aFNlcCkpLnRyaW0oJFBhdGhTZXApDQogICAgICAgICRQdGggPSAoKCRQdGgpLnNwbGl0KCRQYXRoU2VwKSB8IHNlbGVjdCAtdW5pcXVlKSAtam9pbiAkUGF0aFNlcA0KICAgICAgICBbRW52aXJvbm1lbnRdOjpTZXRFbnZpcm9ubWVudFZhcmlhYmxlKCRQYXRoVmFyLCAkUHRoKQ0KICAgIH0NCn0KCmZ1bmN0aW9uIEdldC1Fc2NhcGUgew0KICAgIGlmICgkbnVsbCAtZXEgJGdsb2JhbDpBUF9DT05TT0xFLmN1c3RvbUZsYWdzLl9fZGV0ZWN0ZWRfZXNjYXBlX2NvZGVzKSB7JGdsb2JhbDpBUF9DT05TT0xFLmN1c3RvbUZsYWdzLl9fZGV0ZWN0ZWRfZXNjYXBlX2NvZGVzID0gQVAtUmVxdWlyZSAiYWJpbGl0eTplc2NhcGVfY29kZXMifQ0KICAgIGlmICghJEFQX0NPTlNPTEUuY3VzdG9tRmxhZ3MuZm9yY2VVbml4RXNjYXBlcyAtYW5kICEkZ2xvYmFsOkFQX0NPTlNPTEUuY3VzdG9tRmxhZ3MuX19kZXRlY3RlZF9lc2NhcGVfY29kZXMpIHt0aHJvdyAiW0FQQ29uc29sZTo6R2V0LUVzY2FwZV0gWW91ciBjb25zb2xlIGRvZXMgbm90IHN1cHBvcnQgQU5TSSBlc2NhcGUgY29kZXMuIFlvdSBjYW4gc2V0IGAkQVBfQ09OU09MRS5jdXN0b21GbGFncy5ub1VuaXhFc2NhcGVzID0gYCR0cnVlIHRvIGRpc2FibGUgdW5peCBlc2NhcGUgY29kZXMuIE9yLCB1c2U6IGAkQVBfQ09OU09MRS5jdXN0b21GbGFncy5mb3JjZVVuaXhFc2NhcGVzIHRvIGF0dGVtcHQgaXQgYW55d2F5cyJ9DQogICAgIyBXZSBkbyB0aGlzLCBiZWNhdXNlIFBvd2VyU2hlbGwgTmF0aXZlIGRvZXNuJ3Qga25vdyBgZQ0KICAgIHJldHVybiBbQ2hhcl0weDFiICMgYGUNCn0KCmZ1bmN0aW9uIEtleVByZXNzZWRDb2RlIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kVHJ1ZSldW0ludF0kS2V5LCAkU3RvcmU9Il5eXiIpDQoNCiAgICBpZiAoISRIb3N0LlVJLlJhd1VJLktleUF2YWlsYWJsZSAtYW5kICRTdG9yZSAtZXEgIl5eXiIpIHtSZXR1cm4gJEZhbHNlfQ0KICAgIGlmICgkU3RvcmUgLWVxICJeXl4iKSB7JFN0b3JlID0gJEhvc3QuVUkuUmF3VUkuUmVhZEtleSgiSW5jbHVkZUtleVVwLE5vRWNobyIpfQ0KICAgIHJldHVybiAoJEtleSAtaW4gJFN0b3JlLlZpcnR1YWxLZXlDb2RlKQ0KfQoKZnVuY3Rpb24gUGxhY2UtQnVmZmVyZWRDb250ZW50IHtwYXJhbSgkVGV4dCwgJHgsICR5LCBbQ29uc29sZUNvbG9yXSRGb3JlZ3JvdW5kQ29sb3I9W0NvbnNvbGVdOjpGb3JlZ3JvdW5kQ29sb3IsIFtDb25zb2xlQ29sb3JdJEJhY2tncm91bmRDb2xvcj1bQ29uc29sZV06OkJhY2tncm91bmRDb2xvcikNCg0KICAgIGlmICghJFRleHQpIHtyZXR1cm59DQogICAgJGNyZCA9IFtNYW5hZ2VtZW50LkF1dG9tYXRpb24uSG9zdC5Db29yZGluYXRlc106Om5ldygkeCwkeSkNCiAgICAkYiA9ICRIb3N0LlVJLlJhd1VJDQogICAgJGFyciA9ICRiLk5ld0J1ZmZlckNlbGxBcnJheShAKCRUZXh0KSwgJEZvcmVncm91bmRDb2xvciwgJEJhY2tncm91bmRDb2xvcikNCiAgICAkeCA9IFtDb25zb2xlXTo6QnVmZmVyV2lkdGgtMS0kVGV4dC5sZW5ndGgNCiAgICAkYi5TZXRCdWZmZXJDb250ZW50cygkY3JkLCAkYXJyKQ0KfQoKZnVuY3Rpb24gV3JpdGUtQVAgew0KICAgIFtDbWRsZXRCaW5kaW5nKCldDQogICAgcGFyYW0oW1BhcmFtZXRlcihWYWx1ZUZyb21QaXBlbGluZT0xLCBNYW5kYXRvcnk9MSldJFRleHQsW1N3aXRjaF0kTm9TaWduLFtTd2l0Y2hdJFBsYWluVGV4dCxbVmFsaWRhdGVTZXQoIkNlbnRlciIsIlJpZ2h0IiwiTGVmdCIpXVtTdHJpbmddJEFsaWduPSdMZWZ0JyxbU3dpdGNoXSRQYXNzVGhydSkNCiAgICBiZWdpbiB7JFRUID0gQCgpfQ0KICAgIFByb2Nlc3MgeyRUVCArPSAsJFRleHR9DQogICAgRU5EIHsNCiAgICAgICAgJEJsdWUgPSAkKGlmICgkQVBfQ09OU09MRS5jdXN0b21GbGFncy5sZWdhY3lDb2xvcnMpezN9ZWxzZXsnQmx1ZSd9KQ0KICAgICAgICBpZiAoJFRULmNvdW50IC1lcSAxKSB7JFRUID0gJFRUWzBdfTskVGV4dCA9ICRUVA0KICAgICAgICBpZiAoJHRleHQuY291bnQgLWd0IDEgLW9yICR0ZXh0LkdldFR5cGUoKS5OYW1lIC1tYXRjaCAiXFtcXSQiKSB7DQogICAgICAgICAgICByZXR1cm4gJFRleHQgfCAlIHsNCiAgICAgICAgICAgICAgICBXcml0ZS1BUCAkXyAtTm9TaWduOiROb1NpZ24gLVBsYWluVGV4dDokUGxhaW5UZXh0IC1BbGlnbiAkQWxpZ24gLVBhc3NUaHJ1OiRQYXNzVGhydQ0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgICAgIGlmICghJHRleHQgLW9yICR0ZXh0IC1ub3RtYXRjaCAiKD9zbWkpXigoPzxOTkw+eCl8KD88TlM+bnM/KSl7MCwyfSg/PHQ+XD4qKSg/PHM+W1wrXC1cIVwqXCNcQF9dKSg/PHc+LiopIikge3JldHVybiBBbGlnbi1UZXh0ICRUZXh0IC1BbGlnbiAkQWxpZ24gfCBXcml0ZS1Ib3N0fQ0KICAgICAgICAkdGIgID0gIiAgICAiKiRNYXRjaGVzLnQubGVuZ3RoDQogICAgICAgICRDb2wgPSBAeycrJz0nMic7Jy0nPScxMic7JyEnPScxNCc7JyonPSRCbHVlOycjJz0nRGFya0dyYXknOydAJz0nR3JheSc7J18nPSd3aGl0ZSd9WygkU2lnbiA9ICRNYXRjaGVzLlMpXQ0KICAgICAgICBpZiAoISRDb2wpIHtUaHJvdyAiSW5jb3JyZWN0IFNpZ24gWyRTaWduXSBQYXNzZWQhIn0NCiAgICAgICAgJFNpZ24gPSAkKGlmICgkTm9TaWduIC1vciAkTWF0Y2hlcy5OUykgeyIifSBlbHNlIHsiWyRTaWduXSAifSkNCiAgICAgICAgJERhdGEgPSAiJHRiJFNpZ24kKCRNYXRjaGVzLlcpIjtpZiAoISREYXRhKSB7cmV0dXJuIFdyaXRlLUhvc3QgIiJ9DQogICAgICAgIGlmIChBUC1SZXF1aXJlICJmdW5jdGlvbjpBbGlnbi1UZXh0IiAtcGEpIHsNCiAgICAgICAgICAgICREYXRhID0gQWxpZ24tVGV4dCAtQWxpZ24gJEFsaWduICIkdGIkU2lnbiQoJE1hdGNoZXMuVykiDQogICAgICAgIH0NCiAgICAgICAgaWYgKCRQbGFpblRleHQpIHtyZXR1cm4gJERhdGF9DQogICAgICAgICREYXRhTGluZXMgPSAkRGF0YSAtc3BsaXQgImBuIg0KICAgICAgICAxLi4kRGF0YUxpbmVzLkNvdW50IHwgJSB7DQogICAgICAgICAgICAkSWR4ID0gJF8gLSAxDQogICAgICAgICAgICAkTk5MID0gISRpZHggLWFuZCAkTWF0Y2hlcy5OTkwNCiAgICAgICAgICAgIFdyaXRlLUhvc3QgLU5vTmV3TGluZTokTk5MIC1mICRDb2wgJERhdGFMaW5lc1skSWR4XQ0KICAgICAgICAgICAgaWYgKCRQYXNzVGhydSkge3JldHVybiAkRGF0YX0NCiAgICAgICAgfQ0KICAgIH0NCn0KCmZ1bmN0aW9uIEdldC1QYXRoIHtwYXJhbSgkbWF0Y2gsIFtzdHJpbmddJFBhdGhWYXIgPSAiUEFUSCIpDQoNCiAgICAkUHRoID0gW0Vudmlyb25tZW50XTo6R2V0RW52aXJvbm1lbnRWYXJpYWJsZSgkUGF0aFZhcikNCiAgICAkSXNVbml4ID0gJFBTVmVyc2lvblRhYmxlLlBsYXRmb3JtIC1lcSAiVW5peCINCiAgICAkUGF0aFNlcCA9ICQoaWYgKCRJc1VuaXgpIHsiOiJ9IGVsc2UgeyI7In0pDQogICAgaWYgKCEkUHRoKSB7cmV0dXJuIEAoKX0NCiAgICBTZXQtUGF0aCAkUHRoIC1QYXRoVmFyICRQYXRoVmFyDQogICAgJGQgPSAoJFB0aCkuc3BsaXQoJFBhdGhTZXApDQogICAgaWYgKCRtYXRjaCkgeyRkIC1tYXRjaCAkbWF0Y2h9IGVsc2UgeyRkfQ0KfQoKZnVuY3Rpb24gS2V5VHJhbnNsYXRlIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kVHJ1ZSldW1N0cmluZ10kS2V5KQ0KDQogICAgJEhhc2hLZXkgPSBAew0KICAgICAgICAifn5DdHJsQ35+Ij02Nw0KICAgICAgICAifn5TcGFjZX5+Ij0zMg0KICAgICAgICAifn5FU0NBUEV+fiI9MjcNCiAgICAgICAgIn5+RW50ZXJ+fiI9MTMNCiAgICAgICAgIn5+U2hpZnR+fiI9MTYNCiAgICAgICAgIn5+Q29udHJvbH5+Ij0xNw0KICAgICAgICAifn5Db250cm9sTGVmdH5+Ij1Ae2NvZGUgPSAxNzsgZW5oYW5jZWQgPSAkZmFsc2V9DQogICAgICAgICJ+fkNvbnRyb2xSaWdodH5+Ij1Ae2NvZGUgPSAxNzsgZW5oYW5jZWQgPSAkdHJ1ZX0NCiAgICAgICAgIn5+QWx0fn4iPTE4DQogICAgICAgICJ+fkJhY2tTcGFjZX5+Ij04DQogICAgICAgICJ+fkRlbGV0ZX5+Ij00Ng0KICAgICAgICAifn5mMX5+Ij0xMTINCiAgICAgICAgIn5+ZjJ+fiI9MTEzDQogICAgICAgICJ+fmYzfn4iPTExNA0KICAgICAgICAifn5mNH5+Ij0xMTUNCiAgICAgICAgIn5+ZjV+fiI9MTE2DQogICAgICAgICJ+fmY2fn4iPTExNw0KICAgICAgICAifn5mN35+Ij0xMTgNCiAgICAgICAgIn5+Zjh+fiI9MTE5DQogICAgICAgICJ+fmY5fn4iPTEyMA0KICAgICAgICAifn5mMTB+fiI9MTIxDQogICAgICAgICJ+fmYxMX5+Ij0xMjINCiAgICAgICAgIn5+ZjEyfn4iPTEyMw0KICAgICAgICAifn5NdXRlfn4iPTE3Mw0KICAgICAgICAifn5JbnNlcnR+fiI9NDUNCiAgICAgICAgIn5+UGFnZVVwfn4iPTMzDQogICAgICAgICJ+flBhZ2VEb3dufn4iPTM0DQogICAgICAgICJ+fkVORH5+Ij0zNQ0KICAgICAgICAifn5IT01Ffn4iPTM2DQogICAgICAgICJ+fnRhYn5+Ij05DQogICAgICAgICJ+fkNhcHNMb2Nrfn4iPTIwDQogICAgICAgICJ+fk51bUxvY2t+fiI9MTQ0DQogICAgICAgICJ+flNjcm9sbExvY2t+fiI9MTQ1DQogICAgICAgICJ+fldpbmRvd3N+fiI9OTENCiAgICAgICAgIn5+TGVmdH5+Ij0zNw0KICAgICAgICAifn5VcH5+Ij0zOA0KICAgICAgICAifn5SaWdodH5+Ij0zOQ0KICAgICAgICAifn5Eb3dufn4iPTQwDQogICAgICAgICJ+fktQMH5+Ij05Ng0KICAgICAgICAifn5LUDF+fiI9OTcNCiAgICAgICAgIn5+S1Ayfn4iPTk4DQogICAgICAgICJ+fktQM35+Ij05OQ0KICAgICAgICAifn5LUDR+fiI9MTAwDQogICAgICAgICJ+fktQNX5+Ij0xMDENCiAgICAgICAgIn5+S1A2fn4iPTEwMg0KICAgICAgICAifn5LUDd+fiI9MTAzDQogICAgICAgICJ+fktQOH5+Ij0xMDQNCiAgICAgICAgIn5+S1A5fn4iPTEwNQ0KICAgICAgICAifn5LUCp+fiI9MTA2DQogICAgICAgICJ+fktQK35+Ij0xMDcNCiAgICAgICAgIn5+S1Atfn4iPTEwOQ0KICAgICAgICAifn5LUC5+fiI9MTEwDQogICAgICAgICJ+fktQL35+Ij0xMTENCiAgICAgICAgIn5+S1AtRU5URVJ+fiI9QHtjb2RlID0gMTM7IGVuaGFuY2VkID0gJHRydWV9DQogICAgfQ0KICAgIGlmICgkQ29udmVydCA9ICRIYXNoS2V5LiRLZXkpIHtyZXR1cm4gJENvbnZlcnR9DQogICAgVGhyb3cgIkludmFsaWQgU3BlY2lhbCBLZXkgQ29udmVyc2lvbiBbJEtleV0iDQp9CgpmdW5jdGlvbiBUZXN0LUFkbWluaXN0cmF0b3Igew0KICAgIGlmICgkUFNWZXJzaW9uVGFibGUuUGxhdGZvcm0gLWVxICJVbml4Iikgew0KICAgICAgICBpZiAoJCh3aG9hbWkpIC1lcSAicm9vdCIpIHsNCiAgICAgICAgICAgIHJldHVybiAkdHJ1ZQ0KICAgICAgICB9DQogICAgICAgIGVsc2Ugew0KICAgICAgICAgICAgcmV0dXJuICRmYWxzZQ0KICAgICAgICB9DQogICAgfQ0KICAgICMgV2luZG93cw0KICAgIChOZXctT2JqZWN0IFNlY3VyaXR5LlByaW5jaXBhbC5XaW5kb3dzUHJpbmNpcGFsIChbU2VjdXJpdHkuUHJpbmNpcGFsLldpbmRvd3NJZGVudGl0eV06OkdldEN1cnJlbnQoKSkpLklzSW5Sb2xlKFtTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c0J1aWx0aW5Sb2xlXTo6QWRtaW5pc3RyYXRvcikNCn0KCmZ1bmN0aW9uIFN0cmlwLUNvbG9yQ29kZXMgew0KICAgIFtDbWRsZXRCaW5kaW5nKCldcGFyYW0oW1BhcmFtZXRlcihWYWx1ZUZyb21QaXBlbGluZT0xKV0kU3RyKQ0KICAgIHByb2Nlc3MgeyRTdHIgfCAlIHskXyAtcmVwbGFjZSAiJChbcmVnZXhdOjplc2NhcGUoIiQoR2V0LUVzY2FwZSlbIikpXGQrKFw7XGQrKSptIiwiIn19DQp9CgpTZXQtQWxpYXMgPzogSW52b2tlLVRlcm5hcnk=")
} elseif($AP_CONSOLE.warnOnCompileRun) {& $AP_CONSOLE.warnOnCompileRun}
# ========================================END=OF=COMPILER=================================================================|
if ($Renderer -eq "Auto-Detect") {$Renderer = ?: (AP-Require ability:escape_codes) "Unix" "Windows"}
$e = Get-Escape

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
            Write-Host -NoNewline "${e}[$y;${x}H "
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
            $escapeSequence = "${e}[$y;${x}H${e}[38;2;$red;$green;$blue m"
        } else {
            $escapeSequence = "${e}[$y;${x}H${e}[38;2;0;$baseGreen;0m"
        }
        
        Write-Host -NoNewline "$escapeSequence$text${e}[0m"
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
        Write-Host "${e}[?47h"

        # # Save the current cursor position with ESC[s
        # Write-Host "${e}[s"

        # Save Cursor Exact Position with ESC[6n
        Write-Host "${e}[6n"
        while (!$Host.UI.RawUI.KeyAvailable) {Start-Sleep -Milliseconds 10; if ($iters -gt 15) {
            Write-AP "-[Unix Renderer] Failed to get the cursor position"
            exit
        }}
        $Global:cp = $Script:CursorPosUnix = $(while ($Host.UI.RawUI.KeyAvailable) {
            $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown,IncludeKeyUp")
        }).Character -join ""

        # Hide the cursor with ESC[?25l
        Write-Host -NoNewline "${e}[?25l"
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
        Write-Host "${e}[?47l"

        # Show the cursor with ESC[?25h
        Write-Host "${e}[?25h"

        # # Restore the original cursor position with ESC[u
        # Write-Host "${e}[u"

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
try {
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
} finally {
    Reset-Console
}
