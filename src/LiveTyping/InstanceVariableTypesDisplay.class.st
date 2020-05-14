Class {
	#name : #InstanceVariableTypesDisplay,
	#superclass : #ParseNodeTypesDisplay,
	#instVars : [
		'instVarTypeInfo'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation' }
InstanceVariableTypesDisplay class >> typeInfo: anInstanceVariableTypeInfo [ 
	
	^self new initializeTypeInfo: anInstanceVariableTypeInfo
]

{ #category : #'showing - private' }
InstanceVariableTypesDisplay >> addCrudOptions [

	self addCrudOptionsFor: instVarTypeInfo 
]

{ #category : #initialization }
InstanceVariableTypesDisplay >> initializeTypeInfo: anInstanceVariableTypeInfo [ 
	
	instVarTypeInfo := anInstanceVariableTypeInfo.
	types := instVarTypeInfo types.
	incompleteTypeInfoReasons := #()
]

{ #category : #'showing - private' }
InstanceVariableTypesDisplay >> showTypes [
	
	types isEmpty 
		ifTrue: [ self inform: 'There is no type info for ', instVarTypeInfo variableName ]
		ifFalse: [ self showTypesWhenNotEmpty ].

]

{ #category : #'showing - private' }
InstanceVariableTypesDisplay >> showTypesPopUp [

	| menu |

	menu := PopUpMenu labelArray: labels lines: lines icons: icons.
	selectedIndex := menu startUpWithCaption: 'Type info of inst var ', instVarTypeInfo variableName 
]
