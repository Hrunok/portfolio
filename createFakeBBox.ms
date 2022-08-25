fn getBBoxPts sel =
(
	convertToPoly sel
    bbPoints = #()
    
    bbMin = Point3 0.0 0.0 0.0
    bbMax = Point3 0.0 0.0 0.0
    
    for obj in sel do
    (
        for pt in obj.verts do
        (
            if pt.pos.x > bbMax.x do
                bbMax.x = pt.pos.x
            if pt.pos.x < bbMin.x do
                bbMin.x = pt.pos.x
            
            if pt.pos.y > bbMax.y do
                bbMax.y = pt.pos.y
            if pt.pos.y < bbMin.y do
                bbMin.y = pt.pos.y
            
            if pt.pos.z > bbMax.z do
                bbMax.z = pt.pos.z
            if pt.pos.z < bbMin.z do
                bbMin.z = pt.pos.z
        )
    )
    
    append bbPoints (Point3 bbMax.x bbMax.y bbMax.z) -- top-right-front corner
    append bbPoints (Point3 bbMax.x bbMin.y bbMax.z) -- top-right-back corner
    append bbPoints (Point3 bbMin.x bbMin.y bbMax.z)    -- top-left-back corner
    append bbPoints (Point3 bbMin.x bbMax.y bbMax.z) -- top-left-front corner
    
    append bbPoints (Point3 bbMax.x bbMax.y bbMin.z)-- bottom-right-front corner
    append bbPoints (Point3 bbMax.x bbMin.y bbMin.z)    -- bottom-right-back corner
    append bbPoints (Point3 bbMin.x bbMin.y bbMin.z)    -- bottom-left-back corner
    append bbPoints (Point3 bbMin.x bbMax.y bbMin.z)    -- bottom-left-front corner
    
    return bbPoints
)

fn createTriangle geoPos = (
    restSelection = selection as array
    
    vertArr = #()
    faceArr = #(Point3 1 3 2)

    for i = 0 to 3 do
    (
        vert = geoPos
        append vertArr vert
    )
    m = mesh vertices: vertArr faces: faceArr
	convertToPoly m
        
    addModifier m (Unwrap_UVW ()) ui: off
    select m
    UVW = m.Unwrap_UVW
    UVW.selectVertices #{1, 2, 3}
    UVW.moveX 0.0
    UVW.moveY 0.0
    UVW.moveZ 0.0
    
    collapseStack m
    deselect m
    select restSelection
    
    return m
)

fn createFakeBBox BBoxPts =
(
	fakeBBox = for pt in BBoxPts collect (createTriangle pt)
	parent = fakeBBox[1]
	
		for obj in fakeBBox do
	(
		if obj != parent do
			parent.attach obj parent
	)
	
	return parent
)

bboxPts = getBBoxPts selection
for geo in selection do 
(
	convertToPoly geo
	m = createFakeBBox bboxPts
	geo.attach m geo
)