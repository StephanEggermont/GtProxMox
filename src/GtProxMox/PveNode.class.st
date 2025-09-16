Class {
	#name : #PveNode,
	#superclass : #Object,
	#instVars : [
		'rawData',
		'client',
		'cluster',
		'api'
	],
	#category : #'GtProxMox-Model'
}

{ #category : #'as yet unclassified' }
PveNode >> api: anApi [
	api := anApi
]

{ #category : #'as yet unclassified' }
PveNode >> cluster: aCluster [
	cluster := aCluster
]

{ #category : #'as yet unclassified' }
PveNode >> containers [
	"Fetch containers for this node" 
	| data |
	self isRunning ifFalse: [^#()].
	data := api get: 'nodes/', self name, '/lxc'.
	
	^ data collect: [ :ctData |
		PveContainer new
			rawData: ctData;
			node: self; 
			api: api;
			yourself ]
]

{ #category : #'as yet unclassified' }
PveNode >> cpuUsage [
	^ self rawData at: 'cpu' ifAbsent: [ nil ]

]

{ #category : #'as yet unclassified' }
PveNode >> gtContainersFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Containers';
		priority: 30;
		items: [ self containers ];
		column: 'ID' text: [ :ct | ct vmid ];
		column: 'Name' text: [ :ct | ct name ];
		column: 'Status' text: [ :ct | ct status ];
		column: 'Memory' text: [ :ct | ct memoryDisplay ];
		actionUpdateButton
]

{ #category : #'as yet unclassified' }
PveNode >> gtDetailsFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Details';
		priority: 10;
		text: [
			String streamContents: [ :s |
				s nextPutAll: 'Node: ', self name; cr.
				s nextPutAll: 'Status: ', self status; cr.
				self cpuUsage ifNotNil: [ :cpu |
					s nextPutAll: 'CPU Usage: ', (cpu * 100) rounded asString, '%'; cr ].
				s nextPutAll: 'Memory Usage: ', self memoryUsagePercent rounded asString, '%'; cr.
				s nextPutAll: 'Memory: ', (self memoryUsage // (1024*1024)) asString, 'MB / ', 
					(self maxMemory // (1024*1024)) asString, 'MB'; cr ] ]
]

{ #category : #'as yet unclassified' }
PveNode >> gtVMsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'VMs';
		priority: 20;
		items: [ self vms ];
		column: 'ID' text: [ :vm | vm vmid ];
		column: 'Name' text: [ :vm | vm name ];
		column: 'Status' text: [ :vm | vm status ];
		column: 'CPU'
			text: [ :vm | 
				vm cpuUsage
					ifNotNil: [ :usage | (usage * 100) rounded asString , '%' ]
					ifNil: [ 'N/A' ] ];
		column: 'Memory' text: [ :vm | vm memoryDisplay ];
		column: 'Actions' stencil: [ :vm :anIndex | self startOrStopActionOn: vm ];
		actionUpdateButton
]

{ #category : #'as yet unclassified' }
PveNode >> isRunning [
	^self status = 'online'
]

{ #category : #'as yet unclassified' }
PveNode >> maxMemory [
	^ self rawData at: 'maxmem' ifAbsent: [ 1 ]
]

{ #category : #'as yet unclassified' }
PveNode >> memoryUsage [
	^ self rawData at: 'mem' ifAbsent: [ 0 ]

]

{ #category : #'as yet unclassified' }
PveNode >> memoryUsagePercent [
	^ self maxMemory = 0 
		ifTrue: [ 0 ]
		ifFalse: [ (self memoryUsage / self maxMemory) * 100 ]
]

{ #category : #'as yet unclassified' }
PveNode >> name [
	^ self rawData at: 'node'
]

{ #category : #'as yet unclassified' }
PveNode >> rawData [
	^rawData
]

{ #category : #'as yet unclassified' }
PveNode >> rawData: nodeData [ 
	rawData := nodeData
]

{ #category : #'as yet unclassified' }
PveNode >> startOrStopActionOn: vm [
	^ vm status = 'running'
		ifTrue: [ BrHorizontalPane new
				fitContent;
				in: [ :aPane | 
					aPane
						addChild: (BrButton new
								fitContent;
								aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
								margin: (BlInsets right: 5);
								icon: BrGlamorousIcons cancel;
								label: 'Stop';
								action: [ :aButton | 
									vm stop.
									aButton phlow fireToolUpdateWish ]) ] ]
		ifFalse: [ BrHorizontalPane new
				fitContent;
				in: [ :aPane | 
					aPane
						addChild: (BrButton new
								fitContent;
								aptitude: BrGlamorousButtonWithIconAndLabelAptitude;
								margin: (BlInsets right: 5);
								icon: BrGlamorousIcons play;
								label: 'Start';
								action: [ :aButton | 
									vm start.
									aButton phlow fireToolUpdateWish ]) ] ]
]

{ #category : #'as yet unclassified' }
PveNode >> status [
	^ self rawData at: 'status'
]

{ #category : #'as yet unclassified' }
PveNode >> vms [
	"Fetch VMs for this node"
	| data |
	self isRunning ifFalse: [^#()].
	data :=  (api get: 'nodes/', self name, '/qemu') .
	
	^ (data collect: [ :vmData |
		PveVM new
			rawData: vmData;
			node: self;
			api: api;
			yourself ]) sorted: [:a :b | a vmid < b vmid]
]
