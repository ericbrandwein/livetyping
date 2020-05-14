Class {
	#name : #CodeWindow,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
CodeWindow >> browseActualImplementorsOfSelectedMethod [
	
	self model currentCompiledMethod ifNotNil: [ :aSentCompileMethod |
		Smalltalk browseAllActualmplementorsOf: aSentCompileMethod ]
]

{ #category : #'as yet unclassified' }
CodeWindow >> browseActualSendersOfSelectedMethod [
	
	self model currentCompiledMethod ifNotNil: [ :aSentCompileMethod |
		Smalltalk browseAllActualSendersOn: aSentCompileMethod ]
]
