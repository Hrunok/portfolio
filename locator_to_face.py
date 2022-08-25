import maya.api.OpenMaya as om2

# constannts start
WORLD_SPACE = om2.MSpace.kWorld
# constannts end

sel = om2.MGlobal.getActiveSelectionList()

# first polygon initialize
poly_dag, poly_component = sel.getComponent(0)
first_poly = om2.MItMeshPolygon(poly_dag, poly_component)

# locator initialize
locator_dag, locator_component = sel.getComponent(sel.length() - 1)
locator_transform = om2.MFnTransform(locator_dag)

# basic face info
face_center = first_poly.center(space=WORLD_SPACE)
face_normal = first_poly.getNormal(space=WORLD_SPACE)

result_distance = 0.0
tangent = om2.MVector()

# get tangent from longest edge in face
face_edges = first_poly.getEdges() # edges iterator
for edge_idx in face_edges:
    edge = om2.MItMeshEdge(poly_dag)
    edge.setIndex(edge_idx)
    
    pt0 = edge.point(0, space=WORLD_SPACE)
    pt0_pos = om2.MVector(pt0.x, pt0.y, pt0.z)

    pt1 = edge.point(1, space=WORLD_SPACE)
    pt1_pos = om2.MVector(pt1.x, pt1.y, pt1.z)

    current_distance = pt0.distanceTo(pt1)
    if current_distance > result_distance:
        result_distance = current_distance
        tangent = pt1_pos - pt0_pos
        
tangent = tangent.normalize()
binormal = face_normal ^ tangent # cross product

# matrix manipulations
xform = om2.MMatrix([face_normal.x, face_normal.y, face_normal.z, 0.0,
                     tangent.x, tangent.y, tangent.z, 0.0,
                     binormal.x, binormal.y, binormal.z, 0.0,
                     face_center.x, face_center.y, face_center.z, 1.0])
locator_transform.setTransformation(om2.MTransformationMatrix(xform))