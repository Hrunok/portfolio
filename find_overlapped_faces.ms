function compareVerticesDistance obj srcPoly destPoly threshold = (
	srcVertices = polyOp.getFaceVerts obj srcPoly
	destVertices = polyOp.getFaceVerts obj destPoly
	for srcVert in srcVertices do (
		srcVertPos = polyOp.getVert obj srcVert
		for i = 1 to destVertices.count do (
			destVertPos = polyOp.getVert obj destVertices[i]
			if distance srcVertPos destVertPos <= threshold do (
				deleteItem destVertices i
				exit
			)
		)
	)
	return destVertices.count <= 0
)

obj = $
threshold = 0.01

objFaceCenters = #()
objFaceNormals = #()
overlappedFaces = #{}

for i = 1 to obj.faces.count do (
	append objFaceCenters (polyOp.getSafeFaceCenter obj i)
	append objFaceNormals (polyOp.getFaceNormal obj i)
)

for x = 1 to objFaceCenters.count do (
	for y = x + 1 to objFaceCenters.count do (
		if distance objFaceCenters[x] objFaceCenters[y] <= threshold and abs (dot objFaceNormals[x] objFaceNormals[y]) >= 1.0 - threshold do (
			if (compareVerticesDistance obj x y threshold) do ( 
				append overlappedFaces x
				append overlappedFaces y
			)
		)
	)
)
setFaceSelection obj overlappedFaces