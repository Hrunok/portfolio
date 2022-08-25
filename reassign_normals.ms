obj = $
planeNorm = Point3 0 0 0
planeCenter = Point3 0 0 0
planeSize = 1.0


slicePlane = obj.getSlicePlane &planeNorm &planeCenter &planeSize

selFaces = polyop.getFaceSelection obj
selVertices = #{}
for face in selFaces do (
	for vert in polyop.getFaceVerts obj face do (
		append selVertices vert
	)
)

editNormMod = Edit_Normals ()
addModifier obj editNormMod
vertNormals = #()

for vert in selVertices do (
-- 	vertNormals = editNormMod.GetNormal vert
	explNorm = undefined
	tempVertBitArray = #{vert}
	tempNormBitArray = #{}
	editNormMod.ConvertVertexSelection tempVertBitArray &tempNormBitArray
	for norm in tempNormBitArray do (
		if editNormMod.GetNormalExplicit norm do (
			explNorm = editNormMod.GetNormal norm
			exit
		)
	)

	for norm in tempNormBitArray do (
		editNormMod.setNormal norm explNorm
	)
	editNormMod.MakeExplicit selection: tempNormBitArray
)

convertTo obj Editable_Poly
obj.setSlicePlane planeNorm planeCenter planeSize