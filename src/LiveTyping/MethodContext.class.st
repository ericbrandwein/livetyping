Class {
	#name : #MethodContext,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
MethodContext >> popIntoTemporaryVariable: offset [ 

	| index value |
	
	index := offset + 1.
	value := self pop.
		
	self contextForLocalVariables at: index put: value.
	method annotateTemporaryTypeOf: value at: index 
	
]

{ #category : #'as yet unclassified' }
MethodContext >> return: value from: aSender [ 
	
	| newTop ctxt  |

	aSender isDead ifTrue: [
		"I do not have to keep the type because it does not return - Hernan"
		^ self send: #cannotReturn: to: self with: {value} super: false].
	newTop _ aSender sender.
	ctxt _ self findNextUnwindContextUpTo: newTop.
	ctxt ifNotNil: [
		"If #aboutToReturn:through: fails, I do not keep the type - Hernan"
		newTop _ self send: #aboutToReturn:through: to: self with: {value. ctxt} super: false.
		method annotateReturnTypeOf: value.
		^ newTop ].
	self releaseTo: newTop.
	newTop ifNotNil: [newTop push: value].
	method annotateReturnTypeOf: value.
	
	^ newTop

]

{ #category : #'as yet unclassified' }
MethodContext >> storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	
	| index value |
	
	index := remoteTempIndex + 1.
	value := self top.
	
	self object: (self at: tempVectorIndex + 1) basicAt: index put: value.
	method annotateRemoteTemporaryTypeOf: value at: index 
]
