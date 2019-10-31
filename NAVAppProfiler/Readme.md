Installing and Running the Sample Code

1. Create a folder for the Profiler in the NAV Development Environment Add-Ins folder and the Server Add-ins folder of NST.
2. Copy all DLLs into the Add-ins folders.
3. Important!!! Open properties for the EtwPerformanceProfiler.dll and Microsoft.Diagnostics.Tracing.TraceEvent.dll (right mouse click in the Windows Explorer and choose Properties). Make sure that DLLs are not locked. Unlock them if they are locked.
4. Import and compile the application objects from the App Objects folder.
5. Important!!! Open the Server CustomSettings.XML file and change EnableFullALFunctionTracing property from false to true. This specifies whether full C/AL method tracing is enabled when an ETW session is performed.
6. When this setting is enabled, all C/AL methods and statements are logged in an ETL log file.
7. Restart NST.
8. Run the Page 50000.

Source:
https://archive.codeplex.com/?p=navappprofiler
