typeArr = #("balcony", "balks", "doors", "floor", "foundation", "outdoor staircase", "roof", "walls", "windows")
subtypeSizeArr = #("small", "medium", "big")
subtype1Arr = #("closed balcony", "open balcony", "support", "window", "straight staircase negative", "straight staircase positive", "vertical staircase", "base down", "base negative", "base postive", "roof negative", "roof positive")
subtype2Arr = #("base corner", "connector corner", "corner", "base side", "connector side", "side", "base transition", "connector transition", "base wall", "connector wall", "base")
wallElementsArr = #("wall", "door", "window")
dirArr = #("front", "back", "left", "right", "top", "down", "center")
materialArr = #("thatched", "tiling", "fakhverk", "logs", "stone")

typeVal = ""
subtypeSizeVal = ""
subtype1Val = ""
subtype2Val = ""
wallCombLeftSizeVal = ""
wallCombLeftTypeVal = ""
wallCombRightSizeVal = ""
wallCombRightTypeVal = ""
dirVal = ""
materialVal = ""
sideFromVal = ""
sideToVal = ""
tierVal = ""
varVal = ""
newName = "house"

fn windowTypeReact sizeParm &sizeVal typeParmVal &typeVal prefix =
(
	if typeParmVal == "window" then
	(
		sizeParm.visible = true
		sizeVal = prefix + sizeParm.selected
		typeVal = " " + typeParmVal
	)
	else
	(
		sizeParm.visible = false
		sizeVal = ""
		typeVal = prefix + typeParmVal
	)
)

fn comboboxUpdate val &parmVal prefix zeroText =
(
	if val.count > 0 then
		parmVal = prefix + val
	else
		parmVal = zeroText
)
	
fn updateSliderLabel labelParm labelText sliderParm sliderValue toggleCond functionCond =
(
	labelParm.text = labelText + "\n" + sliderValue as string
	if functionCond == true do
		sliderParm.enabled = toggleCond
)

fn hideDependentParm cond parmArr &parmVal trueVal falseVal =
(
	for parm in parmArr do
		parm.visible = cond
	if cond == true then
		parmVal = trueVal
	else
		parmVal = falseVal
)

fn resizeWindow cond parmArr yOffset =
(
	if cond == false do
		yOffset *= -1
	houseGeneratorGeoRenamer.height += yOffset
	for parm in parmArr do
	(
		local newPos = [parm.pos[1], parm.pos[2] + yOffset]
		parm.pos = newPos
	)
)

fn updateNewName label =
(
	newName = "house" + typeVal + subtypeSizeVal + subtype1Val + subtype2Val + wallCombLeftSizeVal + wallCombLeftTypeVal + wallCombRightSizeVal + wallCombRightTypeVal +dirVal + materialVal + sideFromVal + sideToVal + tierVal + varVal
	label.text = newName
)
	
