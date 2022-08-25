function convertToEditMesh obj = (
	editMeshMod = Edit_Mesh()
	addModifier obj editMeshMod before: (obj.modifiers.count)
	maxops.CollapseNodeTo obj 2 true
)

function updateSkinMod obj DQ boneAffectLim = (
	obj.modifiers[Skin].enableDQ = DQ
	obj.modifiers[Skin].bone_Limit = boneAffectLim
)

rollout updateSkinModels "Update skin models" width:200 height:200 (
	checkbox 'DQ' " DQ Skinning toggle" pos:[25,63] width:150 height:26 align:#left
	spinner 'boneAffectLim' "Bone affect limit: " pos:[25,100] width:69 height:16 type:#integer scale:1 align:#left range: [0, 100, 4]
	checkbox 'updateSkin' " Update skin modifier?" pos:[25,15] width:150 height:26 align:#left
	button 'updateBtn' "Update models" pos:[25,155] width:150 height:30 align:#left
	
	on updateBtn pressed do (
		for obj in selection do (
			convertToEditMesh obj
			if updateSkin.checked do (
				updateSkinMod obj DQ.checked boneAffectLim.value		
			)
		)
	)
)
createDialog updateSkinModels