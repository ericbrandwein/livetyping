Class {
	#name : #ManyTypesCast,
	#superclass : #TypeCast,
	#instVars : [
		'typesToCastTo',
		'typesToReject'
	],
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #'instance creation' }
ManyTypesCast class >> to: aTypesToCastTo rejecting: aTypesToReject of: anObjectToCast [

	^self new initializeTo: aTypesToCastTo rejecting: aTypesToReject of: anObjectToCast
]

{ #category : #casting }
ManyTypesCast >> cast: originalTypes [

	| newTypes |
	
	newTypes := originalTypes select: [ :aType | self shouldKeep: aType ].
	
	^newTypes 
]

{ #category : #'casting - private' }
ManyTypesCast >> does: aType withoutRejectionsIncludesBehavior: aTypeToCastTo [
	
	^(aType includesBehavior: aTypeToCastTo) and: [ self is: aType notRejectedInSubclassesOf: aTypeToCastTo ]
]

{ #category : #initialization }
ManyTypesCast >> initializeTo: aTypesToCastTo rejecting: aTypesToReject of: anObjectToCast [

	typesToCastTo := aTypesToCastTo.
	typesToReject := aTypesToReject.
	objetToCast := anObjectToCast 
]

{ #category : #'casting - private' }
ManyTypesCast >> is: aType notRejectedInSubclassesOf: aTypeToCastTo [

	^(self typeToRejectSubclassesOf: aTypeToCastTo) noneSatisfy: [ :aTypeToReject | aType includesBehavior: aTypeToReject ]
]

{ #category : #'casting - private' }
ManyTypesCast >> shouldKeep: aType [

	^typesToCastTo anySatisfy: [ :aTypeToCastTo | self does: aType withoutRejectionsIncludesBehavior: aTypeToCastTo ]
	
]

{ #category : #'casting - private' }
ManyTypesCast >> typeToRejectSubclassesOf: aTypeToCastTo [

	^typesToReject select: [ :aTypeToReject | aTypeToReject inheritsFrom: aTypeToCastTo ]
]
