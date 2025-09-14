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
PveContainer >> memoryDisplay [
	^ self rawData at: 'mem' ifAbsent: [ 0 ]
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
