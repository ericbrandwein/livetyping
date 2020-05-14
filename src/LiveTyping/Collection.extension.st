Extension { #name : #Collection }

{ #category : #'*LiveTyping' }
Collection >> inject: aCollector addingAll: aBlock [
	
	self do: [ :anObject | aCollector addAll: (aBlock value: anObject) ].
	
	^aCollector 
]

{ #category : #'*LiveTyping' }
Collection >> reject: aRejectBlock thenCollect: aCollectBlock [

	^(self reject: aRejectBlock) collect: aCollectBlock 
]
