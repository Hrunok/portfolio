rollout regExRenamer "Objects renamer by regular expressions" width:456 height:88
(
	edittext 'oldName' "Old name" pos:[24,24] width:256 height:18 align:#left
	edittext 'newName' "New name" pos:[24,48] width:256 height:18 align:#left
	button 'renameBtn' "Rename" pos:[288,45] width:144 height:27 align:#left
	checkbox 'selBox' "In selection" pos:[288,24] width:145 height:18 align:#left
	
	on renameBtn pressed do
	(
		undo on
		(
			pattern = oldName.text
			rgx = dotnetObject "System.Text.RegularExpressions.Regex" pattern
		
			for o in (if selBox.state  == true then  selection else objects) do
			(
				o.name = rgx.Replace o.name newName.text
			)
		)
	)
)

createDialog regExRenamer