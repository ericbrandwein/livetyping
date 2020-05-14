Class {
	#name : #CodeProvider,
	#superclass : #Object,
	#category : #'LiveTyping-StubClasses'
}

{ #category : #'as yet unclassified' }
CodeProvider >> resetMethodTypes [
	
	self currentCompiledMethod initializeTypeInformation.
	
]

{ #category : #'as yet unclassified' }
CodeProvider >> typeCheckMethod [
		
	| typeChecker |
		
	typeChecker := self currentCompiledMethod typeCheck.
	typeChecker showResultsWith:  typeChecker method classAndSelector 
	
]
