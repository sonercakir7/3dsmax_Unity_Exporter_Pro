/* 3dsmax Unity Exporter Pro (Fixed)
   --------------------------------------------------
   Platform: 3ds Max 2024/2025/2026
   Target: Unity 3D
   Author: Soner Cakir
   GitHub: https://github.com/sonercakir7
   License: GNU GPLv3
   
   Description: Batch exporter with separate logging and Unity-friendly defaults.
*/

-- Pencereleri temizle
try(destroyDialog rol_UnityExporterPro)catch()
try(destroyDialog rol_ExportLogs)catch()

-- -----------------------------------------------------------------------------
-- 1. LOG PENCERESİ (Düzeltildi)
-- -----------------------------------------------------------------------------
rollout rol_ExportLogs "Export Logs" width:400 height:300
(
    listbox lb_logs "Process Details:" height:18 readOnly:true
    button btn_clear "Clear Logs" width:100 align:#left across:2
    button btn_close "Close" width:100 align:#right

    -- [FIX] timeString fonksiyonu artık en üstte tanımlı
    fn timeString = 
    (
        local t = getLocalTime()
        -- Saat, Dakika, Saniye formatlaması
        return (t[4] as string + ":" + t[5] as string + ":" + t[6] as string)
    )

    fn AddLog msg =
    (
        local currentItems = lb_logs.items
        -- timeString artık tanımlı olduğu için hata vermez
        append currentItems ("[" + timeString() + "] " + msg)
        lb_logs.items = currentItems
        lb_logs.selection = currentItems.count
    )

    on btn_clear pressed do lb_logs.items = #()
    on btn_close pressed do destroyDialog rol_ExportLogs
)

