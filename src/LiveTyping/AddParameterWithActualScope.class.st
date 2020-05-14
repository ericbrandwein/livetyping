Class {
	#name : #AddParameterWithActualScope,
	#superclass : #Object,
	#instVars : [
		'shouldChangePossibleMessageSends'
	],
	#category : #LiveTyping
}

{ #category : #'instance creation - invalidated' }
AddParameterWithActualScope class >> named: aNewParameter
	at: anIndex 
	initializedWith: aNewParameterValue
	using: aNewKeyword 
	toKeywordSelector: anOldSelector  
	implementors: implementorsCollection 
	senders: sendersCollection [
	
	self shouldNotImplement 
]

{ #category : #'instance creation' }
AddParameterWithActualScope class >> named: aNewParameter
	at: anIndex 
	initializedWith: aNewParameterValue
	using: aNewKeyword 
	toKeywordSelector: anOldSelector  
	implementors: implementorsCollection 
	senders: sendersCollection
	withPossibleMessageSends: aShouldChangePossibleMessageSends [
	
	self assertReceiverTypesOfAll: sendersCollection areIncludedInAllTypesOf: implementorsCollection. 

	^(super
		named: aNewParameter
		at: anIndex 
		initializedWith: aNewParameterValue
		using: aNewKeyword 
		toKeywordSelector: anOldSelector  
		implementors: implementorsCollection 
		senders: sendersCollection) initilaizeWithPossibleMessageSends: aShouldChangePossibleMessageSends 
]

{ #category : #'instance creation - invalidated' }
AddParameterWithActualScope class >> named: aNewParameter 
	initializedWith: aNewParameterValue 
	toUnarySelector: anOldSelector  
	implementors: implementorsCollection 
	senders: sendersCollection [
 	
	self shouldNotImplement 
]

{ #category : #'instance creation' }
AddParameterWithActualScope class >> named: aNewParameter 
	initializedWith: aNewParameterValue 
	toUnarySelector: anOldSelector  
	implementors: implementorsCollection 
	senders: sendersCollection
 	withPossibleMessageSends: aShouldChangePossibleMessageSends [
	
	self assertReceiverTypesOfAll: sendersCollection areIncludedInAllTypesOf: implementorsCollection. 

	^(super 
		named: aNewParameter 
		initializedWith: aNewParameterValue 
		toUnarySelector: anOldSelector  
		implementors: implementorsCollection 
		senders: sendersCollection) initilaizeWithPossibleMessageSends: aShouldChangePossibleMessageSends 
]

{ #category : #'instance creation - invalidated' }
AddParameterWithActualScope class >> named: aNewParameter 
	initializedWith: aNewParameterValue
	using: aNewKeyword 
	toKeywordSelector: anOldSelector  
	implementors: implementorsCollection 
	senders: sendersCollection [

	self shouldNotImplement 
]

{ #category : #'instance creation' }
AddParameterWithActualScope class >> named: aNewParameter 
	initializedWith: aNewParameterValue
	using: aNewKeyword 
	toKeywordSelector: anOldSelector  
	implementors: implementorsCollection 
	senders: sendersCollection
 	withPossibleMessageSends: aShouldChangePossibleMessageSends [

	^self 
		named: aNewParameter 
		at: anOldSelector numArgs + 1
		initializedWith: aNewParameterValue
		using: aNewKeyword 
		toKeywordSelector: anOldSelector  
		implementors: implementorsCollection 
		senders: sendersCollection
	 	withPossibleMessageSends: aShouldChangePossibleMessageSends

]

{ #category : #initialization }
AddParameterWithActualScope >> initilaizeWithPossibleMessageSends: aShouldChangePossibleMessageSends [ 
	
	shouldChangePossibleMessageSends := aShouldChangePossibleMessageSends 
]

{ #category : #'rename senders - private' }
AddParameterWithActualScope >> messageSendKeywordPositionsIn: aMethodNode [

	^aMethodNode actualMessageSendKeywordPositionsOfAll: implementors at: index ifAbsent: [ #()] withPossibleMessageSends: shouldChangePossibleMessageSends.
	
]

{ #category : #'rename senders - private' }
AddParameterWithActualScope >> messageSendLastPositionIn: aMethodNode [

	^aMethodNode actualMessageSendLastPositionsOfAll: implementors ifAbsent: [ #() ] withPossibleMessageSends: shouldChangePossibleMessageSends.
			
]
