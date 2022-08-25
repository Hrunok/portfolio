fn exportFormat selFormat =
(
	theClasses = exporterPlugin.classes
	if selFormat == "FBX" then
		id = findItem theClasses FBXEXP
	else
		id = findItem theClasses OBJEXP
	exporter = theClasses[id]
	
	return exporter
)

fn pathCheck exportPath =
(
	if exportPath != "" and exportPath[2] == ":" then
		return (exportPath + "\\")
	else
		return (maxFilePath + "links\geo" + "\\")
)

fn exportSel exporter rememberPos rememberRot rememberSc filePath =
(
	selObjs = getCurrentSelection()
	for obj in selObjs do
	(
		select obj
		if not isGroupMember obj do
		(
			restMatrix = obj.transform
			newMatrix = matrix3 1

			if rememberPos == true do
				preTranslate newMatrix (restMatrix.translationpart)
			if rememberRot == true do
				preRotate newMatrix (restMatrix.rotationpart)
			if rememberSc == true do
				preScale newMatrix (restMatrix.scalepart)

			if isGroupHead obj then
			(
				for childObj in obj.children do
				(
					childMatrix = childObj.transform
					childObj.transform = matrix3 1 * obj.transform
					resetxform childObj
					collapsestack childObj
					childObj.transform = childMatrix
				)
				resetxform obj
				collapsestack obj
				obj.transform = newMatrix
			)
			else
			(
				obj.transform = newMatrix
				resetxform obj
				collapsestack obj
			)
			
				exportFile (filePath + obj.name) #noPrompt using: exporter selectedOnly: true
				obj.transform *= inverse NewMatrix
				resetxform obj
				obj.transform = restMatrix
		)
	)
)

fn initialzeFBXPresets presetsDir =
(
	paths = getFiles (presetsDir + "*.fbxexportpreset")
	files = for f in paths collect (getFilenameFile f)
	return files
)

fn afterCopy stateNum dir =
(
	msg = "Files successfully exported to " + dir
	if stateNum == 1 then
	(
		return msg
	)
	else if stateNum == 2 then
	(
		DOSCommand ("explorer " + dir)
		return msg
	)
	else stateNum == 3
	(
		setclipboardText dir
		msg += " and this path now in your clipboard."
		return msg
	)
)

exportPath = ""
formatTogText = #("FBX", "OBJ")
fbxPresetsDir = getFilenamePath (getThisScriptFilename()) + "fbxPresets" + "\\"
	
rollout exportMenu "Batch exporter" width:496 height:216
(
	button 'exportBtn' "Export selection" pos:[280,56] width:184 height:60 toolTip:"" align:#left
	label 'rememberLabel' "What do you want to remember before export?" pos:[124,56] width:80 height:60 align:#left
	checkbox 'rememberPos' "Position" pos:[210,56] width:75 height:20 checked:true align:#left
	checkbox 'rememberRot' "Rotation" pos:[210,76] width:75 height:20 checked:true align:#left
	checkbox 'rememberSc' "Scale" pos:[210,96] width:75 height:20 checked:true align:#left
	radiobuttons 'formatTog' "Format" pos:[32,56] width:43 height:46 labels:formatTogText align:#left
	edittext 'loadPath' "Export path" pos:[32,32] width:392 height:15 align:#left
	button 'loadBtn' "..." pos:[432,32] width:31 height:15 align:#left
	dropdownList 'presets' "FBX presets" pos:[32,128] width:214 height:40 items:(initialzeFBXPresets fbxPresetsDir) align:#left
	radiobuttons 'choose' "What to do after copy?" pos:[280,128] width:183 height:62 labels:#("Nothing", "Open destination folder", "Copy destination path to clipboard") columns:1 align:#left
	

	on exportBtn pressed do
	(
		exporter = exportFormat formatTogText[formatTog.state]
		fileDir = pathCheck exportPath
		if selection.count > 0 then
		(
			if formatTogText[formatTog.state] == "FBX" do
			(
				fbxPresetPath = fbxPresetsDir + presets.selected + ".fbxexportpreset"
				FBXExporterSetParam "LoadExportPresetFile" fbxPresetPath
			)
			exportSel exporter rememberPos.state rememberRot.state rememberSc.state fileDir
			exportMsg = afterCopy choose.state fileDir
			print exportMsg
			messagebox exportMsg
		)
		else
			messagebox ("Please, choose objects.")
	)
	on formatTog changed newText do
	(
			if formatTogText[formatTog.state] == "FBX" then
			(		
				presets.visible = true
				presets.items = initialzeFBXPresets fbxPresetsDir
			)
			else
			(
				presets.visible = false
			)
		)
	on loadPath changed txt do
	(
		exportPath = txt
-- 		loadPath.tooltip = (pathCheck exportPath)
	)
	on loadBtn pressed do
	(
		exportPath = getSavePath caption:"Choose folder to export geometry" initialDir: maxFilePath
		loadPath.text = exportPath
-- 		loadPath.tooltip = (pathCheck exportPath)
	)
)
createDialog exportMenu