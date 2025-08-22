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
    & (Get-Alias iex) (B64 "ZnVuY3Rpb24gSW52b2tlLU9yUmV0dXJuIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kdHJ1ZSwgVmFsdWVGcm9tUGlwZWxpbmU9JHRydWUsIFBvc2l0aW9uPTApXVtBbGxvd051bGwoKV0kQ29kZSwgW1BhcmFtZXRlcihWYWx1ZUZyb21SZW1haW5pbmdBcmd1bWVudHM9MSldJF9fUmVzdCwgW1N3aXRjaF0kQXNQcm9jZXNzQmxvY2spDQoNCiAgICBpZiAoISgkQ29kZSAtaXMgW1NjcmlwdEJsb2NrXSkpIHtyZXR1cm4gJENvZGV9DQogICAgaWYgKCEkQXNQcm9jZXNzQmxvY2spIHtyZXR1cm4gJiAkQ29kZSBAX19SZXN0fQ0KICAgIHJldHVybiBGb3JFYWNoLU9iamVjdCAtcHJvY2VzcyAkQ29kZSAtSW5wdXRPYmplY3QgJF9fUmVzdA0KfQoKZnVuY3Rpb24gQVAtQ29udmVydFBhdGgge3BhcmFtKFtQYXJhbWV0ZXIoTWFuZGF0b3J5PSRUcnVlKV1bU3RyaW5nXSRQYXRoKQ0KDQogICAgJFBhdGhTZXAgPSBbSU8uUGF0aF06OkRpcmVjdG9yeVNlcGFyYXRvckNoYXINCiAgICByZXR1cm4gJFBhdGggLXJlcGxhY2UNCiAgICAgICAgIjxEZXA+IiwiPExpYj4ke1BhdGhTZXB9RGVwZW5kZW5jaWVzIiAtcmVwbGFjZQ0KICAgICAgICAiPExpYj4iLCI8SG9tZT4ke1BhdGhTZXB9QVAtTGlicmFyaWVzIiAtcmVwbGFjZQ0KICAgICAgICAiPENvbXAob25lbnRzKT8+IiwiPEhvbWU+JHtQYXRoU2VwfUFQLUNvbXBvbmVudHMiIC1yZXBsYWNlDQogICAgICAgICI8SG9tZT4iLCRQU0hlbGx9CgpmdW5jdGlvbiBBbGlnbi1UZXh0IHsNCiAgICBbQ21kbGV0QmluZGluZygpXQ0KICAgIFtPdXRwdXRUeXBlKFtTdHJpbmddLCBbSGFzaHRhYmxlXSldDQogICAgcGFyYW0oDQogICAgICAgIFtQYXJhbWV0ZXIoTWFuZGF0b3J5PTEsIFZhbHVlRnJvbVBpcGVsaW5lPTEpXVtTdHJpbmdbXV0kVGV4dCwNCiAgICAgICAgW3N3aXRjaF0kQ29sb3JDb2Rlc0Rpc2NyZXRlUGVyTGluZSwNCiAgICAgICAgW3N3aXRjaF0kUG9yY2VsYWluLA0KICAgICAgICAjIFRoaXMgY2FuIGJlIFtpbnRdIG9yIFtzY3JpcHRibG9ja10NCiAgICAgICAgJENvbnN0cmFpblRvV2lkdGgsDQogICAgICAgIFtWYWxpZGF0ZVNldCgiQ2VudGVyIiwiUmlnaHQiLCJMZWZ0IildW1N0cmluZ10kQWxpZ249J0NlbnRlcicNCiAgICApDQogICAgYmVnaW4gew0KICAgICAgICAkaXNWZXJib3NlID0gJFBTQ21kbGV0Lk15SW52b2NhdGlvbi5Cb3VuZFBhcmFtZXRlcnMuVmVyYm9zZQ0KICAgICAgICAkRXNjYXBlQ29kZVNwbGl0dGVyID0gIiQoW3JlZ2V4XTo6ZXNjYXBlKCIkKEdldC1Fc2NhcGUpWyIpKVxkKyg/Olw7XGQrKSptIg0KICAgICAgICAkRGl2aWRlcnMgPSBAe2NodW5rID0gdSAiYHV7MTEyODh9Ijsgc3R5bGUgPSB1ICJgdXsxMjI4OH0ifQ0KICAgICAgICAkRmluYWxGb3JtYXR0ZXIgPSB7DQogICAgICAgICAgICBwYXJhbSgkTGluZXMsICRTdHlsZXMpDQogICAgICAgICAgICBpZiAoISRQb3JjZWxhaW4pIHtyZXR1cm4gJExpbmVzfQ0KICAgICAgICAgICAgaWYgKCRudWxsIC1lcSAkU3R5bGVzKSB7JFN0eWxlcyA9IFtSZWdleF06Ok1hdGNoZXMoKCRMaW5lcyAtam9pbiAiIiksICRFc2NhcGVDb2RlU3BsaXR0ZXIpLnZhbHVlfQ0KICAgICAgICAgICAgcmV0dXJuIEB7TGluZXMgPSAkTGluZXM7IFJ1bm5pbmdTdHlsZXMgPSAkU3R5bGVzfQ0KICAgICAgICB9DQogICAgfQ0KICAgIHByb2Nlc3Mgew0KICAgICAgICBpZiAoJEFsaWduIC1lcSAiTGVmdCIpIHtyZXR1cm4gJiAkRmluYWxGb3JtYXR0ZXIgJFRleHR9DQogICAgICAgIGlmICghIiRUZXh0Ii50cmltKCkpIHtyZXR1cm4gJFRleHR9DQogICAgICAgICRXaW5TaXplID0gPzogJENvbnN0cmFpblRvV2lkdGgge0ludm9rZS1PclJldHVybiAkQ29uc3RyYWluVG9XaWR0aH0gKFtjb25zb2xlXTo6QnVmZmVyV2lkdGgpDQogICAgICAgIA0KICAgICAgICAkVGV4dCA9ICRUZXh0IC1zcGxpdCAiYHI/YG4iDQogICAgICAgIGlmICgkVGV4dC5jb3VudCAtZ3QgMSkgew0KICAgICAgICAgICAgJExpbmVzID0gJFRleHQgfCBBbGlnbi1UZXh0IC1BbGlnbiAkQWxpZ24gLUNvbG9yQ29kZXNEaXNjcmV0ZVBlckxpbmU6JENvbG9yQ29kZXNEaXNjcmV0ZVBlckxpbmUgLVBvcmNlbGFpbg0KICAgICAgICAgICAgaWYgKCRDb2xvckNvZGVzRGlzY3JldGVQZXJMaW5lKSB7DQogICAgICAgICAgICAgICAgZm9yICgkaSA9IDE7ICRpIC1sdCAkTGluZXMuQ291bnQ7ICRpKyspIHsNCiAgICAgICAgICAgICAgICAgICAgJExpbmUgPSAkTGluZXNbJGldDQogICAgICAgICAgICAgICAgICAgICRQcmV2U3R5bGVzICs9ICRMaW5lc1skaSAtIDFdLlJ1bm5pbmdTdHlsZXMNCiAgICAgICAgICAgICAgICAgICAgJExpbmUuTGluZXMgPSAkTGluZS5MaW5lcyB8ICUgeyIkUHJldlN0eWxlcyRfIn0NCiAgICAgICAgICAgICAgICAgICAgJExpbmUuUnVubmluZ1N0eWxlcyA9ICIkUHJldlN0eWxlcyQoJExpbmUuUnVubmluZ1N0eWxlcykiDQogICAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgfQ0KICAgICAgICAgICAgcmV0dXJuICYgJEZpbmFsRm9ybWF0dGVyIChGbGF0dGVuICRMaW5lcy5MaW5lcykgKCRMaW5lcy5SdW5uaW5nU3R5bGVzIC1qb2luICIiKQ0KICAgICAgICB9DQogICAgICAgICMgU2luZ2xlIG5vbiBgbiBsaW5lIHByb2Nlc3MNCiAgICAgICAgJENsZWFuVGV4dFNpemUgPSAoU3RyaXAtQ29sb3JDb2RlcyAoIiIrJFRleHQpKS5MZW5ndGgNCg0KICAgICAgICAjID09PT09PT09IExpbmUgaXMgPCAkV2luU2l6ZSA9PT09PT09PT09PT09PXwNCiAgICAgICAgaWYgKCRDbGVhblRleHRTaXplIC1sZSAkV2luU2l6ZSkgew0KICAgICAgICAgICAgaWYgKCRBbGlnbiAtZXEgIkNlbnRlciIpIHsNCiAgICAgICAgICAgICAgICByZXR1cm4gJiAkRmluYWxGb3JtYXR0ZXIgKCIgIipbbWF0aF06OnRydW5jYXRlKCgkV2luU2l6ZS0kQ2xlYW5UZXh0U2l6ZSkvMikrJFRleHQpDQogICAgICAgICAgICB9DQogICAgICAgICAgICAjIFJpZ2h0DQogICAgICAgICAgICByZXR1cm4gJiAkRmluYWxGb3JtYXR0ZXIgKCIgIiooJFdpblNpemUtJENsZWFuVGV4dFNpemUpKyRUZXh0KQ0KICAgICAgICB9DQoNCiAgICAgICAgIyA9PT09PT09PSBMaW5lIGlzID49ICRXaW5TaXplID09PT09PT09PT09PT09fA0KICAgICAgICAjIFRyYWNraW5nIFN0eWxlcw0KICAgICAgICAkUnVubmluZ1N0eWxlcyA9ICIiDQogICAgICAgICRDdXJybGluZSA9IEB7DQogICAgICAgICAgICBzdHlsZWREYXRhID0gIiINCiAgICAgICAgICAgIGNvbnRlbnRTaXplID0gMA0KICAgICAgICAgICAgZmluYWxMaW5lcyA9IEAoKQ0KICAgICAgICAgICAgbmV4dCA9IHsNCiAgICAgICAgICAgICAgICAjIFdyaXRlLVZlcmJvc2UgIiokSW52b2sgfCBOZXcgTGluZSB8IExpbmVEYXRhOiAkKCgnJyskQ3VycmxpbmUuc3R5bGVkRGF0YS5MZW5ndGgpLlBhZExlZnQoMykpIg0KICAgICAgICAgICAgICAgICRDdXJybGluZS5maW5hbExpbmVzICs9ICwkQ3VycmxpbmUuc3R5bGVkRGF0YQ0KICAgICAgICAgICAgICAgICRDdXJybGluZS5zdHlsZWREYXRhID0gJFJ1bm5pbmdTdHlsZXMNCiAgICAgICAgICAgICAgICAkQ3VycmxpbmUuY29udGVudFNpemUgPSAwDQogICAgICAgICAgICAgICAgIyBXcml0ZS1WZXJib3NlICIqJEludm9rIHwgQ3VyciBUb3RhbCBMaW5lczogJCgkY3VycmxpbmUuZmluYWxMaW5lcy5Db3VudCkiDQogICAgICAgICAgICB9DQogICAgICAgIH0NCiAgICAgICAgJEFsbENodW5rcyA9ICRUZXh0IC1yZXBsYWNlICIoJHtFc2NhcGVDb2RlU3BsaXR0ZXJ9KSsoLio/KSg/PSR7RXNjYXBlQ29kZVNwbGl0dGVyfXwkKSIsIiQoJERpdmlkZXJzLmNodW5rKWAkMSQoJERpdmlkZXJzLnN0eWxlKWAkMiIgLXNwbGl0ICREaXZpZGVycy5jaHVuaw0KICAgICAgICBpZiAoJEFsbENodW5rc1swXSAtbm90Y29udGFpbnMgJERpdmlkZXJzLnN0eWxlKSB7JEFsbENodW5rc1swXSA9ICIkKCREaXZpZGVycy5zdHlsZSkkKCRBbGxDaHVua3NbMF0pIn0gIyBUaGUgZmlyc3QgY2h1bmsgY291bGQgaGF2ZSBubyBzdHlsZXMNCiAgICAgICAgZm9yZWFjaCAoJEN1cnJDaHVuayBpbiAkQWxsQ2h1bmtzKSB7DQogICAgICAgICAgICAkU3R5bGUsJFRleHRDaHVuayA9ICRDdXJyQ2h1bmsgLXNwbGl0ICREaXZpZGVycy5zdHlsZQ0KICAgICAgICAgICAgJFJ1bm5pbmdTdHlsZXMgPSA/OiAkQ29sb3JDb2Rlc0Rpc2NyZXRlUGVyTGluZSAiJFJ1bm5pbmdTdHlsZXMkU3R5bGUiICRTdHlsZQ0KICAgICAgICAgICAgIyBXcml0ZS1Ib3N0IC1mIDIgKCJJbmNvbWluZ1N0eWxlOiAkU3R5bGUgfCBSdW5uaW5nU3R5bGVzOiAkUnVubmluZ1N0eWxlcyIgLXJlcGxhY2UgKFtyZWdleF06OkVzY2FwZSgkKEdldC1Fc2NhcGUpKSksJ1xlJykNCiAgICAgICAgICAgICMgV3JpdGUtSG9zdCAtZiBZZWxsb3cgIlRleHRDaHVuazogJFRleHRDaHVuayINCiAgICAgICAgICAgICRDdXJybGluZS5zdHlsZWREYXRhICs9ICRSdW5uaW5nU3R5bGVzDQogICAgICAgICAgICAkVGV4dENodW5rU3RySW5kZXggPSAwDQogICAgICAgICAgICAjIFdyaXRlLVZlcmJvc2UgIiokSW52b2sgfCBUZXh0Q2h1bms6ICRUZXh0Q2h1bmsgfCBBbGxDaHVua3NTaXplOiAkKCgnJyskQWxsQ2h1bmtzLkxlbmd0aCkuUGFkTGVmdCgzKSkiDQogICAgICAgICAgICB3aGlsZSgkVGV4dENodW5rU3RySW5kZXggLWx0ICRUZXh0Q2h1bmsuTGVuZ3RoKSB7DQogICAgICAgICAgICAgICAgaWYgKCRpc1ZlcmJvc2UpIHtQbGFjZS1CdWZmZXJlZENvbnRlbnQgKCIkSW52b2sgfCBMaW5lRGF0YTogJCgoJycrJEN1cnJsaW5lLnN0eWxlZERhdGEuTGVuZ3RoKS5QYWRMZWZ0KDMpKSB8IENodW5rSWR4OiAkKCgnJyskVGV4dENodW5rU3RySW5kZXgpLlBhZExlZnQoMykpIHwgQ2h1bmtMZW46ICQoJFRleHRDaHVuay5MZW5ndGgpIHwgRmluYWxMaW5lczogJCgkQ3VycmxpbmUuZmluYWxMaW5lcy5Db3VudCkiKSAteCAwIC15IChbQ29uc29sZV06OkJ1ZmZlckhlaWdodCAtIDEpIFllbGxvdyBEYXJrR3JheX0NCiAgICAgICAgICAgICAgICAkQ2h1bmtTaXplID0gJFRleHRDaHVuay5MZW5ndGggLSAkVGV4dENodW5rU3RySW5kZXgNCiAgICAgICAgICAgICAgICAjIFdyaXRlLVZlcmJvc2UgIipDaHVua1NpemU6ICRDaHVua1NpemUiDQogICAgICAgICAgICAgICAgaWYgKCgkQ3VycmxpbmUuY29udGVudFNpemUrJENodW5rU2l6ZSkgLWx0ICRXaW5TaXplKSB7DQogICAgICAgICAgICAgICAgICAgICMgSWYgdGhlIGN1cnJlbnQgY2h1bmsgZml0cyBpbiB0aGUgY3VycmVudCBsaW5lDQogICAgICAgICAgICAgICAgICAgICRDdXJybGluZS5zdHlsZWREYXRhICs9ICRUZXh0Q2h1bmsuU3Vic3RyaW5nKCRUZXh0Q2h1bmtTdHJJbmRleCkNCiAgICAgICAgICAgICAgICAgICAgJEN1cnJsaW5lLmNvbnRlbnRTaXplICs9ICRDaHVua1NpemUNCiAgICAgICAgICAgICAgICAgICAgJFRleHRDaHVua1N0ckluZGV4ICs9ICRDaHVua1NpemUNCiAgICAgICAgICAgICAgICAgICAgY29udGludWUNCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICAgICAgIyBJZiB0aGUgY3VycmVudCBjaHVuayBkb2Vzbid0IGZpdCBpbiB0aGUgY3VycmVudCBsaW5lDQogICAgICAgICAgICAgICAgJG5ld0NvbnRlbnQgPSAkVGV4dENodW5rLlN1YnN0cmluZygkVGV4dENodW5rU3RySW5kZXgsICRXaW5TaXplLSRDdXJybGluZS5jb250ZW50U2l6ZSkNCiAgICAgICAgICAgICAgICAkQ3VycmxpbmUuc3R5bGVkRGF0YSArPSAkbmV3Q29udGVudA0KICAgICAgICAgICAgICAgICRDdXJybGluZS5jb250ZW50U2l6ZSArPSAkbmV3Q29udGVudC5sZW5ndGgNCiAgICAgICAgICAgICAgICAkVGV4dENodW5rU3RySW5kZXggKz0gJG5ld0NvbnRlbnQubGVuZ3RoDQogICAgICAgICAgICAgICAgJiAkQ3VycmxpbmUubmV4dA0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgICAgIGlmICgkQ3VycmxpbmUuY29udGVudFNpemUgLWd0IDApIHsNCiAgICAgICAgICAgIGlmICgkQ3VycmxpbmUuY29udGVudFNpemUpew0KICAgICAgICAgICAgICAgIEFsaWduLVRleHQgLUFsaWduICRBbGlnbiAtVGV4dCAkQ3VycmxpbmUuc3R5bGVkRGF0YSAtQ29sb3JDb2Rlc0Rpc2NyZXRlUGVyTGluZTokQ29sb3JDb2Rlc0Rpc2NyZXRlUGVyTGluZSB8ID8geyRffSB8ICUgew0KICAgICAgICAgICAgICAgICAgICAkQ3VycmxpbmUuZmluYWxMaW5lcyArPSAsJF8NCiAgICAgICAgICAgICAgICB9DQogICAgICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgICAgICRDdXJybGluZS5maW5hbExpbmVzWy0xXSArPSAkQ3VycmxpbmUuc3R5bGVkRGF0YQ0KICAgICAgICAgICAgfQ0KICAgICAgICB9DQogICAgICAgIHJldHVybiAmICRGaW5hbEZvcm1hdHRlciAkQ3VycmxpbmUuZmluYWxMaW5lcyAkUnVubmluZ1N0eWxlcw0KICAgICAgICByZXR1cm4gJEN1cnJsaW5lLmZpbmFsTGluZXMNCiAgICB9DQp9CgpmdW5jdGlvbiBHZXQtV2hlcmUgew0KICAgIFtDbWRsZXRCaW5kaW5nKERlZmF1bHRQYXJhbWV0ZXJTZXROYW1lPSJOb3JtYWwiKV0NCiAgICBwYXJhbSgNCiAgICAgICAgW1BhcmFtZXRlcihNYW5kYXRvcnk9JHRydWUsIFBvc2l0aW9uPTApXVtzdHJpbmddJEZpbGUsDQogICAgICAgIFtTd2l0Y2hdJEFsbCwNCiAgICAgICAgW1BhcmFtZXRlcihQYXJhbWV0ZXJTZXROYW1lPSdOb3JtYWwnKV1bUGFyYW1ldGVyKFBhcmFtZXRlclNldE5hbWU9J1NjYW4nKV1bU3dpdGNoXSRNYW51YWxTY2FuLA0KICAgICAgICBbUGFyYW1ldGVyKFBhcmFtZXRlclNldE5hbWU9J1NjYW4nKV1bU3dpdGNoXSREYmcsDQogICAgICAgIFtQYXJhbWV0ZXIoUGFyYW1ldGVyU2V0TmFtZT0nU2NhbicpXVtzdHJpbmddJFBhdGhWYXIgPSAiUEFUSCINCiAgICApDQogICAgJElzVmVyYm9zZSA9ICREYmcgLW9yICRQU0NtZGxldC5NeUludm9jYXRpb24uQm91bmRQYXJhbWV0ZXJzLlZlcmJvc2UgLW9yICRQU0NtZGxldC5NeUludm9jYXRpb24uQm91bmRQYXJhbWV0ZXJzLkRlYnVnDQogICAgJFdoZXJlQmluRXhpc3RzID0gR2V0LUNvbW1hbmQgIndoZXJlIiAtZWEgU2lsZW50bHlDb250aW51ZQ0KICAgICRJc1VuaXggPSAkUFNWZXJzaW9uVGFibGUuUGxhdGZvcm0gLWVxICJVbml4Ig0KICAgIGlmICgkRmlsZSAtZXEgIndoZXJlIiAtb3IgJEZpbGUgLWVxICJ3aGVyZS5leGUiKSB7cmV0dXJuICRXaGVyZUJpbkV4aXN0c30NCiAgICBpZiAoJFdoZXJlQmluRXhpc3RzIC1hbmQgISRNYW51YWxTY2FuKSB7DQogICAgICAgICRPdXQ9JG51bGwNCiAgICAgICAgaWYgKCRJc1VuaXgpIHsNCiAgICAgICAgICAgICRPdXQgPSB3aGljaCAkZmlsZSAyPiRudWxsDQogICAgICAgIH0gZWxzZSB7JE91dCA9IHdoZXJlLmV4ZSAkZmlsZSAyPiRudWxsfQ0KDQogICAgICAgIGlmICghJE91dCkge3JldHVybn0NCiAgICAgICAgaWYgKCRBbGwpIHtyZXR1cm4gJE91dH0NCiAgICAgICAgcmV0dXJuIEAoJE91dClbMF0NCiAgICB9DQogICAgZm9yZWFjaCAoJEZvbGRlciBpbiAoR2V0LVBhdGggLVBhdGhWYXIgJFBhdGhWYXIpKSB7DQogICAgICAgIGlmICgkSXNVbml4KSB7DQogICAgICAgICAgICAkTG9va3VwID0gIiRGb2xkZXIvJEZpbGUiDQogICAgICAgICAgICBpZiAoJElzVmVyYm9zZSkge1dyaXRlLUFQICIqQ2hlY2tpbmcgWyRMb29rdXBdIn0NCiAgICAgICAgICAgIGlmICghKFRlc3QtUGF0aCAtUGF0aFR5cGUgTGVhZiAkTG9va3VwKSkge2NvbnRpbnVlfQ0KICAgICAgICAgICAgUmVzb2x2ZS1QYXRoICRMb29rdXAgfCAlIFBhdGgNCiAgICAgICAgICAgIGlmICghJEFsbCkge3JldHVybn0NCiAgICAgICAgfSBlbHNlIHsNCiAgICAgICAgICAgIGZvcmVhY2ggKCRFeHRlbnNpb24gaW4gKEdldC1QYXRoIC1QYXRoVmFyIFBBVEhFWFQpKSB7DQogICAgICAgICAgICAgICAgJExvb2t1cCA9ICIkRm9sZGVyLyRGaWxlJEV4dGVuc2lvbiINCiAgICAgICAgICAgICAgICBpZiAoJElzVmVyYm9zZSkge1dyaXRlLUFQICIqQ2hlY2tpbmcgWyRMb29rdXBdIn0NCiAgICAgICAgICAgICAgICBpZiAoIShUZXN0LVBhdGggLVBhdGhUeXBlIExlYWYgJExvb2t1cCkpIHtjb250aW51ZX0NCiAgICAgICAgICAgICAgICBSZXNvbHZlLVBhdGggJExvb2t1cCB8ICUgUGF0aA0KICAgICAgICAgICAgICAgIGlmICghJEFsbCkge3JldHVybn0NCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAgIH0NCn0KCmZ1bmN0aW9uIFByb2Nlc3MtVW5pY29kZSB7DQogICAgJEZpbmFsQXJncyA9IEZsYXR0ZW4gJGFyZ3MNCiAgICAjIFBvd2VyU2hlbGwgQ29yZSBzeW50YXggd2hlbiBwcm9jZXNzZWQgYnkgUG93ZXJTaGVsbCBOYXRpdmUNCiAgICBpZiAoIiRGaW5hbEFyZ3MiIC1tYXRjaCAidXsoXHcrKX0iKSB7DQogICAgICAgIHJldHVybiBbUmVnZXhdOjpVbmVzY2FwZSgoIiRGaW5hbEFyZ3MiIC1yZXBsYWNlICJ1eyhcdyspfSIsJ1x1JDEnKSkNCiAgICB9DQogICAgaWYgKCEoJEZpbmFsQXJncyB8ID8geyRfIC1pc25vdCBbaW50XX0pKSB7DQogICAgICAgIHJldHVybiBbY2hhcltdXSRGaW5hbEFyZ3MgLWpvaW4gJycNCiAgICB9DQogICAgcmV0dXJuICRhcmdzDQp9CgpmdW5jdGlvbiBJbnZva2UtVGVybmFyeSB7cGFyYW0oJGRlY2lkZXIsICRpZnRydWUsICRpZmZhbHNlID0ge30pDQoNCiAgICAkSW52b2tlT3JSZXR1cm4gPSB7DQogICAgICAgIHBhcmFtKCRDbWQpDQogICAgICAgIGlmICgkQ21kIC1pcyBbU2NyaXB0QmxvY2tdKSB7JiAkQ21kfSBlbHNlIHskQ21kfQ0KICAgIH0NCiAgICBpZiAoJGRlY2lkZXIpIHsgJiAkSW52b2tlT3JSZXR1cm4gJGlmdHJ1ZSB9IGVsc2UgeyAmICRJbnZva2VPclJldHVybiAkaWZmYWxzZSB9DQp9CgpmdW5jdGlvbiBBUC1SZXF1aXJlIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kVHJ1ZSldW0FsaWFzKCJGdW5jdGlvbmFsaXR5IiwiTGlicmFyeSIpXVtBcmd1bWVudENvbXBsZXRlcih7DQogICAgW091dHB1dFR5cGUoW1N5c3RlbS5NYW5hZ2VtZW50LkF1dG9tYXRpb24uQ29tcGxldGlvblJlc3VsdF0pXQ0KICAgIHBhcmFtKA0KICAgICAgICBbc3RyaW5nXSAkQ29tbWFuZE5hbWUsDQogICAgICAgIFtzdHJpbmddICRQYXJhbWV0ZXJOYW1lLA0KICAgICAgICBbc3RyaW5nXSAkV29yZFRvQ29tcGxldGUsDQogICAgICAgIFtTeXN0ZW0uTWFuYWdlbWVudC5BdXRvbWF0aW9uLkxhbmd1YWdlLkNvbW1hbmRBc3RdICRDb21tYW5kQXN0LA0KICAgICAgICBbU3lzdGVtLkNvbGxlY3Rpb25zLklEaWN0aW9uYXJ5XSAkRmFrZUJvdW5kUGFyYW1ldGVycw0KICAgICkNCiAgICAkQ29tcGxldGlvblJlc3VsdHMgPSBbU3lzdGVtLkNvbGxlY3Rpb25zLkdlbmVyaWMuTGlzdFtTeXN0ZW0uTWFuYWdlbWVudC5BdXRvbWF0aW9uLkNvbXBsZXRpb25SZXN1bHRdXTo6bmV3KCkNCiAgICAkTGliID0gQCgiSW50ZXJuZXQiLCJvczp3aW5kb3dzIiwib3M6bGludXgiLCJvczp1bml4IiwiYWRtaW5pc3RyYXRvciIsInJvb3QiLCJkZXA6IiwibGliOiIsImxpYl90ZXN0OiIsIm1vZHVsZToiLCJtb2R1bGVfdGVzdDoiLCJmdW5jdGlvbjoiLCJzdHJpY3RfZnVuY3Rpb246IiwiYWJpbGl0eTplc2NhcGVfY29kZXMiLCJhYmlsaXR5OmVtb2ppcyIsImFiaWxpdHk6bG9uZ19wYXRocyIsImFiaWxpdHk6Y29uc29sZV9tYW5pcHVsYXRpb24iKQ0KICAgICRqc09yID0ge2ZvcmVhY2ggKCRhIGluICRhcmdzKSB7JGEgPSAkKGlmKCRhIC1pcyBbc2NyaXB0YmxvY2tdKXsmJGF9ZWxzZXskYX0pO2lmICghJGEpe2NvbnRpbnVlfTtyZXR1cm4gJGF9O3JldHVybiAkYX0gIyBNYW51YWxseSBlbWJlZGRlZCBKUy1PUg0KICAgICYgJGpzT3IgeyRMaWIgfCA/IHskXyAtbGlrZSAiJFdvcmRUb0NvbXBsZXRlKiJ9fSB7JExpYiB8ID8geyRfIC1saWtlICIqJFdvcmRUb0NvbXBsZXRlKiJ9fSB8ICUgew0KICAgICAgICAkQ29tcGxldGlvblJlc3VsdHMuQWRkKFtTeXN0ZW0uTWFuYWdlbWVudC5BdXRvbWF0aW9uLkNvbXBsZXRpb25SZXN1bHRdOjpuZXcoJF8sICRfLCAnUGFyYW1ldGVyVmFsdWUnLCAkXykpDQogICAgfQ0KICAgIHJldHVybiAkQ29tcGxldGlvblJlc3VsdHMNCn0pXVtTdHJpbmddJExpYiwgW1NjcmlwdEJsb2NrXSRPbkZhaWwsIFtTd2l0Y2hdJFBhc3NUaHJ1KQ0KDQogICAgJExvYWRNb2R1bGUgPSB7DQogICAgICAgIHBhcmFtKCRGaWxlLFtib29sXSRJbXBvcnQpDQogICAgICAgIHRyeSB7SW1wb3J0LU1vZHVsZSAkRmlsZSAtZWEgc3RvcDtyZXR1cm4gMX0gY2F0Y2gge30NCiAgICAgICAgJExpYj1BUC1Db252ZXJ0UGF0aCAiPExJQj4iOyRMRiA9ICIkTGliXCRGaWxlIg0KICAgICAgICAkZiA9ICRMRiwiJExGLnBzbTEiLCIkTEYuZGxsIiB8ID8ge3Rlc3QtcGF0aCAtdCBsZWFmICRffSB8IHNlbGVjdCAtZiAxDQogICAgICAgIGlmICgkZiAtYW5kICRJbXBvcnQpIHsNCiAgICAgICAgICAgIEltcG9ydC1Nb2R1bGUgJGYNCiAgICAgICAgICAgIGlmICgkPykge3JldHVybiAkZn0gZWxzZSB7V3JpdGUtQVAgIiFGYWlsZWQgdG8gaW1wb3J0IFskRmlsZSAtPiAkRl0iO3JldHVybiAwfQ0KICAgICAgICB9DQogICAgICAgIHJldHVybiAkZg0KICAgIH0NCiAgICAkSW52b2tlT3JSZXR1cm4gPSB7cGFyYW0oJENtZCkgaWYgKCRDbWQgLWlzIFtTY3JpcHRCbG9ja10pIHsmICRDbWR9IGVsc2UgeyRDbWR9fQ0KICAgIGlmICghJE9uRmFpbCkgeyRQYXNzVGhydSA9ICR0cnVlfQ0KICAgICRTdGF0ID0gJChzd2l0Y2ggLXJlZ2V4ICgkTGliLnRyaW0oKSkgew0KICAgICAgICAiXkludGVybmV0JCIgICAgICAgICAgICAgICAgICAge3Rlc3QtY29ubmVjdGlvbiBnb29nbGUuY29tIC1Db3VudCAxIC1RdWlldH0NCiAgICAgICAgIl5vczood2luKGRvd3MpP3xsaW51eHx1bml4KSQiIHskSXNVbml4ID0gJFBTVmVyc2lvblRhYmxlLlBsYXRmb3JtIC1lcSAiVW5peCI7aWYgKCRNYXRjaGVzWzFdIC1tYXRjaCAiXndpbiIpIHshJElzVW5peH0gZWxzZSB7JElzVW5peH19DQogICAgICAgICJeYWRtaW4oaXN0cmF0b3IpPyR8XnJvb3QkIiAgICB7VGVzdC1BZG1pbmlzdHJhdG9yfQ0KICAgICAgICAiXmRlcDooLiopJCIgICAgICAgICAgICAgICAgICAge0dldC1XaGVyZSAkTWF0Y2hlc1sxXX0NCiAgICAgICAgIl4obGlifG1vZHVsZSk6KC4qKSQiICAgICAgICAgIHskTG9hZE1vZHVsZS5pbnZva2UoJE1hdGNoZXNbMl0sICR0cnVlKX0NCiAgICAgICAgIl4obGlifG1vZHVsZSlfdGVzdDooLiopJCIgICAgIHskTG9hZE1vZHVsZS5pbnZva2UoJE1hdGNoZXNbMl0pfQ0KICAgICAgICAiXmZ1bmN0aW9uOiguKikkIiAgICAgICAgICAgICAge2djbSAkTWF0Y2hlc1sxXSAtZWEgU2lsZW50bHlDb250aW51ZX0NCiAgICAgICAgIl5zdHJpY3RfZnVuY3Rpb246KC4qKSQiICAgICAgIHtUZXN0LVBhdGggIkZ1bmN0aW9uOlwkKCRNYXRjaGVzWzFdKSJ9DQogICAgICAgICJeYWJpbGl0eTooZXNjYXBlX2NvZGVzfGVtb2ppc3xsb25nX3BhdGhzfGNvbnNvbGVfbWFuaXB1bGF0aW9uKSQiICAgICB7JiAkSW52b2tlT3JSZXR1cm4gKEB7DQogICAgICAgICAgICBlc2NhcGVfY29kZXMgPSAkSG9zdC5VSS5TdXBwb3J0c1ZpcnR1YWxUZXJtaW5hbA0KICAgICAgICAgICAgZW1vamlzID0gJGVudjpXVF9TRVNTSU9OIC1vciAkZW52OldUX1BST0ZJTEVfSUQNCiAgICAgICAgICAgIGxvbmdfcGF0aHMgPSAkUFNWZXJzaW9uVGFibGUuUGxhdGZvcm0gLWVxICJVbml4IiAtb3IgKEdldC1JdGVtUHJvcGVydHkgLVBhdGggIkhLTE06XFNZU1RFTVxDdXJyZW50Q29udHJvbFNldFxDb250cm9sXEZpbGVTeXN0ZW0iIHwgJSBsb25ncGF0aHNlbmFibGVkKQ0KICAgICAgICAgICAgY29uc29sZV9tYW5pcHVsYXRpb24gPSAhW1N5c3RlbS5Db25zb2xlXTo6SXNPdXRwdXRSZWRpcmVjdGVkIC1hbmQgKCRIb3N0Lk5hbWUgLWVxICdDb25zb2xlSG9zdCcpDQogICAgICAgIH1bJE1hdGNoZXNbMV1dKX0NCiAgICAgICAgZGVmYXVsdCB7V3JpdGUtQVAgIiFJbnZhbGlkIHNlbGVjdG9yIHByb3ZpZGVkIFskKCIkTGliIi5zcGxpdCgnOicpWzBdKV0iO3Rocm93ICdCQURfU0VMRUNUT1InfQ0KICAgIH0pDQogICAgaWYgKCEkU3RhdCAtYW5kICRPbkZhaWwpIHsmICRPbkZhaWx9DQogICAgaWYgKCRQYXNzVGhydSAtb3IgISRPbkZhaWwpIHtyZXR1cm4gJFN0YXR9DQp9CgpmdW5jdGlvbiBLZXlQcmVzc2VkIHtwYXJhbShbUGFyYW1ldGVyKE1hbmRhdG9yeT0kVHJ1ZSldW1N0cmluZ1tdXSRLZXksICRTdG9yZSA9ICJeXl4iKQ0KDQogICAgaWYgKCRTdG9yZSAtZXEgIl5eXiIgLWFuZCAkSG9zdC5VSS5SYXdVSS5LZXlBdmFpbGFibGUpIHskU3RvcmUgPSAkSG9zdC5VSS5SYXdVSS5SZWFkS2V5KCJJbmNsdWRlS2V5VXAsTm9FY2hvIil9IGVsc2Uge2lmICgkU3RvcmUgLWVxICJeXl4iKSB7cmV0dXJuICRGYWxzZX19DQogICAgJEtleSB8ICUgew0KICAgICAgICAkU09VUkNFID0gJF8NCiAgICAgICAgRm9yZWFjaCAoJEsgaW4gJFNPVVJDRSkgew0KICAgICAgICAgICAgW1N0cmluZ10kSyA9ICRLDQogICAgICAgICAgICBpZiAoJEsgLW1hdGNoICJeYy0oXGQrKSQiKSB7DQogICAgICAgICAgICAgICAgaWYgKEtleVByZXNzZWRDb2RlICRNYXRjaGVzWzFdICRTdG9yZSkge3JldHVybiAkVHJ1ZX0NCiAgICAgICAgICAgIH0gZWxzZWlmICgkSyAtbWF0Y2ggIl5+figuKyl+fiQiKSB7DQogICAgICAgICAgICAgICAgJENvZGUgPSBLZXlUcmFuc2xhdGUgJEsNCiAgICAgICAgICAgICAgICBpZiAoJENvZGUgLWlzIFtoYXNodGFibGVdKSB7DQogICAgICAgICAgICAgICAgICAgICRIYXNFbmhhbmNlZCA9ICRTdG9yZS5Db250cm9sS2V5U3RhdGUuSGFzRmxhZyhbU3lzdGVtLk1hbmFnZW1lbnQuQXV0b21hdGlvbi5Ib3N0LkNvbnRyb2xLZXlTdGF0ZXNdOjpFbmhhbmNlZEtleSkNCiAgICAgICAgICAgICAgICAgICAgaWYgKCRDb2RlLmVuaGFuY2VkIC1uZSAkSGFzRW5oYW5jZWQpIHtjb250aW51ZX0NCiAgICAgICAgICAgICAgICAgICAgJENvZGUgPSAkQ29kZS5jb2RlDQogICAgICAgICAgICAgICAgfQ0KICAgICAgICAgICAgICAgIGlmIChLZXlQcmVzc2VkQ29kZSAkQ29kZSAkU3RvcmUpIHtyZXR1cm4gJFRydWV9DQogICAgICAgICAgICB9IGVsc2Ugew0KICAgICAgICAgICAgICAgIGlmICgkSy5jaGFycygwKSAtaW4gJFN0b3JlLkNoYXJhY3Rlcikge3JldHVybiAkVHJ1ZX0NCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAgIH0NCiAgICByZXR1cm4gJEZhbHNlDQp9CgpmdW5jdGlvbiBGbGF0dGVuIHtwYXJhbShbb2JqZWN0W11dJHgpDQoNCiAgICBpZiAoISgkWCAtaXMgW2FycmF5XSkpIHtyZXR1cm4gJHh9DQogICAgaWYgKCRYLmNvdW50IC1lcSAxKSB7DQogICAgICAgIHJldHVybiAkeCB8ICUgeyRffQ0KICAgIH0NCiAgICAkeCB8ICUge0ZsYXR0ZW4gJF99DQp9CgpmdW5jdGlvbiBTZXQtUGF0aCB7DQogICAgW2NtZGxldGJpbmRpbmcoKV0NCiAgICBwYXJhbSgNCiAgICAgICAgW1BhcmFtZXRlcihNYW5kYXRvcnkgPSAkdHJ1ZSwgVmFsdWVGcm9tUGlwZWxpbmUgPSAkdHJ1ZSldW3N0cmluZ1tdXSRQYXRoLA0KICAgICAgICBbc3RyaW5nXSRQYXRoVmFyID0gIlBBVEgiDQogICAgKQ0KICAgIGJlZ2luIHsNCiAgICAgICAgW3N0cmluZ1tdXSRGaW5hbFBhdGgNCiAgICB9DQogICAgcHJvY2VzcyB7DQogICAgICAgICRQYXRoIHwgJSB7DQogICAgICAgICAgICAkRmluYWxQYXRoICs9ICRfDQogICAgICAgIH0NCiAgICB9DQogICAgZW5kIHsNCiAgICAgICAgJElzVW5peCA9ICRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiDQogICAgICAgICRQYXRoU2VwID0gJChpZiAoJElzVW5peCkgeyI6In0gZWxzZSB7IjsifSkNCiAgICAgICAgJFB0aCA9ICRGaW5hbFBhdGggLWpvaW4gJFBhdGhTZXANCiAgICAgICAgJFB0aCA9ICgkUHRoIC1yZXBsYWNlKCIkUGF0aFNlcCsiLCAkUGF0aFNlcCkgLXJlcGxhY2UoIlxcJFBhdGhTZXB8XFwkIiwgJFBhdGhTZXApKS50cmltKCRQYXRoU2VwKQ0KICAgICAgICAkUHRoID0gKCgkUHRoKS5zcGxpdCgkUGF0aFNlcCkgfCBzZWxlY3QgLXVuaXF1ZSkgLWpvaW4gJFBhdGhTZXANCiAgICAgICAgW0Vudmlyb25tZW50XTo6U2V0RW52aXJvbm1lbnRWYXJpYWJsZSgkUGF0aFZhciwgJFB0aCkNCiAgICB9DQp9CgpmdW5jdGlvbiBHZXQtRXNjYXBlIHsNCiAgICBpZiAoJG51bGwgLWVxICRBUF9DT05TT0xFLmN1c3RvbUZsYWdzLl9fZGV0ZWN0ZWRfZXNjYXBlX2NvZGVzKSB7JEFQX0NPTlNPTEUuY3VzdG9tRmxhZ3MuX19kZXRlY3RlZF9lc2NhcGVfY29kZXMgPSBBUC1SZXF1aXJlICJhYmlsaXR5OmVzY2FwZV9jb2RlcyJ9DQogICAgaWYgKCEkQVBfQ09OU09MRS5jdXN0b21GbGFncy5mb3JjZVVuaXhFc2NhcGVzIC1hbmQgISRBUF9DT05TT0xFLmN1c3RvbUZsYWdzLl9fZGV0ZWN0ZWRfZXNjYXBlX2NvZGVzKSB7dGhyb3cgIltBUENvbnNvbGU6OkdldC1Fc2NhcGVdIFlvdXIgY29uc29sZSBkb2VzIG5vdCBzdXBwb3J0IEFOU0kgZXNjYXBlIGNvZGVzLiBZb3UgY2FuIHNldCBgJEFQX0NPTlNPTEUuY3VzdG9tRmxhZ3Mubm9Vbml4RXNjYXBlcyA9IGAkdHJ1ZSB0byBkaXNhYmxlIHVuaXggZXNjYXBlIGNvZGVzLiBPciwgdXNlOiBgJEFQX0NPTlNPTEUuY3VzdG9tRmxhZ3MuZm9yY2VVbml4RXNjYXBlcyB0byBhdHRlbXB0IGl0IGFueXdheXMifQ0KICAgICMgV2UgZG8gdGhpcywgYmVjYXVzZSBQb3dlclNoZWxsIE5hdGl2ZSBkb2Vzbid0IGtub3cgYGUNCiAgICByZXR1cm4gW0NoYXJdMHgxYiAjIGBlDQp9CgpmdW5jdGlvbiBLZXlQcmVzc2VkQ29kZSB7cGFyYW0oW1BhcmFtZXRlcihNYW5kYXRvcnk9JFRydWUpXVtJbnRdJEtleSwgJFN0b3JlPSJeXl4iKQ0KDQogICAgaWYgKCEkSG9zdC5VSS5SYXdVSS5LZXlBdmFpbGFibGUgLWFuZCAkU3RvcmUgLWVxICJeXl4iKSB7UmV0dXJuICRGYWxzZX0NCiAgICBpZiAoJFN0b3JlIC1lcSAiXl5eIikgeyRTdG9yZSA9ICRIb3N0LlVJLlJhd1VJLlJlYWRLZXkoIkluY2x1ZGVLZXlVcCxOb0VjaG8iKX0NCiAgICByZXR1cm4gKCRLZXkgLWluICRTdG9yZS5WaXJ0dWFsS2V5Q29kZSkNCn0KCmZ1bmN0aW9uIFBsYWNlLUJ1ZmZlcmVkQ29udGVudCB7cGFyYW0oJFRleHQsICR4LCAkeSwgW0NvbnNvbGVDb2xvcl0kRm9yZWdyb3VuZENvbG9yPVtDb25zb2xlXTo6Rm9yZWdyb3VuZENvbG9yLCBbQ29uc29sZUNvbG9yXSRCYWNrZ3JvdW5kQ29sb3I9W0NvbnNvbGVdOjpCYWNrZ3JvdW5kQ29sb3IpDQoNCiAgICBpZiAoISRUZXh0KSB7cmV0dXJufQ0KICAgICRjcmQgPSBbTWFuYWdlbWVudC5BdXRvbWF0aW9uLkhvc3QuQ29vcmRpbmF0ZXNdOjpuZXcoJHgsJHkpDQogICAgJGIgPSAkSG9zdC5VSS5SYXdVSQ0KICAgICRhcnIgPSAkYi5OZXdCdWZmZXJDZWxsQXJyYXkoQCgkVGV4dCksICRGb3JlZ3JvdW5kQ29sb3IsICRCYWNrZ3JvdW5kQ29sb3IpDQogICAgJHggPSBbQ29uc29sZV06OkJ1ZmZlcldpZHRoLTEtJFRleHQubGVuZ3RoDQogICAgJGIuU2V0QnVmZmVyQ29udGVudHMoJGNyZCwgJGFycikNCn0KCmZ1bmN0aW9uIFdyaXRlLUFQIHsNCiAgICBbQ21kbGV0QmluZGluZygpXQ0KICAgIHBhcmFtKFtQYXJhbWV0ZXIoVmFsdWVGcm9tUGlwZWxpbmU9MSwgTWFuZGF0b3J5PTEpXSRUZXh0LFtTd2l0Y2hdJE5vU2lnbixbU3dpdGNoXSRQbGFpblRleHQsW1ZhbGlkYXRlU2V0KCJDZW50ZXIiLCJSaWdodCIsIkxlZnQiKV1bU3RyaW5nXSRBbGlnbj0nTGVmdCcsW1N3aXRjaF0kUGFzc1RocnUpDQogICAgYmVnaW4geyRUVCA9IEAoKX0NCiAgICBQcm9jZXNzIHskVFQgKz0gLCRUZXh0fQ0KICAgIEVORCB7DQogICAgICAgICRCbHVlID0gJChpZiAoJEFQX0NPTlNPTEUuY3VzdG9tRmxhZ3MubGVnYWN5Q29sb3JzKXszfWVsc2V7J0JsdWUnfSkNCiAgICAgICAgaWYgKCRUVC5jb3VudCAtZXEgMSkgeyRUVCA9ICRUVFswXX07JFRleHQgPSAkVFQNCiAgICAgICAgaWYgKCR0ZXh0LmNvdW50IC1ndCAxIC1vciAkdGV4dC5HZXRUeXBlKCkuTmFtZSAtbWF0Y2ggIlxbXF0kIikgew0KICAgICAgICAgICAgcmV0dXJuICRUZXh0IHwgJSB7DQogICAgICAgICAgICAgICAgV3JpdGUtQVAgJF8gLU5vU2lnbjokTm9TaWduIC1QbGFpblRleHQ6JFBsYWluVGV4dCAtQWxpZ24gJEFsaWduIC1QYXNzVGhydTokUGFzc1RocnUNCiAgICAgICAgICAgIH0NCiAgICAgICAgfQ0KICAgICAgICBpZiAoISR0ZXh0IC1vciAkdGV4dCAtbm90bWF0Y2ggIig/c21pKV4oKD88Tk5MPngpfCg/PE5TPm5zPykpezAsMn0oPzx0Plw+KikoPzxzPltcK1wtXCFcKlwjXEBfXSkoPzx3Pi4qKSIpIHtyZXR1cm4gQWxpZ24tVGV4dCAkVGV4dCAtQWxpZ24gJEFsaWduIHwgV3JpdGUtSG9zdH0NCiAgICAgICAgJHRiICA9ICIgICAgIiokTWF0Y2hlcy50Lmxlbmd0aA0KICAgICAgICAkQ29sID0gQHsnKyc9JzInOyctJz0nMTInOychJz0nMTQnOycqJz0kQmx1ZTsnIyc9J0RhcmtHcmF5JzsnQCc9J0dyYXknOydfJz0nd2hpdGUnfVsoJFNpZ24gPSAkTWF0Y2hlcy5TKV0NCiAgICAgICAgaWYgKCEkQ29sKSB7VGhyb3cgIkluY29ycmVjdCBTaWduIFskU2lnbl0gUGFzc2VkISJ9DQogICAgICAgICRTaWduID0gJChpZiAoJE5vU2lnbiAtb3IgJE1hdGNoZXMuTlMpIHsiIn0gZWxzZSB7IlskU2lnbl0gIn0pDQogICAgICAgICREYXRhID0gIiR0YiRTaWduJCgkTWF0Y2hlcy5XKSI7aWYgKCEkRGF0YSkge3JldHVybiBXcml0ZS1Ib3N0ICIifQ0KICAgICAgICBpZiAoQVAtUmVxdWlyZSAiZnVuY3Rpb246QWxpZ24tVGV4dCIgLXBhKSB7DQogICAgICAgICAgICAkRGF0YSA9IEFsaWduLVRleHQgLUFsaWduICRBbGlnbiAiJHRiJFNpZ24kKCRNYXRjaGVzLlcpIg0KICAgICAgICB9DQogICAgICAgIGlmICgkUGxhaW5UZXh0KSB7cmV0dXJuICREYXRhfQ0KICAgICAgICAkRGF0YUxpbmVzID0gJERhdGEgLXNwbGl0ICJgbiINCiAgICAgICAgMS4uJERhdGFMaW5lcy5Db3VudCB8ICUgew0KICAgICAgICAgICAgJElkeCA9ICRfIC0gMQ0KICAgICAgICAgICAgJE5OTCA9ICEkaWR4IC1hbmQgJE1hdGNoZXMuTk5MDQogICAgICAgICAgICBXcml0ZS1Ib3N0IC1Ob05ld0xpbmU6JE5OTCAtZiAkQ29sICREYXRhTGluZXNbJElkeF0NCiAgICAgICAgICAgIGlmICgkUGFzc1RocnUpIHtyZXR1cm4gJERhdGF9DQogICAgICAgIH0NCiAgICB9DQp9CgpmdW5jdGlvbiBHZXQtUGF0aCB7cGFyYW0oJG1hdGNoLCBbc3RyaW5nXSRQYXRoVmFyID0gIlBBVEgiKQ0KDQogICAgJFB0aCA9IFtFbnZpcm9ubWVudF06OkdldEVudmlyb25tZW50VmFyaWFibGUoJFBhdGhWYXIpDQogICAgJElzVW5peCA9ICRQU1ZlcnNpb25UYWJsZS5QbGF0Zm9ybSAtZXEgIlVuaXgiDQogICAgJFBhdGhTZXAgPSAkKGlmICgkSXNVbml4KSB7IjoifSBlbHNlIHsiOyJ9KQ0KICAgIGlmICghJFB0aCkge3JldHVybiBAKCl9DQogICAgU2V0LVBhdGggJFB0aCAtUGF0aFZhciAkUGF0aFZhcg0KICAgICRkID0gKCRQdGgpLnNwbGl0KCRQYXRoU2VwKQ0KICAgIGlmICgkbWF0Y2gpIHskZCAtbWF0Y2ggJG1hdGNofSBlbHNlIHskZH0NCn0KCmZ1bmN0aW9uIEtleVRyYW5zbGF0ZSB7cGFyYW0oW1BhcmFtZXRlcihNYW5kYXRvcnk9JFRydWUpXVtTdHJpbmddJEtleSkNCg0KICAgICRIYXNoS2V5ID0gQHsNCiAgICAgICAgIn5+Q3RybEN+fiI9NjcNCiAgICAgICAgIn5+U3BhY2V+fiI9MzINCiAgICAgICAgIn5+RVNDQVBFfn4iPTI3DQogICAgICAgICJ+fkVudGVyfn4iPTEzDQogICAgICAgICJ+flNoaWZ0fn4iPTE2DQogICAgICAgICJ+fkNvbnRyb2x+fiI9MTcNCiAgICAgICAgIn5+Q29udHJvbExlZnR+fiI9QHtjb2RlID0gMTc7IGVuaGFuY2VkID0gJGZhbHNlfQ0KICAgICAgICAifn5Db250cm9sUmlnaHR+fiI9QHtjb2RlID0gMTc7IGVuaGFuY2VkID0gJHRydWV9DQogICAgICAgICJ+fkFsdH5+Ij0xOA0KICAgICAgICAifn5CYWNrU3BhY2V+fiI9OA0KICAgICAgICAifn5EZWxldGV+fiI9NDYNCiAgICAgICAgIn5+ZjF+fiI9MTEyDQogICAgICAgICJ+fmYyfn4iPTExMw0KICAgICAgICAifn5mM35+Ij0xMTQNCiAgICAgICAgIn5+ZjR+fiI9MTE1DQogICAgICAgICJ+fmY1fn4iPTExNg0KICAgICAgICAifn5mNn5+Ij0xMTcNCiAgICAgICAgIn5+Zjd+fiI9MTE4DQogICAgICAgICJ+fmY4fn4iPTExOQ0KICAgICAgICAifn5mOX5+Ij0xMjANCiAgICAgICAgIn5+ZjEwfn4iPTEyMQ0KICAgICAgICAifn5mMTF+fiI9MTIyDQogICAgICAgICJ+fmYxMn5+Ij0xMjMNCiAgICAgICAgIn5+TXV0ZX5+Ij0xNzMNCiAgICAgICAgIn5+SW5zZXJ0fn4iPTQ1DQogICAgICAgICJ+flBhZ2VVcH5+Ij0zMw0KICAgICAgICAifn5QYWdlRG93bn5+Ij0zNA0KICAgICAgICAifn5FTkR+fiI9MzUNCiAgICAgICAgIn5+SE9NRX5+Ij0zNg0KICAgICAgICAifn50YWJ+fiI9OQ0KICAgICAgICAifn5DYXBzTG9ja35+Ij0yMA0KICAgICAgICAifn5OdW1Mb2Nrfn4iPTE0NA0KICAgICAgICAifn5TY3JvbGxMb2Nrfn4iPTE0NQ0KICAgICAgICAifn5XaW5kb3dzfn4iPTkxDQogICAgICAgICJ+fkxlZnR+fiI9MzcNCiAgICAgICAgIn5+VXB+fiI9MzgNCiAgICAgICAgIn5+UmlnaHR+fiI9MzkNCiAgICAgICAgIn5+RG93bn5+Ij00MA0KICAgICAgICAifn5LUDB+fiI9OTYNCiAgICAgICAgIn5+S1Axfn4iPTk3DQogICAgICAgICJ+fktQMn5+Ij05OA0KICAgICAgICAifn5LUDN+fiI9OTkNCiAgICAgICAgIn5+S1A0fn4iPTEwMA0KICAgICAgICAifn5LUDV+fiI9MTAxDQogICAgICAgICJ+fktQNn5+Ij0xMDINCiAgICAgICAgIn5+S1A3fn4iPTEwMw0KICAgICAgICAifn5LUDh+fiI9MTA0DQogICAgICAgICJ+fktQOX5+Ij0xMDUNCiAgICAgICAgIn5+S1Aqfn4iPTEwNg0KICAgICAgICAifn5LUCt+fiI9MTA3DQogICAgICAgICJ+fktQLX5+Ij0xMDkNCiAgICAgICAgIn5+S1Aufn4iPTExMA0KICAgICAgICAifn5LUC9+fiI9MTExDQogICAgICAgICJ+fktQLUVOVEVSfn4iPUB7Y29kZSA9IDEzOyBlbmhhbmNlZCA9ICR0cnVlfQ0KICAgIH0NCiAgICBpZiAoJENvbnZlcnQgPSAkSGFzaEtleS4kS2V5KSB7cmV0dXJuICRDb252ZXJ0fQ0KICAgIFRocm93ICJJbnZhbGlkIFNwZWNpYWwgS2V5IENvbnZlcnNpb24gWyRLZXldIg0KfQoKZnVuY3Rpb24gVGVzdC1BZG1pbmlzdHJhdG9yIHsNCiAgICBpZiAoJFBTVmVyc2lvblRhYmxlLlBsYXRmb3JtIC1lcSAiVW5peCIpIHsNCiAgICAgICAgaWYgKCQod2hvYW1pKSAtZXEgInJvb3QiKSB7DQogICAgICAgICAgICByZXR1cm4gJHRydWUNCiAgICAgICAgfQ0KICAgICAgICBlbHNlIHsNCiAgICAgICAgICAgIHJldHVybiAkZmFsc2UNCiAgICAgICAgfQ0KICAgIH0NCiAgICAjIFdpbmRvd3MNCiAgICAoTmV3LU9iamVjdCBTZWN1cml0eS5QcmluY2lwYWwuV2luZG93c1ByaW5jaXBhbCAoW1NlY3VyaXR5LlByaW5jaXBhbC5XaW5kb3dzSWRlbnRpdHldOjpHZXRDdXJyZW50KCkpKS5Jc0luUm9sZShbU2VjdXJpdHkuUHJpbmNpcGFsLldpbmRvd3NCdWlsdGluUm9sZV06OkFkbWluaXN0cmF0b3IpDQp9CgpmdW5jdGlvbiBTdHJpcC1Db2xvckNvZGVzIHsNCiAgICBbQ21kbGV0QmluZGluZygpXXBhcmFtKFtQYXJhbWV0ZXIoVmFsdWVGcm9tUGlwZWxpbmU9MSldJFN0cikNCiAgICBwcm9jZXNzIHskU3RyIHwgJSB7JF8gLXJlcGxhY2UgIiQoW3JlZ2V4XTo6ZXNjYXBlKCIkKEdldC1Fc2NhcGUpWyIpKVxkKyhcO1xkKykqbSIsIiJ9fQ0KfQoKU2V0LUFsaWFzIHUgUHJvY2Vzcy1Vbmljb2RlClNldC1BbGlhcyA/OiBJbnZva2UtVGVybmFyeQ==")
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
