for obj in selection do
(
	convertToPoly(obj)
	objName = obj.name
	resetXForm obj
	collapsestack obj
	addModifier obj (Edit_Normals())
	numNormals = obj.Edit_Normals.GetNumNormals()

	normalArray = #{} 
	for i = 1 to numNormals do
	(
		append normalArray i
	)
	obj.Edit_Normals.SetSelection normalArray
	obj.Edit_Normals.EditNormalsMod.MakeExplicit ()
	resetXForm obj
	collapsestack obj

	facesNewPairsArr = #()
	allFaces = #{}
	for i = 1 to (polyop.getNumFaces obj) do
	(
		faceMatID = polyop.getFaceMatID obj i
		if facesNewPairsArr[faceMatID] == undefined do
			facesNewPairsArr[faceMatID] = #{}
		append facesNewPairsArr[faceMatID] i
		append allFaces i
	)

	objArr = for i = 1 to facesNewPairsArr.count collect if (i == 1) then obj else copy obj

	for i = 1 to facesNewPairsArr.count do
	(
		objNewName = stringstream ""
		format "%_%"  objName i to: objNewName
		objArr[i].name = objNewName
		objArr[i].wirecolor = color (random 0 255) (random 0 255) (random 0 255)
		setFaceSelection objArr[i] (allFaces - facesNewPairsArr[i])
		objArr[i].EditablePoly.delete #Face
	  
	)
)
