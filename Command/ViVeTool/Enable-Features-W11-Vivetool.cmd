::
::
::
@echo off
@cls
::
::
@echo Automated Windows Features Activator for ITsTechBased BlogPosts with ViVeTool
@echo Version 1 
@echo.
@echo Script written by John Tutert for TutSOFT
@echo ITsTechBased thanks for the BlogPosts ! 
@echo. 
::
@echo Installing NanaZip and Curl needed for this Script using WinGet
@winget install M2Team.NanaZip 
@winget install cURL.cURL
::
@echo.
@echo Downloading ViVeTool version 0.3.4
::
@mkdir %USERPROFILE%\Downloads\ViVeTool
@curl -s -L -o %USERPROFILE%\Downloads\ViVeTool\ViVetool.zip https://github.com/thebookisclosed/ViVe/releases/download/v0.3.4/ViVeTool-v0.3.4-IntelAmd.zip
::
@echo Extracting ViVetool
:: 
@7z e %USERPROFILE%\Downloads\ViVeTool\ViVetool.zip -o%USERPROFILE%\Downloads\ViVeTool\ -y
::
@echo Activation of Windows Features using ViVETool
::
::
::      ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::      :::: FEATURE ACTIVATION
::      ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: May 23
:: Build 26200.5603 on Dev and 26120.4151 on Beta
:: https://itstechbased.com/how-to-enable-all-new-features-in-windows-11-dev-beta-new-ai-actions-new-taskbar-change-new-apps/
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:54792954,55345819
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:56661439
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:56887328
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:42733866
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:42739793
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:42739800
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:44357190
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:57166128 /variant:2
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:56778684,56892083
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:56904074
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:57571928
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:44574505
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: April 28
:: Windows 11 24H2 April Update (KB5055627).
:: https://itstechbased.com/how-to-enable-all-new-features-from-the-big-windows-11-24h2-april-update-kb5055627/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:54237988
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47942714
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48697323
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:56659543
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:56038648
::
:: April 21
:: https://itstechbased.com/how-to-enable-the-new-notification-center-in-windows-11-22635-5240/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:42651849
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: April 5
:: Windows 11 (26120.3671 and 26200.5518)
:: https://itstechbased.com/how-to-enable-the-new-start-menu-in-windows-11-26120-3671-and-26200-5518/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49221331
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47205210
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49402389
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:55495322
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: February 20
:: https://itstechbased.com/how-to-enable-new-taskbar-battery-icon-and-percentage-in-windows-11-release-preview-or-main-release/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48822452
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:54237969
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: January 27
:: https://itstechbased.com/how-to-enable-the-new-drag-to-share-feature-in-windows-11-22635-4805/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45624564
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:53397005
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: January 23
:: https://itstechbased.com/how-to-enable-all-new-features-in-the-big-windows-11-24h2-january-2025-update-build-26100-3025/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:54237951
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:29532725
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45286384
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: Januari 21
:: https://itstechbased.com/how-to-enable-all-new-features-in-windows-11-22635-4800-new-start-menu-new-file-explorer-home-new-copy-dialog-and-more/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47205210
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49221331
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:54865932
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47274802
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:51721485
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48895801
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:51784082
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:54618938
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: Januari 6
:: https://itstechbased.com/how-to-enable-new-settings-app-design-in-windows-11-22635-4660/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:51784082
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:54618938
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: December 10 2024
:: https://itstechbased.com/new-big-features-in-the-file-explorer-in-windows-11-22635-4580-how-to-enable/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:54572881
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49143212
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:52081114
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47944061
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: December 3 2024
:: https://itstechbased.com/how-to-enable-new-file-explorer-features-in-windows-11-22635-4515/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49143212
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:52081114
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47944061
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: November 19 2024
:: https://itstechbased.com/how-to-enable-all-new-features-in-the-big-windows-11-24h2-update-build-26100-2448/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:50564332
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:50565209
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: November 12 2024
:: https://itstechbased.com/how-to-enable-all-new-features-in-windows-11-new-taskbar-start-menu-features-canary-and-beta/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:46493758
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45738940
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:41598133
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:41670003
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: September 25 2024
:: https://itstechbased.com/how-to-enable-all-new-features-in-windows-11-26120-1843-new-taskbar-start-menu-file-explorer/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:50564196
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45130483
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:32222762
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47205210
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:46874415
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45286411
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:44560941
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48177092
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:40637063
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: September 4 2024
:: https://itstechbased.com/how-to-enable-all-new-features-in-windows-11-22635-4145-new-settings-new-gamepad-keyboard/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:50692135,48433719,50557073
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:50968699
::	%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:52793632 /variant:X (replace with 1,2 or 3)
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:52793632 /variant:1
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:51900073
::
:: Augustus 13
:: https://itstechbased.com/new-start-menu-ui-in-windows-11-22635-4010-how-to-enable/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47205210
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49221331
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: Juli 21 2024
:: https://itstechbased.com/best-new-setting-in-windows-11-24h2-how-to-enable/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:39007349
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: Juli 18 2024
:: https://itstechbased.com/how-to-enable-new-start-menu-in-windows-11-22635-3930/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47205210
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49221331
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: June 25
:: https://itstechbased.com/how-to-enable-new-taskbar-settings-and-open-with-dialog-in-windows-11-22635-3790/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48525682
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49082522
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:41118774
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:51339492
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: June 24
:: https://itstechbased.com/how-to-enable-new-start-menu-in-windows-11-22635-3790/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48697323
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: June 17 2024
:: https://itstechbased.com/how-to-enable-new-start-menu-jump-lists-in-windows-11-22635-3785/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:32222762
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47205210
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: May 28 2024
:: https://itstechbased.com/how-to-enable-new-features-in-windows-11-22635-3646/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48513251
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45425284
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433541
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433706
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49208286 /variant:2 
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: May 23 2024
:: https://itstechbased.com/how-to-enable-new-file-explorer-in-windows-11-22635-3640/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45130483
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: May 22, 2024
:: https://itstechbased.com/how-to-enable-all-new-features-in-big-windows-11-update-start-menu-file-explorer-and-more/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45286373
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47448915
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:46892085
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:46961347
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47343535
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: May 7, 2024
:: https://itstechbased.com/how-to-enable-new-task-manager-change-in-windows-11-22635-3570/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:38476224
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48380607
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: May 2, 2024
:: https://itstechbased.com/how-to-enable-new-taskbar-animations-in-windows-11-main-release/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48468527
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48969045
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: April 30, 2024
:: https://itstechbased.com/new-windows-11-24h2-feature-in-windows-11-22635-3566-how-to-enable/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49256040
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: April 29, 2024
:: https://itstechbased.com/new-file-explorer-feature-in-windows-11-22635-3566-how-to-enable/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45262221
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: April 3, 2024 
:: https://itstechbased.com/enable-new-features-in-windows-11-new-taskbar-layout-new-copilot-suggestions-and-more-beta/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48660958
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48468527,48468541
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:49010421,49035782
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45596742,45690501
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:46961347
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
:: April 2, 2024
:: https://itstechbased.com/how-to-enable-new-file-explorer-drag-and-drop-to-the-address-bar-in-windows-11-22635-3420/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47664723
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
:: April 1, 2024
:: https://itstechbased.com/how-to-enable-new-start-menu-all-apps-section-in-windows-11-22635-3420/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47205210 /variant:2
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
:: March 19, 2024
:: https://itstechbased.com/how-to-enable-new-copilot-ui-in-windows-11-26080/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47526251
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:5930103
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: March 18, 2024
:: https://itstechbased.com/how-to-enable-new-start-menu-feature-in-windows-11-22635-3350/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48455785
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
::  February 12, 2024
:: https://itstechbased.com/how-to-enable-new-taskbar-thumbnails-and-new-copilot-animations-in-windows-11-26052/
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:29532725
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:5596742 /variant:3
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: January 9, 2024
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45596742
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45240877
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:46375308
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47526873
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: December 12, 2023
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:47384741
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:44531625
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:44685875
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:45046901
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: November 13, 2023
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:46874360
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: xxx
:: %USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:
::
%USERPROFILE%\Downloads\ViVeTool\ViVeTool /enable /id:48433719
::
::
:: :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::
::	Verder gaan met
:: https://itstechbased.com/category/windows-11/page/124/
::
::
@echo Vergeet NIET om Updates & Downloads uit te voeren in de Windows Store
::
@pause
::
exit 1
