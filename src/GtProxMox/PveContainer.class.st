Class {
	#name : #PveContainer,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'node',
		'client',
		'api'
	],
	#category : #'GtProxMox-Model'
}

{ #category : #'as yet unclassified' }
PveContainer >> api: anApi [ 
	api := anApi
]

{ #category : #'as yet unclassified' }
PveContainer >> client: aZnClient [
	client := aZnClient
]

{ #category : #'as yet unclassified' }
PveContainer >> gtStatusFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Status';
		priority: 10;
		text: [
			String streamContents: [ :s |
				s nextPutAll: 'VM ID: ', self vmid asString; cr.
				s nextPutAll: 'Name: ', self name; cr.
				s nextPutAll: 'Status: ', self status asString; cr.
				s nextPutAll: 'Memory: ', self memoryDisplay; cr.

	]]
]

{ #category : #'as yet unclassified' }
PveContainer >> maxMemory [
	^ self rawData at: 'maxmem' ifAbsent: [ 1 ]

]

{ #category : #'as yet unclassified' }
PveContainer >> memory [
	^ self rawData at: 'mem' ifAbsent: [ 0 ]
]

{ #category : #'as yet unclassified' }
PveContainer >> memoryDisplay [
	^ (self memory // (1024*1024)) asString, 'MB / ', 
		(self maxMemory // (1024*1024)) asString, 'MB'
]

{ #category : #'as yet unclassified' }
PveContainer >> name [
	^ self rawData at: 'name'
]

{ #category : #'as yet unclassified' }
PveContainer >> node: aNode [
	node := aNode
]

{ #category : #'as yet unclassified' }
PveContainer >> rawData [
	^rawData
]

{ #category : #'as yet unclassified' }
PveContainer >> rawData: ctData [ 
	rawData := ctData
]

{ #category : #'as yet unclassified' }
PveContainer >> status [
	^ self rawData at: 'status'
]

{ #category : #'as yet unclassified' }
PveContainer >> vmid [
	^ self rawData at: 'vmid'
]
