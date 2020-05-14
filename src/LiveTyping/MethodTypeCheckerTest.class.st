Class {
	#name : #MethodTypeCheckerTest,
	#superclass : #TestCase,
	#category : #'LiveTyping-TypeChecking-Tests'
}

{ #category : #assertions }
MethodTypeCheckerTest >> assertHasNoTypeErrorsAndWarnings: aSelector [

	self 
		typeCheck: aSelector 
		andAssert: [ :typeChecker | self assert: typeChecker hasNoErrorsAndWarnings ]

]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test01MethodNotAnnotatingTypesGeneratesWarning [

	| methodToCkeck typeChecker |
	
	methodToCkeck := TypeCheckerTestMethods >> #methodNotAnnotatingTypes.
	methodToCkeck removeProperties.
	
	typeChecker := methodToCkeck typeCheck.
	
	self assert: 1 equals: typeChecker problemsSize.
	self assert: (typeChecker problems anyOne isKindOf: MethodNotAnnotatingTypesProblem)
]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test02EmptyMethodDoesNotGenerateWarningsOrErrors [

	| methodToCkeck typeChecker |
	
	methodToCkeck := TypeCheckerTestMethods >> #emptyMethod.
	
	typeChecker := methodToCkeck typeCheck.
	
	self assert: typeChecker errorsIsEmpty.
	self assert: typeChecker warningsIsEmpty
]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test03MessageSendNotUnderstoodByReceiverGeneratesError [

	| methodToCheck typeChecker typeError notImplemented |
	
	methodToCheck := TypeCheckerTestMethods >> #methodWithTypeError.
	
	typeChecker := methodToCheck typeCheck.
	
	self assert: 1 equals: typeChecker errorsSize.
	self assert: typeChecker warningsIsEmpty.
		
	typeError := typeChecker errors anyOne.
	
	self assert: methodToCheck asMethodReference equals: typeError method.
	self assert: 1 equals: typeError receiver key.
	self assert: #date equals: typeError selector key.
	
	notImplemented := typeError notImplemented.
	self assert: 1 equals: notImplemented size.
	self assert: SmallInteger equals: notImplemented first actualClass.
	self assert: #date equals: notImplemented first selector.
]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test04MessageUnderstooodByReceiverDoesNotGenerateErrors [

	| methodToCkeck typeChecker |
	
	methodToCkeck := TypeCheckerTestMethods >> #methodWithoutTypeErrors.
	
	typeChecker := methodToCkeck typeCheck.
	
	self assert: typeChecker errorsIsEmpty.
	self assert: typeChecker warningsIsEmpty 
]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test05ErrorsWhenNoTypeImplementMessageSent [

	| typeError notImplemented typesNotImplementingSelector |
	
	self 
		typeCheck: #methodWithTypeErrorWithManyNotImplemented
		andAssert: [ :typeChecker |
			self assert: 1 equals: typeChecker errorsSize.
			self assert: typeChecker warningsIsEmpty.
			
			typeError := typeChecker errors anyOne.
			
			self assert: (TypeCheckerTestMethods>>#methodWithTypeErrorWithManyNotImplemented) asMethodReference equals: typeError method.
			self assert: 'temp1' equals: typeError receiver key.
			self assert: #date equals: typeError selector key.
			
			notImplemented := typeError notImplemented.
			self assert: 2 equals: notImplemented size.
			
			typesNotImplementingSelector := typeError notImplementedTypes.
			self assert: 2 equals: typesNotImplementingSelector size.
			self assert: (typesNotImplementingSelector includes: SmallInteger).
			self assert: (typesNotImplementingSelector includes: String) ]
]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test06DifferentErrorsAreReported [

	| methodToCheck typeChecker typeError |
	
	methodToCheck := TypeCheckerTestMethods >> #methodWithManyTypeErrors.
	
	typeChecker := methodToCheck typeCheck.
	
	self assert: 2 equals: typeChecker errorsSize.
	self assert: typeChecker warningsIsEmpty.
	
	typeError := typeChecker errorsDetect: [ :aTypeError | aTypeError receiver key = 1 ] ifNone: [ self fail ].	
	self assert: 1 equals: typeError receiver key.
	self assert: #date equals: typeError selector key.
	self assert: 1 equals: typeError notImplementedSize.
	self assert: (typeError notImplementedIncludesType: SmallInteger).
	
	typeError := typeChecker errorsDetect: [ :aTypeError | aTypeError receiver key = 'hello' ] ifNone: [ self fail ].	
	self assert: 'hello' equals: typeError receiver key.
	self assert: #factorial equals: typeError selector key.
	self assert: 1 equals: typeError notImplementedSize.
	self assert: (typeError notImplementedIncludesType: String).

]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test07ReceiverWithoutTypesGeneratesWarning [

	| typeCheckProblem |
	
	self
		typeCheck: #methodWithReceiverWithNoTypes
		andAssert: [ :typeChecker |					
			self assert: 1 equals: typeChecker problemsSize.
			self assert: typeChecker errorsIsEmpty.
			self assert: typeChecker warningsIsEmpty.
			
			typeCheckProblem := typeChecker problemsDetect: [ :aTypeCheckWarning | aTypeCheckWarning receiver key = 'temp1' ] ifNone: [ self fail ].	
			self assert: #date equals: typeCheckProblem selector key.
			self assert: TypeCheckingWarning receiverHasNoTypesDescription equals: typeCheckProblem reason ]
	
]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test08GivesAWarningWhenReceiversTypeHasAnError [

	| methodToCheck typeChecker typeWarning |
	
	methodToCheck := TypeCheckerTestMethods >> #methodWithWarningForError.
	
	typeChecker := methodToCheck typeCheck.
	
	self assert: 1 equals: typeChecker warningsSize.
	self assert: 1 equals: typeChecker errorsSize.
	
	typeWarning := typeChecker warningsDetect: [ :aTypeWarning | true ] ifNone: [ self fail ].
	self assert: typeWarning receiver isMessageNode.	
	self assert: #first equals: typeWarning selector key.
	self 
		assert: (TypeCheckingWarning canNotDeduceReceiverTypeDueToDescription: (
			IncompleteTypeInfoError missingImplementationDescriptionOf: (MethodReference class: SmallInteger selector: #date))) 
		equals: typeWarning reason
	
]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test09WhenMethodHasNoReturnTypesAProblemIsAdded [

	| methodToCheck typeChecker typeCheckProblem |
	
	methodToCheck := TypeCheckerTestMethods >> #methodWithNoReturnTypes.
	methodToCheck initializeTypeInformation.
	
	typeChecker := methodToCheck typeCheck.
	
	self assert: 1 equals: typeChecker problemsSize.
	self assert: typeChecker errorsIsEmpty.
	self assert: typeChecker warningsIsEmpty.
	
	typeCheckProblem := typeChecker problemsDetect: [ :aTypeCheckProblem | true ] ifNone: [ self fail ].
	self assert: typeCheckProblem receiver isMessageNode.	
	self assert: #printString equals: typeCheckProblem selector key.
	self 
		assert: (TypeCheckingProblem canNotDeduceReceiverTypeDueToDescription: (
			(IncompleteTypeInfoWarning noReturnTypesDescriptionOf: methodToCheck asMethodReference)))
		equals: typeCheckProblem reason
	
]

{ #category : #'tests - type checking' }
MethodTypeCheckerTest >> test10PrimitiveMethodsAreNotTypedChecked [

	| methodToCheck typeChecker |
	
	methodToCheck := Array >> #elementsForwardIdentityTo:.
	
	typeChecker := methodToCheck typeCheck.
	
	self assert: typeChecker hasNoErrorsAndWarnings 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test11IfNotNilFiltersUndefinedObjectType [

	self assertHasNoTypeErrorsAndWarnings: #ifNotNilCheck.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test12IfNotNilDoesNotFiltersUndefinedObjectTypeForNotCheckedObject [

	self 
		typeCheck: #ifNotNilCheckAccesingOtherObject 
		andAssert: [ :typeChecker | 
			self assert: 1 equals: typeChecker errorsSize.
			self assert: typeChecker warningsIsEmpty ]	
	
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test13ComparingForNilWithIfTrueIfFalse [

	self assertHasNoTypeErrorsAndWarnings: #comparingForNilWithIfTrueIfFalse.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test14ComparingForNilWithIfTrueIfFalseWhenNilFiltersOtherTypes [

	self assertHasNoTypeErrorsAndWarnings: #comparingForNilWithIfTrueIfFalseWhenNilFiltersOtherTypes.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test15ComparingForNilWithIfTrueIfFalseWhenNilKeepsUndefinedObject [

	| error |
	
	self 
		typeCheck: #comparingForNilWithIfTrueIfFalseWhenNilKeepsUndefinedObject
		andAssert: [:typeChecker |
			self assert: 1 equals: typeChecker errorsSize.

			error := typeChecker errors first.
			self assert: 1 equals: error notImplementedSize.
			self assert: 'temp1' equals: error receiver key.
			self assert: (error selector isNamed: #*) ]
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test16NestedIfNotNilFiltersUndefinedObjectType [

	self assertHasNoTypeErrorsAndWarnings: #nestedIfNotNilCheck.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test17NestedIfNotNilDoesNotFilterUndefinedObjectWhenOutsideRightIfNotNil [

	| error |
	
	self 
		typeCheck: #nestedIfNotNilCheckErrorsWhenOutsideOfRightIfNotNil
		andAssert: [ :typeChecker |
			self assert: 1 equals: typeChecker errorsSize.

			error := typeChecker errors first.
			self assert: 1 equals: error notImplementedSize.
			self assert: 'temp2' equals: error receiver key.
			self assert: (error selector isNamed: #*) ]
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test18IfNilAssumesUndefinedObjectAsType [

	self assertHasNoTypeErrorsAndWarnings: #ifNilCheck.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test19NestedIfNilAssumesUndefinedObjectAsType [

	self assertHasNoTypeErrorsAndWarnings: #nestedIfNilCheck.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test20NestedIfNilDoesUseUndefinedObjectWhenOutsideRightIfNil [

	| error |
	
	self
		typeCheck: #nestedIfNilCheckErrorsWhenOutsideOfRightIfNil
		andAssert: [:typeChecker | 
			self assert: 1 equals: typeChecker errorsSize.

			error := typeChecker errors first.
			self assert: 1 equals: error notImplementedSize.
			self assert: 'temp2' equals: error receiver key.
			self assert: (error selector isNamed: #subclasses) ]
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test21IfNilIfNotNilWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #ifNilIfNotNil.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test22IfNotNilIfNilWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #ifNotNilIfNil.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test23EqualsNilIfTrueIfFalseWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #equalsNilIfTrueIfFalse.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test24EqualsNilIfTrueWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #equalsNilIfTrue
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test25IdenticalToNilIfTrueWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #identicalToNilIfTrue
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test26EqualsNilIfFalseWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #equalsNilIfFalse.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test27IdenticalToNilIfFalseWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #identicalToNilIfFalse.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test28EqualsToNilIfFalseIfTrueWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #equalsNilIfFalseIfTrue.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test29IdenticalToNilIfFalseIfTrueWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #identicalToNilIfFalseIfTrue.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test30nilEqualsToIfTrueIfFalseOrIfFalseIfTrueWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #nilEqualsToIfTrueIfFalseOrIfFalseIfTrue.
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test31nilEqualsToIfTrueOrIfFalseWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #nilEqualsToIfTrueOrIfFalse
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test32_01_nilNotIdenticalOrEqualToWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #nilNotEqualOrIdenticalIdenticalTo
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test32nilIdenticalToWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #nilIdenticalTo
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test33NotEqualToNilWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #notEqualToNil
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test34NotIdenticalToNilWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #notIdenticalToNil
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test35isNilWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #isNilCondition
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test36notNilWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #notNilCondition
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test37TypeCastWithEqualOrIdenticalToWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #typeCastWithEqualOrIdenticalTo
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test38TypeCastWithNotEqualOrNotIdenticalToWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #typeCastWithNotEqualOrNotIdenticalTo
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test39TypeCastToUsingEqualOrIdenticalToWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #typeCastToWithEqualOrIdenticalTo
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test40TypeCastToUsingNotEqualOrNotIdenticalToWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #typeCastToWithNotEqualOrNotIdenticalTo
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test41TypeCastUsingIsKindOfToWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #typeCastUsingIsKindOf
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test42TypeCheckMessageWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #typeCheckMessage
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test43TypeCheckMessageSentToSelfWorksAsExpected [

	| typeChecker |
	
	typeChecker := (Morph>>#buildDebugMenu:) typeCheck.
	
	self assert: typeChecker hasNoErrorsAndWarnings 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test44TypeCheckMessageWorksAsExpected [

	self assertHasNoTypeErrorsAndWarnings: #typeCheckMessageNestedInsideIfNotNil
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test46TypeCastRejectsCanBeNested [

	self assertHasNoTypeErrorsAndWarnings: #nestedRejects
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test47IsKindOfCastingAllowsSubtypes [

	self assertHasNoTypeErrorsAndWarnings: #isKindOfKeepsSubtypes
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test48IfNotNilWithBlockArgumentFiltersUndefinedObject [

	self assertHasNoTypeErrorsAndWarnings: #ifNotNilCheckWithArgument
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test49TypeCastWithBlockInRejectBlockKeepsCastingStrategy [

	self assertHasNoTypeErrorsAndWarnings: #castWithBlockInRejectBlock
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test50TypeCastWithoutBlockShouldFail [

	self 
		typeCheck: #ifNotNilWithoutBlock 
		andAssert: [ :typeChecker | self assert: 1 equals: typeChecker errorsSize ]
 
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test51NotNilAndFiltersUndefinedObject [

	self assertHasNoTypeErrorsAndWarnings: #notNilAnd 
		
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test52CascasdeMessageSendAreTypeChecked [

	| methodToCheck typeChecker |
	
	methodToCheck := TypeCheckerTestMethods >> #cascadeMessageSend.
	
	typeChecker := methodToCheck typeCheck.

	self assert: 1 equals: typeChecker errorsSize. 
	self assert: #odd equals: typeChecker errors anyOne notImplemented first selector
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test53TypeCastWorksOnCascadeMessageSends [

	self assertHasNoTypeErrorsAndWarnings: #cascadeMessageSendWithTypeCast 
		
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test54IfNilWithReturnRejectsNilInNextColaborations [

	self assertHasNoTypeErrorsAndWarnings: #ifNilWithReturn 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test55TypeCheckMessageWithSubclassesReturningFalse [

	self assertHasNoTypeErrorsAndWarnings: #typeCheckMessageWithFalseInSubclass 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test56Float_store_on_hasNoTypeErrors [

	| methodToCheck typeChecker |
	
	methodToCheck := Float >> #storeOn:base:.
	
	typeChecker := methodToCheck typeCheck.

	self assert: typeChecker hasNoErrorsAndWarnings.
	self deny: typeChecker hasProblems 
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test57TypeCheckMessageWithFalse_True_False_InSubclassesCastCorrectly [
	

	self assertHasNoTypeErrorsAndWarnings: #typeCheckMessageWithFalse_True_False_InSubclasses 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test58TypeCheckMessageWithReturnOnIfTrueRejectsTypeInNextColaborations [

	self assertHasNoTypeErrorsAndWarnings: #typeCheckMessageWithReturnOnIfTrue 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test59TypeCheckMessageWithReturnOnIfFalseRejectsTypeInNextColaborations [

	self assertHasNoTypeErrorsAndWarnings: #typeCheckMessageWithReturnOnIfFalse 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test60TypeCastWithReturnOnIfTrueRejectsTypeInNextColaborations [

	self assertHasNoTypeErrorsAndWarnings: #typeCastWithReturnOnIfTrue 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test61TypeCastWithReturnOnIfFalseRejectsTypeInNextColaborations [

	self assertHasNoTypeErrorsAndWarnings: #typeCastWithReturnOnIfFalse 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test62ifNotNilifNotNilWithMoreThanAMessageSendAndNilAsValue [

	| methodToCheck testMethods typeChecker |
	
	testMethods := TypeCheckerTestMethods new.
	testMethods 
		ifNotNilifNotNil: nil; 
		ifNotNilifNotNil: testMethods.

	methodToCheck := TypeCheckerTestMethods >> #ifNotNilifNotNil:.

	typeChecker := methodToCheck typeCheck.
	
	self assert: typeChecker hasNoErrorsAndWarnings 	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test63orCheck [

	self assertHasNoTypeErrorsAndWarnings: #orCheck 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test64notNilAndIfTrue [

	self assertHasNoTypeErrorsAndWarnings: #notNilAndIfTrue 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test65isNilOr [

	self assertHasNoTypeErrorsAndWarnings: #isNilOr 
	
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test66DoesNotFailsWithMessageSendAsConditionOfIfTrueWithCascadeSend [

	self 
		shouldnt: [ self assertHasNoTypeErrorsAndWarnings: #messageSendAsConditionOfIfTrueWithCascadeSend ] 
		raise: Error
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test66orWithoutMessageAsReceiverShouldNotError [

	self 
		shouldnt: [ self assertHasNoTypeErrorsAndWarnings: #orWithoutMessageAsReceiver ] 
		raise: Error
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test67andWithoutMessageAsReceiverShouldNotError [

	self 
		shouldnt: [ self assertHasNoTypeErrorsAndWarnings: #andWithoutMessageAsReceiver ] 
		raise: Error
]

{ #category : #'tests - casting' }
MethodTypeCheckerTest >> test68DoesNotFailsWithIfTrueSendInCascadeMode [

	self 
		shouldnt: [ self assertHasNoTypeErrorsAndWarnings: #ifTrueCascadeSend ] 
		raise: Error
]

{ #category : #assertions }
MethodTypeCheckerTest >> typeCheck: aSelector andAssert: assertionsBlock [

	| methodToCheck typeChecker |
	
	methodToCheck := TypeCheckerTestMethods >> aSelector.
	TypeCheckerTestMethods new perform: aSelector.
	
	typeChecker := methodToCheck typeCheck.
	
	assertionsBlock value: typeChecker
	
	
]
