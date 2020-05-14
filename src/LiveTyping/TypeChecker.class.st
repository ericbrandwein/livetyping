Class {
	#name : #TypeChecker,
	#superclass : #Object,
	#category : #'LiveTyping-TypeChecking'
}

{ #category : #errors }
TypeChecker >> errors [
	
	self subclassResponsibility
]

{ #category : #errors }
TypeChecker >> errorsAndWarnings [
	
	self subclassResponsibility
]

{ #category : #errors }
TypeChecker >> errorsDetect: aCondition ifNone: aNoneBlock [
	
	self subclassResponsibility
]

{ #category : #errors }
TypeChecker >> errorsIsEmpty [
	
	self subclassResponsibility
]

{ #category : #errors }
TypeChecker >> errorsSize [
	
	self subclassResponsibility
]

{ #category : #testing }
TypeChecker >> hasErrors [
	
	self subclassResponsibility
]

{ #category : #testing }
TypeChecker >> hasErrorsOrWarnings [
	
	self subclassResponsibility
]

{ #category : #testing }
TypeChecker >> hasNoErrorsAndWarnings [
	
	self subclassResponsibility
]

{ #category : #testing }
TypeChecker >> hasProblems [
	
	self subclassResponsibility
]

{ #category : #problems }
TypeChecker >> problems [
	
	self subclassResponsibility
]

{ #category : #problems }
TypeChecker >> problemsDetect: aCondition ifNone: noneBlock [
	
	self subclassResponsibility
]

{ #category : #problems }
TypeChecker >> problemsSize [
	
	self subclassResponsibility
]

{ #category : #'showing results' }
TypeChecker >> showResultsWith: aLabelTrail [

	| showProblems |

	showProblems := self hasProblems and: [ self confirm: 'There were problems during the type check.\Do you want to see them' withNewLines ].
	(showProblems not and: [ self hasNoErrorsAndWarnings ]) ifTrue: [  ^self inform: 'There are no type errors or warnings' ].
		
	TypeCheckingResultWindow openFor: self labelTrail: aLabelTrail showingProblems: showProblems 
]

{ #category : #'type checking' }
TypeChecker >> value [
	
	self subclassResponsibility
]

{ #category : #warnings }
TypeChecker >> warnings [
	
	self subclassResponsibility
]

{ #category : #warnings }
TypeChecker >> warningsDetect: aCondition ifNone: aNoneBlock [
	
	self subclassResponsibility
]

{ #category : #warnings }
TypeChecker >> warningsIsEmpty [
	
	self subclassResponsibility
]

{ #category : #warnings }
TypeChecker >> warningsSize [
	
	self subclassResponsibility
]
