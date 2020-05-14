Extension { #name : #RBMethodNode }

{ #category : #'*LiveTyping' }
RBMethodNode >> blockExtentsToTempsMap [
	self shouldBeImplemented.
]

{ #category : #'*LiveTyping' }
RBMethodNode >> topBlockTempsMap [
	
	self blockExtentsToTempsMap associationsDo: [ :anAssociation | anAssociation key first = 0 ifTrue: [ ^anAssociation value ]].
	
	self error: 'Should not happen, there is always a topContext'
]
