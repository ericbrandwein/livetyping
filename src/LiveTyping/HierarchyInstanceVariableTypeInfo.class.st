Class {
	#name : #HierarchyInstanceVariableTypeInfo,
	#superclass : #InstanceVariableTypeInfo,
	#category : #LiveTyping
}

{ #category : #types }
HierarchyInstanceVariableTypeInfo >> allSubclassesTypesPlus: thisClassTypes [

	| typesWithAllSubclasses |
			
	typesWithAllSubclasses := Set withAll: thisClassTypes.
	
	class allSubclassesDo: [ :aSubclass | | subclassTypes |
		subclassTypes := (aSubclass instanceVariablesTypes localTypeInfoOf: variableName) types.
		typesWithAllSubclasses addAll: subclassTypes ].
	
	^typesWithAllSubclasses
]

{ #category : #testing }
HierarchyInstanceVariableTypeInfo >> isMegamorphic [
	
	^ self types size >= self maxRawTypesSize
]

{ #category : #types }
HierarchyInstanceVariableTypeInfo >> isTypesEmpty [
	
	^self types isEmpty
]

{ #category : #types }
HierarchyInstanceVariableTypeInfo >> maxRawTypesSize [
	
	^(class withAllSubclasses collect: [ :aSubclass | aSubclass instanceVariableRawTypesSizeFor: variableName ]) max
]

{ #category : #types }
HierarchyInstanceVariableTypeInfo >> types [
	
	| thisClassTypes |
	
	thisClassTypes := super types.
	
	^ class isSubclassesEmpty 
		ifTrue: [ thisClassTypes ]
		ifFalse: [ self allSubclassesTypesPlus: thisClassTypes ]
]

{ #category : #types }
HierarchyInstanceVariableTypeInfo >> typesSize [
	
	^self types size
]
