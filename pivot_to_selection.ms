if (subObjectLevel == 1) then
(
	vertSel = polyop.getVertSelection $
)
else if (subObjectLevel == 2) then
(
	edgeSel = polyop.getEdgeSelection $
	vertSel = polyop.getVertsUsingEdge $ edgeSel
)
else if (subObjectLevel == 4) then
(
	faceSel = polyop.getFaceSelection $
	vertSel = polyop.getVertsUsingFace $ faceSel
)
else
(
	message = "Please, choose vertices, edges or polygons"
	print message1
)

averagePos = [0.0, 0.0, 0.0]
amount = 0
for i in vertSel do
(
	vertPos = polyop.getVert $ i
	averagePos += vertPos
	amount += 1
)
averagePos /= amount
$.pivot = averagePos