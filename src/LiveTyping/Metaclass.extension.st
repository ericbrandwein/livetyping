Extension { #name : #Metaclass }

{ #category : #'*LiveTyping' }
Metaclass >> isSubclassesEmpty [

	self subclassesDo: [ :aSubclass | ^false ].
	^true 
]
