Class {
	#name : #PveVM,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'client',
		'node',
		'api'
	],
	#category : #'GtProxMox-Model'
}

{ #category : #'as yet unclassified' }
PveVM >> api: anApi [ 
	api := anApi
]

{ #category : #'as yet unclassified' }
PveVM >> client: aZnClient [
	client := aZnClient
]

{ #category : #'as yet unclassified' }
PveVM >> config [
	"Get VM configuration"

	^ (api get:'nodes/', node name, '/qemu/', self vmid asString, '/config' )
]

{ #category : #'as yet unclassified' }
PveVM >> cpuUsage [
	^ self rawData at: 'cpu' ifAbsent: [ nil ]

]

{ #category : #'as yet unclassified' }
PveVM >> currentStatus [
	"Get detailed current status"
	^ api get: 'nodes/', node name, '/qemu/', self vmid asString, '/status/current'.
]

{ #category : #'as yet unclassified' }
PveVM >> gtConfigFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Config';
		items: [ self config associations ];
		column: 'Key' text: #key;
		column: 'Value' text: #value;
		actionUpdateButton
]

{ #category : #'as yet unclassified' }
PveVM >> gtStatusFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Status';
		text: [
			| status |
			status := self currentStatus.
			String streamContents: [ :s |
				s nextPutAll: 'VM ID: ', self vmid asString; cr.
				s nextPutAll: 'Name: ', self name; cr.
				s nextPutAll: 'Status: ', (status at: 'status'); cr.
				s nextPutAll: 'Uptime: ', (status at: 'uptime' ifAbsent: [ 0 ]) asString, ' seconds'; cr.
				status at: 'cpu' ifPresent: [ :cpu |
					s nextPutAll: 'CPU Usage: ', (cpu * 100) rounded asString, '%'; cr ].
				s nextPutAll: 'Memory: ', self memoryDisplay; cr.
				s nextPutAll: 'Node: ', node name; cr ] ]
]

{ #category : #'as yet unclassified' }
PveVM >> maxMemory [
	^ self rawData at: 'maxmem' ifAbsent: [ 1 ]

]

{ #category : #'as yet unclassified' }
PveVM >> memory [
	^ self rawData at: 'mem' ifAbsent: [ 0 ]
]

{ #category : #'as yet unclassified' }
PveVM >> memoryDisplay [
	^ (self memory // (1024*1024)) asString, 'MB / ', 
		(self maxMemory // (1024*1024)) asString, 'MB'
]

{ #category : #'as yet unclassified' }
PveVM >> name [
	^ self rawData at: 'name' ifAbsent: [ 'VM-', self vmid asString ]
]

{ #category : #'as yet unclassified' }
PveVM >> node: aNode [
	node := aNode
]

{ #category : #'as yet unclassified' }
PveVM >> rawData [
	^rawData
]

{ #category : #'as yet unclassified' }
PveVM >> rawData: vmData [ 
	rawData := vmData
]

{ #category : #'as yet unclassified' }
PveVM >> start [
	"Start the VM"
	^ api post: 'nodes/', node name, '/qemu/', self vmid asString, '/status/start'.
]

{ #category : #'as yet unclassified' }
PveVM >> status [
	^ self rawData at: 'status'
]

{ #category : #'as yet unclassified' }
PveVM >> stop [
	"Stop the VM"
	^ api post: 'nodes/', node name, '/qemu/', self vmid asString, '/status/stop'.
]

{ #category : #'as yet unclassified' }
PveVM >> vmid [
	^ self rawData at: 'vmid'
]
