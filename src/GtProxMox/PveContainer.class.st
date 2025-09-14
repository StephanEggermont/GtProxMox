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
PveContainer >> node: aNode [
	node := aNode
]

{ #category : #'as yet unclassified' }
PveContainer >> rawData: ctData [ 
	rawData := ctData
]
