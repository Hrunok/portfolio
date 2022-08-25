resizeValues = #(#(54.24152 * 2.0, 0.01843606152629941 / 2.0), #(54.24152, 0.01843606152629941), #(10.0, 1.0 / 10.0))
resizeNames = #("Kochergin LiF 2", "Kochergin LiF 1", "ZBrush standard")

fn resize resizeArr mode offset resizeType resetXFormVal=
(
	if resizeType == "+" then
		resizeVal = resizeArr[1]
	else
		resizeVal = resizeArr[2]
	for obj in selection do
	(
		objPivot = obj.pivot
		restPos = obj.pos
		obj.scale *= resizeVal
		if mode == 2 then
			obj.pos *= resizeVal
		else if mode == 3 do
			obj.pos = (obj.pos - offset) * resizeVal + offset
		
		if resetXFormVal == true do
			resetXForm obj
	)
)

rollout extendedScale "Extended tool for scale" width:200 height:320
(
	button 'increase' "increase size" pos:[25,10] width:150 height:60 align:#left
	button 'decrease' "decrease size" pos:[25,250] width:150 height:60 align:#left
	dropdownlist 'scalePresets' "Scale presets" pos:[25,80] width: 150 height: 5 items: resizeNames align: #left
	radiobuttons 'mode' "Scale from" pos:[25,130] width:98 height:60 labels:#("each pivot", "center", "specific position") default: 2 align:#left
	spinner 'xPos' "X" pos:[25,200] width:43 height:16 range: [-100.0, 100.0, 0.0] align:#left visible: false
	spinner 'yPos' "Y" pos:[75,200] width:43 height:16 range: [-100.0, 100.0, 0.0] align:#left visible: false
	spinner 'zPos' "Z" pos:[125,200] width:43 height:16 range: [-100.0, 100.0, 0.0] align:#left visible: false
	checkbox 'freezeTransform' "Reset XForm?" pos:[25, 226] checked: true align: #left
	
	
	on mode changed index do
	(
		if index == 3 then
		(
			for spinner in #(xPos, yPos, zPos) do
				spinner.visible = true
		)
		else
		(
			for spinner in #(xPos, yPos, zPos) do
				spinner.visible = false
		)
	)

	on increase pressed do
	(
		undo on
			resize resizeValues[scalePresets.selection] mode.state [xPos.value, yPos.value, zPos.value] "+" freezeTransform.state 
	)
	on decrease pressed do
	(
		undo on
			resize resizeValues[scalePresets.selection] mode.state [xPos.value, yPos.value, zPos.value] "-" freezeTransform.state 
	)
)

createDialog extendedScale
clearListener()