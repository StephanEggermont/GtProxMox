Class {
	#name : #PveVMSpec,
	#superclass : #Object,
	#instVars : [
		'vmid',
		'name',
		'memory',
		'cores',
		'sockets',
		'osType',
		'bootOrder',
		'qemuAgent',
		'networks',
		'disks'
	],
	#category : #'GtProxMox-Model'
}

{ #category : #'as yet unclassified' }
PveVMSpec class >> osTypes [
	^#('l24', "Linux 2.4"
	'l26', "Linux 2.6+"
	'w2k', "Windows 2000"
	'wxp', "Windows XP"
	'w2k3', 
	'w2k8', 
	'wvista', 
	'win7', 
	'win8', 
	'win10', 
	'solaris')
]

{ #category : #'as yet unclassified' }
PveVMSpec >> addDisk: diskSpec key: diskKey [
	"Add disk (e.g., 'scsi0')"
	disks at: diskKey put: diskSpec
]

{ #category : #'as yet unclassified' }
PveVMSpec >> addNetwork: networkSpec key: networkKey [
	"Add network interface (e.g., 'net0')"
	networks at: networkKey put: networkSpec
]

{ #category : #accessing }
PveVMSpec >> bootOrder [
	^ bootOrder
]

{ #category : #accessing }
PveVMSpec >> bootOrder: anObject [
	bootOrder := anObject
]

{ #category : #accessing }
PveVMSpec >> cores [
	^ cores
]

{ #category : #accessing }
PveVMSpec >> cores: anObject [
	cores := anObject
]

{ #category : #accessing }
PveVMSpec >> disks [
	^ disks
]

{ #category : #accessing }
PveVMSpec >> disks: anObject [
	disks := anObject
]

{ #category : #'as yet unclassified' }
PveVMSpec >> initialize [
	super initialize.
	memory := 2048.
	cores := 2.
	sockets := 1.
	osType := 'l26'.
	bootOrder := 'c'.
	qemuAgent := true.
	networks := Dictionary new.
	disks := Dictionary new.
]

{ #category : #accessing }
PveVMSpec >> memory [
	^ memory
]

{ #category : #accessing }
PveVMSpec >> memory: anObject [
	memory := anObject
]

{ #category : #accessing }
PveVMSpec >> name [
	^ name
]

{ #category : #accessing }
PveVMSpec >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PveVMSpec >> networks [
	^ networks
]

{ #category : #accessing }
PveVMSpec >> networks: anObject [
	networks := anObject
]

{ #category : #accessing }
PveVMSpec >> osType [
	^ osType
]

{ #category : #accessing }
PveVMSpec >> osType: anObject [
	osType := anObject
]

{ #category : #accessing }
PveVMSpec >> qemuAgent [
	^ qemuAgent
]

{ #category : #accessing }
PveVMSpec >> qemuAgent: anObject [
	qemuAgent := anObject
]

{ #category : #accessing }
PveVMSpec >> sockets [
	^ sockets
]

{ #category : #accessing }
PveVMSpec >> sockets: anObject [
	sockets := anObject
]

{ #category : #accessing }
PveVMSpec >> vmid [
	^ vmid
]

{ #category : #accessing }
PveVMSpec >> vmid: anObject [
	vmid := anObject
]