-- -----------------------------------------------------------------------------
-- 2. ANA PENCERE
-- -----------------------------------------------------------------------------
rollout rol_UnityExporterPro "3dsmax Unity Exporter Pro" width:280 height:630
(
    -- HEADER
    label lbl_title "UNITY EXPORTER PRO" pos:[10,10] width:260 height:20 style_sunkenedge:true align:#center

    -- 1. TRANSFORM & GEOMETRY
    group "Geometry Processing"
    (
        checkbox chk_xform "Smart Reset XForm" checked:true tooltip:"Applies Reset XForm to Meshes (Safe for Groups)."
        checkbox chk_triangulate "Triangulate" checked:true tooltip:"Prevents ngon issues in Unity."
        checkbox chk_center "Move to Origin (0,0,0)" checked:true tooltip:"Exports object at world zero."
        
        -- Default: Original Pivot (Index 1)
        dropdownlist ddl_pivot "Pivot Point" items:#("Original Pivot", "Bottom Center", "Object Center") selection:1
    )

    -- 2. NAMING
    group "Naming & Sanitization"
    (
        edittext edt_prefix "Prefix:" fieldWidth:90 text:"SM_" across:2
        edittext edt_suffix "Suffix:" fieldWidth:90 text:""
        checkbox chk_fixNames "Sanitize Names" checked:true tooltip:"Spaces to underscores."
        checkbox chk_lowercase "Force Lowercase" checked:false
    )

    -- 3. FBX SETTINGS
    group "FBX Configuration"
    (
        -- Default: FBX 2009 (Index 1)
        dropdownlist ddl_fbxVer "FBX Version" items:#("FBX 2009 (Legacy/Safe)", "FBX 2020 (PBR)", "FBX 2014") selection:1
        checkbox chk_embed "Embed Media (Textures)" checked:true
        checkbox chk_anim "Export Animation" checked:false
        checkbox chk_collider "Auto-Generate Mesh Collider" checked:false
    )

    -- 4. OUTPUT
    group "Export Destination"
    (
        button btn_path "Select Unity Project Folder" width:240 height:30
        edittext edt_displayPath "" readOnly:true height:20 text:"..."
        
        progressbar pb_export value:0 color:orange
        button btn_doExport "START BATCH EXPORT" width:240 height:45 highlightColor:(color 0 160 255)
        button btn_showLogs "Open Log Window" width:240 height:20
    )

    -- 5. INFO
    group "Info"
    (
        label lbl_author "Author: Soner Cakir" align:#center
        hyperlink lnk_git "GitHub (GNU GPLv3)" address:"https://github.com/sonercakir7" align:#center color:(color 0 120 255)
    )

    -- VARIABLES
    local savePath = ""
    local iniFile = getDir #userScripts + "\\UnityExporterPro_Settings.ini"

    -- HELPERS
    fn Log msg =
    (
        if (rol_ExportLogs.open) do rol_ExportLogs.AddLog msg
    )

    fn ApplyPivotLogic obj mode =
    (
        case mode of
        (
            1: () -- Original: Do Nothing
            2: ( -- Bottom Center
                centerPivot obj
                obj.pivot.z = obj.min.z
            )
            3: ( -- Center
                centerPivot obj
            )
        )
    )

    fn SanitizeString str forceLower =
    (
        local newStr = substituteString str " " "_"
        newStr = substituteString newStr "-" "_"
        if forceLower do newStr = toLower newStr
        return newStr
    )

    -- LOAD/SAVE SETTINGS
    fn SaveSettings =
    (
        setINISetting iniFile "Settings" "Path" savePath
        setINISetting iniFile "Settings" "Prefix" edt_prefix.text
    )

    fn LoadSettings =
    (
        local storedPath = getINISetting iniFile "Settings" "Path"
        if storedPath != "" and doesFileExist storedPath do 
        (
            savePath = storedPath
            edt_displayPath.text = storedPath
        )
    )

    on rol_UnityExporterPro open do LoadSettings()
    
    on btn_showLogs pressed do 
    (
        createDialog rol_ExportLogs
    )

    on btn_path pressed do
    (
        local path = getSavePath caption:"Select Unity Assets Folder"
        if path != undefined do
        (
            savePath = path + "\\"
            edt_displayPath.text = savePath
            SaveSettings()
        )
    )

    on btn_doExport pressed do
    (
        if savePath == "" then (messageBox "Please select an export folder first." title:"Error"; return false)
        
        if (not rol_ExportLogs.open) do createDialog rol_ExportLogs
        rol_ExportLogs.AddLog "--- BATCH EXPORT STARTED ---"

        local rawSel = selection as array
        if rawSel.count == 0 then (messageBox "No objects selected." title:"Warning"; return false)

        -- Filter Group Children
        local exportList = #()
        for obj in rawSel do
        (
            local parentSelected = (obj.parent != undefined and (findItem rawSel obj.parent) != 0)
            if not parentSelected do append exportList obj
        )

        rol_ExportLogs.AddLog ("Processing " + (exportList.count as string) + " root objects.")

        -- FBX Setup
        local fbxID = case ddl_fbxVer.selection of
        (
            1: "FBX200900"
            2: "FBX202000"
            3: "FBX201400"
        )
        
        FBXExporterSetParam "FileVersion" fbxID
        FBXExporterSetParam "ASCII" false
        FBXExporterSetParam "UpAxis" "Y"
        FBXExporterSetParam "ScaleFactor" 1.0
        FBXExporterSetParam "EmbedTextures" chk_embed.checked
        FBXExporterSetParam "Triangulate" chk_triangulate.checked
        FBXExporterSetParam "Animation" chk_anim.checked
        FBXExporterSetParam "Preserveinstances" true 

        pb_export.value = 0
        local progressStep = 100.0 / exportList.count
        local count = 0

        undo "UnityBatchExport" on
        (
            for i = 1 to exportList.count do
            (
                local obj = exportList[i]
                select obj 

                -- Name Processing
                local cleanName = SanitizeString obj.name chk_lowercase.checked
                if chk_fixNames.checked do cleanName = substituteString cleanName " " "_"
                local finalName = edt_prefix.text + cleanName + edt_suffix.text

                -- Geometry Operations
                if (superclassof obj == GeometryClass and not isGroupHead obj) do
                (
                    if chk_xform.checked do 
                    (
                        resetXForm obj
                        convertToPoly obj
                    )
                )

                -- Pivot & Position
                ApplyPivotLogic obj ddl_pivot.selection
                
                local oldPos = obj.pos
                if chk_center.checked do obj.pos = [0,0,0]

                -- Collider
                local colObj = undefined
                if chk_collider.checked and superclassof obj == GeometryClass do
                (
                    colObj = copy obj
                    colObj.name = "UCX_" + finalName
                    convertToPoly colObj
                    proOptimizer modifier:colObj 
                    colObj.modifiers[#ProOptimizer].VertexPercent = 20.0 
                    colObj.modifiers[#ProOptimizer].Calculate = true
                    collapseStack colObj
                    colObj.parent = obj
                    colObj.material = undefined
                )

                -- Export
                local fullPath = savePath + finalName + ".fbx"
                Log ("Exporting: " + finalName)
                
                try 
                (
                    exportFile fullPath #noPrompt selectedOnly:true using:FBXEXP
                )
                catch
                (
                    Log ("ERROR exporting: " + finalName)
                )

                -- Cleanup
                if chk_center.checked do obj.pos = oldPos
                if colObj != undefined do delete colObj

                count += 1
                pb_export.value = i * progressStep
            )
            select rawSel
        )

        pb_export.value = 100
        Log "--- EXPORT COMPLETED SUCCESSFULLY ---"
        messageBox ("Done! Check Log Window for details.") title:"Success"
    )
)

createDialog rol_UnityExporterPro