rollout houseGeneratorGeoRenamer "House generator geometry renamer" width:900 height:580
(
	-- base elements block
	label 'nameLabel' newName pos:[30,30] width:500 height:30 align:#left
	button 'renameBtn' "Rename" pos:[640,15] width:200 height:50 align:#left
	
	-- type block
	label 'typeLabel' "Type" pos:[30,80] width:80 height:15 align:#left
	combobox 'type' "" pos:[30,100] width:200 height:10 items: typeArr align:#left
	button 'typeAdd' "+" pos:[235,100] width:20 height:20 align:#left
	button 'typeRemove' "-" pos:[260,100] width:20 height:20 align:#left
	
	-- subtype size block
	listbox 'subtypeSize' "" pos:[290,100] width:80 height:3 items:subtypeSizeArr align:#left visible: false
	-- subtype 1 block
	label 'subtype1Label' "Subtype 1" pos:[380,80] width:72 height:15 align:#left
	combobox 'subtype1' "" pos:[380,100] width:200 height:10 items:subtype1Arr align:#left
	button 'subtype1Add' "+" pos:[585,100] width:20 height:20 align:#left
	button 'subtype1Remove' "-" pos:[610,100] width:20 height:20 align:#left
		
	-- subtype 2 block
	label 'subtype2Label' "Subtype 2" pos:[640,80] width:72 height:15 align:#left visible: false
	combobox 'subtype2' "" pos:[640,100] width:200 height:10 items: subtype2Arr align:#left visible: false
	button 'subtype2Add' "+" pos:[845,100] width:20 height:20 align:#left visible: false
	button 'subtype2Remove' "-" pos:[870,100] width:20 height:20 align:#left visible: false
	
	-- wall combinations block
	checkbox 'wallCombTog' "" pos:[10,256] width:15 height:15 align:#left
	label 'wallCombLabel' "Wall combination" pos:[30,256] width:72 height:30 align:#left	
	
	label 'wallCombLeftLabel' "left side" pos:[30,296] width:72 height:15 align:#left visible: false
	listbox 'wallCombLeftSize' "" pos:[30,316] width:100 height:3 items: subtypeSizeArr align:#left visible: false
	listbox 'wallCombLeftType' "" pos:[140,316] width:100 height:3 items: wallElementsArr align:#left visible: false
	label 'wallCombRightLabel' "right side" pos:[290,296] width:72 height:15 align:#left visible: false
	listbox 'wallCombRightSize' "" pos:[290,316] width:100 height:3 items: subtypeSizeArr align:#left visible: false
	listbox 'wallCombRightType' "" pos:[400,316] width:100 height:3 items: wallElementsArr align:#left visible: false

	-- direction block
	checkbox 'dirTog' "" pos:[10,376] width:15 height:15 align:#left
	label 'dirLabel' "Direction" pos:[30,376] width:72 height:15 align:#left
	listbox 'dir' "" pos:[30,396] width:100 height:10 items: dirArr align:#left enabled: false
	
	-- material block
	label 'materialLabel' "Material" pos:[140,376] width:72 height:15 align:#left
	combobox 'material' "" pos:[140,396] width:150 height:10 items: materialArr align:#left
	button 'materialAdd' "+" pos:[295,396] width:20 height:20 align:#left
	button 'materialRemove' "-" pos:[320,396] width:20 height:20 align:#left
	
	-- side from block
	checkbox 'sideFromTog' "" pos:[360,376] width:15 height:15 align:#left
	label 'sideFromLabel' "Size from | width\n1" pos:[380,376] width:150 height:30 align:#left
	slider 'sideFrom' "" pos:[370,406] width:200 height:25 enabled:false range:[1,10,1] type:#integer ticks:10 align:#left

	-- side to block
	checkbox 'sideToTog' "" pos:[610,376] width:15 height:15 align:#left visible: false
	label 'sideToLabel' "Size to | length\n1" pos:[630,376] width:150 height:30 align:#left	visible: false
	slider 'sideTo' "" pos:[620,406] width:200 height:25 enabled:false range:[1,10,1] type:#integer ticks:1 align:#left visible: false
	
	-- tier block
	checkbox 'tierTog' "" pos:[360,456] width:15 height:15 align:#left
	label 'tierLabel' "Tier\n1" pos:[380,456] width:80 height:30 align:#left
	slider 'tier' "" pos:[370,486] width:100 height:25 enabled:false range:[1,5,1] type:#integer ticks:1 align:#left

	-- variation block
	checkbox 'varTog' "" pos:[510,456] width:15 height:15 align:#left
	label 'varLabel' "Variation\n1" pos:[530,456] width:80 height:30 align:#left
	slider 'var' "" pos:[520,486] width:100 height:25 enabled:false range:[1,5,1] type:#integer ticks:1 align:#left
	
	-- type update
	on type selected index do
	(
		comboboxUpdate type.selected &typeVal "_" "_unknown type"
		updateNewName nameLabel
	)
	on type changed val do
	(
		comboboxUpdate val &typeVal "_" "_unknown type"
		updateNewName nameLabel
	)
	
	-- subtype size update
	on subtypeSize selected index do
	(
		if subtypeSize.visible == true do
			subtypeSizeVal = "-" + subtypeSize.selected
		updateNewName nameLabel
	)
	
	-- subtype 1 update
	on subtype1 selected index do
	(
		hideDependentParm (subtype1.selected.count > 0) #(subtype2Label, subtype2, subtype2Add, subtype2Remove) &subtype2Val ("-" + subtype2.text) ""
		windowTypeReact subtypeSize &subtypeSizeVal subtype1.selected &subtype1Val "-"
		if (subtype1.selected) == "window" then
			comboboxUpdate subtype1.selected &subtype1Val " " ""
		else
			comboboxUpdate subtype1.selected &subtype1Val "-" ""
		
		if subtype1.selected.count > 0 then
		
		updateNewName nameLabel
	)
	on subtype1 changed val do
	(
		hideDependentParm (val.count > 0) #(subtype2Label, subtype2, subtype2Add, subtype2Remove) &subtype2Val ("-" + subtype2.text) ""
		windowTypeReact subtypeSize &subtypeSizeVal val &subtype1Val "-"
		if val == "window" then
			comboboxUpdate val &subtype1Val " " ""
		else
			comboboxUpdate val &subtype1Val "-" ""
		updateNewName nameLabel
	)
	
	-- subtype 2 update
	on subtype2 selected index do
	(
		comboboxUpdate subtype2.selected &subtype2Val "-" ""
		updateNewName nameLabel
	)
	on subtype2 changed val do
	(
		comboboxUpdate val &subtype2Val "-" ""
		updateNewName nameLabel
	)
	
	-- wall combinations update
	on wallCombTog changed val do
	(
		resizeWindow val #(dirTog, dirLabel, dir, materialLabel, material, materialAdd, materialRemove, sideFromTog, sideFromLabel, sideFrom, sideToTog, sideToLabel, sideTo, tierTog, tierLabel, tier, varTog, varLabel, var) 85
		for parm in #(wallCombLeftLabel, wallCombLeftType, wallCombLeftSize, wallCombRightLabel, wallCombRightType, wallCombRightSize) do
			parm.visible = val
		if val == true then
		(
			windowTypeReact wallCombLeftSize &wallCombLeftSizeVal wallCombLeftType.selected &wallCombLeftTypeVal "_"
			windowTypeReact wallCombRightSize &wallCombRightSizeVal wallCombRightType.selected &wallCombRightTypeVal "-" 			
		)
		else
		(
			wallCombLeftSizeVal = ""
			wallCombLeftTypeVal = ""
			wallCombRightSizeVal = ""
			wallCombRightTypeVal = ""
		)
		updateNewName nameLabel
	)

	-- wall combination left update
	on wallCombLeftSize selected index do
	(
		if wallCombLeftSize.visible == true do
			wallCombLeftSizeVal = "_" + wallCombLeftSize.selected
		updateNewName nameLabel
	)
	on wallCombLeftType selected index do
	(	
		windowTypeReact wallCombLeftSize &wallCombLeftSizeVal wallCombLeftType.selected &wallCombLeftTypeVal "_" 
		updateNewName nameLabel
	)
	
	-- wall combination right update
	on wallCombRightSize selected index do
	(
		if wallCombRightSize.visible == true do
			wallCombRightSizeVal = "-" + wallCombRightSize.selected
		updateNewName nameLabel
	)
	on wallCombRightType selected index do
	(
		windowTypeReact wallCombRightSize &wallCombRightSizeVal wallCombRightType.selected &wallCombRightTypeVal "-" 
		updateNewName nameLabel
	)
	
	-- direction update
	on dirTog changed val do
	(
		if val == true then
		(
			dir.enabled = true
			dirVal = "_" + dir.selected
		)
		else
		(
			dir.enabled = false
			dirVal = ""
		)
		updateNewName nameLabel
	)
	on dir selected index do
	(
		dirVal = "_" + dir.selected
		updateNewName nameLabel
		
	)
	
	-- material update
	on material selected index do
	(
		comboboxUpdate material.selected &materialVal "_" ""
		updateNewName nameLabel
	)
	on material changed val do
	(
		comboboxUpdate val &materialVal "_" ""
		updateNewName nameLabel
	)
	
	-- size from update
	on sideFromTog changed val do
	(
		hideDependentParm val #(sideToTog, sideToLabel, sideTo) &sideToVal "" ""
		updateSliderLabel sideFromLabel "Size from | width" sideFrom sideFrom.value val true
		if val == true then
			sideFromVal = "_s" + sideFrom.value as string
		else
			sideFromVal = ""
		updateNewName nameLabel
	)
	on sideFrom changed val do
	(
		updateSliderLabel sideFromLabel "Size from | width" sideFrom val sideFromTog.checked false
		sideFromVal = "_s" + val as string
		updateNewName nameLabel
	)
	
	-- size to update
	on sideToTog changed val do
	(
		updateSliderLabel sideToLabel "Size to | length" sideTo sideTo.value val true
		if val == true then
			sideToVal = "-" + sideTo.value as string
		else
			sideToVal = ""
		updateNewName nameLabel
	)
	on sideTo changed val do
	(
		updateSliderLabel sideToLabel "Size to | length" sideTo val sideToTog.checked false
		sideToVal = "-" + val as string
		updateNewName nameLabel
	)
	
	-- tier update
	on tierTog changed val do
	(
		updateSliderLabel tierLabel "Tier" tier tier.value val true
		if val == true then
			tierVal = "_t" + tier.value as string
		else
			tierVal = ""
		updateNewName nameLabel
	)
	on tier changed val do
	(
		updateSliderLabel tierLabel "Tier" tier val tierTog.checked false
		tierVal = "_t" + val as string
		updateNewName nameLabel
	)
	
	-- variation update
	on varTog changed val do
	(
		updateSliderLabel varLabel "Variation" var var.value val true
		if val == true then
			varVal = "_v" + var.value as string
		else
			varVal = ""
		updateNewName nameLabel
	)
	on var changed val do
	(
		updateSliderLabel varLabel "Variation" var val varTog.checked false
		varVal = "_v" + val as string
		updateNewName nameLabel
	)
	

	
	on renameBtn pressed do
	(
		if (selection.count) == 1 then
			$.name = newName
		else
			messagebox "Choose only one object to rename"
	)
)

createDialog houseGeneratorGeoRenamer
resizeWindow false #(houseGeneratorGeoRenamer.dirTog, houseGeneratorGeoRenamer.dirLabel, houseGeneratorGeoRenamer.dir, houseGeneratorGeoRenamer.materialLabel, houseGeneratorGeoRenamer.material, houseGeneratorGeoRenamer.materialAdd, houseGeneratorGeoRenamer.materialRemove, houseGeneratorGeoRenamer.sideFromTog, houseGeneratorGeoRenamer.sideFromLabel, houseGeneratorGeoRenamer.sideFrom, houseGeneratorGeoRenamer.sideToTog, houseGeneratorGeoRenamer.sideToLabel, houseGeneratorGeoRenamer.sideTo, houseGeneratorGeoRenamer.tierTog, houseGeneratorGeoRenamer.tierLabel, houseGeneratorGeoRenamer.tier, houseGeneratorGeoRenamer.varTog, houseGeneratorGeoRenamer.varLabel, houseGeneratorGeoRenamer.var) 85
-- clearListener()