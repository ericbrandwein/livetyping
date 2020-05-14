Class {
	#name : #RemoveParameterWithActualScope,
	#superclass : #Object,
	#instVars : [
		'shouldChangePossibleMessageSends'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation - invalidated' }
RemoveParameterWithActualScope class >> named: aParameterToRemove from: aMethod implementors: implementorsCollection senders: sendersCollection [

	self shouldNotImplement 
]

{ #category : #'instance creation' }
RemoveParameterWithActualScope class >> named: aParameterToRemove from: aMethod implementors: implementorsCollection senders: sendersCollection withPossibleMessageSends: aShouldChangePossibleMessageSends [

	self assertReceiverTypesOfAll: sendersCollection areIncludedInAllTypesOf: implementorsCollection. 

	^(super named: aParameterToRemove from: aMethod implementors: implementorsCollection senders: sendersCollection) 
		initilaizeWithPossibleMessageSends: aShouldChangePossibleMessageSends 
]

{ #category : #initialization }
RemoveParameterWithActualScope >> initilaizeWithPossibleMessageSends: aShouldChangePossibleMessageSends [ 
	
	shouldChangePossibleMessageSends := aShouldChangePossibleMessageSends 
]

{ #category : #'rename senders - private' }
RemoveParameterWithActualScope >> keywordAndParameterPositionsIn: aMethodNode [
	
	^aMethodNode 
		actualMessageSendKeywordAndParameterPositionsOfAll: implementors 
		at: parameterIndex 
		of: oldSelector 
		ifAbsent: [ #() ]
		withPossibleMessageSends: shouldChangePossibleMessageSends.
	
]
