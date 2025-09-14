Class {
	#name : #PveApi,
	#superclass : #Object,
	#instVars : [
		'client',
		'baseUrl',
		'host',
		'tokenId',
		'tokenSecret'
	],
	#category : #'GtProxMox-Model'
}

{ #category : #'as yet unclassified' }
PveApi class >> connectFrom: aFileName [
	| lines |
	lines := aFileName asFileReference contents lines.
	^self new connectTo: lines first token: lines second secret: lines third
]

{ #category : #'as yet unclassified' }
PveApi >> connectTo: aHost token: aTokenId secret: aTokenSecret [
	client := ZnClient new.
	host := aHost.
	tokenId := aTokenId.
	tokenSecret := aTokenSecret.
	baseUrl := 'https://' , host , '/api2/json/'.
	client request setAuthorization: 'PVEAPIToken=' , tokenId , '=' , tokenSecret.

]

{ #category : #'as yet unclassified' }
PveApi >> get: path [
	| json dictionary data |
	client url: baseUrl , path.
	json := client get.
	dictionary := STONJSON fromString: json.
	data := dictionary at: 'data'.
	^data
]

{ #category : #'as yet unclassified' }
PveApi >> getStatus [
	client url: baseUrl, 'cluster/status'.
	^client get
]
